from __future__ import annotations

import struct

I32 = 0x7F
I64 = 0x7E
F32 = 0x7D
F64 = 0x7C

OP_UNREACHABLE = 0x00
OP_NOP = 0x01
OP_BLOCK = 0x02
OP_LOOP = 0x03
OP_IF = 0x04
OP_ELSE = 0x05
OP_END = 0x0B
OP_BR = 0x0C
OP_BR_IF = 0x0D
OP_RETURN = 0x0F
OP_DROP = 0x1A
OP_LOCAL_GET = 0x20
OP_LOCAL_SET = 0x21
OP_LOCAL_TEE = 0x22
OP_GLOBAL_GET = 0x23
OP_GLOBAL_SET = 0x24
OP_I32_LOAD = 0x28
OP_I64_LOAD = 0x29
OP_I32_LOAD8_U = 0x2D
OP_I32_STORE = 0x36
OP_I64_STORE = 0x37
OP_I32_STORE8 = 0x3A
OP_I32_CONST = 0x41
OP_I64_CONST = 0x42
OP_F64_CONST = 0x44
OP_I64_EQZ = 0x50
OP_I32_EQZ = 0x45
OP_I32_EQ = 0x46
OP_I32_NE = 0x47
OP_I64_EQ = 0x51
OP_I64_NE = 0x52
OP_I64_LT_S = 0x53
OP_I64_LT_U = 0x54
OP_I64_GT_S = 0x55
OP_I64_GT_U = 0x56
OP_I64_LE_S = 0x57
OP_I64_LE_U = 0x58
OP_I64_GE_S = 0x59
OP_I64_GE_U = 0x5A
OP_I32_LT_S = 0x48
OP_I32_LT_U = 0x49
OP_I32_GT_S = 0x4A
OP_I32_GT_U = 0x4B
OP_I32_LE_S = 0x4C
OP_I32_LE_U = 0x4D
OP_I32_GE_S = 0x4E
OP_I32_GE_U = 0x4F
OP_I32_ADD = 0x6A
OP_I32_SUB = 0x6B
OP_I32_MUL = 0x6C
OP_I32_DIV_U = 0x6E
OP_I32_REM_U = 0x70
OP_I32_AND = 0x71
OP_I32_OR = 0x72
OP_I32_XOR = 0x73
OP_I32_SHL = 0x74
OP_I32_SHR_U = 0x76
OP_SELECT = 0x1B
OP_F64_EQ = 0x61
OP_F64_NE = 0x62
OP_F64_LT = 0x63
OP_F64_GT = 0x64
OP_F64_LE = 0x65
OP_F64_GE = 0x66
OP_I64_CLZ = 0x79
OP_I64_ADD = 0x7C
OP_I64_SUB = 0x7D
OP_I64_MUL = 0x7E
OP_I64_DIV_S = 0x7F
OP_I64_DIV_U = 0x80
OP_I64_REM_S = 0x81
OP_I64_REM_U = 0x82
OP_I64_AND = 0x83
OP_I64_OR = 0x84
OP_I64_XOR = 0x85
OP_I64_SHL = 0x86
OP_I64_SHR_S = 0x87
OP_I64_SHR_U = 0x88
OP_F64_ABS = 0x99
OP_F64_NEG = 0x9A
OP_F64_NEAREST = 0x9E
OP_F64_ADD = 0xA0
OP_F64_SUB = 0xA1
OP_F64_MUL = 0xA2
OP_F64_DIV = 0xA3
OP_F64_POW = 0xA6
OP_I32_WRAP_I64 = 0xA7
OP_I64_EXTEND_I32_S = 0xAC
OP_I64_EXTEND_I32_U = 0xAD
OP_I64_TRUNC_F64_S = 0xB0
OP_I64_TRUNC_F64_U = 0xB1
OP_F64_CONVERT_I32_S = 0xB7
OP_F64_CONVERT_I32_U = 0xB8
OP_F64_CONVERT_I64_S = 0xB9
OP_F64_CONVERT_I64_U = 0xBA
OP_I64_REINTERPRET_F64 = 0xBD
OP_F64_REINTERPRET_I64 = 0xBF

BLOCK_VOID = 0x40

SEC_CUSTOM = 0
SEC_TYPE = 1
SEC_IMPORT = 2
SEC_FUNCTION = 3
SEC_TABLE = 4
SEC_MEMORY = 5
SEC_GLOBAL = 6
SEC_EXPORT = 7
SEC_START = 8
SEC_ELEMENT = 9
SEC_CODE = 10
SEC_DATA = 11

EXPORT_FUNC = 0
EXPORT_TABLE = 1
EXPORT_MEM = 2
EXPORT_GLOBAL = 3


def uleb128(value: int) -> bytes:
    if value < 0:
        raise ValueError(f"uleb128 requires a non-negative integer, got {value}")
    result = bytearray()
    while True:
        byte = value & 0x7F
        value >>= 7
        if value:
            byte |= 0x80
        result.append(byte)
        if not value:
            break
    return bytes(result)


def sleb128(value: int) -> bytes:
    result = bytearray()
    while True:
        byte = value & 0x7F
        value >>= 7
        if (value == 0 and (byte & 0x40) == 0) or (value == -1 and (byte & 0x40) != 0):
            result.append(byte)
            break
        byte |= 0x80
        result.append(byte)
    return bytes(result)


def encode_vec(items: list[bytes]) -> bytes:
    return uleb128(len(items)) + b"".join(items)


def encode_name(name: str) -> bytes:
    data = name.encode("utf-8")
    return uleb128(len(data)) + data


def encode_memarg(align: int = 2, offset: int = 0) -> bytes:
    return uleb128(align) + uleb128(offset)


def encode_block_type(types: list[int]) -> bytes:
    if len(types) == 0:
        return bytes([BLOCK_VOID])
    if len(types) == 1:
        return bytes([types[0]])
    raise ValueError("Multi-value block types not supported")


class FuncBody:
    def __init__(self, num_params: int = 0) -> None:
        self._bytes = bytearray()
        self._num_params = num_params
        self._local_types: list[int] = []
        self._label_depth = 0

    def byte(self, b: int) -> None:
        self._bytes.append(b)

    def put(self, data: bytes) -> None:
        self._bytes.extend(data)

    def uleb(self, value: int) -> None:
        self._bytes.extend(uleb128(value))

    def new_i32(self) -> int:
        self._local_types.append(I32)
        return self._num_params + len(self._local_types) - 1

    def new_i64(self) -> int:
        self._local_types.append(I64)
        return self._num_params + len(self._local_types) - 1

    def new_f64(self) -> int:
        self._local_types.append(F64)
        return self._num_params + len(self._local_types) - 1

    def push_block(self) -> None:
        self._label_depth += 1

    def pop_block(self) -> None:
        self._label_depth -= 1

    @property
    def label_depth(self) -> int:
        return self._label_depth

    def br(self, depth: int) -> None:
        self.byte(OP_BR)
        self.uleb(depth)

    def br_if(self, depth: int) -> None:
        self.byte(OP_BR_IF)
        self.uleb(depth)

    def emit_block(self, sig: bytes = b"\x40") -> None:
        self.byte(OP_BLOCK)
        self.put(sig)
        self.push_block()

    def emit_loop(self, sig: bytes = b"\x40") -> None:
        self.byte(OP_LOOP)
        self.put(sig)
        self.push_block()

    def emit_if(self, sig: bytes = b"\x40") -> None:
        self.byte(OP_IF)
        self.put(sig)
        self.push_block()

    def emit_else(self) -> None:
        self.byte(OP_ELSE)

    def emit_end(self) -> None:
        self.byte(OP_END)
        self.pop_block()

    def local_get(self, idx: int) -> None:
        self.byte(OP_LOCAL_GET)
        self.uleb(idx)

    def local_set(self, idx: int) -> None:
        self.byte(OP_LOCAL_SET)
        self.uleb(idx)

    def global_get(self, idx: int) -> None:
        self.byte(OP_GLOBAL_GET)
        self.uleb(idx)

    def global_set(self, idx: int) -> None:
        self.byte(OP_GLOBAL_SET)
        self.uleb(idx)

    def i32_const(self, value: int) -> None:
        self.byte(OP_I32_CONST)
        self.put(sleb128(value))

    def i64_const(self, value: int) -> None:
        self.byte(OP_I64_CONST)
        self.put(sleb128(value))

    def f64_const(self, value: float) -> None:
        self.byte(OP_F64_CONST)
        self.put(struct.pack("<d", value))

    def get_bytes(self) -> bytes:
        return bytes(self._bytes)

    def get_locals_decls(self) -> list[tuple[int, int]]:
        result: list[tuple[int, int]] = []
        for t in self._local_types:
            if result and result[-1][1] == t:
                result[-1] = (result[-1][0] + 1, t)
            else:
                result.append((1, t))
        return result


class WasmModule:
    def __init__(self) -> None:
        self._types: list[bytes] = []
        self._type_cache: dict[tuple[tuple[int, ...], tuple[int, ...]], int] = {}
        self._imports: list[bytes] = []
        self._functions: list[int] = []
        self._memories: list[tuple[int, int]] = []
        self._globals: list[tuple[int, bool, bytes]] = []
        self._exports: list[tuple[str, int, int]] = []
        self._start: int | None = None
        self._codes: list[tuple[list[tuple[int, int]], bytes]] = []
        self._data: list[tuple[int, bytes, bytes]] = []

        self._func_import_count = 0
        self._global_count = 0

    def add_type(self, params: list[int], results: list[int]) -> int:
        key = (tuple(params), tuple(results))
        if key in self._type_cache:
            return self._type_cache[key]
        idx = len(self._types)
        self._types.append(self._encode_functype(params, results))
        self._type_cache[key] = idx
        return idx

    def _encode_functype(self, params: list[int], results: list[int]) -> bytes:
        return b"\x60" + encode_vec([bytes([t]) for t in params]) + encode_vec([bytes([t]) for t in results])

    def add_import(self, module: str, name: str, type_idx: int) -> int:
        idx = self._func_import_count
        self._imports.append(encode_name(module) + encode_name(name) + b"\x00" + uleb128(type_idx))
        self._func_import_count += 1
        return idx

    def add_function(self, type_idx: int) -> int:
        idx = len(self._functions)
        self._functions.append(type_idx)
        return self._func_import_count + idx

    def add_memory(self, min_pages: int, max_pages: int = -1) -> int:
        idx = len(self._memories)
        self._memories.append((min_pages, max_pages))
        return idx

    def add_global(self, type_id: int, mutable: bool, init_expr: bytes) -> int:
        idx = self._global_count
        self._globals.append((type_id, mutable, init_expr))
        self._global_count += 1
        return idx

    def add_export(self, name: str, kind: int, index: int) -> None:
        self._exports.append((name, kind, index))

    def set_start(self, func_idx: int) -> None:
        self._start = func_idx

    def add_code(self, locals_decls: list[tuple[int, int]], body: bytes) -> int:
        idx = len(self._codes)
        self._codes.append((locals_decls, body))
        return idx

    def add_data(self, mem_idx: int, offset_bytes: bytes, data: bytes) -> None:
        self._data.append((mem_idx, offset_bytes, data))

    def to_bytes(self) -> bytes:
        sections: list[bytes] = []

        if self._types:
            content = encode_vec(self._types)
            sections.append(bytes([SEC_TYPE]) + uleb128(len(content)) + content)

        if self._imports:
            content = encode_vec(self._imports)
            sections.append(bytes([SEC_IMPORT]) + uleb128(len(content)) + content)

        if self._functions:
            content = encode_vec([uleb128(t) for t in self._functions])
            sections.append(bytes([SEC_FUNCTION]) + uleb128(len(content)) + content)

        if self._memories:
            entries: list[bytes] = []
            for min_p, max_p in self._memories:
                if max_p < 0:
                    entries.append(b"\x00" + uleb128(min_p))
                else:
                    entries.append(b"\x01" + uleb128(min_p) + uleb128(max_p))
            content = encode_vec(entries)
            sections.append(bytes([SEC_MEMORY]) + uleb128(len(content)) + content)

        if self._globals:
            entries = []
            for type_id, mutable, init_expr in self._globals:
                flags = 1 if mutable else 0
                entries.append(bytes([type_id, flags]) + init_expr + bytes([OP_END]))
            content = encode_vec(entries)
            sections.append(bytes([SEC_GLOBAL]) + uleb128(len(content)) + content)

        if self._exports:
            entries = []
            for name, kind, idx in self._exports:
                entries.append(encode_name(name) + bytes([kind]) + uleb128(idx))
            content = encode_vec(entries)
            sections.append(bytes([SEC_EXPORT]) + uleb128(len(content)) + content)

        if self._start is not None:
            content = uleb128(self._start)
            sections.append(bytes([SEC_START]) + uleb128(len(content)) + content)

        if self._codes:
            entries = []
            for locals_decls, body_bytes in self._codes:
                local_bytes = encode_vec([uleb128(count) + bytes([t]) for count, t in locals_decls])
                func_body = local_bytes + body_bytes + bytes([OP_END])
                entries.append(uleb128(len(func_body)) + func_body)
            content = encode_vec(entries)
            sections.append(bytes([SEC_CODE]) + uleb128(len(content)) + content)

        if self._data:
            entries = []
            for mem_idx, offset_bytes, data in self._data:
                assert mem_idx == 0, "only memory index 0 supported"
                entries.append(b"\x00" + offset_bytes + uleb128(len(data)) + data)
            content = encode_vec(entries)
            sections.append(bytes([SEC_DATA]) + uleb128(len(content)) + content)

        return b"\x00asm\x01\x00\x00\x00" + b"".join(sections)
