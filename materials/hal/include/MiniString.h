#ifndef MINI_STRING_H
#define MINI_STRING_H

#include <cstdint>
#include <cstddef>
#include <cstring>
#include <type_traits>

// ---------------------------------------------------------------------------
// MiniString<N>
//
// A minimal, dependency-free, fixed-capacity string type intended for
// embedded / bare-metal / custom-runtime use where std::string is too
// heavy (dynamic allocation, exceptions, locale, iostream coupling,
// SSO/COW machinery, allocator templates, etc).
//
//   - No dynamic allocation: storage lives inline in the object
//     (stack, .bss, or wherever the object itself lives).
//   - No exceptions: every mutating operation is bounds-checked and
//     silently truncates instead of throwing or asserting.
//   - No RTTI, no iostream, no locale, no <string>/<memory>.
//   - Only depends on <cstdint>, <cstddef>, <cstring>.
//   - Trivially relocatable / copyable (plain POD-ish layout), so it is
//     safe to memcpy or place in a struct that gets DMA'd or memory
//     mapped, if that's ever useful.
//
// Capacity N is the maximum number of *characters* (not counting the
// terminating null). Total storage is exactly N+1 bytes.
//
// Usage:
//   MiniString<31> s = "hello";
//   s += " world";
//   send(s.c_str(), s.size());
// ---------------------------------------------------------------------------
template <std::size_t N>
class MiniString
{
public:
    static constexpr std::size_t capacity = N;

    MiniString() { clear(); }
    MiniString(const char* src) { assign(src); }

    template <std::size_t M>
    MiniString(const MiniString<M>& other) { assign(other.c_str()); }

    // -- queries ----------------------------------------------------------
    std::size_t size()     const { return len_; }
    std::size_t length()   const { return len_; }
    uint32_t    empty()    const { return len_ == 0 ? 1u : 0u; }
    uint32_t    full()     const { return len_ == N ? 1u : 0u; }
    const char* c_str()    const { return buf_; }
    char*       data()           { return buf_; }

    // -- mutation -----------------------------------------------------------
    void clear()
    {
        len_ = 0;
        buf_[0] = '\0';
    }

    // Overwrites current contents. Silently truncates if src is longer than N.
    void assign(const char* src)
    {
        clear();
        append(src);
    }

    // Appends a C-string, truncating silently if it does not fit.
    // Returns the number of characters actually appended.
    std::size_t append(const char* src)
    {
        if (!src) return 0;
        std::size_t i = 0;
        while (src[i] != '\0' && len_ < N)
        {
            buf_[len_++] = src[i++];
        }
        buf_[len_] = '\0';
        return i;
    }

    // Appends raw bytes (not necessarily null-terminated), e.g. from a
    // byte-at-a-time UART RX path. Returns 0 once the buffer is full,
    // 1 on success.
    uint32_t push_back(char c)
    {
        if (len_ >= N) return 0u;
        buf_[len_++] = c;
        buf_[len_] = '\0';
        return 1u;
    }

    void pop_back()
    {
        if (len_ == 0) return;
        buf_[--len_] = '\0';
    }

    // Appends the decimal (or arbitrary-base, 2-16) text representation of
    // an unsigned value. `min_digits` left-pads with '0' if the natural
    // representation is shorter (handy for e.g. 2-digit hex byte dumps).
    // Returns the number of characters actually appended (may be less
    // than the full representation if the buffer fills up mid-append).
    std::size_t appendUInt(uint32_t value, uint32_t base = 10, uint32_t min_digits = 0)
    {
        char digits[32];
        std::size_t n = 0;

        if (value == 0)
        {
            digits[n++] = '0';
        }
        while (value != 0 && n < sizeof(digits))
        {
            uint32_t d = value % base;
            digits[n++] = (d < 10) ? static_cast<char>('0' + d)
                                    : static_cast<char>('A' + (d - 10));
            value /= base;
        }
        while (n < min_digits && n < sizeof(digits))
        {
            digits[n++] = '0';
        }

        std::size_t appended = 0;
        while (n > 0)
        {
            --n;
            if (!push_back(digits[n])) break;
            ++appended;
        }
        return appended;
    }

    // Appends a signed decimal value (handles the '-' sign itself).
    std::size_t appendInt(int32_t value)
    {
        std::size_t appended = 0;
        uint32_t magnitude;

        if (value < 0)
        {
            if (!push_back('-')) return 0;
            ++appended;
            // Careful with INT32_MIN, whose magnitude doesn't fit in int32_t.
            magnitude = static_cast<uint32_t>(-(value + 1)) + 1u;
        }
        else
        {
            magnitude = static_cast<uint32_t>(value);
        }

        appended += appendUInt(magnitude, 10);
        return appended;
    }

    // Convenience wrapper: appendUInt in base 16, uppercase digits.
    std::size_t appendHex(uint32_t value, uint32_t min_digits = 0)
    {
        return appendUInt(value, 16, min_digits);
    }

    MiniString& operator+=(const char* src) { append(src);   return *this; }
    MiniString& operator+=(char c)          { push_back(c);  return *this; }
    MiniString& operator+=(int32_t v)       { appendInt(v);  return *this; }
    MiniString& operator+=(uint32_t v)      { appendUInt(v); return *this; }

    char& operator[](std::size_t i)       { return buf_[i]; }
    char  operator[](std::size_t i) const { return buf_[i]; }

    uint32_t operator==(const char* rhs) const
    {
        return std::strcmp(buf_, rhs) == 0 ? 1u : 0u;
    }

    template <std::size_t M>
    uint32_t operator==(const MiniString<M>& rhs) const
    {
        return std::strcmp(buf_, rhs.c_str()) == 0 ? 1u : 0u;
    }

private:
    char        buf_[N + 1];
    std::size_t len_;
};

// ---------------------------------------------------------------------------
// format() - a minimal, allocation-free analogue of fprintf.
//
// Supported specifiers only: %d / %i (int32_t), %u (uint32_t),
// %x / %X (uint32_t, hex), %s (const char*), %c (char), %% (literal '%').
// No width/precision/flags beyond what's listed, no floating point.
// Extra trailing arguments are ignored (fewer args than specifiers is a
// compile error, since matching is done via variadic templates, not at
// runtime like real printf).
//
// Usage:
//   MiniString<64> msg;
//   format(msg, "count=%d addr=0x%x name=%s\n", -3, 0xDEADu, "uart0");
//   uart.writeString(msg);
// ---------------------------------------------------------------------------

// Handles any plain integral argument type (int, unsigned int, long,
// uint32_t, int32_t, short, ... - but not char/bool, which have their
// own exact-match overloads below and win overload resolution over this
// template when they apply). Using a single templated overload here -
// rather than separate int32_t/uint32_t overloads - avoids ambiguous
// overload errors on platforms where uint32_t/int32_t are typedef'd to
// something other than plain unsigned int/int (e.g. LP64, where they're
// unsigned long/long): a literal 'unsigned int' argument would otherwise
// be an equally-good conversion to either overload.
template <std::size_t N, typename T,
          typename = typename std::enable_if<
              std::is_integral<T>::value &&
              !std::is_same<T, char>::value &&
              !std::is_same<T, bool>::value>::type>
inline void appendArg(MiniString<N>& out, char spec, T value)
{
    if (std::is_signed<T>::value)
    {
        int32_t v = static_cast<int32_t>(value);
        if (spec == 'x' || spec == 'X') out.appendHex(static_cast<uint32_t>(v));
        else if (spec == 'u')           out.appendUInt(static_cast<uint32_t>(v));
        else                             out.appendInt(v); // 'd' / 'i' / fallback
    }
    else
    {
        uint32_t v = static_cast<uint32_t>(value);
        if (spec == 'x' || spec == 'X')      out.appendHex(v);
        else if (spec == 'd' || spec == 'i') out.appendInt(static_cast<int32_t>(v));
        else                                  out.appendUInt(v); // 'u' / fallback
    }
}

template <std::size_t N>
inline void appendArg(MiniString<N>& out, char spec, const char* value)
{
    (void)spec; // only %s is meaningful for a C-string argument
    out.append(value);
}

template <std::size_t N>
inline void appendArg(MiniString<N>& out, char spec, char value)
{
    (void)spec; // only %c is meaningful for a char argument
    out.push_back(value);
}

// Base case: no more args, copy the remaining literal text.
template <std::size_t N>
inline void format(MiniString<N>& out, const char* fmt)
{
    while (*fmt != '\0')
    {
        if (fmt[0] == '%' && fmt[1] == '%')
        {
            out.push_back('%');
            fmt += 2;
            continue;
        }
        out.push_back(*fmt++);
    }
}

// Recursive case: consume literal text up to the next specifier, format
// one argument against it, then recurse on the rest of the format string.
template <std::size_t N, typename T, typename... Rest>
inline void format(MiniString<N>& out, const char* fmt, T value, Rest... rest)
{
    while (*fmt != '\0')
    {
        if (fmt[0] == '%' && fmt[1] == '%')
        {
            out.push_back('%');
            fmt += 2;
            continue;
        }
        if (fmt[0] == '%' && fmt[1] != '\0')
        {
            appendArg(out, fmt[1], value);
            format(out, fmt + 2, rest...);
            return;
        }
        out.push_back(*fmt++);
    }
    // Format string ran out before this argument's specifier was found;
    // remaining args are silently dropped (mirrors printf's leniency).
}

#endif // MINI_STRING_H
