# 📚 `DbStdLib` — Multi-Model Database Connectors and Abstractions

> **Architectural Pillar**: Pillar 2 (Structures & State)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/DbStdLib/DbStdLib.fdsl`  
> **Import Mode**: `use DbStdLib` or `use DbStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`DbStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Unified multi-model database abstraction layer supporting SQL relational querying, NoSQL key-value stores, JSON document collections, analytical columnar storage, node/edge graph traversals, and vector embedding similarity indexes.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `DbStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **7 domain modules** declaring a total of **44 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `DbColumn.fdsl` | `DbColumnContract` | Specialized domain for `DbColumn` | 6 |
| `DbDoc.fdsl` | `DbDocContract` | Specialized domain for `DbDoc` | 7 |
| `DbGraph.fdsl` | `DbGraphContract` | Specialized domain for `DbGraph` | 6 |
| `DbKv.fdsl` | `DbKvContract` | Specialized domain for `DbKv` | 6 |
| `DbSql.fdsl` | `DbSqlContract` | Specialized domain for `DbSql` | 10 |
| `DbValidation.fdsl` | `DbValidationContract` | Specialized domain for `DbValidation` | 3 |
| `DbVector.fdsl` | `DbVectorContract` | Specialized domain for `DbVector` | 6 |

---

## 3. Public Types, Structures, and Enumerations

The `DbStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `DbColumnContract` (`DbColumn.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dbColumnOpen` | `op dbColumnOpen (as string: path) as data` | `data` |
| `dbColumnExecute` | `op dbColumnExecute (as data: connection, as string: sql) as bool` | `bool` |
| `dbColumnQuery` | `op dbColumnQuery (as data: connection, as string: sql) as list of data` | `list of data` |
| `dbColumnRowCount` | `op dbColumnRowCount (as data: connection, as string: table_name) as int64` | `int64` |
| `dbColumnScalar` | `op dbColumnScalar (as data: connection, as string: sql) as data` | `data` |
| `dbColumnClose` | `op dbColumnClose (as data: connection) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op dbColumnOpen`
```flux
op dbColumnOpen (as string: path) as data
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbColumnOpen` functionality within the `DbColumnContract` domain.

##### `op dbColumnExecute`
```flux
op dbColumnExecute (as data: connection, as string: sql) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `sql` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbColumnExecute` functionality within the `DbColumnContract` domain.

##### `op dbColumnQuery`
```flux
op dbColumnQuery (as data: connection, as string: sql) as list of data
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `sql` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbColumnQuery` functionality within the `DbColumnContract` domain.

##### `op dbColumnRowCount`
```flux
op dbColumnRowCount (as data: connection, as string: table_name) as int64
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `table_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbColumnRowCount` functionality within the `DbColumnContract` domain.

##### `op dbColumnScalar`
```flux
op dbColumnScalar (as data: connection, as string: sql) as data
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `sql` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbColumnScalar` functionality within the `DbColumnContract` domain.

##### `op dbColumnClose`
```flux
op dbColumnClose (as data: connection) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbColumnClose` functionality within the `DbColumnContract` domain.

### 4.2 Contract `DbDocContract` (`DbDoc.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dbDocOpen` | `op dbDocOpen (as string: path) as data` | `data` |
| `dbDocStore` | `op dbDocStore (as data: connection, as string: collection, as map: doc) as string` | `string` |
| `dbDocFetch` | `op dbDocFetch (as data: connection, as string: collection, as string: doc_id) as map` | `map` |
| `dbDocDelete` | `op dbDocDelete (as data: connection, as string: collection, as string: doc_id) as bool` | `bool` |
| `dbDocQuery` | `op dbDocQuery (as data: connection, as string: collection, as string: key, as string: val) as list of data` | `list of data` |
| `dbDocCount` | `op dbDocCount (as data: connection, as string: collection) as int64` | `int64` |
| `dbDocClose` | `op dbDocClose (as data: connection) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op dbDocOpen`
```flux
op dbDocOpen (as string: path) as data
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbDocOpen` functionality within the `DbDocContract` domain.

##### `op dbDocStore`
```flux
op dbDocStore (as data: connection, as string: collection, as map: doc) as string
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `collection` (`string`): Input argument for operation execution.
  - `doc` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbDocStore` functionality within the `DbDocContract` domain.

##### `op dbDocFetch`
```flux
op dbDocFetch (as data: connection, as string: collection, as string: doc_id) as map
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `collection` (`string`): Input argument for operation execution.
  - `doc_id` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbDocFetch` functionality within the `DbDocContract` domain.

##### `op dbDocDelete`
```flux
op dbDocDelete (as data: connection, as string: collection, as string: doc_id) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `collection` (`string`): Input argument for operation execution.
  - `doc_id` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbDocDelete` functionality within the `DbDocContract` domain.

##### `op dbDocQuery`
```flux
op dbDocQuery (as data: connection, as string: collection, as string: key, as string: val) as list of data
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `collection` (`string`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
  - `val` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbDocQuery` functionality within the `DbDocContract` domain.

##### `op dbDocCount`
```flux
op dbDocCount (as data: connection, as string: collection) as int64
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `collection` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbDocCount` functionality within the `DbDocContract` domain.

##### `op dbDocClose`
```flux
op dbDocClose (as data: connection) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbDocClose` functionality within the `DbDocContract` domain.

### 4.3 Contract `DbGraphContract` (`DbGraph.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dbGraphOpen` | `op dbGraphOpen (as string: path) as data` | `data` |
| `dbGraphExecute` | `op dbGraphExecute (as data: connection, as string: cypher) as bool` | `bool` |
| `dbGraphQuery` | `op dbGraphQuery (as data: connection, as string: cypher) as list of data` | `list of data` |
| `dbGraphNodeCount` | `op dbGraphNodeCount (as data: connection, as string: node_table) as int64` | `int64` |
| `dbGraphRelCount` | `op dbGraphRelCount (as data: connection, as string: rel_table) as int64` | `int64` |
| `dbGraphClose` | `op dbGraphClose (as data: connection) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op dbGraphOpen`
```flux
op dbGraphOpen (as string: path) as data
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbGraphOpen` functionality within the `DbGraphContract` domain.

##### `op dbGraphExecute`
```flux
op dbGraphExecute (as data: connection, as string: cypher) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `cypher` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbGraphExecute` functionality within the `DbGraphContract` domain.

##### `op dbGraphQuery`
```flux
op dbGraphQuery (as data: connection, as string: cypher) as list of data
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `cypher` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbGraphQuery` functionality within the `DbGraphContract` domain.

##### `op dbGraphNodeCount`
```flux
op dbGraphNodeCount (as data: connection, as string: node_table) as int64
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `node_table` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbGraphNodeCount` functionality within the `DbGraphContract` domain.

##### `op dbGraphRelCount`
```flux
op dbGraphRelCount (as data: connection, as string: rel_table) as int64
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `rel_table` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbGraphRelCount` functionality within the `DbGraphContract` domain.

##### `op dbGraphClose`
```flux
op dbGraphClose (as data: connection) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbGraphClose` functionality within the `DbGraphContract` domain.

### 4.4 Contract `DbKvContract` (`DbKv.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dbKvOpen` | `op dbKvOpen (as string: engine, as string: path) as data` | `data` |
| `dbKvPut` | `op dbKvPut (as data: connection, as string: key, as string: value) as bool` | `bool` |
| `dbKvGet` | `op dbKvGet (as data: connection, as string: key) as string` | `string` |
| `dbKvDelete` | `op dbKvDelete (as data: connection, as string: key) as bool` | `bool` |
| `dbKvExists` | `op dbKvExists (as data: connection, as string: key) as bool` | `bool` |
| `dbKvClose` | `op dbKvClose (as data: connection) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op dbKvOpen`
```flux
op dbKvOpen (as string: engine, as string: path) as data
```
- **Parameters**:
  - `engine` (`string`): Input argument for operation execution.
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbKvOpen` functionality within the `DbKvContract` domain.

##### `op dbKvPut`
```flux
op dbKvPut (as data: connection, as string: key, as string: value) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
  - `value` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbKvPut` functionality within the `DbKvContract` domain.

##### `op dbKvGet`
```flux
op dbKvGet (as data: connection, as string: key) as string
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbKvGet` functionality within the `DbKvContract` domain.

##### `op dbKvDelete`
```flux
op dbKvDelete (as data: connection, as string: key) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbKvDelete` functionality within the `DbKvContract` domain.

##### `op dbKvExists`
```flux
op dbKvExists (as data: connection, as string: key) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbKvExists` functionality within the `DbKvContract` domain.

##### `op dbKvClose`
```flux
op dbKvClose (as data: connection) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbKvClose` functionality within the `DbKvContract` domain.

### 4.5 Contract `DbSqlContract` (`DbSql.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op dbSqlOpen`
```flux
op dbSqlOpen (as string: connection_string) as data
```
- **Parameters**:
  - `connection_string` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSqlOpen` functionality within the `DbSqlContract` domain.

##### `op dbSqlExecute`
```flux
op dbSqlExecute (as data: connection, as string: sql, as list of data: params) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `sql` (`string`): Input argument for operation execution.
  - `params` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSqlExecute` functionality within the `DbSqlContract` domain.

##### `op dbSqlQuery`
```flux
op dbSqlQuery (as data: connection, as string: sql, as list of data: params) as list of data
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `sql` (`string`): Input argument for operation execution.
  - `params` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSqlQuery` functionality within the `DbSqlContract` domain.

##### `op dbSqlBegin`
```flux
op dbSqlBegin (as data: connection) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSqlBegin` functionality within the `DbSqlContract` domain.

##### `op dbSqlCommit`
```flux
op dbSqlCommit (as data: connection) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSqlCommit` functionality within the `DbSqlContract` domain.

##### `op dbSqlRollback`
```flux
op dbSqlRollback (as data: connection) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSqlRollback` functionality within the `DbSqlContract` domain.

##### `op dbSqlLastInsertId`
```flux
op dbSqlLastInsertId (as data: connection) as int64
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSqlLastInsertId` functionality within the `DbSqlContract` domain.

##### `op dbSqlChanges`
```flux
op dbSqlChanges (as data: connection) as int64
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSqlChanges` functionality within the `DbSqlContract` domain.

##### `op dbSqlTableExists`
```flux
op dbSqlTableExists (as data: connection, as string: table_name) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `table_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSqlTableExists` functionality within the `DbSqlContract` domain.

##### `op dbSqlClose`
```flux
op dbSqlClose (as data: connection) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSqlClose` functionality within the `DbSqlContract` domain.

### 4.6 Contract `DbValidationContract` (`DbValidation.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dbIsValidRecord` | `op dbIsValidRecord (as map: record, as map: schema) as bool` | `bool` |
| `dbSanitizeIdentifier` | `op dbSanitizeIdentifier (as string: name) as string` | `string` |
| `dbEscapeString` | `op dbEscapeString (as string: val) as string` | `string` |

#### Operation Technical Specifications:

##### `op dbIsValidRecord`
```flux
op dbIsValidRecord (as map: record, as map: schema) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `schema` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbIsValidRecord` functionality within the `DbValidationContract` domain.

##### `op dbSanitizeIdentifier`
```flux
op dbSanitizeIdentifier (as string: name) as string
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbSanitizeIdentifier` functionality within the `DbValidationContract` domain.

##### `op dbEscapeString`
```flux
op dbEscapeString (as string: val) as string
```
- **Parameters**:
  - `val` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbEscapeString` functionality within the `DbValidationContract` domain.

### 4.7 Contract `DbVectorContract` (`DbVector.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dbVectorOpen` | `op dbVectorOpen (as string: path, as int64: dimensions, as string: metric) as data` | `data` |
| `dbVectorInsert` | `op dbVectorInsert (as data: connection, as int64: id, as list of data: embedding, as string: metadata) as bool` | `bool` |
| `dbVectorSearch` | `op dbVectorSearch (as data: connection, as list of data: query_vector, as int64: top_k) as list of data` | `list of data` |
| `dbVectorDelete` | `op dbVectorDelete (as data: connection, as int64: id) as bool` | `bool` |
| `dbVectorCount` | `op dbVectorCount (as data: connection) as int64` | `int64` |
| `dbVectorClose` | `op dbVectorClose (as data: connection) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op dbVectorOpen`
```flux
op dbVectorOpen (as string: path, as int64: dimensions, as string: metric) as data
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `dimensions` (`int64`): Input argument for operation execution.
  - `metric` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbVectorOpen` functionality within the `DbVectorContract` domain.

##### `op dbVectorInsert`
```flux
op dbVectorInsert (as data: connection, as int64: id, as list of data: embedding, as string: metadata) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `id` (`int64`): Input argument for operation execution.
  - `embedding` (`list of data`): Input argument for operation execution.
  - `metadata` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbVectorInsert` functionality within the `DbVectorContract` domain.

##### `op dbVectorSearch`
```flux
op dbVectorSearch (as data: connection, as list of data: query_vector, as int64: top_k) as list of data
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `query_vector` (`list of data`): Input argument for operation execution.
  - `top_k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbVectorSearch` functionality within the `DbVectorContract` domain.

##### `op dbVectorDelete`
```flux
op dbVectorDelete (as data: connection, as int64: id) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
  - `id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbVectorDelete` functionality within the `DbVectorContract` domain.

##### `op dbVectorCount`
```flux
op dbVectorCount (as data: connection) as int64
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbVectorCount` functionality within the `DbVectorContract` domain.

##### `op dbVectorClose`
```flux
op dbVectorClose (as data: connection) as bool
```
- **Parameters**:
  - `connection` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dbVectorClose` functionality within the `DbVectorContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for DbStdLib
use DbStdLib

program (ExampleOfDbStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: DbStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = DbStdLib::sqlExecute("SELECT 1")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
