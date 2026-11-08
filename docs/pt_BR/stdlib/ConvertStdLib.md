# 📚 `ConvertStdLib` — Conversão Universal de Tipos, Encodings e Bases Numéricas

> **Pilar Arquitetural**: Pilar 1 (Núcleo, Texto & OO)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/ConvertStdLib/ConvertStdLib.fdsl`  
> **Modo de Importação**: `use ConvertStdLib` ou `use ConvertStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`ConvertStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Proê conversões determinísticas entre escalares numéricos inteiros e floats (16, 32 e 64 bits), transcodificação de encodings de texto (UTF-8, ASCII, Latin-1), representação em bases (binário, octal, hexadecimal, Base64) e parsing seguro com fallback.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `ConvertStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **6 módulos de domínio** e declara **71 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `ConvertBase.fdsl` | `ConvertBaseContract` | Domínio especializado de `ConvertBase` | 9 |
| `ConvertComplex.fdsl` | `ConvertComplexContract` | Domínio especializado de `ConvertComplex` | 4 |
| `ConvertEncoding.fdsl` | `ConvertEncodingContract` | Domínio especializado de `ConvertEncoding` | 8 |
| `ConvertNumeric.fdsl` | `ConvertNumericContract` | Domínio especializado de `ConvertNumeric` | 37 |
| `ConvertParsing.fdsl` | `ConvertParsingContract` | Domínio especializado de `ConvertParsing` | 8 |
| `ConvertString.fdsl` | `ConvertStringContract` | Domínio especializado de `ConvertString` | 5 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `ConvertStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `ConvertBaseContract` (`ConvertBase.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `convertIntToHex` | `op convertIntToHex (as int64: value) as string` | `string` |
| `convertIntToHexPadded` | `op convertIntToHexPadded (as int64: value, as int64: width) as string` | `string` |
| `convertIntToBinary` | `op convertIntToBinary (as int64: value) as string` | `string` |
| `convertIntToBinaryPadded` | `op convertIntToBinaryPadded (as int64: value, as int64: width) as string` | `string` |
| `convertIntToOctal` | `op convertIntToOctal (as int64: value) as string` | `string` |
| `convertIntToOctalPadded` | `op convertIntToOctalPadded (as int64: value, as int64: width) as string` | `string` |
| `convertIntToRadix` | `op convertIntToRadix (as int64: value, as int64: base) as string` | `string` |
| `convertParseRadix` | `op convertParseRadix (as string: text, as int64: base) as int64` | `int64` |
| `convertParseRadixOrDefault` | `op convertParseRadixOrDefault (as string: text, as int64: base, as int64: default) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op convertIntToHex`
```flux
op convertIntToHex (as int64: value) as string
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToHex` no domínio `ConvertBaseContract`.

##### `op convertIntToHexPadded`
```flux
op convertIntToHexPadded (as int64: value, as int64: width) as string
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToHexPadded` no domínio `ConvertBaseContract`.

##### `op convertIntToBinary`
```flux
op convertIntToBinary (as int64: value) as string
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToBinary` no domínio `ConvertBaseContract`.

##### `op convertIntToBinaryPadded`
```flux
op convertIntToBinaryPadded (as int64: value, as int64: width) as string
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToBinaryPadded` no domínio `ConvertBaseContract`.

##### `op convertIntToOctal`
```flux
op convertIntToOctal (as int64: value) as string
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToOctal` no domínio `ConvertBaseContract`.

##### `op convertIntToOctalPadded`
```flux
op convertIntToOctalPadded (as int64: value, as int64: width) as string
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToOctalPadded` no domínio `ConvertBaseContract`.

##### `op convertIntToRadix`
```flux
op convertIntToRadix (as int64: value, as int64: base) as string
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `base` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToRadix` no domínio `ConvertBaseContract`.

##### `op convertParseRadix`
```flux
op convertParseRadix (as string: text, as int64: base) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `base` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertParseRadix` no domínio `ConvertBaseContract`.

##### `op convertParseRadixOrDefault`
```flux
op convertParseRadixOrDefault (as string: text, as int64: base, as int64: default) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `base` (`int64`): Parâmetro de entrada para processamento da operação.
  - `default` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertParseRadixOrDefault` no domínio `ConvertBaseContract`.

### 4.2 Contrato `ConvertComplexContract` (`ConvertComplex.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `convertToComplex` | `op convertToComplex (as float64: real, as float64: imag) as complex64` | `complex64` |
| `convertToComplex32` | `op convertToComplex32 (as float64: real, as float64: imag) as complex32` | `complex32` |
| `convertToComplex128` | `op convertToComplex128 (as float64: real, as float64: imag) as complex128` | `complex128` |
| `convertComplexToList` | `op convertComplexToList (as complex64: value) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op convertToComplex`
```flux
op convertToComplex (as float64: real, as float64: imag) as complex64
```
- **Parâmetros**:
  - `real` (`float64`): Parâmetro de entrada para processamento da operação.
  - `imag` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `complex64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertToComplex` no domínio `ConvertComplexContract`.

##### `op convertToComplex32`
```flux
op convertToComplex32 (as float64: real, as float64: imag) as complex32
```
- **Parâmetros**:
  - `real` (`float64`): Parâmetro de entrada para processamento da operação.
  - `imag` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `complex32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertToComplex32` no domínio `ConvertComplexContract`.

##### `op convertToComplex128`
```flux
op convertToComplex128 (as float64: real, as float64: imag) as complex128
```
- **Parâmetros**:
  - `real` (`float64`): Parâmetro de entrada para processamento da operação.
  - `imag` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `complex128`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertToComplex128` no domínio `ConvertComplexContract`.

##### `op convertComplexToList`
```flux
op convertComplexToList (as complex64: value) as list of data
```
- **Parâmetros**:
  - `value` (`complex64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertComplexToList` no domínio `ConvertComplexContract`.

### 4.3 Contrato `ConvertEncodingContract` (`ConvertEncoding.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `convertCharToAscii` | `op convertCharToAscii (as string: ch) as int64` | `int64` |
| `convertOrd` | `op convertOrd (as string: ch) as int64` | `int64` |
| `convertAsciiToChar` | `op convertAsciiToChar (as int64: code) as string` | `string` |
| `convertChr` | `op convertChr (as int64: code) as string` | `string` |
| `convertStringToBase64` | `op convertStringToBase64 (as string: text) as string` | `string` |
| `convertBase64ToString` | `op convertBase64ToString (as string: b64_text) as string` | `string` |
| `convertStringToHex` | `op convertStringToHex (as string: text) as string` | `string` |
| `convertHexToString` | `op convertHexToString (as string: hex_text) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op convertCharToAscii`
```flux
op convertCharToAscii (as string: ch) as int64
```
- **Parâmetros**:
  - `ch` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCharToAscii` no domínio `ConvertEncodingContract`.

##### `op convertOrd`
```flux
op convertOrd (as string: ch) as int64
```
- **Parâmetros**:
  - `ch` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertOrd` no domínio `ConvertEncodingContract`.

##### `op convertAsciiToChar`
```flux
op convertAsciiToChar (as int64: code) as string
```
- **Parâmetros**:
  - `code` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertAsciiToChar` no domínio `ConvertEncodingContract`.

##### `op convertChr`
```flux
op convertChr (as int64: code) as string
```
- **Parâmetros**:
  - `code` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertChr` no domínio `ConvertEncodingContract`.

##### `op convertStringToBase64`
```flux
op convertStringToBase64 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertStringToBase64` no domínio `ConvertEncodingContract`.

##### `op convertBase64ToString`
```flux
op convertBase64ToString (as string: b64_text) as string
```
- **Parâmetros**:
  - `b64_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertBase64ToString` no domínio `ConvertEncodingContract`.

##### `op convertStringToHex`
```flux
op convertStringToHex (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertStringToHex` no domínio `ConvertEncodingContract`.

##### `op convertHexToString`
```flux
op convertHexToString (as string: hex_text) as string
```
- **Parâmetros**:
  - `hex_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertHexToString` no domínio `ConvertEncodingContract`.

### 4.4 Contrato `ConvertNumericContract` (`ConvertNumeric.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `convertIntToFloat` | `op convertIntToFloat (as int64: value) as float64` | `float64` |
| `convertFloatToInt` | `op convertFloatToInt (as float64: value) as int64` | `int64` |
| `convertBoolToInt` | `op convertBoolToInt (as bool: value) as int64` | `int64` |
| `convertIntToBool` | `op convertIntToBool (as int64: value) as bool` | `bool` |
| `convertIntToInt8` | `op convertIntToInt8 (as int64: value) as int8` | `int8` |
| `convertIntToInt8OrDefault` | `op convertIntToInt8OrDefault (as int64: value, as int8: default) as int8` | `int8` |
| `convertIntToUint8` | `op convertIntToUint8 (as int64: value) as uint8` | `uint8` |
| `convertIntToUint8OrDefault` | `op convertIntToUint8OrDefault (as int64: value, as uint8: default) as uint8` | `uint8` |
| `convertIntToInt16` | `op convertIntToInt16 (as int64: value) as int16` | `int16` |
| `convertIntToInt16OrDefault` | `op convertIntToInt16OrDefault (as int64: value, as int16: default) as int16` | `int16` |
| `convertIntToUint16` | `op convertIntToUint16 (as int64: value) as uint16` | `uint16` |
| `convertIntToUint16OrDefault` | `op convertIntToUint16OrDefault (as int64: value, as uint16: default) as uint16` | `uint16` |
| `convertIntToInt32` | `op convertIntToInt32 (as int64: value) as int32` | `int32` |
| `convertIntToInt32OrDefault` | `op convertIntToInt32OrDefault (as int64: value, as int32: default) as int32` | `int32` |
| `convertIntToUint32` | `op convertIntToUint32 (as int64: value) as uint32` | `uint32` |
| `convertIntToUint32OrDefault` | `op convertIntToUint32OrDefault (as int64: value, as uint32: default) as uint32` | `uint32` |
| `convertIntToInt64` | `op convertIntToInt64 (as data: value) as int64` | `int64` |
| `convertIntToUint64` | `op convertIntToUint64 (as data: value) as uint64` | `uint64` |
| `convertFloatToFloat16` | `op convertFloatToFloat16 (as float64: value) as float16` | `float16` |
| `convertFloatToFloat32` | `op convertFloatToFloat32 (as float64: value) as float32` | `float32` |
| `convertFloatToFloat64` | `op convertFloatToFloat64 (as float64: value) as float64` | `float64` |
| `convertCastToInt8` | `op convertCastToInt8 (as int64: value) as int8` | `int8` |
| `convertCastToUint8` | `op convertCastToUint8 (as int64: value) as uint8` | `uint8` |
| `convertCastToInt16` | `op convertCastToInt16 (as int64: value) as int16` | `int16` |
| `convertCastToUint16` | `op convertCastToUint16 (as int64: value) as uint16` | `uint16` |
| `convertCastToInt32` | `op convertCastToInt32 (as int64: value) as int32` | `int32` |
| `convertCastToUint32` | `op convertCastToUint32 (as int64: value) as uint32` | `uint32` |
| `convertCastToInt64` | `op convertCastToInt64 (as int32: value) as int64` | `int64` |
| `convertCastToUint64` | `op convertCastToUint64 (as int64: value) as uint64` | `uint64` |
| `convertCastToFloat16` | `op convertCastToFloat16 (as float64: value) as float16` | `float16` |
| `convertCastToFloat32` | `op convertCastToFloat32 (as float64: value) as float32` | `float32` |
| `convertCastToFloat64` | `op convertCastToFloat64 (as float64: value) as float64` | `float64` |
| `convertCastToBf16E8M7` | `op convertCastToBf16E8M7 (as float32: value) as bf16_e8m7` | `bf16_e8m7` |
| `convertCastToTf32E8M10` | `op convertCastToTf32E8M10 (as float32: value) as tf32_e8m10` | `tf32_e8m10` |
| `convertCastToFp8E4M3` | `op convertCastToFp8E4M3 (as float32: value) as fp8_e4m3` | `fp8_e4m3` |
| `convertCastToFp8E4M3OrDefault` | `op convertCastToFp8E4M3OrDefault (as float32: value, as fp8_e4m3: default) as fp8_e4m3` | `fp8_e4m3` |
| `convertCastToFp8E5M2` | `op convertCastToFp8E5M2 (as float32: value) as fp8_e5m2` | `fp8_e5m2` |

#### Ficha Técnica das Operações:

##### `op convertIntToFloat`
```flux
op convertIntToFloat (as int64: value) as float64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToFloat` no domínio `ConvertNumericContract`.

##### `op convertFloatToInt`
```flux
op convertFloatToInt (as float64: value) as int64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertFloatToInt` no domínio `ConvertNumericContract`.

##### `op convertBoolToInt`
```flux
op convertBoolToInt (as bool: value) as int64
```
- **Parâmetros**:
  - `value` (`bool`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertBoolToInt` no domínio `ConvertNumericContract`.

##### `op convertIntToBool`
```flux
op convertIntToBool (as int64: value) as bool
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToBool` no domínio `ConvertNumericContract`.

##### `op convertIntToInt8`
```flux
op convertIntToInt8 (as int64: value) as int8
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int8`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToInt8` no domínio `ConvertNumericContract`.

##### `op convertIntToInt8OrDefault`
```flux
op convertIntToInt8OrDefault (as int64: value, as int8: default) as int8
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `default` (`int8`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int8`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToInt8OrDefault` no domínio `ConvertNumericContract`.

##### `op convertIntToUint8`
```flux
op convertIntToUint8 (as int64: value) as uint8
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint8`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToUint8` no domínio `ConvertNumericContract`.

##### `op convertIntToUint8OrDefault`
```flux
op convertIntToUint8OrDefault (as int64: value, as uint8: default) as uint8
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `default` (`uint8`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint8`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToUint8OrDefault` no domínio `ConvertNumericContract`.

##### `op convertIntToInt16`
```flux
op convertIntToInt16 (as int64: value) as int16
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToInt16` no domínio `ConvertNumericContract`.

##### `op convertIntToInt16OrDefault`
```flux
op convertIntToInt16OrDefault (as int64: value, as int16: default) as int16
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `default` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToInt16OrDefault` no domínio `ConvertNumericContract`.

##### `op convertIntToUint16`
```flux
op convertIntToUint16 (as int64: value) as uint16
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToUint16` no domínio `ConvertNumericContract`.

##### `op convertIntToUint16OrDefault`
```flux
op convertIntToUint16OrDefault (as int64: value, as uint16: default) as uint16
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `default` (`uint16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToUint16OrDefault` no domínio `ConvertNumericContract`.

##### `op convertIntToInt32`
```flux
op convertIntToInt32 (as int64: value) as int32
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToInt32` no domínio `ConvertNumericContract`.

##### `op convertIntToInt32OrDefault`
```flux
op convertIntToInt32OrDefault (as int64: value, as int32: default) as int32
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `default` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToInt32OrDefault` no domínio `ConvertNumericContract`.

##### `op convertIntToUint32`
```flux
op convertIntToUint32 (as int64: value) as uint32
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToUint32` no domínio `ConvertNumericContract`.

##### `op convertIntToUint32OrDefault`
```flux
op convertIntToUint32OrDefault (as int64: value, as uint32: default) as uint32
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `default` (`uint32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToUint32OrDefault` no domínio `ConvertNumericContract`.

##### `op convertIntToInt64`
```flux
op convertIntToInt64 (as data: value) as int64
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToInt64` no domínio `ConvertNumericContract`.

##### `op convertIntToUint64`
```flux
op convertIntToUint64 (as data: value) as uint64
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToUint64` no domínio `ConvertNumericContract`.

##### `op convertFloatToFloat16`
```flux
op convertFloatToFloat16 (as float64: value) as float16
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertFloatToFloat16` no domínio `ConvertNumericContract`.

##### `op convertFloatToFloat32`
```flux
op convertFloatToFloat32 (as float64: value) as float32
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertFloatToFloat32` no domínio `ConvertNumericContract`.

##### `op convertFloatToFloat64`
```flux
op convertFloatToFloat64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertFloatToFloat64` no domínio `ConvertNumericContract`.

##### `op convertCastToInt8`
```flux
op convertCastToInt8 (as int64: value) as int8
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int8`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToInt8` no domínio `ConvertNumericContract`.

##### `op convertCastToUint8`
```flux
op convertCastToUint8 (as int64: value) as uint8
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint8`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToUint8` no domínio `ConvertNumericContract`.

##### `op convertCastToInt16`
```flux
op convertCastToInt16 (as int64: value) as int16
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToInt16` no domínio `ConvertNumericContract`.

##### `op convertCastToUint16`
```flux
op convertCastToUint16 (as int64: value) as uint16
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToUint16` no domínio `ConvertNumericContract`.

##### `op convertCastToInt32`
```flux
op convertCastToInt32 (as int64: value) as int32
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToInt32` no domínio `ConvertNumericContract`.

##### `op convertCastToUint32`
```flux
op convertCastToUint32 (as int64: value) as uint32
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToUint32` no domínio `ConvertNumericContract`.

##### `op convertCastToInt64`
```flux
op convertCastToInt64 (as int32: value) as int64
```
- **Parâmetros**:
  - `value` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToInt64` no domínio `ConvertNumericContract`.

##### `op convertCastToUint64`
```flux
op convertCastToUint64 (as int64: value) as uint64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `uint64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToUint64` no domínio `ConvertNumericContract`.

##### `op convertCastToFloat16`
```flux
op convertCastToFloat16 (as float64: value) as float16
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToFloat16` no domínio `ConvertNumericContract`.

##### `op convertCastToFloat32`
```flux
op convertCastToFloat32 (as float64: value) as float32
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToFloat32` no domínio `ConvertNumericContract`.

##### `op convertCastToFloat64`
```flux
op convertCastToFloat64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToFloat64` no domínio `ConvertNumericContract`.

##### `op convertCastToBf16E8M7`
```flux
op convertCastToBf16E8M7 (as float32: value) as bf16_e8m7
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bf16_e8m7`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToBf16E8M7` no domínio `ConvertNumericContract`.

##### `op convertCastToTf32E8M10`
```flux
op convertCastToTf32E8M10 (as float32: value) as tf32_e8m10
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `tf32_e8m10`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToTf32E8M10` no domínio `ConvertNumericContract`.

##### `op convertCastToFp8E4M3`
```flux
op convertCastToFp8E4M3 (as float32: value) as fp8_e4m3
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `fp8_e4m3`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToFp8E4M3` no domínio `ConvertNumericContract`.

##### `op convertCastToFp8E4M3OrDefault`
```flux
op convertCastToFp8E4M3OrDefault (as float32: value, as fp8_e4m3: default) as fp8_e4m3
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
  - `default` (`fp8_e4m3`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `fp8_e4m3`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToFp8E4M3OrDefault` no domínio `ConvertNumericContract`.

##### `op convertCastToFp8E5M2`
```flux
op convertCastToFp8E5M2 (as float32: value) as fp8_e5m2
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `fp8_e5m2`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertCastToFp8E5M2` no domínio `ConvertNumericContract`.

### 4.5 Contrato `ConvertParsingContract` (`ConvertParsing.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `convertParseInt` | `op convertParseInt (as string: text) as int64` | `int64` |
| `convertParseIntOrDefault` | `op convertParseIntOrDefault (as string: text, as int64: default) as int64` | `int64` |
| `convertParseFloat` | `op convertParseFloat (as string: text) as float64` | `float64` |
| `convertParseFloatOrDefault` | `op convertParseFloatOrDefault (as string: text, as float64: default) as float64` | `float64` |
| `convertParseBool` | `op convertParseBool (as string: text) as bool` | `bool` |
| `convertParseHex` | `op convertParseHex (as string: text) as int64` | `int64` |
| `convertParseBinary` | `op convertParseBinary (as string: text) as int64` | `int64` |
| `convertParseOctal` | `op convertParseOctal (as string: text) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op convertParseInt`
```flux
op convertParseInt (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertParseInt` no domínio `ConvertParsingContract`.

##### `op convertParseIntOrDefault`
```flux
op convertParseIntOrDefault (as string: text, as int64: default) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `default` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertParseIntOrDefault` no domínio `ConvertParsingContract`.

##### `op convertParseFloat`
```flux
op convertParseFloat (as string: text) as float64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertParseFloat` no domínio `ConvertParsingContract`.

##### `op convertParseFloatOrDefault`
```flux
op convertParseFloatOrDefault (as string: text, as float64: default) as float64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `default` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertParseFloatOrDefault` no domínio `ConvertParsingContract`.

##### `op convertParseBool`
```flux
op convertParseBool (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertParseBool` no domínio `ConvertParsingContract`.

##### `op convertParseHex`
```flux
op convertParseHex (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertParseHex` no domínio `ConvertParsingContract`.

##### `op convertParseBinary`
```flux
op convertParseBinary (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertParseBinary` no domínio `ConvertParsingContract`.

##### `op convertParseOctal`
```flux
op convertParseOctal (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertParseOctal` no domínio `ConvertParsingContract`.

### 4.6 Contrato `ConvertStringContract` (`ConvertString.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `convertToString` | `op convertToString (as data: value) as string` | `string` |
| `convertIntToString` | `op convertIntToString (as int64: value) as string` | `string` |
| `convertFloatToString` | `op convertFloatToString (as float64: value) as string` | `string` |
| `convertBoolToString` | `op convertBoolToString (as bool: value) as string` | `string` |
| `convertEnumToString` | `op convertEnumToString (as data: value) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op convertToString`
```flux
op convertToString (as data: value) as string
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertToString` no domínio `ConvertStringContract`.

##### `op convertIntToString`
```flux
op convertIntToString (as int64: value) as string
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertIntToString` no domínio `ConvertStringContract`.

##### `op convertFloatToString`
```flux
op convertFloatToString (as float64: value) as string
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertFloatToString` no domínio `ConvertStringContract`.

##### `op convertBoolToString`
```flux
op convertBoolToString (as bool: value) as string
```
- **Parâmetros**:
  - `value` (`bool`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertBoolToString` no domínio `ConvertStringContract`.

##### `op convertEnumToString`
```flux
op convertEnumToString (as data: value) as string
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `convertEnumToString` no domínio `ConvertStringContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da ConvertStdLib
use ConvertStdLib

program (ExemploConvertStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: ConvertStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = ConvertStdLib::stringToInt64("1024")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
