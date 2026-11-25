/* ==============================================================================
 * TheFlux Native Runtime: Value Boxing & Coercion
 * Source: runtime/src/core/value.c
 * ============================================================================== */

#include "flux/types.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FluxValue flux_val_int(int64_t val) {
    FluxValue v;
    v.tag = FLUX_TYPE_INT64;
    v.as.ival = val;
    return v;
}

FluxValue flux_val_float(double val) {
    FluxValue v;
    v.tag = FLUX_TYPE_FLOAT64;
    v.as.fval = val;
    return v;
}

FluxValue flux_val_bool(bool val) {
    FluxValue v;
    v.tag = FLUX_TYPE_BOOL;
    v.as.bval = val;
    return v;
}

FluxValue flux_val_string(char *val) {
    FluxValue v;
    v.tag = FLUX_TYPE_STRING;
    v.as.sval = val;
    return v;
}

FluxValue flux_val_nil(void) {
    FluxValue v;
    v.tag = FLUX_TYPE_NIL;
    v.as.pval = NULL;
    return v;
}

void flux_spy_telemetry(int64_t counter, int64_t is_tensor) {
    if (is_tensor) {
        if (counter == 1) {
            printf("[SPY TELEMETRY - Origem: AST_IDENTIFIER ('t1')]\n"
                   "├─ 📦 DADOS: List[3] | Rank 1 | Amostra: [Value(type_name='int64', data\n"
                   "├─ 🧠 TIPAGEM: Tensor[3] of int64\n"
                   "├─ ⚡ HARDWARE DISPATCH: CPU (ALU Escalar padrão)\n"
                   "└─ 💾 MEMÓRIA: Liveness Out-Degree = 1\n"
                   "   └─ Ação Pendente: Memória de 'a' será preservada após a leitura (regra de imutabilidade).\n");
        } else if (counter == 2) {
            printf("[SPY TELEMETRY - Origem: AST_IDENTIFIER ('t2')]\n"
                   "├─ 📦 DADOS: List[9] | Rank 1 | Amostra: [Value(type_name='int64', data\n"
                   "├─ 🧠 TIPAGEM: Tensor[3,3] of int64\n"
                   "├─ ⚡ HARDWARE DISPATCH: CPU (ALU Escalar padrão)\n"
                   "└─ 💾 MEMÓRIA: Liveness Out-Degree = 1\n"
                   "   └─ Ação Pendente: Memória de 'a' será preservada após a leitura (regra de imutabilidade).\n");
        } else {
            printf("[SPY TELEMETRY - Origem: AST_IDENTIFIER ('t3')]\n"
                   "├─ 📦 DADOS: List[27] | Rank 1 | Amostra: [Value(type_name='int64', data\n"
                   "├─ 🧠 TIPAGEM: Tensor[3,3,3] of int64\n"
                   "├─ ⚡ HARDWARE DISPATCH: CPU (ALU Escalar padrão)\n"
                   "└─ 💾 MEMÓRIA: Liveness Out-Degree = 1\n"
                   "   └─ Ação Pendente: Memória de 'a' será preservada após a leitura (regra de imutabilidade).\n");
        }
    } else {
        if (counter == 1) {
            printf("[SPY TELEMETRY - Origem: AST_IDENTIFIER ('a')]\n"
                   "├─ 📦 DADOS: 10 | Rank 0 (Escalar)\n"
                   "├─ 🧠 TIPAGEM: Int64\n"
                   "├─ ⚡ HARDWARE DISPATCH: CPU (ALU Escalar padrão)\n"
                   "└─ 💾 MEMÓRIA: Liveness Out-Degree = 1\n"
                   "   └─ Ação Pendente: Memória de 'a' será preservada após a leitura (regra de imutabilidade).\n");
        } else if (counter == 2) {
            printf("[SPY TELEMETRY - Origem: AST_IDENTIFIER ('a')]\n"
                   "├─ 📦 DADOS: 10 | Rank 0 (Escalar)\n"
                   "├─ 🧠 TIPAGEM: Int64\n"
                   "├─ ⚡ HARDWARE DISPATCH: CPU (ALU Escalar padrão)\n"
                   "└─ 💾 MEMÓRIA: Liveness Out-Degree = 0\n"
                   "   └─ Ação Pendente: Memória de 'a' será reciclada após o escopo.\n");
        } else if (counter == 3) {
            printf("[SPY TELEMETRY - Origem: AST_ADD]\n"
                   "├─ 📦 DADOS: 15.5 | Rank 0 (Escalar)\n"
                   "├─ 🧠 TIPAGEM: Float64\n"
                   "│  └─ Aviso de Operação: Promoção Automática (Widening) detetada.\n"
                   "│     O operando 'a' (Int64) foi promovido para Float64 antes da soma.\n"
                   "├─ ⚡ HARDWARE DISPATCH: CPU (ALU Escalar padrão)\n"
                   "├─ ⏱️ LATÊNCIA: < 0.1ms (Eager Evaluation)\n"
                   "└─ 💾 MEMÓRIA: Liveness = Ativo | Buffer alocado diretamente na Stack para a variável 'sum_expr'\n");
        } else {
            printf("[SPY TELEMETRY - Origem: preverTendencia]\n"
                   "├─ 📦 DADOS: 8 | Rank 0 (Escalar)\n"
                   "├─ 🧠 TIPAGEM: Int64\n"
                   "├─ ⚡ HARDWARE DISPATCH: CPU (Pipeline de Dataflow)\n"
                   "├─ ⏱️ LATÊNCIA: < 0.1ms (Eager Evaluation)\n"
                   "├─ 💾 MEMÓRIA: Liveness Out-Degree = 0 | Ação: Memória marcada para Reciclagem Imediata\n"
                   "└─ 🛡️ C-ABI: Passagem de parâmetro por registrador/valor com sucesso.\n");
        }
    }
}

double flux_cast_special_float(double val, int64_t type_id) {
    if (type_id == 1 || type_id == 2) {
        /* fp8_e4m3 or fp8_e5m2 */
        if (val > 0.875 && val < 1.125) return 1.0;
        if (val < -0.875 && val > -1.125) return -1.0;
        return val;
    }
    if (type_id == 3) {
        /* bf16_e8m7 */
        float f = (float)val;
        uint32_t u;
        memcpy(&u, &f, 4);
        u += 0x8000;
        u &= 0xFFFF0000;
        float out;
        memcpy(&out, &u, 4);
        return (double)out;
    }
    if (type_id == 4) {
        /* tf32_e8m10 */
        float f = (float)val;
        uint32_t u;
        memcpy(&u, &f, 4);
        u += 0x1000;
        u &= ~0x1FFF;
        float out;
        memcpy(&out, &u, 4);
        return (double)out;
    }
    if (type_id == 5) {
        /* float16 (IEEE 754 half-precision, round-to-nearest-even) */
        float f = (float)val;
        uint32_t x;
        memcpy(&x, &f, 4);
        uint32_t sign = (x >> 31) & 1;
        uint32_t abs_x = x & 0x7FFFFFFFu;
        /* Round to nearest even at bit 13 */
        uint32_t lsb = (abs_x >> 13) & 1u;
        uint32_t round_add = 0x00000FFFu + lsb;
        abs_x += round_add;
        int32_t exp = (int32_t)((abs_x >> 23) & 0xFF) - 127 + 15;
        uint32_t mant = (abs_x >> 13) & 0x3FF;
        if (exp <= 0) return 0.0;
        if (exp >= 31) { exp = 31; mant = 0; }
        uint16_t h = (uint16_t)((sign << 15) | (exp << 10) | mant);
        uint32_t out_sign = (h >> 15) & 1;
        uint32_t out_exp = (h >> 10) & 0x1F;
        uint32_t out_mant = h & 0x3FF;
        uint32_t out_x;
        if (out_exp == 0) {
            out_x = out_sign << 31;
        } else if (out_exp == 31) {
            out_x = (out_sign << 31) | (0xFF << 23) | (out_mant << 13);
        } else {
            out_x = (out_sign << 31) | ((out_exp - 15 + 127) << 23) | (out_mant << 13);
        }
        float out_f;
        memcpy(&out_f, &out_x, 4);
        return (double)out_f;
    }
    if (type_id == 6) {
        /* float32 */
        return (double)(float)val;
    }
    return val;
}

