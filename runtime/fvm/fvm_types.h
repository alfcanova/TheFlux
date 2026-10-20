/* ==============================================================================
 * TheFlux Fast Virtual Machine (FVM)
 * Header: runtime/fvm/fvm_types.h
 * ============================================================================== */

#ifndef FVM_TYPES_H
#define FVM_TYPES_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Enumeração dos 92 Opcodes Canônicos da VM TheFlux */
typedef enum {
    OP_HALT = 0,
    OP_PUSH,
    OP_LOAD,
    OP_STORE,
    OP_MAKE_REF,
    OP_DECLARE,
    OP_ADD,
    OP_SUB,
    OP_MUL,
    OP_DIV,
    OP_IDIV,
    OP_REM,
    OP_POW_E,
    OP_POW_R,
    OP_NEG,
    OP_NOT,
    OP_DUP,
    OP_POP,
    OP_EQ,
    OP_NE,
    OP_LT,
    OP_LE,
    OP_GT,
    OP_GE,
    OP_AND,
    OP_OR,
    OP_BAND,
    OP_BOR,
    OP_BXOR,
    OP_BSHL,
    OP_BSHR,
    OP_BSHRU,
    OP_BNOT,
    OP_PRINT,
    OP_PRINTLN,
    OP_INPUT,
    OP_JMP,
    OP_JZ,
    OP_JNZ,
    OP_CALL,
    OP_RET,
    OP_SCOPE_ENTER,
    OP_SCOPE_EXIT,
    OP_EMIT,
    OP_FAIL,
    OP_IS_FAIL,
    OP_MAKE_STRUCT,
    OP_FIELD_ACCESS,
    OP_FIELD_SET,
    OP_TO_STRING,
    OP_JUMP_IF_NOT_MATCH,
    OP_JUMP_IF_NOT_MATCH_DROP,
    OP_MATCH_BIND,
    OP_MATCH_FAIL,
    OP_ENUM_NEW,
    OP_ENUM_TAG,
    OP_ENUM_FIELD,
    OP_STRUCT_MATCH,
    OP_FIELD_GET,
    OP_ROUND,
    OP_ROUND_COMPLEX,
    OP_INDEX,
    OP_INDEX_ASSIGN,
    OP_TGET,
    OP_TSET,
    OP_TENSOR_PACK,
    OP_TSLICE,
    OP_TMAT,
    OP_SLICE,
    OP_IN,
    OP_MAKE_LIST,
    OP_MAKE_SET,
    OP_MAKE_MAP,
    OP_MAKE_RECORD,
    OP_RECORD_MATCH,
    OP_RECORD_FIELD,
    OP_LIST_MATCH,
    OP_LIST_ITEM,
    OP_LIST_REST,
    OP_SPLIT,
    OP_JOIN,
    OP_CAST,
    OP_ITER_NEW,
    OP_ITER_NEXT,
    OP_UNWRAP_NICE,
    OP_SPY,
    OP_COUNT
} FvmOpcode;

/* Tipos de Valores FVM */
typedef enum {
    VAL_NIL = 0,
    VAL_BOOL,
    VAL_INT,        /* int64_t */
    VAL_FLOAT,      /* double */
    VAL_CHAR,       /* uint32_t UTF-32 */
    VAL_DATETIME,   /* int64_t nanos */
    VAL_COMPLEX,    /* double r, i */
    VAL_STRING,     /* FvmString* */
    VAL_LIST,       /* FvmList* */
    VAL_MAP,        /* FvmMap* */
    VAL_SET,        /* FvmSet* */
    VAL_STRUCT,     /* FvmStruct* */
    VAL_ENUM,       /* FvmEnum* */
    VAL_TENSOR,     /* FvmTensor* */
    VAL_STATUS,     /* FvmStatus* */
    VAL_REF         /* Slot pointer */
} ValType;

/* Representação de Valor Tagged (16 bytes alinhados) */
typedef struct FluxVal {
    uint8_t type;
    uint8_t flags;
    uint16_t aux;
    int32_t len;
    union {
        int64_t i64;
        double f64;
        uint32_t u32[2];
        void *ptr;
    } as;
} FluxVal;

/* Estruturas de Heap / Coleções */

typedef struct FvmString {
    uint32_t hash;
    uint32_t len;
    char chars[1]; /* Flexible array */
} FvmString;

typedef struct FvmList {
    uint32_t count;
    uint32_t capacity;
    FluxVal *items;
} FvmList;

typedef struct FvmMapEntry {
    char *key;
    FluxVal val;
    struct FvmMapEntry *next;
} FvmMapEntry;

typedef struct FvmMap {
    uint32_t count;
    uint32_t bucket_count;
    FvmMapEntry **buckets;
} FvmMap;

typedef struct FvmField {
    char *name;
    FluxVal val;
} FvmField;

typedef struct FvmStruct {
    char *type_name;
    uint32_t field_count;
    FvmField *fields;
} FvmStruct;

typedef struct FvmEnum {
    char *type_name;
    char *variant;
    int32_t tag;
    uint32_t field_count;
    FvmField *fields;
} FvmEnum;

typedef struct FvmComplex {
    double real;
    double imag;
} FvmComplex;

typedef struct FvmTensor {
    uint32_t ndims;
    int32_t *dims;
    int32_t *strides;
    int32_t offset;
    uint32_t total_elements;
    FluxVal *data;
} FvmTensor;

typedef struct FvmStatus {
    char *status; /* "nice", "fail", etc. */
    FluxVal val;
    char *msg;
} FvmStatus;

/* Instrução em Memória da FVM */
typedef struct FvmInstr {
    uint8_t opcode;
    uint8_t aux;
    int32_t imm_int;
    char *imm_str;
    FluxVal imm_val;
    char **field_names;
    int32_t field_count;
} FvmInstr;

/* Programa Compilado em Memória */
typedef struct FvmProgram {
    FvmInstr *instrs;
    size_t count;
    size_t capacity;
} FvmProgram;

/* Frame de Escopo Léxico */
#define FVM_MAX_SCOPE_VARS 64
typedef struct FvmScope {
    uint32_t var_count;
    char *names[FVM_MAX_SCOPE_VARS];
    FluxVal values[FVM_MAX_SCOPE_VARS];
    struct FvmScope *parent;
} FvmScope;

/* Frame de Chamada */
typedef struct FvmCallFrame {
    size_t ret_ip;
    FvmScope *scope;
    size_t sp_base;
} FvmCallFrame;

#ifdef __cplusplus
}
#endif

#endif /* FVM_TYPES_H */
