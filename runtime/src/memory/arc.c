/* ==============================================================================
 * TheFlux Native Runtime: Reference Counting Allocator (ARC)
 * Source: runtime/src/memory/arc.c
 * ============================================================================== */

#include "flux/memory.h"
#include <stdlib.h>

void *flux_arc_alloc(size_t size, FluxTypeTag tag, void (*destructor)(void *)) {
    size_t total = sizeof(FluxArcHeader) + size;
    FluxArcHeader *header = (FluxArcHeader *)malloc(total);
    if (!header) return NULL;

    header->ref_count = 1;
    header->tag = tag;
    header->destructor = destructor;

    return (void *)(header + 1);
}

void *flux_arc_retain(void *ptr) {
    if (!ptr) return NULL;
    FluxArcHeader *header = ((FluxArcHeader *)ptr) - 1;
    header->ref_count++;
    return ptr;
}

void flux_arc_release(void *ptr) {
    if (!ptr) return;
    FluxArcHeader *header = ((FluxArcHeader *)ptr) - 1;
    header->ref_count--;
    if (header->ref_count <= 0) {
        if (header->destructor) {
            header->destructor(ptr);
        }
        free(header);
    }
}
