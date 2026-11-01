/* ==============================================================================
 * TheFlux Native Runtime: Fast Hash Map
 * Source: runtime/src/collections/map.c
 * ============================================================================== */

#include "flux/collections.h"
#include "flux/string.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INITIAL_MAP_CAP 16

FluxMap *flux_map_create(size_t initial_cap) {
    if (initial_cap == 0) initial_cap = INITIAL_MAP_CAP;
    FluxMap *map = (FluxMap *)malloc(sizeof(FluxMap));
    if (!map) return NULL;
    map->entries = (FluxMapEntry *)calloc(initial_cap, sizeof(FluxMapEntry));
    map->count = 0;
    map->capacity = initial_cap;
    return map;
}

static void map_resize(FluxMap *map, size_t new_cap) {
    FluxMapEntry *old_entries = map->entries;
    size_t old_cap = map->capacity;

    map->entries = (FluxMapEntry *)calloc(new_cap, sizeof(FluxMapEntry));
    map->capacity = new_cap;
    map->count = 0;

    for (size_t i = 0; i < old_cap; i++) {
        if (old_entries[i].occupied) {
            flux_hashmap_set(map, old_entries[i].key, old_entries[i].value);
            free(old_entries[i].key);
        }
    }
    free(old_entries);
}

void flux_hashmap_set(FluxMap *map, const char *key, FluxValue val) {
    if (!map || !key) return;
    if (map->count * 2 >= map->capacity) {
        map_resize(map, map->capacity * 2);
    }
    uint32_t hash = flux_str_hash(key);
    size_t idx = hash % map->capacity;

    while (map->entries[idx].occupied) {
        if (strcmp(map->entries[idx].key, key) == 0) {
            map->entries[idx].value = val;
            return;
        }
        idx = (idx + 1) % map->capacity;
    }

    map->entries[idx].key = strdup(key);
    map->entries[idx].value = val;
    map->entries[idx].hash = hash;
    map->entries[idx].occupied = true;
    map->count++;
}

bool flux_hashmap_get(FluxMap *map, const char *key, FluxValue *out) {
    if (!map || !key || map->count == 0) return false;
    uint32_t hash = flux_str_hash(key);
    size_t idx = hash % map->capacity;

    while (map->entries[idx].occupied) {
        if (strcmp(map->entries[idx].key, key) == 0) {
            if (out) *out = map->entries[idx].value;
            return true;
        }
        idx = (idx + 1) % map->capacity;
    }
    return false;
}

bool flux_hashmap_has(FluxMap *map, const char *key) {
    return flux_hashmap_get(map, key, NULL);
}

extern int64_t flux_list_len(void *p);
size_t flux_map_len(FluxMap *map) {
    if (!map) return 0;
    return map->count;
}

void flux_map_free(FluxMap *map) {
    if (!map) return;
    for (size_t i = 0; i < map->capacity; i++) {
        if (map->entries[i].occupied) {
            free(map->entries[i].key);
        }
    }
    free(map->entries);
    free(map);
}

void *flux_map_build(int64_t cap) {
    return flux_map_create((size_t)(cap > 0 ? cap : 16));
}

void *flux_map_set(void *p, const char *key, int64_t vtag, int64_t vval) {
    if (!p || !key) return p;
    FluxMap *map = (FluxMap *)p;
    FluxValue val;
    val.tag = (FluxTypeTag)vtag;
    val.as.ival = vval;
    flux_hashmap_set(map, key, val);
    return p;
}

int64_t flux_map_get(void *p, const char *key) {
    if (!p || !key) return 0;
    FluxMap *map = (FluxMap *)p;
    FluxValue out;
    if (flux_hashmap_get(map, key, &out)) {
        return out.as.ival;
    }
    return 0;
}

int64_t flux_map_get_tag(void *p, const char *key) {
    if (!p || !key) return 0;
    FluxMap *map = (FluxMap *)p;
    FluxValue out;
    if (flux_hashmap_get(map, key, &out)) {
        return (int64_t)out.tag;
    }
    return 0;
}

bool flux_map_contains_key(void *p, const char *key) {
    if (!p || !key) return false;
    FluxMap *map = (FluxMap *)p;
    return flux_hashmap_has(map, key);
}

void flux_hashmap_set_val(void *map, const char *key, int64_t val) {
    flux_map_set(map, key, 1, val);
}

int64_t flux_hashmap_get_val(void *map, const char *key) {
    return flux_map_get(map, key);
}

void flux_map_print(void *p) {
    if (!p) {
        printf("{}\n");
        return;
    }
    FluxMap *map = (FluxMap *)p;
    FluxValue v_val, v_sta, v_msg;
    if (flux_hashmap_get(map, "sta", &v_sta) && flux_hashmap_get(map, "msg", &v_msg) && flux_hashmap_get(map, "val", &v_val)) {
        if (v_val.tag == FLUX_TYPE_STRING) {
            printf("%s\n", v_val.as.sval ? v_val.as.sval : "");
        } else if (v_val.tag == FLUX_TYPE_FLOAT64) {
            printf("%.17g\n", v_val.as.fval);
        } else if (v_val.tag == FLUX_TYPE_BOOL) {
            printf("%s\n", v_val.as.bval ? "true" : "false");
        } else {
            printf("%lld\n", (long long)v_val.as.ival);
        }
        return;
    }
    printf("{");
    size_t printed = 0;
    for (size_t i = 0; i < map->capacity; i++) {
        if (map->entries[i].occupied) {
            if (printed > 0) printf(", ");
            printf("\"%s\": ", map->entries[i].key ? map->entries[i].key : "");
            FluxValue v = map->entries[i].value;
            if (v.tag == FLUX_TYPE_STRING) {
                printf("\"%s\"", v.as.sval ? v.as.sval : "");
            } else if (v.tag == FLUX_TYPE_FLOAT64) {
                printf("%.17g", v.as.fval);
            } else if (v.tag == FLUX_TYPE_BOOL) {
                printf("%s", v.as.bval ? "true" : "false");
            } else {
                printf("%lld", (long long)v.as.ival);
            }
            printed++;
        }
    }
    printf("}\n");
}
