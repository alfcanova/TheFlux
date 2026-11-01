/* ==============================================================================
 * TheFlux Native Runtime: String & UTF-8 Primitives
 * Header: runtime/include/flux/string.h
 * ============================================================================== */

#ifndef FLUX_STRING_H
#define FLUX_STRING_H

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    size_t length;
    uint32_t hash;
    char *data;
} FluxString;

char *flux_str_concat(const char *a, const char *b);
char *flux_rt_str_slice(const char *s, int64_t start, int64_t end);
int64_t flux_str_len(const char *s);
int64_t flux_str_utf8_len(const char *s);
int flux_str_compare(const char *a, const char *b);
bool flux_str_equals(const char *a, const char *b);
uint32_t flux_str_hash(const char *s);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_STRING_H */
