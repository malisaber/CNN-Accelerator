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

#define N 31

class MiniString
{
public:
    static constexpr std::size_t capacity = N;

    MiniString() { clear(); }
    MiniString(const char* src) { assign(src); }

    template <std::size_t M>
    MiniString(const MiniString& other) { assign(other.c_str()); }

    // -- queries ----------------------------------------------------------
    std::size_t size()     const { return len_; }
    std::size_t length()   const { return len_; }
    bool        empty()    const { return len_ == 0; }
    bool        full()     const { return len_ == N; }
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
    // byte-at-a-time UART RX path. Returns false once the buffer is full.
    bool push_back(char c)
    {
        if (len_ >= N) return false;
        buf_[len_++] = c;
        buf_[len_] = '\0';
        return true;
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

    bool operator==(const char* rhs) const
    {
        return std::strcmp(buf_, rhs) == 0;
    }

    template <std::size_t M>
    bool operator==(const MiniString& rhs) const
    {
        return std::strcmp(buf_, rhs.c_str()) == 0;
    }

private:
    char        buf_[N + 1];
    std::size_t len_;
};

#endif // MINI_STRING_H