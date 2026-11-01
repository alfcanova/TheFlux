## ADDED Requirements

### Requirement: Declaração e literal de set
Um set SHALL ser declarado com `mut as set of <Type>: <var> = {<valor>, ...}` onde `<Type>` é obrigatório, os valores duplicados SHALL ser eliminados (dedup) preservando a primeira ocorrência, e o set vazio é `{}`.

#### Scenario: Set com dedup
- **WHEN** um programa declara `mut as set of string: s = {"temp", "pressao", "temp", "vibracao"}`
- **THEN** `s` contém elementos únicos e o print exibe `{temp, pressao, vibracao}` nos 5 backends (in, vm, wat, wasm, llvm)

#### Scenario: Set de inteiros
- **WHEN** um programa declara `mut as set of int64: valores = {1, 2, 2, 3}`
- **THEN** `valores` contém `{1, 2, 3}` nos 5 backends

#### Scenario: Reassign de set
- **WHEN** executa `valores = {3, 4, 4, 5}` sobre um set existente
- **THEN** `valores` passa a conter `{3, 4, 5}` nos 5 backends

### Requirement: Operador in sobre set
A expressão `<elem> in <set>` SHALL devolver true se o elemento pertence ao set, false caso contrário, nos 5 backends.

#### Scenario: Pertinência presente
- **WHEN** `s = {"temp", "pressao", "vibracao"}` e executa `"temp" in s`
- **THEN** o resultado é `true`

#### Scenario: Pertinência ausente
- **WHEN** executa `"umidade" in s` e `2 in {1, 2, 3}`
- **THEN** o resultado é `false` e `true` respectivamente

### Requirement: Print e concatenação de set
A exibição de um set SHALL usar `{e1, e2, ...}` com vírgula e espaço; strings sem aspas. `"texto: " + <set>` SHALL concatenar a representação formatada do set.

#### Scenario: Print de set
- **WHEN** `print(sensores)` com `sensores = {temp, pressao, vibracao}`
- **THEN** a saída é `{temp, pressao, vibracao}`

#### Scenario: Concatenação string + set
- **WHEN** executa `print("Set inicial: " + valores)` com set de inteiros
- **THEN** a saída é `Set inicial: {1, 2, 3}` sem erro

#### Scenario: Concatenação string + resultado de op
- **WHEN** executa `print("Incluir item no set: " + include(set_a, 4))`
- **THEN** a saída é `Incluir item no set: {3, 4, 5}` e a op é avaliada primeiro

### Requirement: Operações da stdlib de set
Todas as operações de set SHALL residir no agente `SetStdLib` em `stdlib/SetStdLib.fdsl` (include, exclude, union, intersect, difference, symmetricDifference, isSubset, isSuperset, isDisjoint, toList, toSet), chamáveis via `use SetStdLib`, e SHALL ser **autocontidas no próprio tipo** (nenhum builtin de linguagem fora do fdsl; nenhuma referência a bibliotecas externas). Sets são coleções mutáveis: as operações `include` e `exclude` SHALL mutar o conjunto argumento *in-place* e retornar a referência ao conjunto modificado. Corpos SHALL empregar intrínsecos privados `stdSet*` (ex: `stdSetInclude`, `stdSetUnion`, `stdSetIsSubset`, `stdSetToList`, `stdSetToSet`).

#### Scenario: Chamada de op importada e mutabilidade
- **WHEN** programa contém `use SetStdLib`, `set_a = {1, 2, 3}` e executa `include(set_a, 4)`
- **THEN** `set_a` passa a conter `{1, 2, 3, 4}` e a saída é `{1, 2, 3, 4}` nos 5 backends

#### Scenario: Álgebra de sets
- **WHEN** `set_a = {1, 2, 3}` e `set_b = {3, 4}` e executa `union(set_a, set_b)`, `intersect(set_a, set_b)`, `difference(set_a, set_b)`, `symmetricDifference(set_a, set_b)`
- **THEN** o resultado é `{1, 2, 3, 4}`, `{3}`, `{1, 2}`, `{1, 2, 4}` respectivamente

#### Scenario: Relações entre sets
- **WHEN** executa `isSubset({1, 2}, {1, 2, 3})`, `isSuperset({1, 2, 3}, {1, 2})`, `isDisjoint({8, 9}, {1, 2})`
- **THEN** o resultado é `true`, `true`, `true` respectivamente

#### Scenario: Conversões
- **WHEN** executa `toList(set_a)` e `toSet([1, 1, 2, 3])`
- **THEN** o resultado é `[1, 2, 3]` e `{1, 2, 3}` respectivamente

### Requirement: Intrínsecos stdSet nos 5 backends
Cada backend SHALL expor os intrínsecos `stdSet*` usados pelos corpos do `SetStdLib.fdsl`: `stdSetInclude`, `stdSetExclude`, `stdSetUnion`, `stdSetIntersect`, `stdSetDifference`, `stdSetSymmetricDifference`, `stdSetIsSubset`, `stdSetIsSuperset`, `stdSetIsDisjoint`, `stdSetToList`, `stdSetToSet`.

#### Scenario: Intrínseco ausente
- **WHEN** um backend executa op cujo corpo chama intrínseco `stdSet*`
- **THEN** não ocorre "undefined function"; o intrínseco executa e devolve o valor esperado

### Requirement: Runtime embutido para WAT, WASM e LLVM
Os backends WAT, WASM e LLVM SHALL gerar representação própria de set no artefato (memória linear estática/`$flux_alloc` no WASM; array estático global no LLVM) com helpers de operações e formatação de print idêntica à do interpretador.

#### Scenario: Paridade de saída
- **WHEN** executa `flux/ExampleOfSet.flux` em cada um dos 5 backends
- **THEN** a saída é idêntica à do interpretador (IN)