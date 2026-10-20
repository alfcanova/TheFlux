/* ==============================================================================
 * TheFlux Fast Virtual Machine (FVM)
 * Header: runtime/fvm/fvm_core.h
 * ============================================================================== */

#ifndef FVM_CORE_H
#define FVM_CORE_H

#include <stdio.h>
#include "fvm_types.h"
#include "fvm_arena.h"

#ifdef __cplusplus
extern "C" {
#endif

#define FVM_STACK_CAPACITY 65536
#define FVM_CALL_STACK_CAPACITY 1024

typedef struct {
    FluxVal *stack;
    size_t stack_capacity;
    FluxVal *sp;
    FvmCallFrame *call_stack;
    size_t call_stack_capacity;
    size_t csp;
    FvmScope *scope;
    FvmArena arena;
    size_t ip;
    const char *stdin_cursor;
    FILE *out_stream;
    char *out_buffer;
    size_t out_len;
    size_t out_cap;
    char *err_buffer;
    size_t err_len;
    size_t err_cap;
    int exit_code;
    uint64_t instruction_count;
    uint64_t max_instructions;
} FvmState;

/* Inicializa o estado da VM */
void fvm_state_init(FvmState *vm, const char *stdin_text, FILE *out_stream);

/* Libera recursos da VM */
void fvm_state_cleanup(FvmState *vm);

/* Executa um programa FVM */
int fvm_execute_program(FvmState *vm, const FvmProgram *prog);

/* Executor de alta velocidade a partir de string JSON (usado pelo Named Pipe e CLI) */
int fvm_execute_json_buffer(
    const char *bytecode_json,
    const char *stdin_text,
    char **out_stdout,
    size_t *out_stdout_len,
    char **out_stderr,
    size_t *out_stderr_len
);

#ifdef __cplusplus
}
#endif

#endif /* FVM_CORE_H */
