/* ==============================================================================
 * TheFlux Native Runtime: String Set
 * Source: runtime/src/collections/set.c
 * ============================================================================== */

#include "flux/collections.h"
#include <stdlib.h>
#include <string.h>

#define INITIAL_SET_CAP 16

FluxSet *flux_set_create(size_t initial_cap) {
    if (initial_cap == 0) initial_cap = INITIAL_SET_CAP;
    FluxSet *set = (FluxSet *)malloc(sizeof(FluxSet));
    if (!set) return NULL;
    set->items = (char **)malloc(sizeof(char *) * initial_cap);
    set->count = 0;
    set->capacity = initial_cap;
    return set;
}

void flux_set_add(FluxSet *set, const char *item) {
    if (!set || !item || flux_set_has(set, item)) return;
    if (set->count >= set->capacity) {
        size_t new_cap = set->capacity * 2;
        char **new_items = (char **)realloc(set->items, sizeof(char *) * new_cap);
        if (!new_items) return;
        set->items = new_items;
        set->capacity = new_cap;
    }
    set->items[set->count++] = strdup(item);
}

bool flux_set_has(FluxSet *set, const char *item) {
    if (!set || !item) return false;
    for (size_t i = 0; i < set->count; i++) {
        if (strcmp(set->items[i], item) == 0) return true;
    }
    return false;
}

size_t flux_set_len(FluxSet *set) {
    return set ? set->count : 0;
}

void flux_set_free(FluxSet *set) {
    if (!set) return;
    for (size_t i = 0; i < set->count; i++) {
        free(set->items[i]);
    }
    free(set->items);
    free(set);
}
