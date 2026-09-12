# tensor Capability

## Purpose

Tensor N-dimensional de primitivos com shape estática, armazenado em buffer flat row-major indexável por strides. Indexação 1-based na linguagem, 0-based na máquina.

## Requirements

### Requirement: Layout flat por strides
O tensor SHALL ser armazenado em um bloco contíguo contendo header `[rank, d0..d{r-1}]` seguido dos elementos em row-major (primeira dimensão mais externa), cada elemento ocupando exatamente 8 bytes (i64; float bitcast; string como FAT; bool 0/1; char codepoint).

#### Scenario: Offset calculado por strides
- **WHEN** acesso `t[z, y, x]` em `tensor[Z, Y, X] of T`
- **THEN** o elemento lido é `data[((z-1)*Y + (y-1))*X + (x-1)]`

### Requirement: Indexação 1-based
Todo índice SHALL estar no intervalo fechado `[1, dk]` da respectiva dimensão k.

#### Scenario: Índice fora do range
- **WHEN** índice `i` não pertence a `[1, dk]`
- **THEN** erro de runtime informando a dimensão e o range válido

### Requirement: Literal validado contra shape
Um literal initializer SHALL ter estrutura retangular compatível com a shape declarada e folhas do tipo declarado.

#### Scenario: Ragged rejeitado
- **WHEN** `tensor[2,2] of int64: t = [[1, 2], [3]]`
- **THEN** erro (semantic e/ou runtime) de shape mismatch

#### Scenario: Mismatch de contagem rejeitado
- **WHEN** `tensor[2,2] of int64: t = [[1, 2]]`
- **THEN** erro de shape mismatch

### Requirement: Read preserva elem type
A leitura de elemento SHALL produzir valor do tipo declarado (não fixo float64).

#### Scenario: Tensor int64
- **WHEN** `print(t[2,2])` em `tensor[2,2] of int64`
- **THEN** saída inteira formatada como int64

### Requirement: Write valida todas as dimensões
A atribuição por índice SHALL validar bounds de cada dimensão percorrida.

### Requirement: Print aninhado
Print/concat de tensor SHALL usar formato `[[10, 20], [99, 40]]`, elementos formatados conforme seu tipo (strings sem aspas, bool lowercase).

### Requirement: Default zero-filled
Declaração sem initializer SHALL produzir buffer com todos os elementos zero.
