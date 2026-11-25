/* ==============================================================================
 * TheFlux Native Runtime: Arena-Backed Multi-String Concatenation
 * Source: runtime/src/strings/str_fast.c
 * ============================================================================== */

#include "flux/string.h"
#include "flux/memory.h"
#include <stdlib.h>
#include <string.h>

static inline size_t safe_str_len(const char *s, const char **out_s) {
    if (!s || (uintptr_t)s < 0x10000) {
        *out_s = "";
        return 0;
    }
    *out_s = s;
    return strlen(s);
}

char *flux_str_concat3(const char *a, const char *b, const char *c) {
    const char *sa, *sb, *sc;
    size_t la = safe_str_len(a, &sa);
    size_t lb = safe_str_len(b, &sb);
    size_t lc = safe_str_len(c, &sc);
    size_t total = la + lb + lc;
    char *out = (char *)flux_tls_str_alloc(total + 1);
    if (!out) return strdup("");
    char *dst = out;
    if (la > 0) { memcpy(dst, sa, la); dst += la; }
    if (lb > 0) { memcpy(dst, sb, lb); dst += lb; }
    if (lc > 0) { memcpy(dst, sc, lc); dst += lc; }
    *dst = '\0';
    return out;
}

char *flux_str_concat4(const char *a, const char *b, const char *c, const char *d) {
    const char *sa, *sb, *sc, *sd;
    size_t la = safe_str_len(a, &sa);
    size_t lb = safe_str_len(b, &sb);
    size_t lc = safe_str_len(c, &sc);
    size_t ld = safe_str_len(d, &sd);
    size_t total = la + lb + lc + ld;
    char *out = (char *)flux_tls_str_alloc(total + 1);
    if (!out) return strdup("");
    char *dst = out;
    if (la > 0) { memcpy(dst, sa, la); dst += la; }
    if (lb > 0) { memcpy(dst, sb, lb); dst += lb; }
    if (lc > 0) { memcpy(dst, sc, lc); dst += lc; }
    if (ld > 0) { memcpy(dst, sd, ld); dst += ld; }
    *dst = '\0';
    return out;
}
