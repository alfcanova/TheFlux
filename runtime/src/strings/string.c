/* ==============================================================================
 * TheFlux Native Runtime: String Operations
 * Source: runtime/src/strings/string.c
 * ============================================================================== */

#include "flux/string.h"
#include <stdlib.h>
#include <string.h>

char *flux_str_concat(const char *a, const char *b) {
    if (!a) a = "";
    if (!b) b = "";
    size_t la = strlen(a);
    size_t lb = strlen(b);
    char *res = (char *)malloc(la + lb + 1);
    if (!res) return NULL;
    memcpy(res, a, la);
    memcpy(res + la, b, lb);
    res[la + lb] = '\0';
    return res;
}

char *flux_rt_str_slice(const char *s, int64_t start, int64_t end) {
    if (!s) return strdup("");
    int64_t len = (int64_t)strlen(s);
    if (start < 0) start = 0;
    if (end > len) end = len;
    if (start >= end) return strdup("");

    size_t slice_len = (size_t)(end - start);
    char *res = (char *)malloc(slice_len + 1);
    if (!res) return NULL;
    memcpy(res, s + start, slice_len);
    res[slice_len] = '\0';
    return res;
}

int64_t flux_str_len(const char *s) {
    return s ? (int64_t)strlen(s) : 0;
}

int64_t flux_std_string_byte_length(const char *s) {
    return s ? (int64_t)strlen(s) : 0;
}

int64_t flux_str_char_len(const char *s) {
    return flux_str_utf8_len(s);
}

char *flux_str_slice(const char *p, int64_t s, int64_t e) {
    if (!p) return strdup("");
    if (s < 1) s = 1;
    if (s > e) return strdup("");

    const unsigned char *u = (const unsigned char *)p;
    int64_t cur = 0;

    /* Find start of codepoint s */
    while (*u) {
        if ((*u & 0xC0) != 0x80) {
            cur++;
            if (cur == s) break;
        }
        u++;
    }
    if (!*u) return strdup("");
    size_t start_byte = (size_t)(u - (const unsigned char *)p);

    /* Find end of codepoint e: advance past codepoint e */
    while (*u) {
        if ((*u & 0xC0) != 0x80) {
            if (cur > e) break;
            cur++;
        }
        u++;
    }
    size_t end_byte = (size_t)(u - (const unsigned char *)p);

    if (start_byte >= end_byte) return strdup("");
    size_t len = end_byte - start_byte;
    char *res = (char *)malloc(len + 1);
    if (!res) return NULL;
    memcpy(res, p + start_byte, len);
    res[len] = '\0';
    return res;
}

int flux_str_compare(const char *a, const char *b) {
    if (!a) a = "";
    if (!b) b = "";
    return strcmp(a, b);
}

bool flux_str_equals(const char *a, const char *b) {
    return flux_str_compare(a, b) == 0;
}

uint32_t flux_str_hash(const char *s) {
    if (!s) return 0;
    /* FNV-1a 32-bit */
    uint32_t hash = 2166136261u;
    while (*s) {
        hash ^= (uint8_t)*s++;
        hash *= 16777619u;
    }
    return hash;
}

char *flux_std_string_llvm_escape(const char *s) {
    if (!s) return strdup("");
    size_t len = strlen(s);
    char *res = (char *)malloc(len * 4 + 1);
    if (!res) return NULL;
    char *d = res;
    static const char hex[] = "0123456789ABCDEF";
    for (size_t i = 0; i < len; i++) {
        unsigned char c = (unsigned char)s[i];
        if (c == '\\') {
            *d++ = '\\'; *d++ = '5'; *d++ = 'C';
        } else if (c == '"') {
            *d++ = '\\'; *d++ = '2'; *d++ = '2';
        } else if (c == '\n') {
            *d++ = '\\'; *d++ = '0'; *d++ = 'A';
        } else if (c == '\r') {
            *d++ = '\\'; *d++ = '0'; *d++ = 'D';
        } else if (c == '\t') {
            *d++ = '\\'; *d++ = '0'; *d++ = '9';
        } else if (c < 32 || c >= 127) {
            *d++ = '\\';
            *d++ = hex[(c >> 4) & 0x0F];
            *d++ = hex[c & 0x0F];
        } else {
            *d++ = (char)c;
        }
    }
    *d = '\0';
    return res;
}
