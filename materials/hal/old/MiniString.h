#ifndef MINI_STRING_H
#define MINI_STRING_H

#include <cstdint>
#include <cstddef>
#include <cstring>

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

    MiniString& operator+=(const char* src) { append(src);   return *this; }
    MiniString& operator+=(char c)          { push_back(c);  return *this; }

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

#endif // MINI_STRING_H