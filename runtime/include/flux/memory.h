/* ==============================================================================
 * TheFlux Native Runtime: Memory Management (Arena & ARC)
 * Header: runtime/include/flux/memory.h
 * ============================================================================== */

#ifndef FLUX_MEMORY_H
#define FLUX_MEMORY_H

#include "types.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Linear Arena Allocator for high-performance AST & FMIR pipelines */
typedef struct FluxArenaChunk {
    size_t capacity;
    size_t used;
    struct FluxArenaChunk *next;
    char data[];
} FluxArenaChunk;

typedef struct {
    FluxArenaChunk *head;
    FluxArenaChunk *current;
    size_t chunk_size;
    size_t total_allocated;
} FluxArena;

FluxArena *flux_arena_create(size_t default_chunk_size);
void *flux_arena_alloc(FluxArena *arena, size_t size);
void *flux_arena_alloc_zeroed(FluxArena *arena, size_t size);
void flux_arena_reset(FluxArena *arena);
void flux_arena_destroy(FluxArena *arena);

/* ARC (Atomic Reference Counting) header for managed dynamic objects */
typedef struct {
    int32_t ref_count;
    FluxTypeTag tag;
    void (*destructor)(void *ptr);
} FluxArcHeader;

void *flux_arc_alloc(size_t size, FluxTypeTag tag, void (*destructor)(void *));
void *flux_arc_retain(void *ptr);
void flux_arc_release(void *ptr);

#ifdef __cplusplus
}
#endif

#endif /* FLUX_MEMORY_H */
