## ADDED Requirements

### Requirement: Declaração e literal de data
Um `data` SHALL ser declarado com `mut as data: <var> = [<valor>, ...]` (ou `imut as data`), aceitando elementos heterogêneos e aninhados (listas como elemento). `data` sem inicialização SHALL ser `[]`. Indexação SHALL ser 1-based (`[1]` = primeiro).

#### Scenario: Data heterogêneo
- **WHEN** declara `mut as data: payload = ["ok", 42, [0.1, 0.2, 0.3], 0]` e executa `print(payload)`
- **THEN** a saída é `[ok, 42, [0.1, 0.2, 0.3], 0]` nos 5 backends (in, vm, wat, wasm, llvm)

#### Scenario: Data sem inicialização
- **WHEN** declara `mut as data: d` e executa `print(d)`
- **THEN** a saída é `[]` nos 5 backends

#### Scenario: Indexação 1-based
- **WHEN** executa `print(payload[1])` e `print(payload[3][1])`
- **THEN** a saída é `ok` e `0.1` respectivamente nos 5 backends

### Requirement: Atribuição indexada com growth
`<coll>[i] = v` sobre `data` ou `list` SHALL: substituir se `1 <= i <= len`; fazer append se `i == len+1`; e lançar erro out-of-range se `i > len+1`. Aplicável em qualquer profundidade de aninhamento.

#### Scenario: Replace in-range
- **WHEN** `d = [1, 2, 3]` e executa `d[1] = 42`
- **THEN** `d` passa a ser `[42, 2, 3]`

#### Scenario: Append em len+1
- **WHEN** `d = [1, 2, 3]` e executa `d[4] = 100` e `d[5] = 200`
- **THEN** `d` passa a ser `[1, 2, 3, 100, 200]` nos 5 backends

#### Scenario: Buraco proibido
- **WHEN** `d = [1, 2, 3]` e executa `d[5] = 100`
- **THEN** ocorre erro `out of range`

#### Scenario: Mutação aninhada
- **WHEN** `d = [1, [0.1, 0.2], 3]` e executa `d[2][2] = 0.25`
- **THEN** `d` passa a ser `[1, [0.1, 0.25], 3]` nos 5 backends

### Requirement: Tipos de coleção aninhados
A declaração de `list of <T>`/`set of <T>` SHALL aceitar `<T>` sendo outro tipo de coleção (`list of list of string`, `list of data`), sem erro SEM001.

#### Scenario: Lista de listas
- **WHEN** declara `mut as list of list of string: pair_list = [["a", "um"], ["b", "dois"]]` e executa `print(pair_list)`
- **THEN** a saída é `[a, um, b, dois]` nos 5 backends
