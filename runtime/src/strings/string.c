/* ==============================================================================
 * TheFlux Native Runtime: String Operations
 * Source: runtime/src/strings/string.c
 * ============================================================================== */

#include "flux/string.h"
#include "flux/collections.h"
#include "flux/memory.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *flux_str_concat(const char *a, const char *b) {
    char buf_a[32];
    char buf_b[32];
    if (!a) a = "";
    else if (!flux_is_readable_ptr(a, 1)) {
        snprintf(buf_a, sizeof(buf_a), "%lld", (long long)(intptr_t)a);
        a = buf_a;
    }
    if (!b) b = "";
    else if (!flux_is_readable_ptr(b, 1)) {
        snprintf(buf_b, sizeof(buf_b), "%lld", (long long)(intptr_t)b);
        b = buf_b;
    }
    size_t la = strlen(a);
    size_t lb = strlen(b);
    char *res = (char *)flux_tls_str_alloc(la + lb + 1);
    if (!res) return NULL;
    memcpy(res, a, la);
    memcpy(res + la, b, lb);
    res[la + lb] = '\0';
    return res;
}

char *flux_rt_str_slice(const char *s, int64_t start, int64_t end) {
    if (!s || !flux_is_readable_ptr(s, 1)) return flux_tls_str_dup("");
    int64_t len = (int64_t)strlen(s);
    if (start < 0) start = 0;
    if (end > len) end = len;
    if (start >= end) return flux_tls_str_dup("");

    size_t slice_len = (size_t)(end - start);
    char *res = (char *)flux_tls_str_alloc(slice_len + 1);
    if (!res) return NULL;
    memcpy(res, s + start, slice_len);
    res[slice_len] = '\0';
    return res;
}

int64_t flux_str_len(const char *s) {
    return (s && flux_is_readable_ptr(s, 1)) ? (int64_t)strlen(s) : 0;
}

int64_t flux_std_string_byte_length(const char *s) {
    return (s && flux_is_readable_ptr(s, 1)) ? (int64_t)strlen(s) : 0;
}

typedef struct {
    const char *ptr;
    size_t byte_len;
    int64_t cp_len;
    int is_ascii;
    uint64_t head_sig;
    int64_t last_cp;
    size_t last_byte;
    uint64_t last_used;
} FluxUtf8Cursor;

#define FLUX_UTF8_CACHE_SLOTS 8
static _Thread_local FluxUtf8Cursor g_utf8_cache[FLUX_UTF8_CACHE_SLOTS];
static _Thread_local uint64_t g_utf8_lru_clock = 0;

static FluxUtf8Cursor *flux_utf8_cursor_match(const char *p) {
    if (!p || !flux_is_readable_ptr(p, 1)) return NULL;
    for (int i = 0; i < FLUX_UTF8_CACHE_SLOTS; i++) {
        FluxUtf8Cursor *c = &g_utf8_cache[i];
        if (c->ptr == p) {
            uint64_t hsig = 0;
            size_t hcopy = c->byte_len < 8 ? c->byte_len : 8;
            if (hcopy > 0) memcpy(&hsig, p, hcopy);
            if (hsig == c->head_sig && flux_is_readable_ptr(p + c->byte_len, 1) && p[c->byte_len] == '\0') {
                c->last_used = ++g_utf8_lru_clock;
                return c;
            }
        }
    }
    return NULL;
}

static FluxUtf8Cursor *flux_utf8_cursor_populate(const char *p) {
    if (!p || !flux_is_readable_ptr(p, 1)) return &g_utf8_cache[0];
    const unsigned char *u = (const unsigned char *)p;
    int64_t cp = 0;
    int ascii = 1;
    size_t first_byte = 0;
    int found_first = 0;
    while (*u) {
        unsigned char c = *u;
        if (c >= 0x80) ascii = 0;
        if ((c & 0xC0) != 0x80) {
            if (!found_first) {
                first_byte = (size_t)(u - (const unsigned char *)p);
                found_first = 1;
            }
            cp++;
        }
        u++;
    }
    size_t blen = (size_t)(u - (const unsigned char *)p);
    uint64_t hsig = 0;
    size_t hcopy = blen < 8 ? blen : 8;
    if (hcopy > 0) memcpy(&hsig, p, hcopy);

    int victim = 0;
    uint64_t min_used = g_utf8_cache[0].last_used;
    for (int i = 0; i < FLUX_UTF8_CACHE_SLOTS; i++) {
        if (!g_utf8_cache[i].ptr) {
            victim = i;
            break;
        }
        if (g_utf8_cache[i].last_used < min_used) {
            min_used = g_utf8_cache[i].last_used;
            victim = i;
        }
    }

    FluxUtf8Cursor *slot = &g_utf8_cache[victim];
    slot->ptr = p;
    slot->byte_len = blen;
    slot->cp_len = cp;
    slot->is_ascii = ascii;
    slot->head_sig = hsig;
    slot->last_cp = 1;
    slot->last_byte = first_byte;
    slot->last_used = ++g_utf8_lru_clock;
    return slot;
}

int64_t flux_str_char_len(const char *s) {
    if (!s || !flux_is_readable_ptr(s, 1)) return 0;
    FluxUtf8Cursor *cached = flux_utf8_cursor_match(s);
    if (cached) {
        return cached->cp_len;
    }
    const unsigned char *u = (const unsigned char *)s;
    int64_t cp = 0;
    size_t i = 0;
    while (u[i] && i < 64) {
        if ((u[i] & 0xC0) != 0x80) cp++;
        i++;
    }
    if (!u[i]) return cp;
    return flux_utf8_cursor_populate(s)->cp_len;
}

char *flux_str_slice(const char *p, int64_t s, int64_t e) {
    if (!p || !flux_is_readable_ptr(p, 1)) return flux_tls_str_dup("");
    if (s <= 0 && e <= 0 && s == e) return flux_tls_str_dup("");
    if (s < 1) s = 1;
    int64_t total_cp = flux_str_char_len(p);
    if (e <= 0 || e > total_cp) e = total_cp;
    if (s > e) return flux_tls_str_dup("");

    /* Fast direct scan for short offsets without cache overhead */
    if (s <= 64 && e <= 64) {
        const unsigned char *u = (const unsigned char *)p;
        int64_t cur = 0;
        while (*u) {
            if ((*u & 0xC0) != 0x80) {
                cur++;
                if (cur == s) break;
            }
            u++;
        }
        if (!*u) return flux_tls_str_dup("");
        size_t start_byte = (size_t)(u - (const unsigned char *)p);
        while (*u) {
            if ((*u & 0xC0) != 0x80) {
                if (cur > e) break;
                cur++;
            }
            u++;
        }
        size_t end_byte = (size_t)(u - (const unsigned char *)p);
        if (start_byte >= end_byte) return flux_tls_str_dup("");
        size_t len = end_byte - start_byte;
        char *res = (char *)flux_tls_str_alloc(len + 1);
        if (!res) return NULL;
        memcpy(res, p + start_byte, len);
        res[len] = '\0';
        return res;
    }

    FluxUtf8Cursor *c = flux_utf8_cursor_match(p);
    if (!c) {
        c = flux_utf8_cursor_populate(p);
    }

    if (s > c->cp_len) return flux_tls_str_dup("");
    if (e > c->cp_len) e = c->cp_len;
    if (s > e) return flux_tls_str_dup("");

    size_t start_byte = 0;
    size_t end_byte = 0;

    if (c->is_ascii) {
        start_byte = (size_t)(s - 1);
        end_byte = (size_t)e;
    } else {
        size_t blen = c->byte_len;
        int64_t cur = c->last_cp;
        size_t idx = c->last_byte;

        if (s >= cur) {
            while (cur < s && idx < blen) {
                idx++;
                while (idx < blen && (((unsigned char)p[idx] & 0xC0) == 0x80)) {
                    idx++;
                }
                cur++;
            }
        } else if ((cur - s) < s) {
            while (cur > s && idx > 0) {
                idx--;
                while (idx > 0 && (((unsigned char)p[idx] & 0xC0) == 0x80)) {
                    idx--;
                }
                cur--;
            }
        } else {
            cur = 1;
            idx = 0;
            while (idx < blen && (((unsigned char)p[idx] & 0xC0) == 0x80)) {
                idx++;
            }
            while (cur < s && idx < blen) {
                idx++;
                while (idx < blen && (((unsigned char)p[idx] & 0xC0) == 0x80)) {
                    idx++;
                }
                cur++;
            }
        }

        c->last_cp = cur;
        c->last_byte = idx;
        start_byte = idx;

        size_t eidx = idx;
        int64_t rem = e - s + 1;
        while (rem > 0 && eidx < blen) {
            eidx++;
            while (eidx < blen && (((unsigned char)p[eidx] & 0xC0) == 0x80)) {
                eidx++;
            }
            rem--;
        }
        end_byte = eidx;
    }

    if (start_byte >= end_byte) return flux_tls_str_dup("");
    size_t len = end_byte - start_byte;
    char *res = (char *)flux_tls_str_alloc(len + 1);
    if (!res) return NULL;
    memcpy(res, p + start_byte, len);
    res[len] = '\0';
    return res;
}

int flux_str_compare(const char *a, const char *b) {
    if (!a || !flux_is_readable_ptr(a, 1)) a = "";
    if (!b || !flux_is_readable_ptr(b, 1)) b = "";
    return strcmp(a, b);
}

bool flux_str_equals(const char *a, const char *b) {
    return flux_str_compare(a, b) == 0;
}

uint32_t flux_str_hash(const char *s) {
    if (!s || !flux_is_readable_ptr(s, 1)) return 0;
    /* FNV-1a 32-bit */
    uint32_t hash = 2166136261u;
    while (*s) {
        hash ^= (uint8_t)*s++;
        hash *= 16777619u;
    }
    return hash;
}

char *flux_std_string_llvm_escape(const char *s) {
    if (!s || !flux_is_readable_ptr(s, 1)) return flux_tls_str_dup("");
    size_t len = strlen(s);
    char *res = (char *)flux_tls_str_alloc(len * 4 + 1);
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
