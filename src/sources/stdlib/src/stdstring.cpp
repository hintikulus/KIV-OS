#include <stdstring.h>

namespace {
    const char CharConvArr[] = "0123456789ABCDEF";
}

int n_tu(int number, int count) {
    int result = 1;
    while (count-- > 0)
        result *= number;

    return result;
}

void ftoa(float f, char *r) {
    long long int length, length2, i, number, position, sign;
    float number2;

    sign = -1;   // -1 == positive number
    if (f < 0) {
        sign = '-';
        f *= -1;
    }

    number2 = f;
    number = f;
    length = 0;  // Size of decimal part
    length2 = 0; // Size of tenth

    /* Calculate length2 tenth part */
    while ((number2 - (float) number) != 0.0 && !((number2 - (float) number) < 0.0)) {
        number2 = f * (n_tu(10.0, length2 + 1));
        number = number2;

        length2++;
    }

    /* Calculate length decimal part */
    for (length = (f > 1) ? 0 : 1; f > 1; length++)
        f /= 10;

    position = length;
    length = length + 1 + length2;
    number = number2;
    if (sign == '-') {
        length++;
        position++;
    }

    for (i = length; i >= 0; i--) {
        if (i == (length))
            r[i] = '\0';
        else if (i == (position))
            r[i] = '.';
        else if (sign == '-' && i == 0)
            r[i] = '-';
        else {
            r[i] = (number % 10) + '0';
            number /= 10;
        }
    }
}

#define isdigit(c) (c >= '0' && c <= '9')

float atof(const char *s) {
    float a = 0.0;
    int e = 0;
    int c;
    while ((c = *s++) != '\0' && isdigit(c)) {
        a = a * 10.0 + (c - '0');
    }
    if (c == '.') {
        while ((c = *s++) != '\0' && isdigit(c)) {
            a = a * 10.0 + (c - '0');
            e = e - 1;
        }
    }
    if (c == 'e' || c == 'E') {
        int sign = 1;
        int i = 0;
        c = *s++;
        if (c == '+')
            c = *s++;
        else if (c == '-') {
            c = *s++;
            sign = -1;
        }
        while (isdigit(c)) {
            i = i * 10 + (c - '0');
            c = *s++;
        }
        e += i * sign;
    }
    while (e > 0) {
        a *= 10.0;
        e--;
    }
    while (e < 0) {
        a *= 0.1;
        e++;
    }
    return a;
}

void itoa(unsigned int input, char *output, unsigned int base) {
    int i = 0;

    while (input > 0) {
        output[i] = CharConvArr[input % base];
        input /= base;
        i++;
    }

    if (i == 0) {
        output[i] = CharConvArr[0];
        i++;
    }

    output[i] = '\0';
    i--;

    for (int j = 0; j <= i / 2; j++) {
        char c = output[i - j];
        output[i - j] = output[j];
        output[j] = c;
    }
}

int atoi(const char *input) {
    int output = 0;

    while (*input != '\0') {
        output *= 10;
        if (*input > '9' || *input < '0')
            break;

        output += *input - '0';

        input++;
    }

    return output;
}

char *strncpy(char *dest, const char *src, int num) {
    int i;

    for (i = 0; i < num && src[i] != '\0'; i++)
        dest[i] = src[i];
    for (; i < num; i++)
        dest[i] = '\0';

    return dest;
}

int strncmp(const char *s1, const char *s2, int num) {
    unsigned char u1, u2;
    while (num-- > 0) {
        u1 = (unsigned char) *s1++;
        u2 = (unsigned char) *s2++;
        if (u1 != u2)
            return u1 - u2;
        if (u1 == '\0')
            return 0;
    }

    return 0;
}

int strlen(const char *s) {
    int i = 0;

    while (s[i] != '\0')
        i++;

    return i;
}

bool constains(const char *source, const char target) {
    int i = 0;

    while (source[i] != '\0') {
        if (source[i] == target)
            return true;
        i++;
    }
    return false;
}

void bzero(void *memory, int length) {
    char *mem = reinterpret_cast<char *>(memory);

    for (int i = 0; i < length; i++)
        mem[i] = 0;
}

void memcpy(const void *src, void *dst, int num) {
    const char *memsrc = reinterpret_cast<const char *>(src);
    char *memdst = reinterpret_cast<char *>(dst);

    for (int i = 0; i < num; i++)
        memdst[i] = memsrc[i];
}

bool is_digit(char c) {
    return (c >= '0') && (c <= '9');
}

bool is_decimal(const char *str) {
    char c = str[0];
    if (c == '\0') return false;

    int size = 0;

    if (!is_digit(c)) {
        if (c != '+' && c != '-') {
            return false;
        }
    } else {
        size++;
    }

    int i = 1;
    while (str[i] != '\0') {
        if (!is_digit(str[i])) {
            return false;
        }
        size++;
        i++;
    }

    if (size == 0) {
        return false;
    }

    return true;
}

bool is_float(const char *str) {
    char c = str[0];
    bool point = false;
    int after_point = 0;
    int before_point = 0;

    if (c == '\0') return false;

    if (c != '+' && c != '-' && !is_digit(c)) return false;

    if (is_digit(c)) {
        before_point++;
    }

    int i = 1;
    while (str[i] != '\0') {
        if (!is_digit(str[i])) {
            if (str[i] == '.' && point == false) {
                point = true;
            } else {
                return false;
            }
        } else {
            if (point == true) {
                after_point++;
            } else {
                before_point++;
            }
        }
        i++;
    }

    if (before_point < 0) {
        return false;
    }

    if (point == true && after_point == 0) {
        return false;
    }

    return true;
}