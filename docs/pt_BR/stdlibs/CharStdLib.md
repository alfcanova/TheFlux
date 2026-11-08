# 📚 `CharStdLib` — Manipulação, Classificação e Predicados de Caracteres

> **Pilar Arquitetural**: Pilar 1 (Núcleo, Texto & OO)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/CharStdLib/CharStdLib.fdsl`  
> **Modo de Importação**: `use CharStdLib` ou `use CharStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`CharStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Oferece operações de baixo custo para teste de categorias Unicode e ASCII (dígitos, letras maiúsculas/minúsculas, espaços em branco, controle), conversões numéricas hexadecimais e transformações de caixa em caracteres atômicos.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `CharStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **6 módulos de domínio** e declara **36 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `CharAscii.fdsl` | `CharAsciiContract` | Domínio especializado de `CharAscii` | 4 |
| `CharClassification.fdsl` | `CharClassificationContract` | Domínio especializado de `CharClassification` | 12 |
| `CharCompare.fdsl` | `CharCompareContract` | Domínio especializado de `CharCompare` | 5 |
| `CharHex.fdsl` | `CharHexContract` | Domínio especializado de `CharHex` | 4 |
| `CharTransform.fdsl` | `CharTransformContract` | Domínio especializado de `CharTransform` | 5 |
| `CharUtility.fdsl` | `CharUtilityContract` | Domínio especializado de `CharUtility` | 6 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `CharStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `CharAsciiContract` (`CharAscii.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `charToAscii` | `op charToAscii (as char: c) as int64` | `int64` |
| `charFromAscii` | `op charFromAscii (as int64: code) as char` | `char` |
| `charIsPrintable` | `op charIsPrintable (as char: c) as bool` | `bool` |
| `charIsControl` | `op charIsControl (as char: c) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op charToAscii`
```flux
op charToAscii (as char: c) as int64
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charToAscii` no domínio `CharAsciiContract`.

##### `op charFromAscii`
```flux
op charFromAscii (as int64: code) as char
```
- **Parâmetros**:
  - `code` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `char`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charFromAscii` no domínio `CharAsciiContract`.

##### `op charIsPrintable`
```flux
op charIsPrintable (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsPrintable` no domínio `CharAsciiContract`.

##### `op charIsControl`
```flux
op charIsControl (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsControl` no domínio `CharAsciiContract`.

### 4.2 Contrato `CharClassificationContract` (`CharClassification.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `charIsDigit` | `op charIsDigit (as char: c) as bool` | `bool` |
| `charIsAlpha` | `op charIsAlpha (as char: c) as bool` | `bool` |
| `charIsAlphanumeric` | `op charIsAlphanumeric (as char: c) as bool` | `bool` |
| `charIsLower` | `op charIsLower (as char: c) as bool` | `bool` |
| `charIsUpper` | `op charIsUpper (as char: c) as bool` | `bool` |
| `charIsWhitespace` | `op charIsWhitespace (as char: c) as bool` | `bool` |
| `charIsSpace` | `op charIsSpace (as char: c) as bool` | `bool` |
| `charIsPunctuation` | `op charIsPunctuation (as char: c) as bool` | `bool` |
| `charIsHexDigit` | `op charIsHexDigit (as char: c) as bool` | `bool` |
| `charIsOctalDigit` | `op charIsOctalDigit (as char: c) as bool` | `bool` |
| `charIsBinaryDigit` | `op charIsBinaryDigit (as char: c) as bool` | `bool` |
| `charIsAscii` | `op charIsAscii (as char: c) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op charIsDigit`
```flux
op charIsDigit (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsDigit` no domínio `CharClassificationContract`.

##### `op charIsAlpha`
```flux
op charIsAlpha (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsAlpha` no domínio `CharClassificationContract`.

##### `op charIsAlphanumeric`
```flux
op charIsAlphanumeric (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsAlphanumeric` no domínio `CharClassificationContract`.

##### `op charIsLower`
```flux
op charIsLower (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsLower` no domínio `CharClassificationContract`.

##### `op charIsUpper`
```flux
op charIsUpper (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsUpper` no domínio `CharClassificationContract`.

##### `op charIsWhitespace`
```flux
op charIsWhitespace (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsWhitespace` no domínio `CharClassificationContract`.

##### `op charIsSpace`
```flux
op charIsSpace (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsSpace` no domínio `CharClassificationContract`.

##### `op charIsPunctuation`
```flux
op charIsPunctuation (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsPunctuation` no domínio `CharClassificationContract`.

##### `op charIsHexDigit`
```flux
op charIsHexDigit (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsHexDigit` no domínio `CharClassificationContract`.

##### `op charIsOctalDigit`
```flux
op charIsOctalDigit (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsOctalDigit` no domínio `CharClassificationContract`.

##### `op charIsBinaryDigit`
```flux
op charIsBinaryDigit (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsBinaryDigit` no domínio `CharClassificationContract`.

##### `op charIsAscii`
```flux
op charIsAscii (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsAscii` no domínio `CharClassificationContract`.

### 4.3 Contrato `CharCompareContract` (`CharCompare.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `charEquals` | `op charEquals (as char: a, as char: b) as bool` | `bool` |
| `charEqualsIgnoreCase` | `op charEqualsIgnoreCase (as char: a, as char: b) as bool` | `bool` |
| `charCompare` | `op charCompare (as char: a, as char: b) as int64` | `int64` |
| `charCompareIgnoreCase` | `op charCompareIgnoreCase (as char: a, as char: b) as int64` | `int64` |
| `charIsBetween` | `op charIsBetween (as char: c, as char: start, as char: end) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op charEquals`
```flux
op charEquals (as char: a, as char: b) as bool
```
- **Parâmetros**:
  - `a` (`char`): Parâmetro de entrada para processamento da operação.
  - `b` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charEquals` no domínio `CharCompareContract`.

##### `op charEqualsIgnoreCase`
```flux
op charEqualsIgnoreCase (as char: a, as char: b) as bool
```
- **Parâmetros**:
  - `a` (`char`): Parâmetro de entrada para processamento da operação.
  - `b` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charEqualsIgnoreCase` no domínio `CharCompareContract`.

##### `op charCompare`
```flux
op charCompare (as char: a, as char: b) as int64
```
- **Parâmetros**:
  - `a` (`char`): Parâmetro de entrada para processamento da operação.
  - `b` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charCompare` no domínio `CharCompareContract`.

##### `op charCompareIgnoreCase`
```flux
op charCompareIgnoreCase (as char: a, as char: b) as int64
```
- **Parâmetros**:
  - `a` (`char`): Parâmetro de entrada para processamento da operação.
  - `b` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charCompareIgnoreCase` no domínio `CharCompareContract`.

##### `op charIsBetween`
```flux
op charIsBetween (as char: c, as char: start, as char: end) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
  - `start` (`char`): Parâmetro de entrada para processamento da operação.
  - `end` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsBetween` no domínio `CharCompareContract`.

### 4.4 Contrato `CharHexContract` (`CharHex.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `charToHexValue` | `op charToHexValue (as char: c) as int64` | `int64` |
| `charFromHexValue` | `op charFromHexValue (as int64: value) as char` | `char` |
| `charToBinaryValue` | `op charToBinaryValue (as char: c) as int64` | `int64` |
| `charFromBinaryValue` | `op charFromBinaryValue (as int64: value) as char` | `char` |

#### Ficha Técnica das Operações:

##### `op charToHexValue`
```flux
op charToHexValue (as char: c) as int64
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charToHexValue` no domínio `CharHexContract`.

##### `op charFromHexValue`
```flux
op charFromHexValue (as int64: value) as char
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `char`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charFromHexValue` no domínio `CharHexContract`.

##### `op charToBinaryValue`
```flux
op charToBinaryValue (as char: c) as int64
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charToBinaryValue` no domínio `CharHexContract`.

##### `op charFromBinaryValue`
```flux
op charFromBinaryValue (as int64: value) as char
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `char`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charFromBinaryValue` no domínio `CharHexContract`.

### 4.5 Contrato `CharTransformContract` (`CharTransform.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `charToUpper` | `op charToUpper (as char: c) as char` | `char` |
| `charToLower` | `op charToLower (as char: c) as char` | `char` |
| `charToggleCase` | `op charToggleCase (as char: c) as char` | `char` |
| `charToDigit` | `op charToDigit (as char: c) as int64` | `int64` |
| `charFromDigit` | `op charFromDigit (as int64: digit) as char` | `char` |

#### Ficha Técnica das Operações:

##### `op charToUpper`
```flux
op charToUpper (as char: c) as char
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `char`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charToUpper` no domínio `CharTransformContract`.

##### `op charToLower`
```flux
op charToLower (as char: c) as char
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `char`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charToLower` no domínio `CharTransformContract`.

##### `op charToggleCase`
```flux
op charToggleCase (as char: c) as char
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `char`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charToggleCase` no domínio `CharTransformContract`.

##### `op charToDigit`
```flux
op charToDigit (as char: c) as int64
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charToDigit` no domínio `CharTransformContract`.

##### `op charFromDigit`
```flux
op charFromDigit (as int64: digit) as char
```
- **Parâmetros**:
  - `digit` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `char`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charFromDigit` no domínio `CharTransformContract`.

### 4.6 Contrato `CharUtilityContract` (`CharUtility.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `charToString` | `op charToString (as char: c) as string` | `string` |
| `charRepeat` | `op charRepeat (as char: c, as int64: count) as string` | `string` |
| `charIsVowel` | `op charIsVowel (as char: c) as bool` | `bool` |
| `charIsConsonant` | `op charIsConsonant (as char: c) as bool` | `bool` |
| `charEscape` | `op charEscape (as char: c) as string` | `string` |
| `charName` | `op charName (as char: c) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op charToString`
```flux
op charToString (as char: c) as string
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charToString` no domínio `CharUtilityContract`.

##### `op charRepeat`
```flux
op charRepeat (as char: c, as int64: count) as string
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charRepeat` no domínio `CharUtilityContract`.

##### `op charIsVowel`
```flux
op charIsVowel (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsVowel` no domínio `CharUtilityContract`.

##### `op charIsConsonant`
```flux
op charIsConsonant (as char: c) as bool
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charIsConsonant` no domínio `CharUtilityContract`.

##### `op charEscape`
```flux
op charEscape (as char: c) as string
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charEscape` no domínio `CharUtilityContract`.

##### `op charName`
```flux
op charName (as char: c) as string
```
- **Parâmetros**:
  - `c` (`char`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `charName` no domínio `CharUtilityContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da CharStdLib
use CharStdLib

program (ExemploCharStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: CharStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = CharStdLib::charIsDigit('7')
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
