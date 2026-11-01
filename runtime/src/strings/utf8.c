/* ==============================================================================
 * TheFlux Native Runtime: UTF-8 Encoding & Decoding Utilities
 * Source: runtime/src/strings/utf8.c
 * ============================================================================== */

#include "flux/string.h"
#include <stdint.h>

int64_t flux_str_utf8_len(const char *s) {
    if (!s) return 0;
    int64_t count = 0;
    const uint8_t *p = (const uint8_t *)s;
    while (*p) {
        if ((*p & 0xC0) != 0x80) {
            count++;
        }
        p++;
    }
    return count;
}
