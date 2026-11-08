# 📚 `OoStdLib` — Orientação a Objetos, Despacho Dinâmico, Introspecção e Ciclo de Vida

> **Pilar Arquitetural**: Pilar 1 (Núcleo, Texto & OO)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/OoStdLib/OoStdLib.fdsl`  
> **Modo de Importação**: `use OoStdLib` ou `use OoStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`OoStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Mecanismos para interoperabilidade com o paradigma orientado a objetos: simulação de tabelas de métodos virtuais (vtable), despacho dinâmico de operações, introspecção de tipos e instâncias, downcasting seguro e ganchos de ciclo de vida.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `OoStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **5 módulos de domínio** e declara **26 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `OOCasting.fdsl` | `OOCastingContract` | Domínio especializado de `OOCasting` | 4 |
| `OODispatch.fdsl` | `OODispatchContract` | Domínio especializado de `OODispatch` | 1 |
| `OOIntrospection.fdsl` | `OOIntrospectionContract` | Domínio especializado de `OOIntrospection` | 9 |
| `OOLifecycle.fdsl` | `OOLifecycleContract` | Domínio especializado de `OOLifecycle` | 4 |
| `OOValidation.fdsl` | `OOValidationContract` | Domínio especializado de `OOValidation` | 8 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `OoStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `OOCastingContract` (`OOCasting.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `ooCastToContract` | `op ooCastToContract (as data: struct_instance, as string: contract_name) as data` | `data` |
| `ooDowncast` | `op ooDowncast (as data: interface_object, as string: target_struct_name) as data` | `data` |
| `ooCanDowncast` | `op ooCanDowncast (as data: interface_object, as string: target_struct_name) as bool` | `bool` |
| `ooUnwrap` | `op ooUnwrap (as data: interface_object) as data` | `data` |

#### Ficha Técnica das Operações:

##### `op ooCastToContract`
```flux
op ooCastToContract (as data: struct_instance, as string: contract_name) as data
```
- **Parâmetros**:
  - `struct_instance` (`data`): Parâmetro de entrada para processamento da operação.
  - `contract_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooCastToContract` no domínio `OOCastingContract`.

##### `op ooDowncast`
```flux
op ooDowncast (as data: interface_object, as string: target_struct_name) as data
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
  - `target_struct_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ⚠️ Emite `fail` com status `"Objeto polimorfico invalido ou descartado"`
  - ✅ Emite `nice` com status `"Downcast realizado com sucesso"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooDowncast` no domínio `OOCastingContract`.

##### `op ooCanDowncast`
```flux
op ooCanDowncast (as data: interface_object, as string: target_struct_name) as bool
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
  - `target_struct_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooCanDowncast` no domínio `OOCastingContract`.

##### `op ooUnwrap`
```flux
op ooUnwrap (as data: interface_object) as data
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ⚠️ Emite `fail` com status `"Objeto polimorfico invalido ou descartado"`
  - ✅ Emite `nice` com status `"Unwrap realizado com sucesso"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooUnwrap` no domínio `OOCastingContract`.

### 4.2 Contrato `OODispatchContract` (`OODispatch.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `ooDispatch` | `op ooDispatch (as data: interface_object, as string: method_name, as list of data: args) as data` | `data` |

#### Ficha Técnica das Operações:

##### `op ooDispatch`
```flux
op ooDispatch (as data: interface_object, as string: method_name, as list of data: args) as data
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
  - `method_name` (`string`): Parâmetro de entrada para processamento da operação.
  - `args` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ⚠️ Emite `fail` com status `"Objeto polimorfico invalido para despacho"`
  - ✅ Emite `nice` com status `"Despacho executado"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooDispatch` no domínio `OODispatchContract`.

### 4.3 Contrato `OOIntrospectionContract` (`OOIntrospection.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `ooContractName` | `op ooContractName (as data: interface_object) as string` | `string` |
| `ooUnderlyingType` | `op ooUnderlyingType (as data: interface_object) as string` | `string` |
| `ooMethods` | `op ooMethods (as string: contract_or_struct_name) as list of data` | `list of data` |
| `ooMethodCount` | `op ooMethodCount (as string: contract_or_struct_name) as int64` | `int64` |
| `ooContracts` | `op ooContracts (as data: struct_instance) as list of data` | `list of data` |
| `ooContractCount` | `op ooContractCount (as data: struct_instance) as int64` | `int64` |
| `ooToMap` | `op ooToMap (as data: interface_object) as map` | `map` |
| `ooEntries` | `op ooEntries (as data: interface_object) as list of data` | `list of data` |
| `ooDiff` | `op ooDiff (as data: a, as data: b) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op ooContractName`
```flux
op ooContractName (as data: interface_object) as string
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooContractName` no domínio `OOIntrospectionContract`.

##### `op ooUnderlyingType`
```flux
op ooUnderlyingType (as data: interface_object) as string
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooUnderlyingType` no domínio `OOIntrospectionContract`.

##### `op ooMethods`
```flux
op ooMethods (as string: contract_or_struct_name) as list of data
```
- **Parâmetros**:
  - `contract_or_struct_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooMethods` no domínio `OOIntrospectionContract`.

##### `op ooMethodCount`
```flux
op ooMethodCount (as string: contract_or_struct_name) as int64
```
- **Parâmetros**:
  - `contract_or_struct_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooMethodCount` no domínio `OOIntrospectionContract`.

##### `op ooContracts`
```flux
op ooContracts (as data: struct_instance) as list of data
```
- **Parâmetros**:
  - `struct_instance` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooContracts` no domínio `OOIntrospectionContract`.

##### `op ooContractCount`
```flux
op ooContractCount (as data: struct_instance) as int64
```
- **Parâmetros**:
  - `struct_instance` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooContractCount` no domínio `OOIntrospectionContract`.

##### `op ooToMap`
```flux
op ooToMap (as data: interface_object) as map
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooToMap` no domínio `OOIntrospectionContract`.

##### `op ooEntries`
```flux
op ooEntries (as data: interface_object) as list of data
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooEntries` no domínio `OOIntrospectionContract`.

##### `op ooDiff`
```flux
op ooDiff (as data: a, as data: b) as map
```
- **Parâmetros**:
  - `a` (`data`): Parâmetro de entrada para processamento da operação.
  - `b` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooDiff` no domínio `OOIntrospectionContract`.

### 4.4 Contrato `OOLifecycleContract` (`OOLifecycle.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `ooClone` | `op ooClone (as data: interface_object) as data` | `data` |
| `ooDispose` | `op ooDispose (as data: interface_object) as bool` | `bool` |
| `ooIsDisposed` | `op ooIsDisposed (as data: interface_object) as bool` | `bool` |
| `ooToString` | `op ooToString (as data: interface_object) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op ooClone`
```flux
op ooClone (as data: interface_object) as data
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooClone` no domínio `OOLifecycleContract`.

##### `op ooDispose`
```flux
op ooDispose (as data: interface_object) as bool
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"Objeto descartado com sucesso"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooDispose` no domínio `OOLifecycleContract`.

##### `op ooIsDisposed`
```flux
op ooIsDisposed (as data: interface_object) as bool
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooIsDisposed` no domínio `OOLifecycleContract`.

##### `op ooToString`
```flux
op ooToString (as data: interface_object) as string
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooToString` no domínio `OOLifecycleContract`.

### 4.5 Contrato `OOValidationContract` (`OOValidation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `ooImplements` | `op ooImplements (as data: struct_instance, as string: contract_name) as bool` | `bool` |
| `ooImplementsAll` | `op ooImplementsAll (as data: struct_instance, as list of data: contract_names) as bool` | `bool` |
| `ooHasMethod` | `op ooHasMethod (as data: target, as string: method_name) as bool` | `bool` |
| `ooIsInstance` | `op ooIsInstance (as data: target, as string: struct_name) as bool` | `bool` |
| `ooValidateContract` | `op ooValidateContract (as data: interface_object) as bool` | `bool` |
| `ooIsValid` | `op ooIsValid (as data: interface_object) as bool` | `bool` |
| `ooEquals` | `op ooEquals (as data: a, as data: b) as bool` | `bool` |
| `ooIsObject` | `op ooIsObject (as data: instance) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op ooImplements`
```flux
op ooImplements (as data: struct_instance, as string: contract_name) as bool
```
- **Parâmetros**:
  - `struct_instance` (`data`): Parâmetro de entrada para processamento da operação.
  - `contract_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooImplements` no domínio `OOValidationContract`.

##### `op ooImplementsAll`
```flux
op ooImplementsAll (as data: struct_instance, as list of data: contract_names) as bool
```
- **Parâmetros**:
  - `struct_instance` (`data`): Parâmetro de entrada para processamento da operação.
  - `contract_names` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooImplementsAll` no domínio `OOValidationContract`.

##### `op ooHasMethod`
```flux
op ooHasMethod (as data: target, as string: method_name) as bool
```
- **Parâmetros**:
  - `target` (`data`): Parâmetro de entrada para processamento da operação.
  - `method_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooHasMethod` no domínio `OOValidationContract`.

##### `op ooIsInstance`
```flux
op ooIsInstance (as data: target, as string: struct_name) as bool
```
- **Parâmetros**:
  - `target` (`data`): Parâmetro de entrada para processamento da operação.
  - `struct_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooIsInstance` no domínio `OOValidationContract`.

##### `op ooValidateContract`
```flux
op ooValidateContract (as data: interface_object) as bool
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooValidateContract` no domínio `OOValidationContract`.

##### `op ooIsValid`
```flux
op ooIsValid (as data: interface_object) as bool
```
- **Parâmetros**:
  - `interface_object` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooIsValid` no domínio `OOValidationContract`.

##### `op ooEquals`
```flux
op ooEquals (as data: a, as data: b) as bool
```
- **Parâmetros**:
  - `a` (`data`): Parâmetro de entrada para processamento da operação.
  - `b` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooEquals` no domínio `OOValidationContract`.

##### `op ooIsObject`
```flux
op ooIsObject (as data: instance) as bool
```
- **Parâmetros**:
  - `instance` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ooIsObject` no domínio `OOValidationContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da OoStdLib
use OoStdLib

program (ExemploOoStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: OoStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = OoStdLib::ooTypeOf("object")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
