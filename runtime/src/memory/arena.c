/* ==============================================================================
 * TheFlux Native Runtime: High-Performance Linear Arena Allocator
 * Source: runtime/src/memory/arena.c
 * ============================================================================== */

#include "flux/memory.h"
#include <stdlib.h>
#include <string.h>

#define DEFAULT_CHUNK_SIZE (64 * 1024) /* 64 KB */

FluxArena *flux_arena_create(size_t default_chunk_size) {
    if (default_chunk_size == 0) {
        default_chunk_size = DEFAULT_CHUNK_SIZE;
    }
    FluxArena *arena = (FluxArena *)malloc(sizeof(FluxArena));
    if (!arena) return NULL;

    size_t alloc_sz = sizeof(FluxArenaChunk) + default_chunk_size;
    FluxArenaChunk *chunk = (FluxArenaChunk *)malloc(alloc_sz);
    if (!chunk) {
        free(arena);
        return NULL;
    }
    chunk->capacity = default_chunk_size;
    chunk->used = 0;
    chunk->next = NULL;

    arena->head = chunk;
    arena->current = chunk;
    arena->chunk_size = default_chunk_size;
    arena->total_allocated = default_chunk_size;
    return arena;
}

void *flux_arena_alloc(FluxArena *arena, size_t size) {
    if (!arena || size == 0) return NULL;

    /* Align to 8 bytes */
    size = (size + 7) & ~((size_t)7);

    FluxArenaChunk *cur = arena->current;
    if (cur->used + size <= cur->capacity) {
        void *ptr = cur->data + cur->used;
        cur->used += size;
        return ptr;
    }

    size_t next_cap = arena->chunk_size;
    if (size > next_cap) {
        next_cap = size;
    }
    size_t alloc_sz = sizeof(FluxArenaChunk) + next_cap;
    FluxArenaChunk *new_chunk = (FluxArenaChunk *)malloc(alloc_sz);
    if (!new_chunk) return NULL;

    new_chunk->capacity = next_cap;
    new_chunk->used = size;
    new_chunk->next = NULL;

    cur->next = new_chunk;
    arena->current = new_chunk;
    arena->total_allocated += next_cap;

    return new_chunk->data;
}

void *flux_arena_alloc_zeroed(FluxArena *arena, size_t size) {
    void *ptr = flux_arena_alloc(arena, size);
    if (ptr) {
        memset(ptr, 0, size);
    }
    return ptr;
}

void flux_arena_reset(FluxArena *arena) {
    if (!arena) return;
    FluxArenaChunk *cur = arena->head;
    while (cur) {
        cur->used = 0;
        cur = cur->next;
    }
    arena->current = arena->head;
}

void flux_arena_destroy(FluxArena *arena) {
    if (!arena) return;
    FluxArenaChunk *cur = arena->head;
    while (cur) {
        FluxArenaChunk *next = cur->next;
        free(cur);
        cur = next;
    }
    free(arena);
}
