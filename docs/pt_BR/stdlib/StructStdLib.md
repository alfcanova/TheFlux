# 📚 `StructStdLib` — Introspecção, Validação de Esquema e Clonagem Profunda de Estruturas

> **Pilar Arquitetural**: Pilar 2 (Estruturas & Estados)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/StructStdLib/StructStdLib.fdsl`  
> **Modo de Importação**: `use StructStdLib` ou `use StructStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`StructStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Utilitários para manipulação reflexiva de estruturas (`struct`): introspecção de nomes de campos e tipos associados, verificação de conformidade estrutural, cópia profunda (deep clone) e serialização em memória.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `StructStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **4 módulos de domínio** e declara **23 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `StructConversion.fdsl` | `StructConversionContract` | Domínio especializado de `StructConversion` | 4 |
| `StructCore.fdsl` | `StructCoreContract` | Domínio especializado de `StructCore` | 7 |
| `StructIntrospection.fdsl` | `StructIntrospectionContract` | Domínio especializado de `StructIntrospection` | 9 |
| `StructMemory.fdsl` | `StructMemoryContract` | Domínio especializado de `StructMemory` | 3 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `StructStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `StructConversionContract` (`StructConversion.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `structToMap` | `op structToMap (as data: instance) as map` | `map` |
| `structEntries` | `op structEntries (as data: instance) as list of data` | `list of data` |
| `structToString` | `op structToString (as data: instance) as string` | `string` |
| `structDiff` | `op structDiff (as data: a, as data: b) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op structToMap`
```flux
op structToMap (as data: instance) as map
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structToMap` no domínio `StructConversionContract`.

##### `op structEntries`
```flux
op structEntries (as data: instance) as list of data
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structEntries` no domínio `StructConversionContract`.

##### `op structToString`
```flux
op structToString (as data: instance) as string
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structToString` no domínio `StructConversionContract`.

##### `op structDiff`
```flux
op structDiff (as data: a, as data: b) as map
```
- **Parâmetros**:
  - `a` (`data`): Parâmetro de entrada para processamento da operação.
  - `b` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structDiff` no domínio `StructConversionContract`.

### 4.2 Contrato `StructCoreContract` (`StructCore.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `structAllocate` | `op structAllocate (as string: name) as data` | `data` |
| `structFromMap` | `op structFromMap (as string: name, as map: data_map) as data` | `data` |
| `structGetField` | `op structGetField (as data: instance, as string: field) as data` | `data` |
| `structSetField` | `op structSetField (as data: instance, as string: field, as data: value) as data` | `data` |
| `structName` | `op structName (as data: instance) as string` | `string` |
| `structClone` | `op structClone (as data: instance) as data` | `data` |
| `structEquals` | `op structEquals (as data: a, as data: b) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op structAllocate`
```flux
op structAllocate (as string: name) as data
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structAllocate` no domínio `StructCoreContract`.

##### `op structFromMap`
```flux
op structFromMap (as string: name, as map: data_map) as data
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
  - `data_map` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structFromMap` no domínio `StructCoreContract`.

##### `op structGetField`
```flux
op structGetField (as data: instance, as string: field) as data
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
  - `field` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structGetField` no domínio `StructCoreContract`.

##### `op structSetField`
```flux
op structSetField (as data: instance, as string: field, as data: value) as data
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
  - `field` (`string`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"Campo atualizado com sucesso"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structSetField` no domínio `StructCoreContract`.

##### `op structName`
```flux
op structName (as data: instance) as string
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structName` no domínio `StructCoreContract`.

##### `op structClone`
```flux
op structClone (as data: instance) as data
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structClone` no domínio `StructCoreContract`.

##### `op structEquals`
```flux
op structEquals (as data: a, as data: b) as bool
```
- **Parâmetros**:
  - `a` (`data`): Parâmetro de entrada para processamento da operação.
  - `b` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structEquals` no domínio `StructCoreContract`.

### 4.3 Contrato `StructIntrospectionContract` (`StructIntrospection.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `structIsStruct` | `op structIsStruct (as data: instance) as bool` | `bool` |
| `structIsInstance` | `op structIsInstance (as data: instance, as string: name) as bool` | `bool` |
| `structHasField` | `op structHasField (as data: instance, as string: field) as bool` | `bool` |
| `structFields` | `op structFields (as string: name) as list of data` | `list of data` |
| `structFieldCount` | `op structFieldCount (as string: name) as int64` | `int64` |
| `structFieldType` | `op structFieldType (as string: name, as string: field) as string` | `string` |
| `structIsFieldMutable` | `op structIsFieldMutable (as string: name, as string: field) as bool` | `bool` |
| `structMutableFields` | `op structMutableFields (as string: name) as list of data` | `list of data` |
| `structImmutableFields` | `op structImmutableFields (as string: name) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op structIsStruct`
```flux
op structIsStruct (as data: instance) as bool
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structIsStruct` no domínio `StructIntrospectionContract`.

##### `op structIsInstance`
```flux
op structIsInstance (as data: instance, as string: name) as bool
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structIsInstance` no domínio `StructIntrospectionContract`.

##### `op structHasField`
```flux
op structHasField (as data: instance, as string: field) as bool
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
  - `field` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structHasField` no domínio `StructIntrospectionContract`.

##### `op structFields`
```flux
op structFields (as string: name) as list of data
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structFields` no domínio `StructIntrospectionContract`.

##### `op structFieldCount`
```flux
op structFieldCount (as string: name) as int64
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structFieldCount` no domínio `StructIntrospectionContract`.

##### `op structFieldType`
```flux
op structFieldType (as string: name, as string: field) as string
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
  - `field` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structFieldType` no domínio `StructIntrospectionContract`.

##### `op structIsFieldMutable`
```flux
op structIsFieldMutable (as string: name, as string: field) as bool
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
  - `field` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structIsFieldMutable` no domínio `StructIntrospectionContract`.

##### `op structMutableFields`
```flux
op structMutableFields (as string: name) as list of data
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structMutableFields` no domínio `StructIntrospectionContract`.

##### `op structImmutableFields`
```flux
op structImmutableFields (as string: name) as list of data
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structImmutableFields` no domínio `StructIntrospectionContract`.

### 4.4 Contrato `StructMemoryContract` (`StructMemory.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `structSizeOf` | `op structSizeOf (as string: name) as int64` | `int64` |
| `structAlignOf` | `op structAlignOf (as string: name) as int64` | `int64` |
| `structFieldOffset` | `op structFieldOffset (as string: name, as string: field) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op structSizeOf`
```flux
op structSizeOf (as string: name) as int64
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structSizeOf` no domínio `StructMemoryContract`.

##### `op structAlignOf`
```flux
op structAlignOf (as string: name) as int64
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structAlignOf` no domínio `StructMemoryContract`.

##### `op structFieldOffset`
```flux
op structFieldOffset (as string: name, as string: field) as int64
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
  - `field` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `structFieldOffset` no domínio `StructMemoryContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da StructStdLib
use StructStdLib

program (ExemploStructStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: StructStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = StructStdLib::structFieldCount("MyStruct")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
