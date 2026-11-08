# 📚 `DbStdLib` — Conectores e Abstrações de Banco de Dados Multi-Modelo

> **Pilar Arquitetural**: Pilar 2 (Estruturas & Estados)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/DbStdLib/DbStdLib.fdsl`  
> **Modo de Importação**: `use DbStdLib` ou `use DbStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`DbStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Camada de abstração unificada para acesso a bancos de dados relacionais SQL, repositórios NoSQL chave-valor, coleções de documentos JSON, armazenamento colunar analítico, grafos de nós/arestas e índices de embeddings vetoriais para IA.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `DbStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **7 módulos de domínio** e declara **44 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `DbColumn.fdsl` | `DbColumnContract` | Domínio especializado de `DbColumn` | 6 |
| `DbDoc.fdsl` | `DbDocContract` | Domínio especializado de `DbDoc` | 7 |
| `DbGraph.fdsl` | `DbGraphContract` | Domínio especializado de `DbGraph` | 6 |
| `DbKv.fdsl` | `DbKvContract` | Domínio especializado de `DbKv` | 6 |
| `DbSql.fdsl` | `DbSqlContract` | Domínio especializado de `DbSql` | 10 |
| `DbValidation.fdsl` | `DbValidationContract` | Domínio especializado de `DbValidation` | 3 |
| `DbVector.fdsl` | `DbVectorContract` | Domínio especializado de `DbVector` | 6 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `DbStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `DbColumnContract` (`DbColumn.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dbColumnOpen` | `op dbColumnOpen (as string: path) as data` | `data` |
| `dbColumnExecute` | `op dbColumnExecute (as data: connection, as string: sql) as bool` | `bool` |
| `dbColumnQuery` | `op dbColumnQuery (as data: connection, as string: sql) as list of data` | `list of data` |
| `dbColumnRowCount` | `op dbColumnRowCount (as data: connection, as string: table_name) as int64` | `int64` |
| `dbColumnScalar` | `op dbColumnScalar (as data: connection, as string: sql) as data` | `data` |
| `dbColumnClose` | `op dbColumnClose (as data: connection) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op dbColumnOpen`
```flux
op dbColumnOpen (as string: path) as data
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbColumnOpen` no domínio `DbColumnContract`.

##### `op dbColumnExecute`
```flux
op dbColumnExecute (as data: connection, as string: sql) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `sql` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbColumnExecute` no domínio `DbColumnContract`.

##### `op dbColumnQuery`
```flux
op dbColumnQuery (as data: connection, as string: sql) as list of data
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `sql` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbColumnQuery` no domínio `DbColumnContract`.

##### `op dbColumnRowCount`
```flux
op dbColumnRowCount (as data: connection, as string: table_name) as int64
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `table_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbColumnRowCount` no domínio `DbColumnContract`.

##### `op dbColumnScalar`
```flux
op dbColumnScalar (as data: connection, as string: sql) as data
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `sql` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbColumnScalar` no domínio `DbColumnContract`.

##### `op dbColumnClose`
```flux
op dbColumnClose (as data: connection) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbColumnClose` no domínio `DbColumnContract`.

### 4.2 Contrato `DbDocContract` (`DbDoc.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dbDocOpen` | `op dbDocOpen (as string: path) as data` | `data` |
| `dbDocStore` | `op dbDocStore (as data: connection, as string: collection, as map: doc) as string` | `string` |
| `dbDocFetch` | `op dbDocFetch (as data: connection, as string: collection, as string: doc_id) as map` | `map` |
| `dbDocDelete` | `op dbDocDelete (as data: connection, as string: collection, as string: doc_id) as bool` | `bool` |
| `dbDocQuery` | `op dbDocQuery (as data: connection, as string: collection, as string: key, as string: val) as list of data` | `list of data` |
| `dbDocCount` | `op dbDocCount (as data: connection, as string: collection) as int64` | `int64` |
| `dbDocClose` | `op dbDocClose (as data: connection) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op dbDocOpen`
```flux
op dbDocOpen (as string: path) as data
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbDocOpen` no domínio `DbDocContract`.

##### `op dbDocStore`
```flux
op dbDocStore (as data: connection, as string: collection, as map: doc) as string
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `collection` (`string`): Parâmetro de entrada para processamento da operação.
  - `doc` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbDocStore` no domínio `DbDocContract`.

##### `op dbDocFetch`
```flux
op dbDocFetch (as data: connection, as string: collection, as string: doc_id) as map
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `collection` (`string`): Parâmetro de entrada para processamento da operação.
  - `doc_id` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbDocFetch` no domínio `DbDocContract`.

##### `op dbDocDelete`
```flux
op dbDocDelete (as data: connection, as string: collection, as string: doc_id) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `collection` (`string`): Parâmetro de entrada para processamento da operação.
  - `doc_id` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbDocDelete` no domínio `DbDocContract`.

##### `op dbDocQuery`
```flux
op dbDocQuery (as data: connection, as string: collection, as string: key, as string: val) as list of data
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `collection` (`string`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `val` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbDocQuery` no domínio `DbDocContract`.

##### `op dbDocCount`
```flux
op dbDocCount (as data: connection, as string: collection) as int64
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `collection` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbDocCount` no domínio `DbDocContract`.

##### `op dbDocClose`
```flux
op dbDocClose (as data: connection) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbDocClose` no domínio `DbDocContract`.

### 4.3 Contrato `DbGraphContract` (`DbGraph.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dbGraphOpen` | `op dbGraphOpen (as string: path) as data` | `data` |
| `dbGraphExecute` | `op dbGraphExecute (as data: connection, as string: cypher) as bool` | `bool` |
| `dbGraphQuery` | `op dbGraphQuery (as data: connection, as string: cypher) as list of data` | `list of data` |
| `dbGraphNodeCount` | `op dbGraphNodeCount (as data: connection, as string: node_table) as int64` | `int64` |
| `dbGraphRelCount` | `op dbGraphRelCount (as data: connection, as string: rel_table) as int64` | `int64` |
| `dbGraphClose` | `op dbGraphClose (as data: connection) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op dbGraphOpen`
```flux
op dbGraphOpen (as string: path) as data
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbGraphOpen` no domínio `DbGraphContract`.

##### `op dbGraphExecute`
```flux
op dbGraphExecute (as data: connection, as string: cypher) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `cypher` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbGraphExecute` no domínio `DbGraphContract`.

##### `op dbGraphQuery`
```flux
op dbGraphQuery (as data: connection, as string: cypher) as list of data
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `cypher` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbGraphQuery` no domínio `DbGraphContract`.

##### `op dbGraphNodeCount`
```flux
op dbGraphNodeCount (as data: connection, as string: node_table) as int64
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `node_table` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbGraphNodeCount` no domínio `DbGraphContract`.

##### `op dbGraphRelCount`
```flux
op dbGraphRelCount (as data: connection, as string: rel_table) as int64
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `rel_table` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbGraphRelCount` no domínio `DbGraphContract`.

##### `op dbGraphClose`
```flux
op dbGraphClose (as data: connection) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbGraphClose` no domínio `DbGraphContract`.

### 4.4 Contrato `DbKvContract` (`DbKv.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dbKvOpen` | `op dbKvOpen (as string: engine, as string: path) as data` | `data` |
| `dbKvPut` | `op dbKvPut (as data: connection, as string: key, as string: value) as bool` | `bool` |
| `dbKvGet` | `op dbKvGet (as data: connection, as string: key) as string` | `string` |
| `dbKvDelete` | `op dbKvDelete (as data: connection, as string: key) as bool` | `bool` |
| `dbKvExists` | `op dbKvExists (as data: connection, as string: key) as bool` | `bool` |
| `dbKvClose` | `op dbKvClose (as data: connection) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op dbKvOpen`
```flux
op dbKvOpen (as string: engine, as string: path) as data
```
- **Parâmetros**:
  - `engine` (`string`): Parâmetro de entrada para processamento da operação.
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbKvOpen` no domínio `DbKvContract`.

##### `op dbKvPut`
```flux
op dbKvPut (as data: connection, as string: key, as string: value) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `value` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbKvPut` no domínio `DbKvContract`.

##### `op dbKvGet`
```flux
op dbKvGet (as data: connection, as string: key) as string
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbKvGet` no domínio `DbKvContract`.

##### `op dbKvDelete`
```flux
op dbKvDelete (as data: connection, as string: key) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbKvDelete` no domínio `DbKvContract`.

##### `op dbKvExists`
```flux
op dbKvExists (as data: connection, as string: key) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbKvExists` no domínio `DbKvContract`.

##### `op dbKvClose`
```flux
op dbKvClose (as data: connection) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbKvClose` no domínio `DbKvContract`.

### 4.5 Contrato `DbSqlContract` (`DbSql.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dbSqlOpen` | `op dbSqlOpen (as string: connection_string) as data` | `data` |
| `dbSqlExecute` | `op dbSqlExecute (as data: connection, as string: sql, as list of data: params) as bool` | `bool` |
| `dbSqlQuery` | `op dbSqlQuery (as data: connection, as string: sql, as list of data: params) as list of data` | `list of data` |
| `dbSqlBegin` | `op dbSqlBegin (as data: connection) as bool` | `bool` |
| `dbSqlCommit` | `op dbSqlCommit (as data: connection) as bool` | `bool` |
| `dbSqlRollback` | `op dbSqlRollback (as data: connection) as bool` | `bool` |
| `dbSqlLastInsertId` | `op dbSqlLastInsertId (as data: connection) as int64` | `int64` |
| `dbSqlChanges` | `op dbSqlChanges (as data: connection) as int64` | `int64` |
| `dbSqlTableExists` | `op dbSqlTableExists (as data: connection, as string: table_name) as bool` | `bool` |
| `dbSqlClose` | `op dbSqlClose (as data: connection) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op dbSqlOpen`
```flux
op dbSqlOpen (as string: connection_string) as data
```
- **Parâmetros**:
  - `connection_string` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSqlOpen` no domínio `DbSqlContract`.

##### `op dbSqlExecute`
```flux
op dbSqlExecute (as data: connection, as string: sql, as list of data: params) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `sql` (`string`): Parâmetro de entrada para processamento da operação.
  - `params` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSqlExecute` no domínio `DbSqlContract`.

##### `op dbSqlQuery`
```flux
op dbSqlQuery (as data: connection, as string: sql, as list of data: params) as list of data
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `sql` (`string`): Parâmetro de entrada para processamento da operação.
  - `params` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSqlQuery` no domínio `DbSqlContract`.

##### `op dbSqlBegin`
```flux
op dbSqlBegin (as data: connection) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSqlBegin` no domínio `DbSqlContract`.

##### `op dbSqlCommit`
```flux
op dbSqlCommit (as data: connection) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSqlCommit` no domínio `DbSqlContract`.

##### `op dbSqlRollback`
```flux
op dbSqlRollback (as data: connection) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSqlRollback` no domínio `DbSqlContract`.

##### `op dbSqlLastInsertId`
```flux
op dbSqlLastInsertId (as data: connection) as int64
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSqlLastInsertId` no domínio `DbSqlContract`.

##### `op dbSqlChanges`
```flux
op dbSqlChanges (as data: connection) as int64
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSqlChanges` no domínio `DbSqlContract`.

##### `op dbSqlTableExists`
```flux
op dbSqlTableExists (as data: connection, as string: table_name) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `table_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSqlTableExists` no domínio `DbSqlContract`.

##### `op dbSqlClose`
```flux
op dbSqlClose (as data: connection) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSqlClose` no domínio `DbSqlContract`.

### 4.6 Contrato `DbValidationContract` (`DbValidation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dbIsValidRecord` | `op dbIsValidRecord (as map: record, as map: schema) as bool` | `bool` |
| `dbSanitizeIdentifier` | `op dbSanitizeIdentifier (as string: name) as string` | `string` |
| `dbEscapeString` | `op dbEscapeString (as string: val) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op dbIsValidRecord`
```flux
op dbIsValidRecord (as map: record, as map: schema) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `schema` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbIsValidRecord` no domínio `DbValidationContract`.

##### `op dbSanitizeIdentifier`
```flux
op dbSanitizeIdentifier (as string: name) as string
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbSanitizeIdentifier` no domínio `DbValidationContract`.

##### `op dbEscapeString`
```flux
op dbEscapeString (as string: val) as string
```
- **Parâmetros**:
  - `val` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbEscapeString` no domínio `DbValidationContract`.

### 4.7 Contrato `DbVectorContract` (`DbVector.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dbVectorOpen` | `op dbVectorOpen (as string: path, as int64: dimensions, as string: metric) as data` | `data` |
| `dbVectorInsert` | `op dbVectorInsert (as data: connection, as int64: id, as list of data: embedding, as string: metadata) as bool` | `bool` |
| `dbVectorSearch` | `op dbVectorSearch (as data: connection, as list of data: query_vector, as int64: top_k) as list of data` | `list of data` |
| `dbVectorDelete` | `op dbVectorDelete (as data: connection, as int64: id) as bool` | `bool` |
| `dbVectorCount` | `op dbVectorCount (as data: connection) as int64` | `int64` |
| `dbVectorClose` | `op dbVectorClose (as data: connection) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op dbVectorOpen`
```flux
op dbVectorOpen (as string: path, as int64: dimensions, as string: metric) as data
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `dimensions` (`int64`): Parâmetro de entrada para processamento da operação.
  - `metric` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbVectorOpen` no domínio `DbVectorContract`.

##### `op dbVectorInsert`
```flux
op dbVectorInsert (as data: connection, as int64: id, as list of data: embedding, as string: metadata) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `embedding` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `metadata` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbVectorInsert` no domínio `DbVectorContract`.

##### `op dbVectorSearch`
```flux
op dbVectorSearch (as data: connection, as list of data: query_vector, as int64: top_k) as list of data
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `query_vector` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `top_k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbVectorSearch` no domínio `DbVectorContract`.

##### `op dbVectorDelete`
```flux
op dbVectorDelete (as data: connection, as int64: id) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
  - `id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbVectorDelete` no domínio `DbVectorContract`.

##### `op dbVectorCount`
```flux
op dbVectorCount (as data: connection) as int64
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbVectorCount` no domínio `DbVectorContract`.

##### `op dbVectorClose`
```flux
op dbVectorClose (as data: connection) as bool
```
- **Parâmetros**:
  - `connection` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dbVectorClose` no domínio `DbVectorContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da DbStdLib
use DbStdLib

program (ExemploDbStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: DbStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = DbStdLib::sqlExecute("SELECT 1")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
