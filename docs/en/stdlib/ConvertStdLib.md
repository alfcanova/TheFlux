# 📚 `ConvertStdLib` — Universal Type, Encoding, and Numeric Base Conversion

> **Architectural Pillar**: Pillar 1 (Core, Text & OO)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/ConvertStdLib/ConvertStdLib.fdsl`  
> **Import Mode**: `use ConvertStdLib` or `use ConvertStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`ConvertStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Provides deterministic conversions between numeric integer and floating-point scalars (16, 32, and 64 bits), character encoding transcoding (UTF-8, ASCII, Latin-1), radix transformations (binary, octal, hexadecimal, Base64), and fallback-safe parsing.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `ConvertStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **6 domain modules** declaring a total of **71 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `ConvertBase.fdsl` | `ConvertBaseContract` | Specialized domain for `ConvertBase` | 9 |
| `ConvertComplex.fdsl` | `ConvertComplexContract` | Specialized domain for `ConvertComplex` | 4 |
| `ConvertEncoding.fdsl` | `ConvertEncodingContract` | Specialized domain for `ConvertEncoding` | 8 |
| `ConvertNumeric.fdsl` | `ConvertNumericContract` | Specialized domain for `ConvertNumeric` | 37 |
| `ConvertParsing.fdsl` | `ConvertParsingContract` | Specialized domain for `ConvertParsing` | 8 |
| `ConvertString.fdsl` | `ConvertStringContract` | Specialized domain for `ConvertString` | 5 |

---

## 3. Public Types, Structures, and Enumerations

The `ConvertStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `ConvertBaseContract` (`ConvertBase.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op convertIntToHex`
```flux
op convertIntToHex (as int64: value) as string
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToHex` functionality within the `ConvertBaseContract` domain.

##### `op convertIntToHexPadded`
```flux
op convertIntToHexPadded (as int64: value, as int64: width) as string
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `width` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToHexPadded` functionality within the `ConvertBaseContract` domain.

##### `op convertIntToBinary`
```flux
op convertIntToBinary (as int64: value) as string
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToBinary` functionality within the `ConvertBaseContract` domain.

##### `op convertIntToBinaryPadded`
```flux
op convertIntToBinaryPadded (as int64: value, as int64: width) as string
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `width` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToBinaryPadded` functionality within the `ConvertBaseContract` domain.

##### `op convertIntToOctal`
```flux
op convertIntToOctal (as int64: value) as string
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToOctal` functionality within the `ConvertBaseContract` domain.

##### `op convertIntToOctalPadded`
```flux
op convertIntToOctalPadded (as int64: value, as int64: width) as string
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `width` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToOctalPadded` functionality within the `ConvertBaseContract` domain.

##### `op convertIntToRadix`
```flux
op convertIntToRadix (as int64: value, as int64: base) as string
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `base` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToRadix` functionality within the `ConvertBaseContract` domain.

##### `op convertParseRadix`
```flux
op convertParseRadix (as string: text, as int64: base) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `base` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertParseRadix` functionality within the `ConvertBaseContract` domain.

##### `op convertParseRadixOrDefault`
```flux
op convertParseRadixOrDefault (as string: text, as int64: base, as int64: default) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `base` (`int64`): Input argument for operation execution.
  - `default` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertParseRadixOrDefault` functionality within the `ConvertBaseContract` domain.

### 4.2 Contract `ConvertComplexContract` (`ConvertComplex.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `convertToComplex` | `op convertToComplex (as float64: real, as float64: imag) as complex64` | `complex64` |
| `convertToComplex32` | `op convertToComplex32 (as float64: real, as float64: imag) as complex32` | `complex32` |
| `convertToComplex128` | `op convertToComplex128 (as float64: real, as float64: imag) as complex128` | `complex128` |
| `convertComplexToList` | `op convertComplexToList (as complex64: value) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op convertToComplex`
```flux
op convertToComplex (as float64: real, as float64: imag) as complex64
```
- **Parameters**:
  - `real` (`float64`): Input argument for operation execution.
  - `imag` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `complex64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertToComplex` functionality within the `ConvertComplexContract` domain.

##### `op convertToComplex32`
```flux
op convertToComplex32 (as float64: real, as float64: imag) as complex32
```
- **Parameters**:
  - `real` (`float64`): Input argument for operation execution.
  - `imag` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `complex32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertToComplex32` functionality within the `ConvertComplexContract` domain.

##### `op convertToComplex128`
```flux
op convertToComplex128 (as float64: real, as float64: imag) as complex128
```
- **Parameters**:
  - `real` (`float64`): Input argument for operation execution.
  - `imag` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `complex128`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertToComplex128` functionality within the `ConvertComplexContract` domain.

##### `op convertComplexToList`
```flux
op convertComplexToList (as complex64: value) as list of data
```
- **Parameters**:
  - `value` (`complex64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertComplexToList` functionality within the `ConvertComplexContract` domain.

### 4.3 Contract `ConvertEncodingContract` (`ConvertEncoding.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `convertCharToAscii` | `op convertCharToAscii (as string: ch) as int64` | `int64` |
| `convertOrd` | `op convertOrd (as string: ch) as int64` | `int64` |
| `convertAsciiToChar` | `op convertAsciiToChar (as int64: code) as string` | `string` |
| `convertChr` | `op convertChr (as int64: code) as string` | `string` |
| `convertStringToBase64` | `op convertStringToBase64 (as string: text) as string` | `string` |
| `convertBase64ToString` | `op convertBase64ToString (as string: b64_text) as string` | `string` |
| `convertStringToHex` | `op convertStringToHex (as string: text) as string` | `string` |
| `convertHexToString` | `op convertHexToString (as string: hex_text) as string` | `string` |

#### Operation Technical Specifications:

##### `op convertCharToAscii`
```flux
op convertCharToAscii (as string: ch) as int64
```
- **Parameters**:
  - `ch` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCharToAscii` functionality within the `ConvertEncodingContract` domain.

##### `op convertOrd`
```flux
op convertOrd (as string: ch) as int64
```
- **Parameters**:
  - `ch` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertOrd` functionality within the `ConvertEncodingContract` domain.

##### `op convertAsciiToChar`
```flux
op convertAsciiToChar (as int64: code) as string
```
- **Parameters**:
  - `code` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertAsciiToChar` functionality within the `ConvertEncodingContract` domain.

##### `op convertChr`
```flux
op convertChr (as int64: code) as string
```
- **Parameters**:
  - `code` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertChr` functionality within the `ConvertEncodingContract` domain.

##### `op convertStringToBase64`
```flux
op convertStringToBase64 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertStringToBase64` functionality within the `ConvertEncodingContract` domain.

##### `op convertBase64ToString`
```flux
op convertBase64ToString (as string: b64_text) as string
```
- **Parameters**:
  - `b64_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertBase64ToString` functionality within the `ConvertEncodingContract` domain.

##### `op convertStringToHex`
```flux
op convertStringToHex (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertStringToHex` functionality within the `ConvertEncodingContract` domain.

##### `op convertHexToString`
```flux
op convertHexToString (as string: hex_text) as string
```
- **Parameters**:
  - `hex_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertHexToString` functionality within the `ConvertEncodingContract` domain.

### 4.4 Contract `ConvertNumericContract` (`ConvertNumeric.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op convertIntToFloat`
```flux
op convertIntToFloat (as int64: value) as float64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToFloat` functionality within the `ConvertNumericContract` domain.

##### `op convertFloatToInt`
```flux
op convertFloatToInt (as float64: value) as int64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertFloatToInt` functionality within the `ConvertNumericContract` domain.

##### `op convertBoolToInt`
```flux
op convertBoolToInt (as bool: value) as int64
```
- **Parameters**:
  - `value` (`bool`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertBoolToInt` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToBool`
```flux
op convertIntToBool (as int64: value) as bool
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToBool` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToInt8`
```flux
op convertIntToInt8 (as int64: value) as int8
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int8`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToInt8` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToInt8OrDefault`
```flux
op convertIntToInt8OrDefault (as int64: value, as int8: default) as int8
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `default` (`int8`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int8`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToInt8OrDefault` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToUint8`
```flux
op convertIntToUint8 (as int64: value) as uint8
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint8`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToUint8` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToUint8OrDefault`
```flux
op convertIntToUint8OrDefault (as int64: value, as uint8: default) as uint8
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `default` (`uint8`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint8`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToUint8OrDefault` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToInt16`
```flux
op convertIntToInt16 (as int64: value) as int16
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToInt16` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToInt16OrDefault`
```flux
op convertIntToInt16OrDefault (as int64: value, as int16: default) as int16
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `default` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToInt16OrDefault` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToUint16`
```flux
op convertIntToUint16 (as int64: value) as uint16
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToUint16` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToUint16OrDefault`
```flux
op convertIntToUint16OrDefault (as int64: value, as uint16: default) as uint16
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `default` (`uint16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToUint16OrDefault` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToInt32`
```flux
op convertIntToInt32 (as int64: value) as int32
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToInt32` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToInt32OrDefault`
```flux
op convertIntToInt32OrDefault (as int64: value, as int32: default) as int32
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `default` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToInt32OrDefault` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToUint32`
```flux
op convertIntToUint32 (as int64: value) as uint32
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToUint32` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToUint32OrDefault`
```flux
op convertIntToUint32OrDefault (as int64: value, as uint32: default) as uint32
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `default` (`uint32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToUint32OrDefault` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToInt64`
```flux
op convertIntToInt64 (as data: value) as int64
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToInt64` functionality within the `ConvertNumericContract` domain.

##### `op convertIntToUint64`
```flux
op convertIntToUint64 (as data: value) as uint64
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToUint64` functionality within the `ConvertNumericContract` domain.

##### `op convertFloatToFloat16`
```flux
op convertFloatToFloat16 (as float64: value) as float16
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertFloatToFloat16` functionality within the `ConvertNumericContract` domain.

##### `op convertFloatToFloat32`
```flux
op convertFloatToFloat32 (as float64: value) as float32
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertFloatToFloat32` functionality within the `ConvertNumericContract` domain.

##### `op convertFloatToFloat64`
```flux
op convertFloatToFloat64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertFloatToFloat64` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToInt8`
```flux
op convertCastToInt8 (as int64: value) as int8
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int8`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToInt8` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToUint8`
```flux
op convertCastToUint8 (as int64: value) as uint8
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint8`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToUint8` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToInt16`
```flux
op convertCastToInt16 (as int64: value) as int16
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToInt16` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToUint16`
```flux
op convertCastToUint16 (as int64: value) as uint16
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToUint16` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToInt32`
```flux
op convertCastToInt32 (as int64: value) as int32
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToInt32` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToUint32`
```flux
op convertCastToUint32 (as int64: value) as uint32
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToUint32` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToInt64`
```flux
op convertCastToInt64 (as int32: value) as int64
```
- **Parameters**:
  - `value` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToInt64` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToUint64`
```flux
op convertCastToUint64 (as int64: value) as uint64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `uint64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToUint64` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToFloat16`
```flux
op convertCastToFloat16 (as float64: value) as float16
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToFloat16` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToFloat32`
```flux
op convertCastToFloat32 (as float64: value) as float32
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToFloat32` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToFloat64`
```flux
op convertCastToFloat64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToFloat64` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToBf16E8M7`
```flux
op convertCastToBf16E8M7 (as float32: value) as bf16_e8m7
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bf16_e8m7`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToBf16E8M7` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToTf32E8M10`
```flux
op convertCastToTf32E8M10 (as float32: value) as tf32_e8m10
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `tf32_e8m10`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToTf32E8M10` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToFp8E4M3`
```flux
op convertCastToFp8E4M3 (as float32: value) as fp8_e4m3
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `fp8_e4m3`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToFp8E4M3` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToFp8E4M3OrDefault`
```flux
op convertCastToFp8E4M3OrDefault (as float32: value, as fp8_e4m3: default) as fp8_e4m3
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
  - `default` (`fp8_e4m3`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `fp8_e4m3`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToFp8E4M3OrDefault` functionality within the `ConvertNumericContract` domain.

##### `op convertCastToFp8E5M2`
```flux
op convertCastToFp8E5M2 (as float32: value) as fp8_e5m2
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `fp8_e5m2`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertCastToFp8E5M2` functionality within the `ConvertNumericContract` domain.

### 4.5 Contract `ConvertParsingContract` (`ConvertParsing.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `convertParseInt` | `op convertParseInt (as string: text) as int64` | `int64` |
| `convertParseIntOrDefault` | `op convertParseIntOrDefault (as string: text, as int64: default) as int64` | `int64` |
| `convertParseFloat` | `op convertParseFloat (as string: text) as float64` | `float64` |
| `convertParseFloatOrDefault` | `op convertParseFloatOrDefault (as string: text, as float64: default) as float64` | `float64` |
| `convertParseBool` | `op convertParseBool (as string: text) as bool` | `bool` |
| `convertParseHex` | `op convertParseHex (as string: text) as int64` | `int64` |
| `convertParseBinary` | `op convertParseBinary (as string: text) as int64` | `int64` |
| `convertParseOctal` | `op convertParseOctal (as string: text) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op convertParseInt`
```flux
op convertParseInt (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertParseInt` functionality within the `ConvertParsingContract` domain.

##### `op convertParseIntOrDefault`
```flux
op convertParseIntOrDefault (as string: text, as int64: default) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `default` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertParseIntOrDefault` functionality within the `ConvertParsingContract` domain.

##### `op convertParseFloat`
```flux
op convertParseFloat (as string: text) as float64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertParseFloat` functionality within the `ConvertParsingContract` domain.

##### `op convertParseFloatOrDefault`
```flux
op convertParseFloatOrDefault (as string: text, as float64: default) as float64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `default` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertParseFloatOrDefault` functionality within the `ConvertParsingContract` domain.

##### `op convertParseBool`
```flux
op convertParseBool (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertParseBool` functionality within the `ConvertParsingContract` domain.

##### `op convertParseHex`
```flux
op convertParseHex (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertParseHex` functionality within the `ConvertParsingContract` domain.

##### `op convertParseBinary`
```flux
op convertParseBinary (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertParseBinary` functionality within the `ConvertParsingContract` domain.

##### `op convertParseOctal`
```flux
op convertParseOctal (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertParseOctal` functionality within the `ConvertParsingContract` domain.

### 4.6 Contract `ConvertStringContract` (`ConvertString.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `convertToString` | `op convertToString (as data: value) as string` | `string` |
| `convertIntToString` | `op convertIntToString (as int64: value) as string` | `string` |
| `convertFloatToString` | `op convertFloatToString (as float64: value) as string` | `string` |
| `convertBoolToString` | `op convertBoolToString (as bool: value) as string` | `string` |
| `convertEnumToString` | `op convertEnumToString (as data: value) as string` | `string` |

#### Operation Technical Specifications:

##### `op convertToString`
```flux
op convertToString (as data: value) as string
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertToString` functionality within the `ConvertStringContract` domain.

##### `op convertIntToString`
```flux
op convertIntToString (as int64: value) as string
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertIntToString` functionality within the `ConvertStringContract` domain.

##### `op convertFloatToString`
```flux
op convertFloatToString (as float64: value) as string
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertFloatToString` functionality within the `ConvertStringContract` domain.

##### `op convertBoolToString`
```flux
op convertBoolToString (as bool: value) as string
```
- **Parameters**:
  - `value` (`bool`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertBoolToString` functionality within the `ConvertStringContract` domain.

##### `op convertEnumToString`
```flux
op convertEnumToString (as data: value) as string
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `convertEnumToString` functionality within the `ConvertStringContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for ConvertStdLib
use ConvertStdLib

program (ExampleOfConvertStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: ConvertStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = ConvertStdLib::stringToInt64("1024")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
