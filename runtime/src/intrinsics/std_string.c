#include "flux/flux.h"
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

char *flux_std_string_to_lower(const char *s) {
    if (!s) return strdup("");
    char *res = strdup(s);
    for (char *p = res; *p; p++) *p = (char)tolower((unsigned char)*p);
    return res;
}

char *flux_std_string_to_upper(const char *s) {
    if (!s) return strdup("");
    char *res = strdup(s);
    for (char *p = res; *p; p++) *p = (char)toupper((unsigned char)*p);
    return res;
}

int64_t flux_std_string_starts_with(const char *s, const char *prefix) {
    if (!s || !prefix) return 0;
    size_t slen = strlen(s), plen = strlen(prefix);
    return (slen >= plen && memcmp(s, prefix, plen) == 0) ? 1 : 0;
}

int64_t flux_std_string_ends_with(const char *s, const char *suffix) {
    if (!s || !suffix) return 0;
    size_t slen = strlen(s), suflen = strlen(suffix);
    return (slen >= suflen && memcmp(s + slen - suflen, suffix, suflen) == 0) ? 1 : 0;
}

int64_t flux_std_string_contains(const char *s, const char *sub) {
    if (!s || !sub) return 0;
    return strstr(s, sub) != NULL ? 1 : 0;
}
