# Design — Tensor Strides

## Layout de memória (todos os backends)

```
ptr ──► [rank: i32]                      # +0
        [d0: i32] ... [d{rank-1}: i32]   # +4 .. +4*rank
        (pad p/ 8)
data ──► elemento[i0, i1, ..., i{r-1}]   # 1-based na fonte
```

- Offset flat **máquina** (0-based): `off = ((i0-1)*d1*d2*... + (i1-1)*d2*... + ... + (ir-1)) * 8` bytes a partir de `data`.
- Strides em bytes são constexpr quando dims são estáticas (sempre são): `S_last=8`, `S_k = d_{k+1} * S_{k+1}`.
- Elemento: i64. float bitcast; char = codepoint; string = FAT `(ptr<<32)|len`; bool = 0/1.
- Tamanho total do bloco: `16-aligned(8 + 8*ceil(4*(rank+1)/8) + prod(dims)*8)` — alocado via `$flux_alloc`/malloc.

## Semântica

### Indexação
- Fonte 1-based em todas as dimensões (`t[1,1]` é o primeiro elemento).
- Índice literal → offset constexpr no codegen.
- Índice variável → `sub 1` por dimensão antes do dot product.
- Bounds: cada dimensão validada `1 <= idx <= dk`; violação = erro de runtime com dim e range.

### Literal initializer
- Validado estaticamente contra a shape declarada (semantic): retangularidade + contagem por nível + tipo dos folhas.
- Runtime re-checa na declaração (interpreter/VM) — erro se mismatch.

### Read
- Retorna valor com o elem type do tensor (corrige bug do float64 hardcoded).

### Write
- Valida bounds de TODAS as dimensões no caminho.

### Print / concat string+tensor
- Formato aninhado `[[10, 20], [99, 40]]`, elementos formatados como print escalar (strings sem aspas, bool lowercase, float via fmt padrão).

### Default
- Decl sem init → buffer zero-filled.

## Backend notes

| Alvo | Storage | Index math | Print |
|---|---|---|---|
| run | list flat Python | índices -1 + strides Python | recursivo com shape |
| vmbc | list flat + shape embutida no Value | strides const no compiler → idx_flat; opcodes `TGET/TSET` | helper runtime |
| wat | `$flux_alloc` block | inline `i32.load/store` c/ offset const | `$tensor_to_str(ptr)` lendo header |
| wasm | idem wat, binário | idem | espelho |
| llvm | `[i64 rank][i64 dims r][i64 data n]` struct-less | `getelementptr` c/ offsets const | loops printf |

VM `TGET/TSET`: recebem `idx_flat` já calculado pelo compiler (strides const); runtime só indexa lista flat e valida range total.

## Não-goals

- Tensor dinâmico (shape mutável), slicing N-D de tensor, ops algébricas (matmul etc.), tensors de coleções (elem é sempre primitivo).
