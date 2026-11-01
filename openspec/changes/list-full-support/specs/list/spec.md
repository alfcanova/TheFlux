## ADDED Requirements

### Requirement: Declaração e literal de lista
Uma lista SHALL ser declarada com `mut as list of <Type>: <var> = [<valor>, ...]` onde `<Type>` é obrigatório, os valores são homogêneos por tipo declarado (listas aninhadas e `list of data` permitem heterogeneidade de fato), e a lista vazia é `[]`.

#### Scenario: Lista numérica
- **WHEN** um programa declara `mut as list of int64: xs = [10, 20, 30]`
- **THEN** `xs` contém `[10, 20, 30]` nos 5 backends (run, vmbc, wat, wasm, llvm)

#### Scenario: Lista de strings
- **WHEN** um programa declara `mut as list of string: nomes = ["ana", "bia"]`
- **THEN** `nomes` contém `[ana, bia]` e itens acessam por índice 1-based

#### Scenario: Lista vazia
- **WHEN** um programa declara `mut as list of int64: v = []`
- **THEN** `v` é uma lista vazia e `listIsEmpty(v)` retorna true

#### Scenario: Lista aninhada
- **WHEN** um programa declara `mut as list of data: nested = [[1, 2], [3, 4], 5]`
- **THEN** o print exibe `[[1, 2], [3, 4], 5]` nos 5 backends

### Requirement: Indexação 1-based de lista
Um acesso a elemento de lista SHALL usar índice 1-based: `xs[1]` é o primeiro elemento. Acesso fora do intervalo `1..len` SHALL ser erro de runtime em todos os backends.

#### Scenario: Leitura por índice
- **WHEN** `xs = [10, 20, 30]` e executa `print(xs[1])` e `print(xs[3])`
- **THEN** a saída é `10` e `30`

#### Scenario: Atribuição por índice
- **WHEN** executa `xs[2] = 25` com `xs = [10, 20, 30]`
- **THEN** `xs` passa a ser `[10, 25, 30]`

#### Scenario: Índice fora de range
- **WHEN** executa `xs[4]` com `xs = [10, 20, 30]`
- **THEN** ocorre erro de runtime (não produz resultado silencioso)

### Requirement: Slice de lista
Um slice SHALL ser escrito `xs[start..end]` e SHALL ser **inclusivo nos dois extremos** (1-based). `start > end` SHALL produzir lista vazia. Índices fora do range SHALL ser erro de runtime.

#### Scenario: Fatia inclusiva
- **WHEN** `numbers = [10, 20, 30, 40]` e executa `print(numbers[2..3])`
- **THEN** a saída é `[20, 30]`

#### Scenario: Fatia em op da stdlib
- **WHEN** executa `listSlice(numbers, 2, 3)`
- **THEN** o resultado é `[20, 30]`

### Requirement: Print e concatenação de lista
A exibição de uma lista SHALL usar `[e1, e2, ...]` com vírgula e espaço; strings sem aspas; aninhamento recursivo. `"texto: " + xs` SHALL concatenar a representação formatada da lista.

#### Scenario: Print de lista
- **WHEN** `print(xs)` com `xs = [10, 25, 30]`
- **THEN** a saída é `[10, 25, 30]`

#### Scenario: Concatenação string + lista
- **WHEN** executa `print("List inicial: " + valores)` com lista de inteiros
- **THEN** a saída é a string com a lista formatada (ex: `List inicial: [10, 20, 30]`) sem erro

#### Scenario: Concatenação string + resultado de op
- **WHEN** executa `print("Tamanho da lista: " + listLength(numbers))`
- **THEN** a saída é `Tamanho da lista: 4` e a op é avaliada primeiro

### Requirement: Operações da stdlib de lista
Todas as operações de lista SHALL residir no agente `ListStdLib` em `stdlib/ListStdLib.fdsl` com nome prefixado `list*` (ex: `listLength`, `listIsEmpty`, `listContains`, `listClearAll`, `listFirst`, `listSecond`, `listThird`, `listGetAt`, `listSlice`, `listSingletonInt`, `listSingletonString`, `listPushBack`, `listPushFront`, `listInsertAt`, `listRemoveAt`, `listRemoveLast`, `listSortAscending`, `listSortDescending`, `listReverse`, `listFlatten`, `listPartition`, `listZip`, `listUnzip`, `listToList`, `listToSet`, `listToMap`), chamáveis via `use ListStdLib`, e SHALL ser autocontidas no tipo (nenhum builtin de linguagem fora do fdsl). Corpos SHALL empregar intrínsecos privados `stdList*` (ex: `stdListLength`, `stdListPushBack`).

#### Scenario: Chamada de op importada
- **WHEN** programa contém `use ListStdLib` e executa `print(listLength(numbers))` com `numbers = [10, 20, 30, 40]`
- **THEN** a saída é `4` nos 5 backends

#### Scenario: Operação mutadora
- **WHEN** executa `print(listPushBack(numbers, 50))` com `numbers = [10, 20, 30, 40]`
- **THEN** a saída é `[10, 20, 30, 40, 50]`

#### Scenario: Ordenação por tipo de elemento
- **WHEN** executa `listSortAscending(["ana", "caio", "bia"])` e `listSortAscending([30, 10, 40])`
- **THEN** o resultado é `[ana, bia, caio]` (lexicográfico) e `[10, 30, 40]` (numérico)

#### Scenario: Zip com menor comprimento
- **WHEN** executa `listZip([1, 2], [10, 20, 30])`
- **THEN** o resultado é `[[1, 10], [2, 20]]` (sobras descartadas)

#### Scenario: Unzip de pares
- **WHEN** executa `listUnzip(listZip([1, 2], [10, 20]))`
- **THEN** o resultado restaura as duas listas originais

### Requirement: Intrínsecos stdList nos 5 backends
Cada backend SHALL expor os intrínsecos `stdList*` usados pelos corpos do `ListStdLib.fdsl`: `stdListLength`, `stdListIsEmpty`, `stdListContains`, `stdListClearAll`, `stdListPushBack`, `stdListPushFront`, `stdListInsertAt`, `stdListRemoveAt`, `stdListRemoveLast`, `stdListSortAscending`, `stdListSortDescending`, `stdListReverse`, `stdListFlatten`, `stdListPartition`, `stdListZip`, `stdListUnzip`, `stdListToList`, `stdListToSet`, `stdListToMap`.

#### Scenario: Intrínseco ausente
- **WHEN** um backend executa op cujo corpo chama intrínseco `stdList*`
- **THEN** não ocorre "undefined function"; o intrínseco executa e devolve o valor esperado

### Requirement: Runtime embutido para WAT, WASM e LLVM
Os backends WAT, WASM e LLVM SHALL gerar runtime próprio no artefato (sem dependência externa): representação de lista em memória (heap linear via `$flux_alloc`/`@malloc`), helpers de todas as operações de lista e formatação de print idêntica à do interpretador.

#### Scenario: Artefato com dados de lista
- **WHEN** compila `flux/ExampleOfList.flux` para wat/wasm/llvm
- **THEN** o artefato contém os dados `[10, 20, 30]`, `[ana, bia, caio]` e executa com saída igual à do interpretador

#### Scenario: Paridade de saída
- **WHEN** executa os 3 exemplos (ExampleOfList, ExampleOfList01, ExampleOfListAtribuicao) em cada um dos 5 backends
- **THEN** a saída é idêntica à do interpretador (IN)