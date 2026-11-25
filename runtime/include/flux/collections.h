/* ==============================================================================
 * TheFlux Native Runtime: Collections (List, Map, Set)
 * Header: runtime/include/flux/collections.h
 * ============================================================================== */

#ifndef FLUX_COLLECTIONS_H
#define FLUX_COLLECTIONS_H

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Dynamic List */
typedef struct {
    FluxValue *items;
    size_t length;
    size_t capacity;
} FluxList;

void *flux_list_create(size_t initial_cap);
void flux_list_append(FluxList *list, FluxValue val);
FluxValue flux_list_get(FluxList *list, size_t index);
void flux_list_set(void *list, int64_t index, int64_t val);
void flux_list_set_tagged(void *list, int64_t index, int64_t tag, int64_t val);
void *flux_list_slice(void *list, int64_t start, int64_t end);
int64_t flux_list_get_val_fast(void *list, int64_t index);
int64_t flux_list_len_fast(void *list);
int64_t flux_collection_len(const void *p);
int64_t flux_list_contains(void *list, int64_t val);
size_t flux_list_count(FluxList *list);
void flux_list_free(FluxList *list);

/* Hash Map Entry */
typedef struct {
    char *key;
    FluxValue value;
    uint32_t hash;
    bool occupied;
} FluxMapEntry;

typedef struct {
    FluxMapEntry *entries;
    size_t count;
    size_t capacity;
} FluxMap;

FluxMap *flux_map_create(size_t initial_cap);
void flux_hashmap_set(FluxMap *map, const char *key, FluxValue val);
bool flux_hashmap_get(FluxMap *map, const char *key, FluxValue *out);
bool flux_hashmap_has(FluxMap *map, const char *key);
size_t flux_map_len(void *map);
const char *flux_map_key_at(void *p, int64_t idx);
void flux_map_free(FluxMap *map);

/* Set */
typedef struct {
    char **items;
    size_t count;
    size_t capacity;
} FluxSet;

FluxSet *flux_set_create(size_t initial_cap);
void flux_set_add(FluxSet *set, const char *item);
bool flux_set_has(FluxSet *set, const char *item);
size_t flux_set_len(FluxSet *set);
void flux_set_free(FluxSet *set);

bool flux_is_readable_ptr(const void *p, size_t size);
void flux_register_immortal_region(const void *base, size_t size);
bool flux_is_collection_ptr(const void *p, int64_t expected_kind);
char *flux_list_to_str(void *p);
char *flux_set_to_str(void *p);
char *flux_map_to_str(void *p);
char *flux_complex_to_str(void *a);
void flux_set_add_tagged(void *set, int64_t tag, int64_t val);
void *flux_dataflow_join(int64_t a1_tag, int64_t a1_val, int64_t a2_tag, int64_t a2_val);
void *flux_list_to_set(void *src);
char *flux_float_to_str(double d);
void flux_float_print(double d);
void flux_set_print(void *p);
void flux_map_print(void *p);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_COLLECTIONS_H */
