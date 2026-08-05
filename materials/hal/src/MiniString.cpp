#include "MiniString.h"

namespace mini_string
{

std::size_t append_char(char* dst, std::size_t& len, std::size_t cap, char c)
{
    if (len >= cap) return 0;
    dst[len++] = c;
    dst[len] = '\0';
    return 1;
}

std::size_t append_cstr(char* dst, std::size_t& len, std::size_t cap, const char* src)
{
    if (!src) return 0;

    std::size_t count = 0;
    while (src[count] != '\0' && len < cap)
    {
        dst[len++] = src[count++];
    }
    dst[len] = '\0';
    return count;
}

std::size_t append_uint(char* dst, std::size_t& len, std::size_t cap, unsigned int value)
{
    unsigned int divisor = 1;
    std::size_t count = 0;

    while (value / divisor >= 10)
        divisor *= 10;

    while (divisor > 0)
    {
        count += append_char(dst, len, cap, static_cast<char>('0' + ((value / divisor) % 10)));
        divisor /= 10;
    }

    return count;
}

std::size_t append_int(char* dst, std::size_t& len, std::size_t cap, int value)
{
    std::size_t count = 0;

    if (value < 0)
    {
        count += append_char(dst, len, cap, '-');
        return count + append_uint(dst, len, cap, static_cast<unsigned int>(-(value + 1)) + 1u);
    }

    return append_uint(dst, len, cap, static_cast<unsigned int>(value));
}

std::size_t vformat(char* dst, std::size_t& len, std::size_t cap, const char* fmt, va_list args)
{
    if (!fmt) return 0;

    std::size_t count = 0;
    for (std::size_t i = 0; fmt[i] != '\0'; ++i)
    {
        if (fmt[i] != '%')
        {
            count += append_char(dst, len, cap, fmt[i]);
            continue;
        }

        ++i;
        if (fmt[i] == '\0') break;

        switch (fmt[i])
        {
            case '%':
                count += append_char(dst, len, cap, '%');
                break;
            case 'c':
                count += append_char(dst, len, cap, static_cast<char>(va_arg(args, int)));
                break;
            case 's':
                count += append_cstr(dst, len, cap, va_arg(args, const char*));
                break;
            case 'u':
                count += append_uint(dst, len, cap, va_arg(args, unsigned int));
                break;
            case 'd':
                count += append_int(dst, len, cap, va_arg(args, int));
                break;
            default:
                count += append_char(dst, len, cap, '%');
                count += append_char(dst, len, cap, fmt[i]);
                break;
        }
    }

    return count;
}

}
