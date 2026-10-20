/* ==============================================================================
 * TheFlux Fast Virtual Machine (FVM)
 * Header: runtime/fvm/fvm_arena.h
 * ============================================================================== */

#ifndef FVM_ARENA_H
#define FVM_ARENA_H

#include <stdio.h>
#include "fvm_types.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct FvmArenaBlock {
    struct FvmArenaBlock *next;
    size_t capacity;
    size_t offset;
    char data[1];
} FvmArenaBlock;

typedef struct FvmArena {
    FvmArenaBlock *current;
    size_t block_size;
} FvmArena;

void fvm_arena_init(FvmArena *arena, size_t default_block_size);
void *fvm_arena_alloc(FvmArena *arena, size_t size);
char *fvm_arena_strdup(FvmArena *arena, const char *str);
char *fvm_arena_strndup(FvmArena *arena, const char *str, size_t n);
void fvm_arena_free_all(FvmArena *arena);

/* Construtores de Valores */
FluxVal fvm_val_nil(void);
FluxVal fvm_val_bool(bool b);
FluxVal fvm_val_int(int64_t i);
FluxVal fvm_val_float(double f);
FluxVal fvm_val_char(uint32_t c);
FluxVal fvm_val_datetime(int64_t nanos);
FluxVal fvm_val_complex(FvmArena *arena, double r, double i);
FluxVal fvm_val_str(FvmArena *arena, const char *s);
FluxVal fvm_val_list(FvmArena *arena, uint32_t initial_cap);
FluxVal fvm_val_map(FvmArena *arena);
FluxVal fvm_val_struct(FvmArena *arena, const char *type_name, uint32_t nfields);
FluxVal fvm_val_enum(FvmArena *arena, const char *type_name, const char *variant, int32_t tag, uint32_t nfields);
FluxVal fvm_val_status(FvmArena *arena, const char *status, FluxVal val, const char *msg);

/* Operações sobre Valores */
FluxVal fvm_unwrap(FluxVal v);
bool fvm_val_is_truthy(FluxVal v);
char *fvm_val_to_str(FvmArena *arena, FluxVal v);
void fvm_val_print(FluxVal v, bool newline, FILE *stream, char **str_acc, size_t *acc_len, size_t *acc_cap);
bool fvm_val_equal(FluxVal a, FluxVal b);

#ifdef __cplusplus
}
#endif

#endif /* FVM_ARENA_H */
