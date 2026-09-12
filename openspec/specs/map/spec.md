# map Specification

## Purpose
TBD - created by archiving change map-data-full-support. Update Purpose after archive.
## Requirements
### Requirement: Declaração e literal de map
A declaração `mut as map: <var> = map{.key of <T>: <valor> of <T>, ...}` SHALL aceitar chaves string (`.nome of string`) e numéricas (`.1 of uint8` → chave runtime `"1"`), e anotação opcional de tipo no valor (`of string`, `of bool`, ...). A forma simplificada `map{"k": v, ...}` continua válida. Acesso por chave ausente SHALL devolver `none` sem erro. Atribuição a chave nova SHALL inserir.

#### Scenario: Entradas tipadas
- **WHEN** declara `mut as map: codigos = map{.1 of uint8: "Norte" of string, .2 of uint8: "Nordeste" of string}` e executa `print(codigos["1"])`
- **THEN** a saída é `Norte` nos 5 backends (in, vm, wat, wasm, llvm)

#### Scenario: Chave ausente
- **WHEN** executa `print(codigos["5"])`
- **THEN** a saída é `none` nos 5 backends

#### Scenario: Atribuição dinâmica
- **WHEN** `m = map{"a": 1}` e executa `m["b"] = 2` e `m["a"] = 42`
- **THEN** `m` passa a ser `{a: 42, b: 2}` nos 5 backends

#### Scenario: Conversão de pares via toMap
- **WHEN** `pair_list = [["a", "um"], ["b", "dois"]]` e executa `print(toMap(pair_list))`
- **THEN** a saída é `{a: um, b: dois}` nos 5 backends

### Requirement: Operações da stdlib de map
Todas as operações de map SHALL residir no agente `MapStdLib` em `stdlib/MapStdLib.fdsl` (collectionLength, collectionIsEmpty, collectionContains, clearAll, keys, values, mapClearAll, insertEntry, insertEntryIfAbsent, replaceEntry, removeEntry, removeKey, mapLength, mapIsEmpty, extractEntries, extractKeys, extractValues, containsKey, containsValue, getValueOrDefault, merge, toList, toSet, toMap), chamáveis via `use MapStdLib`. Corpos SHALL empregar intrínsecos privados `stdMap*`/`stdCollection*`.

#### Scenario: Chamada de op importada
- **WHEN** programa contém `use MapStdLib` e executa `print(keys(m))` com `m = map{.name of string: "flux"}`
- **THEN** a saída é `[name]` nos 5 backends

#### Scenario: Inserção e remoção
- **WHEN** executa `insertEntry(m, "lang", "Flux")`, `insertEntryIfAbsent(m, "name", "outro")`, `replaceEntry(m, "count", 3)`, `removeEntry(m, "count")`
- **THEN** o mapa evolui conforme a semântica de cada op (sobrescreve / preserva existente / substitui / remove)

#### Scenario: Consultas
- **WHEN** executa `containsKey(m, "name")`, `containsValue(m, "flux")`, `getValueOrDefault(m, "missing", "padrao")`, `mapLength(m)`, `mapIsEmpty(m)`
- **THEN** o resultado é `true`, `true`, `padrao`, `N`, `false` respectivamente

#### Scenario: Extrações e conversões
- **WHEN** executa `extractEntries(m)`, `extractKeys(m)`, `extractValues(m)`, `toList(m)`, `toSet(m)`, `toMap(pair_list)`, `merge(a, b)`
- **THEN** devolvem listas/set/map conforme a semântica (merge: direita vence; pares 2-elemento em toMap)

### Requirement: Intrínsecos de coleção e map
Cada backend SHALL expor os intrínsecos referenciados por `stdlib/MapStdLib.fdsl`: `stdCollectionLength`, `stdCollectionIsEmpty`, `stdCollectionContains`, `stdCollectionClearAll`, `stdCollectionKeys`, `stdCollectionValues`, `stdCollectionToList`, `stdCollectionToSet`, `stdCollectionToMap`, `stdMapClearAll`, `stdMapInsertEntry`, `stdMapInsertEntryIfAbsent`, `stdMapReplaceEntry`, `stdMapRemoveEntry`, `stdMapLength`, `stdMapIsEmpty`, `stdMapEntries`, `stdMapKeys`, `stdMapValues`, `stdMapContainsKey`, `stdMapContainsValue`, `stdMapGetValueOrDefault`, `stdMapMerge`.

#### Scenario: Intrínseco ausente
- **WHEN** um backend executa op cujo corpo chama intrínseco `stdMap*`/`stdCollection*`
- **THEN** não ocorre "undefined function"; o intrínseco executa e devolve o valor esperado

### Requirement: Print e concatenação de map
A exibição de um map SHALL usar `{k1: v1, k2: v2}` com ordem de inserção, chaves e valores strings sem aspas, separador `, `. `"texto: " + <map>` SHALL concatenar a representação formatada.

#### Scenario: Print de map
- **WHEN** `m = map{"a": 10, "b": 20}` e executa `print(m)`
- **THEN** a saída é `{a: 10, b: 20}` nos 5 backends

#### Scenario: Concatenação string + map
- **WHEN** executa `print("Mapa: " + m)`
- **THEN** a saída é `Mapa: {a: 10, b: 20}` nos 5 backends

