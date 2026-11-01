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
void flux_list_set(FluxList *list, size_t index, FluxValue val);
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

#ifdef __cplusplus
}
#endif

#endif /* FLUX_COLLECTIONS_H */
