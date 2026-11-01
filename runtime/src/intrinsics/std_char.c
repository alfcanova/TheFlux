#include "flux/flux.h"
#include <ctype.h>

int64_t flux_std_char_is_digit(int64_t c) { return isdigit((int)c) ? 1 : 0; }
int64_t flux_std_char_is_alpha(int64_t c) { return isalpha((int)c) ? 1 : 0; }
int64_t flux_std_char_is_alphanumeric(int64_t c) { return isalnum((int)c) ? 1 : 0; }
int64_t flux_std_char_is_whitespace(int64_t c) { return isspace((int)c) ? 1 : 0; }
int64_t flux_std_char_to_lower(int64_t c) { return tolower((int)c); }
int64_t flux_std_char_to_upper(int64_t c) { return toupper((int)c); }
int64_t flux_std_char_to_int(int64_t c) { return (c >= '0' && c <= '9') ? (c - '0') : -1; }
int64_t flux_std_char_from_int(int64_t v) { return (v >= 0 && v <= 9) ? ('0' + v) : 0; }
