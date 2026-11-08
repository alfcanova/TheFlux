# 📚 `LowLevelStdLib` — Low-Level Memory Management, Raw Pointers, and Binary Buffers

> **Architectural Pillar**: Pillar 4 (System, I/O & Network)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/LowLevelStdLib/LowLevelStdLib.fdsl`  
> **Import Mode**: `use LowLevelStdLib` or `use LowLevelStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`LowLevelStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Direct hardware and memory primitives: raw pointer arithmetic, byte boundary alignment, bit-level manipulations (popcount, leading/trailing zero counts), byte-order flipping, and block-level memory copy operations.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `LowLevelStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **9 domain modules** declaring a total of **105 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `LowLevelAlignment.fdsl` | `LowLevelAlignmentContract` | Specialized domain for `LowLevelAlignment` | 6 |
| `LowLevelBitInspection.fdsl` | `LowLevelBitInspectionContract` | Specialized domain for `LowLevelBitInspection` | 12 |
| `LowLevelBitwise.fdsl` | `LowLevelBitwiseContract` | Specialized domain for `LowLevelBitwise` | 7 |
| `LowLevelBlockMemory.fdsl` | `LowLevelBlockMemoryContract` | Specialized domain for `LowLevelBlockMemory` | 5 |
| `LowLevelBuffer.fdsl` | `LowLevelBufferContract` | Specialized domain for `LowLevelBuffer` | 13 |
| `LowLevelConstants.fdsl` | `LowLevelConstantsContract` | Specialized domain for `LowLevelConstants` | 28 |
| `LowLevelEndianness.fdsl` | `LowLevelEndiannessContract` | Specialized domain for `LowLevelEndianness` | 9 |
| `LowLevelMemoryAccess.fdsl` | `LowLevelMemoryAccessContract` | Specialized domain for `LowLevelMemoryAccess` | 16 |
| `LowLevelShiftRotate.fdsl` | `LowLevelShiftRotateContract` | Specialized domain for `LowLevelShiftRotate` | 9 |

---

## 3. Public Types, Structures, and Enumerations

The `LowLevelStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `LowLevelAlignmentContract` (`LowLevelAlignment.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `lowIsAligned` | `op lowIsAligned (as int64: address, as int64: alignment) as bool` | `bool` |
| `lowAlignForward` | `op lowAlignForward (as int64: address, as int64: alignment) as int64` | `int64` |
| `lowAlignBackward` | `op lowAlignBackward (as int64: address, as int64: alignment) as int64` | `int64` |
| `lowAlignmentPadding` | `op lowAlignmentPadding (as int64: address, as int64: alignment) as int64` | `int64` |
| `lowAddressOffset` | `op lowAddressOffset (as int64: base_address, as int64: offset_bytes) as int64` | `int64` |
| `lowAddressDifference` | `op lowAddressDifference (as int64: addr1, as int64: addr2) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op lowIsAligned`
```flux
op lowIsAligned (as int64: address, as int64: alignment) as bool
```
- **Parameters**:
  - `address` (`int64`): Input argument for operation execution.
  - `alignment` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowIsAligned` functionality within the `LowLevelAlignmentContract` domain.

##### `op lowAlignForward`
```flux
op lowAlignForward (as int64: address, as int64: alignment) as int64
```
- **Parameters**:
  - `address` (`int64`): Input argument for operation execution.
  - `alignment` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowAlignForward` functionality within the `LowLevelAlignmentContract` domain.

##### `op lowAlignBackward`
```flux
op lowAlignBackward (as int64: address, as int64: alignment) as int64
```
- **Parameters**:
  - `address` (`int64`): Input argument for operation execution.
  - `alignment` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowAlignBackward` functionality within the `LowLevelAlignmentContract` domain.

##### `op lowAlignmentPadding`
```flux
op lowAlignmentPadding (as int64: address, as int64: alignment) as int64
```
- **Parameters**:
  - `address` (`int64`): Input argument for operation execution.
  - `alignment` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowAlignmentPadding` functionality within the `LowLevelAlignmentContract` domain.

##### `op lowAddressOffset`
```flux
op lowAddressOffset (as int64: base_address, as int64: offset_bytes) as int64
```
- **Parameters**:
  - `base_address` (`int64`): Input argument for operation execution.
  - `offset_bytes` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowAddressOffset` functionality within the `LowLevelAlignmentContract` domain.

##### `op lowAddressDifference`
```flux
op lowAddressDifference (as int64: addr1, as int64: addr2) as int64
```
- **Parameters**:
  - `addr1` (`int64`): Input argument for operation execution.
  - `addr2` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowAddressDifference` functionality within the `LowLevelAlignmentContract` domain.

### 4.2 Contract `LowLevelBitInspectionContract` (`LowLevelBitInspection.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `lowBitCheck` | `op lowBitCheck (as int64: value, as int64: bit_index) as bool` | `bool` |
| `lowBitSet` | `op lowBitSet (as int64: value, as int64: bit_index) as int64` | `int64` |
| `lowBitClear` | `op lowBitClear (as int64: value, as int64: bit_index) as int64` | `int64` |
| `lowBitToggle` | `op lowBitToggle (as int64: value, as int64: bit_index) as int64` | `int64` |
| `lowBitWrite` | `op lowBitWrite (as int64: value, as int64: bit_index, as bool: state) as int64` | `int64` |
| `lowPopCount` | `op lowPopCount (as int64: value) as int64` | `int64` |
| `lowCountLeadingZeros` | `op lowCountLeadingZeros (as int64: value, as int64: width) as int64` | `int64` |
| `lowCountTrailingZeros` | `op lowCountTrailingZeros (as int64: value) as int64` | `int64` |
| `lowParity` | `op lowParity (as int64: value) as int64` | `int64` |
| `lowReverseBits` | `op lowReverseBits (as int64: value, as int64: width) as int64` | `int64` |
| `lowBitExtract` | `op lowBitExtract (as int64: value, as int64: start_bit, as int64: num_bits) as int64` | `int64` |
| `lowBitInsert` | `op lowBitInsert (as int64: target, as int64: source, as int64: start_bit, as int64: num_bits) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op lowBitCheck`
```flux
op lowBitCheck (as int64: value, as int64: bit_index) as bool
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bit_index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitCheck` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowBitSet`
```flux
op lowBitSet (as int64: value, as int64: bit_index) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bit_index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitSet` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowBitClear`
```flux
op lowBitClear (as int64: value, as int64: bit_index) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bit_index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitClear` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowBitToggle`
```flux
op lowBitToggle (as int64: value, as int64: bit_index) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bit_index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitToggle` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowBitWrite`
```flux
op lowBitWrite (as int64: value, as int64: bit_index, as bool: state) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bit_index` (`int64`): Input argument for operation execution.
  - `state` (`bool`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitWrite` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowPopCount`
```flux
op lowPopCount (as int64: value) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowPopCount` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowCountLeadingZeros`
```flux
op lowCountLeadingZeros (as int64: value, as int64: width) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `width` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowCountLeadingZeros` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowCountTrailingZeros`
```flux
op lowCountTrailingZeros (as int64: value) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowCountTrailingZeros` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowParity`
```flux
op lowParity (as int64: value) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowParity` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowReverseBits`
```flux
op lowReverseBits (as int64: value, as int64: width) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `width` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowReverseBits` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowBitExtract`
```flux
op lowBitExtract (as int64: value, as int64: start_bit, as int64: num_bits) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `start_bit` (`int64`): Input argument for operation execution.
  - `num_bits` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitExtract` functionality within the `LowLevelBitInspectionContract` domain.

##### `op lowBitInsert`
```flux
op lowBitInsert (as int64: target, as int64: source, as int64: start_bit, as int64: num_bits) as int64
```
- **Parameters**:
  - `target` (`int64`): Input argument for operation execution.
  - `source` (`int64`): Input argument for operation execution.
  - `start_bit` (`int64`): Input argument for operation execution.
  - `num_bits` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitInsert` functionality within the `LowLevelBitInspectionContract` domain.

### 4.3 Contract `LowLevelBitwiseContract` (`LowLevelBitwise.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `lowBitAnd` | `op lowBitAnd (as int64: a, as int64: b) as int64` | `int64` |
| `lowBitOr` | `op lowBitOr (as int64: a, as int64: b) as int64` | `int64` |
| `lowBitXor` | `op lowBitXor (as int64: a, as int64: b) as int64` | `int64` |
| `lowBitNot` | `op lowBitNot (as int64: a) as int64` | `int64` |
| `lowBitNand` | `op lowBitNand (as int64: a, as int64: b) as int64` | `int64` |
| `lowBitNor` | `op lowBitNor (as int64: a, as int64: b) as int64` | `int64` |
| `lowBitXnor` | `op lowBitXnor (as int64: a, as int64: b) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op lowBitAnd`
```flux
op lowBitAnd (as int64: a, as int64: b) as int64
```
- **Parameters**:
  - `a` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitAnd` functionality within the `LowLevelBitwiseContract` domain.

##### `op lowBitOr`
```flux
op lowBitOr (as int64: a, as int64: b) as int64
```
- **Parameters**:
  - `a` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitOr` functionality within the `LowLevelBitwiseContract` domain.

##### `op lowBitXor`
```flux
op lowBitXor (as int64: a, as int64: b) as int64
```
- **Parameters**:
  - `a` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitXor` functionality within the `LowLevelBitwiseContract` domain.

##### `op lowBitNot`
```flux
op lowBitNot (as int64: a) as int64
```
- **Parameters**:
  - `a` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitNot` functionality within the `LowLevelBitwiseContract` domain.

##### `op lowBitNand`
```flux
op lowBitNand (as int64: a, as int64: b) as int64
```
- **Parameters**:
  - `a` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitNand` functionality within the `LowLevelBitwiseContract` domain.

##### `op lowBitNor`
```flux
op lowBitNor (as int64: a, as int64: b) as int64
```
- **Parameters**:
  - `a` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitNor` functionality within the `LowLevelBitwiseContract` domain.

##### `op lowBitXnor`
```flux
op lowBitXnor (as int64: a, as int64: b) as int64
```
- **Parameters**:
  - `a` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBitXnor` functionality within the `LowLevelBitwiseContract` domain.

### 4.4 Contract `LowLevelBlockMemoryContract` (`LowLevelBlockMemory.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `lowMemoryCopy` | `op lowMemoryCopy (as map: mem, as int64: src_addr, as int64: dst_addr, as int64: count) as map` | `map` |
| `lowMemorySet` | `op lowMemorySet (as map: mem, as int64: dst_addr, as int64: byte_val, as int64: count) as map` | `map` |
| `lowMemoryCompare` | `op lowMemoryCompare (as map: mem, as int64: addr1, as int64: addr2, as int64: count) as int64` | `int64` |
| `lowMemoryClear` | `op lowMemoryClear (as map: mem, as int64: address, as int64: count) as map` | `map` |
| `lowMemoryDump` | `op lowMemoryDump (as map: mem, as int64: address, as int64: count) as string` | `string` |

#### Operation Technical Specifications:

##### `op lowMemoryCopy`
```flux
op lowMemoryCopy (as map: mem, as int64: src_addr, as int64: dst_addr, as int64: count) as map
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `src_addr` (`int64`): Input argument for operation execution.
  - `dst_addr` (`int64`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryCopy` functionality within the `LowLevelBlockMemoryContract` domain.

##### `op lowMemorySet`
```flux
op lowMemorySet (as map: mem, as int64: dst_addr, as int64: byte_val, as int64: count) as map
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `dst_addr` (`int64`): Input argument for operation execution.
  - `byte_val` (`int64`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemorySet` functionality within the `LowLevelBlockMemoryContract` domain.

##### `op lowMemoryCompare`
```flux
op lowMemoryCompare (as map: mem, as int64: addr1, as int64: addr2, as int64: count) as int64
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `addr1` (`int64`): Input argument for operation execution.
  - `addr2` (`int64`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryCompare` functionality within the `LowLevelBlockMemoryContract` domain.

##### `op lowMemoryClear`
```flux
op lowMemoryClear (as map: mem, as int64: address, as int64: count) as map
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `address` (`int64`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryClear` functionality within the `LowLevelBlockMemoryContract` domain.

##### `op lowMemoryDump`
```flux
op lowMemoryDump (as map: mem, as int64: address, as int64: count) as string
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `address` (`int64`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryDump` functionality within the `LowLevelBlockMemoryContract` domain.

### 4.5 Contract `LowLevelBufferContract` (`LowLevelBuffer.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `lowBufferNew` | `op lowBufferNew (as int64: capacity) as map` | `map` |
| `lowBufferLength` | `op lowBufferLength (as map: buf) as int64` | `int64` |
| `lowBufferCapacity` | `op lowBufferCapacity (as map: buf) as int64` | `int64` |
| `lowBufferWriteByte` | `op lowBufferWriteByte (as map: buf, as int64: val) as map` | `map` |
| `lowBufferWriteHWord` | `op lowBufferWriteHWord (as map: buf, as int64: val) as map` | `map` |
| `lowBufferWriteWord` | `op lowBufferWriteWord (as map: buf, as int64: val) as map` | `map` |
| `lowBufferWriteDWord` | `op lowBufferWriteDWord (as map: buf, as int64: val) as map` | `map` |
| `lowBufferReadByte` | `op lowBufferReadByte (as map: buf, as int64: offset) as int64` | `int64` |
| `lowBufferReadHWord` | `op lowBufferReadHWord (as map: buf, as int64: offset) as int64` | `int64` |
| `lowBufferReadWord` | `op lowBufferReadWord (as map: buf, as int64: offset) as int64` | `int64` |
| `lowBufferReadDWord` | `op lowBufferReadDWord (as map: buf, as int64: offset) as int64` | `int64` |
| `lowBufferToHex` | `op lowBufferToHex (as map: buf) as string` | `string` |
| `lowBufferFromHex` | `op lowBufferFromHex (as string: hex_str) as map` | `map` |

#### Operation Technical Specifications:

##### `op lowBufferNew`
```flux
op lowBufferNew (as int64: capacity) as map
```
- **Parameters**:
  - `capacity` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferNew` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferLength`
```flux
op lowBufferLength (as map: buf) as int64
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferLength` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferCapacity`
```flux
op lowBufferCapacity (as map: buf) as int64
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferCapacity` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferWriteByte`
```flux
op lowBufferWriteByte (as map: buf, as int64: val) as map
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
  - `val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferWriteByte` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferWriteHWord`
```flux
op lowBufferWriteHWord (as map: buf, as int64: val) as map
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
  - `val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferWriteHWord` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferWriteWord`
```flux
op lowBufferWriteWord (as map: buf, as int64: val) as map
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
  - `val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferWriteWord` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferWriteDWord`
```flux
op lowBufferWriteDWord (as map: buf, as int64: val) as map
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
  - `val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferWriteDWord` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferReadByte`
```flux
op lowBufferReadByte (as map: buf, as int64: offset) as int64
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
  - `offset` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferReadByte` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferReadHWord`
```flux
op lowBufferReadHWord (as map: buf, as int64: offset) as int64
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
  - `offset` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferReadHWord` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferReadWord`
```flux
op lowBufferReadWord (as map: buf, as int64: offset) as int64
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
  - `offset` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferReadWord` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferReadDWord`
```flux
op lowBufferReadDWord (as map: buf, as int64: offset) as int64
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
  - `offset` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferReadDWord` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferToHex`
```flux
op lowBufferToHex (as map: buf) as string
```
- **Parameters**:
  - `buf` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferToHex` functionality within the `LowLevelBufferContract` domain.

##### `op lowBufferFromHex`
```flux
op lowBufferFromHex (as string: hex_str) as map
```
- **Parameters**:
  - `hex_str` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowBufferFromHex` functionality within the `LowLevelBufferContract` domain.

### 4.6 Contract `LowLevelConstantsContract` (`LowLevelConstants.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `mask8` | `op mask8 () as int64` | `int64` |
| `mask16` | `op mask16 () as int64` | `int64` |
| `mask32` | `op mask32 () as int64` | `int64` |
| `mask64` | `op mask64 () as int64` | `int64` |
| `int8Min` | `op int8Min () as int64` | `int64` |
| `int8Max` | `op int8Max () as int64` | `int64` |
| `uint8Max` | `op uint8Max () as int64` | `int64` |
| `int16Min` | `op int16Min () as int64` | `int64` |
| `int16Max` | `op int16Max () as int64` | `int64` |
| `uint16Max` | `op uint16Max () as int64` | `int64` |
| `int32Min` | `op int32Min () as int64` | `int64` |
| `int32Max` | `op int32Max () as int64` | `int64` |
| `uint32Max` | `op uint32Max () as int64` | `int64` |
| `int64Min` | `op int64Min () as int64` | `int64` |
| `int64Max` | `op int64Max () as int64` | `int64` |
| `sizeByte` | `op sizeByte () as int64` | `int64` |
| `sizeHWord` | `op sizeHWord () as int64` | `int64` |
| `sizeWord` | `op sizeWord () as int64` | `int64` |
| `sizeDWord` | `op sizeDWord () as int64` | `int64` |
| `bitsByte` | `op bitsByte () as int64` | `int64` |
| `bitsHWord` | `op bitsHWord () as int64` | `int64` |
| `bitsWord` | `op bitsWord () as int64` | `int64` |
| `bitsDWord` | `op bitsDWord () as int64` | `int64` |
| `pageSize4K` | `op pageSize4K () as int64` | `int64` |
| `pageSizeHuge2M` | `op pageSizeHuge2M () as int64` | `int64` |
| `cacheLineSize` | `op cacheLineSize () as int64` | `int64` |
| `endianLittle` | `op endianLittle () as int64` | `int64` |
| `endianBig` | `op endianBig () as int64` | `int64` |

#### Operation Technical Specifications:

##### `op mask8`
```flux
op mask8 () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mask8` functionality within the `LowLevelConstantsContract` domain.

##### `op mask16`
```flux
op mask16 () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mask16` functionality within the `LowLevelConstantsContract` domain.

##### `op mask32`
```flux
op mask32 () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mask32` functionality within the `LowLevelConstantsContract` domain.

##### `op mask64`
```flux
op mask64 () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mask64` functionality within the `LowLevelConstantsContract` domain.

##### `op int8Min`
```flux
op int8Min () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `int8Min` functionality within the `LowLevelConstantsContract` domain.

##### `op int8Max`
```flux
op int8Max () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `int8Max` functionality within the `LowLevelConstantsContract` domain.

##### `op uint8Max`
```flux
op uint8Max () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `uint8Max` functionality within the `LowLevelConstantsContract` domain.

##### `op int16Min`
```flux
op int16Min () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `int16Min` functionality within the `LowLevelConstantsContract` domain.

##### `op int16Max`
```flux
op int16Max () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `int16Max` functionality within the `LowLevelConstantsContract` domain.

##### `op uint16Max`
```flux
op uint16Max () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `uint16Max` functionality within the `LowLevelConstantsContract` domain.

##### `op int32Min`
```flux
op int32Min () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `int32Min` functionality within the `LowLevelConstantsContract` domain.

##### `op int32Max`
```flux
op int32Max () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `int32Max` functionality within the `LowLevelConstantsContract` domain.

##### `op uint32Max`
```flux
op uint32Max () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `uint32Max` functionality within the `LowLevelConstantsContract` domain.

##### `op int64Min`
```flux
op int64Min () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `int64Min` functionality within the `LowLevelConstantsContract` domain.

##### `op int64Max`
```flux
op int64Max () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `int64Max` functionality within the `LowLevelConstantsContract` domain.

##### `op sizeByte`
```flux
op sizeByte () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sizeByte` functionality within the `LowLevelConstantsContract` domain.

##### `op sizeHWord`
```flux
op sizeHWord () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sizeHWord` functionality within the `LowLevelConstantsContract` domain.

##### `op sizeWord`
```flux
op sizeWord () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sizeWord` functionality within the `LowLevelConstantsContract` domain.

##### `op sizeDWord`
```flux
op sizeDWord () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sizeDWord` functionality within the `LowLevelConstantsContract` domain.

##### `op bitsByte`
```flux
op bitsByte () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `bitsByte` functionality within the `LowLevelConstantsContract` domain.

##### `op bitsHWord`
```flux
op bitsHWord () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `bitsHWord` functionality within the `LowLevelConstantsContract` domain.

##### `op bitsWord`
```flux
op bitsWord () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `bitsWord` functionality within the `LowLevelConstantsContract` domain.

##### `op bitsDWord`
```flux
op bitsDWord () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `bitsDWord` functionality within the `LowLevelConstantsContract` domain.

##### `op pageSize4K`
```flux
op pageSize4K () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pageSize4K` functionality within the `LowLevelConstantsContract` domain.

##### `op pageSizeHuge2M`
```flux
op pageSizeHuge2M () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pageSizeHuge2M` functionality within the `LowLevelConstantsContract` domain.

##### `op cacheLineSize`
```flux
op cacheLineSize () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cacheLineSize` functionality within the `LowLevelConstantsContract` domain.

##### `op endianLittle`
```flux
op endianLittle () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `endianLittle` functionality within the `LowLevelConstantsContract` domain.

##### `op endianBig`
```flux
op endianBig () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `endianBig` functionality within the `LowLevelConstantsContract` domain.

### 4.7 Contract `LowLevelEndiannessContract` (`LowLevelEndianness.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `lowByteSwap16` | `op lowByteSwap16 (as int64: v) as int64` | `int64` |
| `lowByteSwap32` | `op lowByteSwap32 (as int64: v) as int64` | `int64` |
| `lowByteSwap64` | `op lowByteSwap64 (as int64: v) as int64` | `int64` |
| `lowHostToNetwork16` | `op lowHostToNetwork16 (as int64: v) as int64` | `int64` |
| `lowNetworkToHost16` | `op lowNetworkToHost16 (as int64: v) as int64` | `int64` |
| `lowHostToNetwork32` | `op lowHostToNetwork32 (as int64: v) as int64` | `int64` |
| `lowNetworkToHost32` | `op lowNetworkToHost32 (as int64: v) as int64` | `int64` |
| `lowHostToNetwork64` | `op lowHostToNetwork64 (as int64: v) as int64` | `int64` |
| `lowNetworkToHost64` | `op lowNetworkToHost64 (as int64: v) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op lowByteSwap16`
```flux
op lowByteSwap16 (as int64: v) as int64
```
- **Parameters**:
  - `v` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowByteSwap16` functionality within the `LowLevelEndiannessContract` domain.

##### `op lowByteSwap32`
```flux
op lowByteSwap32 (as int64: v) as int64
```
- **Parameters**:
  - `v` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowByteSwap32` functionality within the `LowLevelEndiannessContract` domain.

##### `op lowByteSwap64`
```flux
op lowByteSwap64 (as int64: v) as int64
```
- **Parameters**:
  - `v` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowByteSwap64` functionality within the `LowLevelEndiannessContract` domain.

##### `op lowHostToNetwork16`
```flux
op lowHostToNetwork16 (as int64: v) as int64
```
- **Parameters**:
  - `v` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowHostToNetwork16` functionality within the `LowLevelEndiannessContract` domain.

##### `op lowNetworkToHost16`
```flux
op lowNetworkToHost16 (as int64: v) as int64
```
- **Parameters**:
  - `v` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowNetworkToHost16` functionality within the `LowLevelEndiannessContract` domain.

##### `op lowHostToNetwork32`
```flux
op lowHostToNetwork32 (as int64: v) as int64
```
- **Parameters**:
  - `v` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowHostToNetwork32` functionality within the `LowLevelEndiannessContract` domain.

##### `op lowNetworkToHost32`
```flux
op lowNetworkToHost32 (as int64: v) as int64
```
- **Parameters**:
  - `v` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowNetworkToHost32` functionality within the `LowLevelEndiannessContract` domain.

##### `op lowHostToNetwork64`
```flux
op lowHostToNetwork64 (as int64: v) as int64
```
- **Parameters**:
  - `v` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowHostToNetwork64` functionality within the `LowLevelEndiannessContract` domain.

##### `op lowNetworkToHost64`
```flux
op lowNetworkToHost64 (as int64: v) as int64
```
- **Parameters**:
  - `v` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowNetworkToHost64` functionality within the `LowLevelEndiannessContract` domain.

### 4.8 Contract `LowLevelMemoryAccessContract` (`LowLevelMemoryAccess.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `lowMemoryInit` | `op lowMemoryInit (as int64: size_bytes) as map` | `map` |
| `lowMemoryPeekByte` | `op lowMemoryPeekByte (as map: mem, as int64: address) as int64` | `int64` |
| `lowMemoryPokeByte` | `op lowMemoryPokeByte (as map: mem, as int64: address, as int64: value) as map` | `map` |
| `lowMemoryPeekHWord` | `op lowMemoryPeekHWord (as map: mem, as int64: address) as int64` | `int64` |
| `lowMemoryPokeHWord` | `op lowMemoryPokeHWord (as map: mem, as int64: address, as int64: value) as map` | `map` |
| `lowMemoryPeekWord` | `op lowMemoryPeekWord (as map: mem, as int64: address) as int64` | `int64` |
| `lowMemoryPokeWord` | `op lowMemoryPokeWord (as map: mem, as int64: address, as int64: value) as map` | `map` |
| `lowMemoryPeekDWord` | `op lowMemoryPeekDWord (as map: mem, as int64: address) as int64` | `int64` |
| `lowMemoryPokeDWord` | `op lowMemoryPokeDWord (as map: mem, as int64: address, as int64: value) as map` | `map` |
| `lowByteGet` | `op lowByteGet (as int64: value, as int64: byte_index) as int64` | `int64` |
| `lowByteSet` | `op lowByteSet (as int64: value, as int64: byte_index, as int64: byte_val) as int64` | `int64` |
| `lowHWordGet` | `op lowHWordGet (as int64: value, as int64: hword_index) as int64` | `int64` |
| `lowWordGet` | `op lowWordGet (as int64: value, as int64: word_index) as int64` | `int64` |
| `lowMakeHWord` | `op lowMakeHWord (as int64: b0, as int64: b1) as int64` | `int64` |
| `lowMakeWord` | `op lowMakeWord (as int64: b0, as int64: b1, as int64: b2, as int64: b3) as int64` | `int64` |
| `lowMakeDWord` | `op lowMakeDWord (as int64: w0, as int64: w1) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op lowMemoryInit`
```flux
op lowMemoryInit (as int64: size_bytes) as map
```
- **Parameters**:
  - `size_bytes` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryInit` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMemoryPeekByte`
```flux
op lowMemoryPeekByte (as map: mem, as int64: address) as int64
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `address` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryPeekByte` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMemoryPokeByte`
```flux
op lowMemoryPokeByte (as map: mem, as int64: address, as int64: value) as map
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `address` (`int64`): Input argument for operation execution.
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryPokeByte` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMemoryPeekHWord`
```flux
op lowMemoryPeekHWord (as map: mem, as int64: address) as int64
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `address` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryPeekHWord` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMemoryPokeHWord`
```flux
op lowMemoryPokeHWord (as map: mem, as int64: address, as int64: value) as map
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `address` (`int64`): Input argument for operation execution.
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryPokeHWord` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMemoryPeekWord`
```flux
op lowMemoryPeekWord (as map: mem, as int64: address) as int64
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `address` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryPeekWord` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMemoryPokeWord`
```flux
op lowMemoryPokeWord (as map: mem, as int64: address, as int64: value) as map
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `address` (`int64`): Input argument for operation execution.
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryPokeWord` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMemoryPeekDWord`
```flux
op lowMemoryPeekDWord (as map: mem, as int64: address) as int64
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `address` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryPeekDWord` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMemoryPokeDWord`
```flux
op lowMemoryPokeDWord (as map: mem, as int64: address, as int64: value) as map
```
- **Parameters**:
  - `mem` (`map`): Input argument for operation execution.
  - `address` (`int64`): Input argument for operation execution.
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMemoryPokeDWord` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowByteGet`
```flux
op lowByteGet (as int64: value, as int64: byte_index) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `byte_index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowByteGet` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowByteSet`
```flux
op lowByteSet (as int64: value, as int64: byte_index, as int64: byte_val) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `byte_index` (`int64`): Input argument for operation execution.
  - `byte_val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowByteSet` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowHWordGet`
```flux
op lowHWordGet (as int64: value, as int64: hword_index) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `hword_index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowHWordGet` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowWordGet`
```flux
op lowWordGet (as int64: value, as int64: word_index) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `word_index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowWordGet` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMakeHWord`
```flux
op lowMakeHWord (as int64: b0, as int64: b1) as int64
```
- **Parameters**:
  - `b0` (`int64`): Input argument for operation execution.
  - `b1` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMakeHWord` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMakeWord`
```flux
op lowMakeWord (as int64: b0, as int64: b1, as int64: b2, as int64: b3) as int64
```
- **Parameters**:
  - `b0` (`int64`): Input argument for operation execution.
  - `b1` (`int64`): Input argument for operation execution.
  - `b2` (`int64`): Input argument for operation execution.
  - `b3` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMakeWord` functionality within the `LowLevelMemoryAccessContract` domain.

##### `op lowMakeDWord`
```flux
op lowMakeDWord (as int64: w0, as int64: w1) as int64
```
- **Parameters**:
  - `w0` (`int64`): Input argument for operation execution.
  - `w1` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowMakeDWord` functionality within the `LowLevelMemoryAccessContract` domain.

### 4.9 Contract `LowLevelShiftRotateContract` (`LowLevelShiftRotate.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `lowShiftLeft` | `op lowShiftLeft (as int64: value, as int64: bits) as int64` | `int64` |
| `lowShiftRight` | `op lowShiftRight (as int64: value, as int64: bits) as int64` | `int64` |
| `lowShiftRightLogical` | `op lowShiftRightLogical (as int64: value, as int64: bits) as int64` | `int64` |
| `lowRotateLeft` | `op lowRotateLeft (as int64: value, as int64: bits, as int64: width) as int64` | `int64` |
| `lowRotateRight` | `op lowRotateRight (as int64: value, as int64: bits, as int64: width) as int64` | `int64` |
| `lowRotateLeft64` | `op lowRotateLeft64 (as int64: value, as int64: bits) as int64` | `int64` |
| `lowRotateRight64` | `op lowRotateRight64 (as int64: value, as int64: bits) as int64` | `int64` |
| `lowRotateLeft32` | `op lowRotateLeft32 (as int64: value, as int64: bits) as int64` | `int64` |
| `lowRotateRight32` | `op lowRotateRight32 (as int64: value, as int64: bits) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op lowShiftLeft`
```flux
op lowShiftLeft (as int64: value, as int64: bits) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bits` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowShiftLeft` functionality within the `LowLevelShiftRotateContract` domain.

##### `op lowShiftRight`
```flux
op lowShiftRight (as int64: value, as int64: bits) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bits` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowShiftRight` functionality within the `LowLevelShiftRotateContract` domain.

##### `op lowShiftRightLogical`
```flux
op lowShiftRightLogical (as int64: value, as int64: bits) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bits` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowShiftRightLogical` functionality within the `LowLevelShiftRotateContract` domain.

##### `op lowRotateLeft`
```flux
op lowRotateLeft (as int64: value, as int64: bits, as int64: width) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bits` (`int64`): Input argument for operation execution.
  - `width` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowRotateLeft` functionality within the `LowLevelShiftRotateContract` domain.

##### `op lowRotateRight`
```flux
op lowRotateRight (as int64: value, as int64: bits, as int64: width) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bits` (`int64`): Input argument for operation execution.
  - `width` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowRotateRight` functionality within the `LowLevelShiftRotateContract` domain.

##### `op lowRotateLeft64`
```flux
op lowRotateLeft64 (as int64: value, as int64: bits) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bits` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowRotateLeft64` functionality within the `LowLevelShiftRotateContract` domain.

##### `op lowRotateRight64`
```flux
op lowRotateRight64 (as int64: value, as int64: bits) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bits` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowRotateRight64` functionality within the `LowLevelShiftRotateContract` domain.

##### `op lowRotateLeft32`
```flux
op lowRotateLeft32 (as int64: value, as int64: bits) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bits` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowRotateLeft32` functionality within the `LowLevelShiftRotateContract` domain.

##### `op lowRotateRight32`
```flux
op lowRotateRight32 (as int64: value, as int64: bits) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
  - `bits` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lowRotateRight32` functionality within the `LowLevelShiftRotateContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for LowLevelStdLib
use LowLevelStdLib

program (ExampleOfLowLevelStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: LowLevelStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = LowLevelStdLib::lowLevelSwapBytes32(0x12345678)
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
