/* ==============================================================================
 * TheFlux Fast Virtual Machine (FVM)
 * Header: runtime/fvm/fvm_parser.h
 * ============================================================================== */

#ifndef FVM_PARSER_H
#define FVM_PARSER_H

#include "fvm_types.h"
#include "fvm_arena.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Converte nome de string de opcode para FvmOpcode */
FvmOpcode fvm_opcode_from_str(const char *name);

/* Nome do opcode em string */
const char *fvm_opcode_name(FvmOpcode op);

/* Carrega e deserializa bytecode .fvmbc a partir de string JSON */
int fvm_program_load_json(FvmProgram *prog, FvmArena *arena, const char *json_text);

/* Carrega bytecode a partir de um arquivo .fvmbc */
int fvm_program_load_file(FvmProgram *prog, FvmArena *arena, const char *filepath);

#ifdef __cplusplus
}
#endif

#endif /* FVM_PARSER_H */
