# string-fat-pointer

## Purpose

Define como strings são representadas e transportadas nos backends WASM e WAT
usando fat pointer `i64 = (ptr << 32) | len`, garantindo paridade de saída com o
interpreter sem scans de comprimento no caminho quente.

## Requirements

### Requirement: Representação fat pointer de strings
Os backends WASM e WAT SHALL representar uma string em runtime como fat pointer: um `i64` empacotado com `ptr` (endereço dos bytes UTF-8 na memória linear) nos 32 bits superiores (`ptr << 32`) e `len` (número de bytes) nos 32 bits inferiores. O comprimento SHALL ser o número de bytes UTF-8, idêntico ao `len` usado pelo iovéc de `fd_write`. A string NÃO depende de terminador NUL para determinar seu comprimento; bytes `\0` dentro do corpo da string são dados válidos. Constantes em data segment SHALL continuar NUL-terminadas apenas para compatibilidade com caminhos legados (LLVM `%s`, `$strcpy`), sem serem consultadas como fonte de comprimento.

#### Scenario: Empacotamento fat pointer
- **WHEN** o backend WASM gera o valor de uma string constante em memória
- **THEN** o valor runtime resultante é `(ptr << 32) | len` com `ptr` = offset do data segment e `len` = bytes UTF-8 da string

#### Scenario: Extração de ponteiro e comprimento
- **WHEN** o backend precisa de `ptr` ou `len` a partir de um fat pointer
- **THEN** `ptr` é obtido pelo shift dos 32 bits altos e `len` pelos 32 bits baixos, sem scan de memória

#### Scenario: String com NUL interno
- **WHEN** uma string contém byte `\0` no corpo e é impressa no WASM/WAT
- **THEN** todos os bytes são emitidos conforme `len`, sem truncar no NUL

### Requirement: Colecionáveis de string com fat pointer
Listas e sets cujos elementos são string SHALL armazenar em cada linha (16 bytes: `+0 tag i32, +8 val i64`) o fat pointer completo (`(ptr << 32) | len`) no campo `val` com tag 4. A leitura de elemento (formatação em `$elem_to_str`/`$list_to_str`/`$set_to_str`, join, concat) SHALL extrair `len` do fat sem `$strlen`. A escrita de elemento SHALL empacotar `(ptr, len)` antes de `$list_set_row`, preservando `len` na linha.

#### Scenario: Lista de strings preserva comprimento
- **WHEN** uma `list of string` com elementos de comprimentos diferentes é armazenada e impressa
- **THEN** cada elemento é impresso com exatamente seu comprimento original, sem redeterminação por scan

#### Scenario: Elemento com NUL interno em colecionável
- **WHEN** uma `list of string` contém elemento com byte `\0` interno e é impressa
- **THEN** o elemento é emitido integralmente conforme seu `len`

### Requirement: Print sem scan de comprimento
O caminho de print (ex.: `$print_str (ptr i32, len i32)`) SHALL receber pares `(ptr, len)` calculados sem `$strlen`. Para variáveis string e elementos de colecionáveis, `len` SHALL vir do fat pointer; para literais e strings computadas em compile-time (enum variants, mensagens fixas), `len` SHALL ser constante conhecida. O scan `$strlen` SHALL deixar de ser usado no caminho quente de print/formatação de strings.

#### Scenario: Print de variável string
- **WHEN** uma variável string é passada ao print
- **THEN** `(ptr, len)` é extraído do fat pointer da variável, sem `$strlen`

#### Scenario: Print de literal string
- **WHEN** um literal string é passado ao print
- **THEN** `(ptr, len)` usa o offset do data segment e o comprimento constante, sem scan

### Requirement: Mapeamento de tipos string para fat
Globals, locals, campos de struct, parâmetros e retornos de `function` com tipo string/str/char nos backends WASM e WAT SHALL usar unidade i64 (fat pointer) em vez de i32 (ponteiro). Indexação, atribuição por índice e acesso a campo de struct envolvendo string SHALL operar sobre o fat. A leitura de `list of string` por índice SHALL devolver o fat pointer do elemento.

#### Scenario: Storage de string com fat
- **WHEN** um storage global de string é declarado e posteriormente lido
- **THEN** o valor runtime é o fat pointer `(off << 32) | len` da string

#### Scenario: Função com parâmetro string
- **WHEN** uma `function` com parâmetro string é compilada para WAT/WASM
- **THEN** o parâmetro é transportado como i64 fat e o corpo extrai `(ptr, len)` sem scan

### Requirement: ABI externa fat para strings
A fronteira com hosts (navegador/js e futuros hosts WASM) SHALL expor strings como `u64` fat-packed `((ptr as u64) << 32) | (len as u64)` onde a ABI é posicional unicamente do tipo string (ex.: exports/imports de strings); onde a ABI já é por pares iovec (`fd_write`) permanece `(i32 ptr, i32 len)`. O glue JavaScript SHALL decodificar `u64` fat em bytes usando `hi32` como ponteiro e `lo32` como comprimento. Nenhuma re-serialização ou cópia de dados é necessária na decodificação.

#### Scenario: Export de string fat
- **WHEN** um artefato WASM exporta função que produz string como `u64`
- **THEN** o host decodifica `ptr = u64 >> 32` e `len = u64 & 0xFFFFFFFF` e lê os bytes diretamente da memória linear

#### Scenario: Saída via fd_write inalterada
- **WHEN** o programa imprime texto via `fd_write`
- **THEN** o iovéc continua `(ptr i32, len i32)` e o shim JS decodifica como hoje, sem mudança

### Requirement: Paridade de saída entre alvos
Após a adoção do fat pointer, a saída de programas compilados para WAT, WASM e LLVM SHALL permanecer idêntica à do interpreter (oráculo) para strings, `list of string` e `set of string`, conforme verificação com `backend_compliance.py`/`flux_verify.py`. Artefatos de teste de ouro em `t_wat-*`, `t_wasm-*` e `t_llvm` SHALL ser regenerados para refletir o novo layout.

#### Scenario: Suite existente com strings
- **WHEN** as suites de teste de ouro (t_wat-*, t_wasm-*, t_llvm) são executadas com artefatos regenerados
- **THEN** todas as saídas batem com o interpreter nos 5 alvos

#### Scenario: Colecionável de string cross-target
- **WHEN** um programa com `list of string` e `set of string` é compilado e executado nos alvos interpreter, VM, WAT, WASM e LLVM
- **THEN** a saída é idêntica nos 5 alvos
