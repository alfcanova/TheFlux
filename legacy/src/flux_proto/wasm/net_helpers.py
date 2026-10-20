from __future__ import annotations

from flux_proto.wasm.binary import (
    FuncBody, I32, I64,
    OP_I32_LOAD, OP_I32_LOAD8_U, OP_I32_STORE, OP_I32_STORE8,
    OP_I32_CONST, OP_I64_CONST,
    OP_I64_EQZ, OP_I32_EQZ, OP_I32_EQ,
    OP_I64_EQ, OP_I32_LT_U, OP_I32_GT_U, OP_I32_LE_U, OP_I32_GE_U,
    OP_I32_LT_S, OP_I32_GT_S, OP_I32_GE_S, OP_I32_LE_S,
    OP_I32_ADD, OP_I32_SUB, OP_I32_MUL,
    OP_I32_AND, OP_I32_OR,
    OP_I64_ADD, OP_I64_MUL, OP_I64_OR, OP_I64_AND,
    OP_I64_SHL, OP_I64_SHR_U, OP_I64_EXTEND_I32_U, OP_I32_WRAP_I64,
    OP_I32_SHL, OP_I32_SHR_U,
    OP_RETURN, OP_SELECT, OP_IF, OP_ELSE, OP_END,
    OP_BR_IF, OP_BR,
    encode_memarg,
)

class NetHelpers:
    def __init__(self, cg) -> None:
        self.cg = cg
        self.mod = cg._mod
        self.helpers = cg._helper_funcs

    def build_all(self) -> None:
        self.build_net_http_status_text()
        self.build_find_scheme_sep()
        self.build_net_url_get_scheme()
        self.build_net_url_get_host()
        self.build_net_url_get_port()
        self.build_net_url_get_path()
        self.build_net_url_get_query()
        self.build_net_url_get_fragment()
        self.build_net_url_is_valid()
        self.build_strconcat()
        self.build_net_url_join()
        self.build_net_url_encode()
        self.build_hex_val()
        self.build_net_url_decode()
        self.build_net_ip_is_v4()
        self.build_net_ip_is_v6()
        self.build_net_ip_is_valid()
        self.build_net_ip_is_loopback()
        self.build_net_ip_is_private()

    def build_net_http_status_text(self) -> int:
        sig = self.mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        for code, text in [
            (200, "OK"), (201, "Created"), (204, "No Content"),
            (301, "Moved Permanently"), (302, "Found"), (304, "Not Modified"),
            (400, "Bad Request"), (401, "Unauthorized"), (403, "Forbidden"),
            (404, "Not Found"), (405, "Method Not Allowed"), (429, "Too Many Requests"),
            (500, "Internal Server Error"), (502, "Bad Gateway"),
            (503, "Service Unavailable"), (504, "Gateway Timeout"),
        ]:
            fat = self.cg._fat_const(text)
            fb.local_get(0)
            fb.i64_const(code)
            fb.byte(OP_I64_EQ)
            fb.emit_if()
            fb.i64_const(fat)
            fb.byte(OP_RETURN)
            fb.emit_end()
        fat_unknown = self.cg._fat_const("Unknown Status")
        fb.i64_const(fat_unknown)
        fb.byte(OP_RETURN)
        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_http_status_text"] = idx
        return idx

    def build_find_scheme_sep(self) -> int:
        sig = self.mod.add_type([I64], [I32])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.local_get(l_len)
        fb.i32_const(3)
        fb.byte(OP_I32_LT_S)
        fb.emit_if()
        fb.i32_const(-1)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.i32_const(0)
        fb.local_set(l_i)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.i32_const(3)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I32_GT_U)
        fb.br_if(self.cg._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(58)
        fb.byte(OP_I32_EQ)

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(47)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(47)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.emit_if()
        fb.local_get(l_i)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop_pos))

        fb.emit_end()
        fb.emit_end()

        fb.i32_const(-1)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$find_scheme_sep"] = idx
        return idx

    def build_net_url_get_scheme(self) -> int:
        sig = self.mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_pos = fb.new_i32()

        fb.local_get(0)
        fb.byte(0x10)
        fb.uleb(self.helpers["$find_scheme_sep"])
        fb.local_set(l_pos)

        fb.local_get(l_pos)
        fb.i32_const(0)
        fb.byte(OP_I32_GE_S)
        fb.emit_if()

        fb.local_get(0)
        fb.i64_const(-4294967296)
        fb.byte(OP_I64_AND)
        fb.local_get(l_pos)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.i64_const(0)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_url_get_scheme"] = idx
        return idx

    def build_net_url_get_host(self) -> int:
        sig = self.mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_pos = fb.new_i32()
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_start = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()

        fb.local_get(0)
        fb.byte(0x10)
        fb.uleb(self.helpers["$find_scheme_sep"])
        fb.local_set(l_pos)

        fb.local_get(l_pos)
        fb.i32_const(0)
        fb.byte(OP_I32_LT_S)
        fb.emit_if()
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.local_get(l_pos)
        fb.i32_const(3)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_start)

        fb.local_get(l_start)
        fb.local_set(l_i)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self.cg._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(47)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(58)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.local_get(l_c)
        fb.i32_const(63)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.local_get(l_c)
        fb.i32_const(35)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.br_if(self.cg._br_depth(fb, exit_pos))

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop_pos))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_ptr)
        fb.local_get(l_start)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_i)
        fb.local_get(l_start)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_url_get_host"] = idx
        return idx

    def build_net_url_get_port(self) -> int:
        sig = self.mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_pos = fb.new_i32()
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_val = fb.new_i64()
        l_found_colon = fb.new_i32()

        fb.local_get(0)
        fb.byte(0x10)
        fb.uleb(self.helpers["$find_scheme_sep"])
        fb.local_set(l_pos)

        fb.local_get(l_pos)
        fb.i32_const(0)
        fb.byte(OP_I32_LT_S)
        fb.emit_if()
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.local_get(l_pos)
        fb.i32_const(3)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)

        fb.i32_const(0)
        fb.local_set(l_found_colon)

        fb.emit_block()
        exit1 = fb.label_depth
        fb.emit_loop()
        loop1 = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self.cg._br_depth(fb, exit1))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(58)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.i32_const(1)
        fb.local_set(l_found_colon)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, exit1))
        fb.emit_end()

        fb.local_get(l_c)
        fb.i32_const(47)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(63)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.local_get(l_c)
        fb.i32_const(35)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.br_if(self.cg._br_depth(fb, exit1))

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop1))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_found_colon)
        fb.byte(OP_I32_EQZ)
        fb.emit_if()
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.i64_const(0)
        fb.local_set(l_val)

        fb.emit_block()
        exit2 = fb.label_depth
        fb.emit_loop()
        loop2 = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self.cg._br_depth(fb, exit2))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_LT_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.br_if(self.cg._br_depth(fb, exit2))

        fb.local_get(l_val)
        fb.i64_const(10)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_val)

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop2))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_val)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_url_get_port"] = idx
        return idx

    def build_net_url_get_path(self) -> int:
        sig = self.mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_pos = fb.new_i32()
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_start = fb.new_i32()

        fb.local_get(0)
        fb.byte(0x10)
        fb.uleb(self.helpers["$find_scheme_sep"])
        fb.local_set(l_pos)

        fb.local_get(l_pos)
        fb.i32_const(3)
        fb.byte(OP_I32_ADD)
        fb.i32_const(0)
        fb.local_get(l_pos)
        fb.i32_const(0)
        fb.byte(OP_I32_GE_S)
        fb.byte(OP_SELECT)
        fb.local_set(l_start)

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.local_get(l_start)
        fb.local_set(l_i)

        fb.emit_block()
        exit1 = fb.label_depth
        fb.emit_loop()
        loop1 = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(47)
        fb.byte(OP_I32_EQ)
        fb.br_if(self.cg._br_depth(fb, exit1))

        fb.local_get(l_c)
        fb.i32_const(63)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(35)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop1))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_i)
        fb.local_set(l_start)

        fb.emit_block()
        exit2 = fb.label_depth
        fb.emit_loop()
        loop2 = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self.cg._br_depth(fb, exit2))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(63)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(35)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.br_if(self.cg._br_depth(fb, exit2))

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop2))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_ptr)
        fb.local_get(l_start)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_i)
        fb.local_get(l_start)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_url_get_path"] = idx
        return idx

    def build_net_url_get_query(self) -> int:
        sig = self.mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_start = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.i32_const(0)
        fb.local_set(l_i)

        fb.emit_block()
        exit1 = fb.label_depth
        fb.emit_loop()
        loop1 = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(63)
        fb.byte(OP_I32_EQ)
        fb.br_if(self.cg._br_depth(fb, exit1))

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop1))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_start)

        fb.local_get(l_start)
        fb.local_set(l_i)

        fb.emit_block()
        exit2 = fb.label_depth
        fb.emit_loop()
        loop2 = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self.cg._br_depth(fb, exit2))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(35)
        fb.byte(OP_I32_EQ)
        fb.br_if(self.cg._br_depth(fb, exit2))

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop2))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_ptr)
        fb.local_get(l_start)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_i)
        fb.local_get(l_start)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_url_get_query"] = idx
        return idx

    def build_net_url_get_fragment(self) -> int:
        sig = self.mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_start = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.i32_const(0)
        fb.local_set(l_i)

        fb.emit_block()
        exit1 = fb.label_depth
        fb.emit_loop()
        loop1 = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(35)
        fb.byte(OP_I32_EQ)
        fb.br_if(self.cg._br_depth(fb, exit1))

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop1))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_start)

        fb.local_get(l_ptr)
        fb.local_get(l_start)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_len)
        fb.local_get(l_start)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_url_get_fragment"] = idx
        return idx

    def build_net_url_is_valid(self) -> int:
        sig = self.mod.add_type([I64], [I32])
        fb = FuncBody(num_params=1)
        l_pos = fb.new_i32()

        fb.local_get(0)
        fb.byte(0x10)
        fb.uleb(self.helpers["$find_scheme_sep"])
        fb.local_set(l_pos)

        fb.local_get(l_pos)
        fb.i32_const(0)
        fb.byte(OP_I32_GT_S)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_url_is_valid"] = idx
        return idx

    def build_strconcat(self) -> int:
        sig = self.mod.add_type([I64, I64], [I64])
        fb = FuncBody(num_params=2)
        l_buf = fb.new_i32()
        l_la = fb.new_i32()
        l_lb = fb.new_i32()

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_la)

        fb.local_get(1)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_lb)

        fb.local_get(l_la)
        fb.local_get(l_lb)
        fb.byte(OP_I32_ADD)
        fb.i32_const(16)
        fb.byte(OP_I32_ADD)
        fb.byte(0x10)
        fb.uleb(self.helpers["$strbuf_new"])
        fb.local_set(l_buf)

        fb.local_get(l_buf)
        fb.local_get(0)
        fb.byte(0x10)
        fb.uleb(self.helpers["$strappend"])

        fb.local_get(l_buf)
        fb.local_get(1)
        fb.byte(0x10)
        fb.uleb(self.helpers["$strappend"])

        fb.local_get(l_buf)
        fb.byte(0x10)
        fb.uleb(self.helpers["$strbuf_done"])

        fb.local_get(l_buf)
        fb.i32_const(4)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_buf)
        fb.byte(OP_I32_LOAD)
        fb.put(encode_memarg(2, 0))
        fb.byte(OP_I64_EXTEND_I32_U)

        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$strconcat"] = idx
        return idx

    def build_net_url_join(self) -> int:
        sig = self.mod.add_type([I64, I64], [I64])
        fb = FuncBody(num_params=2)
        l_pb = fb.new_i32()
        l_lb = fb.new_i32()
        l_pr = fb.new_i32()
        l_lr = fb.new_i32()
        l_b_slash = fb.new_i32()
        l_r_slash = fb.new_i32()

        fb.local_get(0)
        fb.byte(OP_I64_EQZ)
        fb.emit_if()
        fb.local_get(1)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(1)
        fb.byte(OP_I64_EQZ)
        fb.emit_if()
        fb.local_get(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_pb)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_lb)

        fb.local_get(1)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_pr)

        fb.local_get(1)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_lr)

        fb.local_get(l_pb)
        fb.local_get(l_lb)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(47)
        fb.byte(OP_I32_EQ)
        fb.local_set(l_b_slash)

        fb.local_get(l_pr)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(47)
        fb.byte(OP_I32_EQ)
        fb.local_set(l_r_slash)

        fb.local_get(l_b_slash)
        fb.local_get(l_r_slash)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.local_get(l_pr)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_pr)

        fb.local_get(l_lr)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.local_set(l_lr)

        fb.local_get(l_pr)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)
        fb.local_get(l_lr)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        fb.local_set(1)

        fb.local_get(0)
        fb.local_get(1)
        fb.byte(0x10)
        fb.uleb(self.helpers["$strconcat"])
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_b_slash)
        fb.local_get(l_r_slash)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.local_get(0)
        fb.local_get(1)
        fb.byte(0x10)
        fb.uleb(self.helpers["$strconcat"])
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        fb.local_get(1)
        fb.byte(0x10)
        fb.uleb(self.helpers["$path_join"])
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_url_join"] = idx
        return idx

    def build_net_url_encode(self) -> int:
        sig = self.mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_buf = fb.new_i32()
        l_out_ptr = fb.new_i32()
        l_out_len = fb.new_i32()
        l_h1 = fb.new_i32()
        l_h2 = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.local_get(l_len)
        fb.i32_const(3)
        fb.byte(OP_I32_MUL)
        fb.i32_const(16)
        fb.byte(OP_I32_ADD)
        fb.byte(0x10)
        fb.uleb(self.helpers["$strbuf_new"])
        fb.local_set(l_buf)

        fb.local_get(l_buf)
        fb.i32_const(4)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_out_ptr)

        fb.i32_const(0)
        fb.local_set(l_out_len)
        fb.i32_const(0)
        fb.local_set(l_i)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self.cg._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(97)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(122)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)

        fb.local_get(l_c)
        fb.i32_const(65)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(90)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.byte(OP_I32_OR)

        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.byte(OP_I32_OR)

        fb.local_get(l_c)
        fb.i32_const(45)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)

        fb.local_get(l_c)
        fb.i32_const(95)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)

        fb.local_get(l_c)
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)

        fb.local_get(l_c)
        fb.i32_const(126)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)

        fb.emit_if()

        fb.local_get(l_out_ptr)
        fb.local_get(l_out_len)
        fb.byte(OP_I32_ADD)
        fb.local_get(l_c)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))

        fb.local_get(l_out_len)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_out_len)

        fb.emit_else()

        fb.local_get(l_out_ptr)
        fb.local_get(l_out_len)
        fb.byte(OP_I32_ADD)
        fb.i32_const(37)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))

        fb.local_get(l_c)
        fb.i32_const(4)
        fb.byte(OP_I32_SHR_U)
        fb.local_set(l_h1)

        fb.local_get(l_c)
        fb.i32_const(15)
        fb.byte(OP_I32_AND)
        fb.local_set(l_h2)

        fb.local_get(l_out_ptr)
        fb.local_get(l_out_len)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_ADD)

        fb.local_get(l_h1)
        fb.i32_const(48)
        fb.byte(OP_I32_ADD)
        fb.local_get(l_h1)
        fb.i32_const(55)
        fb.byte(OP_I32_ADD)
        fb.local_get(l_h1)
        fb.i32_const(10)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_SELECT)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))

        fb.local_get(l_out_ptr)
        fb.local_get(l_out_len)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_ADD)

        fb.local_get(l_h2)
        fb.i32_const(48)
        fb.byte(OP_I32_ADD)
        fb.local_get(l_h2)
        fb.i32_const(55)
        fb.byte(OP_I32_ADD)
        fb.local_get(l_h2)
        fb.i32_const(10)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_SELECT)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))

        fb.local_get(l_out_len)
        fb.i32_const(3)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_out_len)

        fb.emit_end()

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop_pos))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_buf)
        fb.local_get(l_out_len)
        fb.byte(OP_I32_STORE)
        fb.put(encode_memarg(2, 0))

        fb.local_get(l_buf)
        fb.byte(0x10)
        fb.uleb(self.helpers["$strbuf_done"])

        fb.local_get(l_out_ptr)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_out_len)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_url_encode"] = idx
        return idx

    def build_hex_val(self) -> int:
        sig = self.mod.add_type([I32], [I32])
        fb = FuncBody(num_params=1)

        fb.local_get(0)
        fb.i32_const(48)
        fb.byte(OP_I32_GE_U)
        fb.local_get(0)
        fb.i32_const(57)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.local_get(0)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        fb.i32_const(65)
        fb.byte(OP_I32_GE_U)
        fb.local_get(0)
        fb.i32_const(70)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.local_get(0)
        fb.i32_const(55)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        fb.i32_const(97)
        fb.byte(OP_I32_GE_U)
        fb.local_get(0)
        fb.i32_const(102)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.local_get(0)
        fb.i32_const(87)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.i32_const(-1)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$hex_val"] = idx
        return idx

    def build_net_url_decode(self) -> int:
        sig = self.mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_buf = fb.new_i32()
        l_out_ptr = fb.new_i32()
        l_out_len = fb.new_i32()
        l_h1 = fb.new_i32()
        l_h2 = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.local_get(l_len)
        fb.i32_const(16)
        fb.byte(OP_I32_ADD)
        fb.byte(0x10)
        fb.uleb(self.helpers["$strbuf_new"])
        fb.local_set(l_buf)

        fb.local_get(l_buf)
        fb.i32_const(4)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_out_ptr)

        fb.i32_const(0)
        fb.local_set(l_out_len)
        fb.i32_const(0)
        fb.local_set(l_i)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self.cg._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(37)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_i)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.local_get(l_len)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_I32_AND)
        fb.emit_if()

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.byte(0x10)
        fb.uleb(self.helpers["$hex_val"])
        fb.local_set(l_h1)

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.byte(0x10)
        fb.uleb(self.helpers["$hex_val"])
        fb.local_set(l_h2)

        fb.local_get(l_h1)
        fb.i32_const(0)
        fb.byte(OP_I32_GE_S)
        fb.local_get(l_h2)
        fb.i32_const(0)
        fb.byte(OP_I32_GE_S)
        fb.byte(OP_I32_AND)
        fb.emit_if()

        fb.local_get(l_out_ptr)
        fb.local_get(l_out_len)
        fb.byte(OP_I32_ADD)
        fb.local_get(l_h1)
        fb.i32_const(4)
        fb.byte(OP_I32_SHL)
        fb.local_get(l_h2)
        fb.byte(OP_I32_OR)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))

        fb.local_get(l_out_len)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_out_len)

        fb.local_get(l_i)
        fb.i32_const(3)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop_pos))
        fb.emit_end()

        fb.emit_end()

        fb.local_get(l_out_ptr)
        fb.local_get(l_out_len)
        fb.byte(OP_I32_ADD)
        fb.local_get(l_c)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))

        fb.local_get(l_out_len)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_out_len)

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop_pos))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_buf)
        fb.local_get(l_out_len)
        fb.byte(OP_I32_STORE)
        fb.put(encode_memarg(2, 0))

        fb.local_get(l_buf)
        fb.byte(0x10)
        fb.uleb(self.helpers["$strbuf_done"])

        fb.local_get(l_out_ptr)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_out_len)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_url_decode"] = idx
        return idx

    def build_net_ip_is_v4(self) -> int:
        sig = self.mod.add_type([I64], [I32])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_val = fb.new_i32()
        l_octets = fb.new_i32()
        l_digits = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.local_get(l_len)
        fb.byte(OP_I32_EQZ)
        fb.emit_if()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.i32_const(0)
        fb.local_set(l_octets)
        fb.i32_const(0)
        fb.local_set(l_val)
        fb.i32_const(0)
        fb.local_set(l_digits)
        fb.i32_const(0)
        fb.local_set(l_i)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self.cg._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.emit_if()

        fb.local_get(l_val)
        fb.i32_const(10)
        fb.byte(OP_I32_MUL)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_val)

        fb.local_get(l_digits)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_digits)

        fb.local_get(l_val)
        fb.i32_const(255)
        fb.byte(OP_I32_GT_U)
        fb.local_get(l_digits)
        fb.i32_const(3)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.emit_else()

        fb.local_get(l_c)
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.emit_if()

        fb.local_get(l_digits)
        fb.byte(OP_I32_EQZ)
        fb.emit_if()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_octets)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_octets)
        fb.i32_const(0)
        fb.local_set(l_val)
        fb.i32_const(0)
        fb.local_set(l_digits)

        fb.emit_else()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.emit_end()

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop_pos))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_octets)
        fb.i32_const(3)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_digits)
        fb.i32_const(0)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_AND)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_ip_is_v4"] = idx
        return idx

    def build_net_ip_is_v6(self) -> int:
        sig = self.mod.add_type([I64], [I32])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_colons = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.local_get(l_len)
        fb.i32_const(2)
        fb.byte(OP_I32_LT_U)
        fb.emit_if()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.i32_const(0)
        fb.local_set(l_colons)
        fb.i32_const(0)
        fb.local_set(l_i)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self.cg._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(58)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.local_get(l_colons)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_colons)
        fb.emit_else()

        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)

        fb.local_get(l_c)
        fb.i32_const(97)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(102)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.byte(OP_I32_OR)

        fb.local_get(l_c)
        fb.i32_const(65)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(70)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.byte(OP_I32_OR)

        fb.local_get(l_c)
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)

        fb.byte(OP_I32_EQZ)
        fb.emit_if()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.emit_end()

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self.cg._br_depth(fb, loop_pos))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_colons)
        fb.i32_const(2)
        fb.byte(OP_I32_GE_U)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_ip_is_v6"] = idx
        return idx

    def build_net_ip_is_valid(self) -> int:
        sig = self.mod.add_type([I64], [I32])
        fb = FuncBody(num_params=1)
        fb.local_get(0)
        fb.byte(0x10)
        fb.uleb(self.helpers["$net_ip_is_v4"])
        fb.local_get(0)
        fb.byte(0x10)
        fb.uleb(self.helpers["$net_ip_is_v6"])
        fb.byte(OP_I32_OR)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_ip_is_valid"] = idx
        return idx

    def build_net_ip_is_loopback(self) -> int:
        sig = self.mod.add_type([I64], [I32])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.local_get(l_len)
        fb.i32_const(4)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.local_get(l_ptr)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(49)
        fb.byte(OP_I32_EQ)

        fb.local_get(l_ptr)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(50)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.local_get(l_ptr)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(55)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.local_get(l_ptr)
        fb.i32_const(3)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.emit_if()
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_len)
        fb.i32_const(3)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.local_get(l_ptr)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(58)
        fb.byte(OP_I32_EQ)

        fb.local_get(l_ptr)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(58)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.local_get(l_ptr)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(49)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.emit_if()
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()

        fb.i32_const(0)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_ip_is_loopback"] = idx
        return idx

    def build_net_ip_is_private(self) -> int:
        sig = self.mod.add_type([I64], [I32])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_c0 = fb.new_i32()
        l_c1 = fb.new_i32()
        l_c2 = fb.new_i32()
        l_sec = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.local_get(l_len)
        fb.i32_const(3)
        fb.byte(OP_I32_LT_U)
        fb.emit_if()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_ptr)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c0)

        fb.local_get(l_ptr)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c1)

        fb.local_get(l_ptr)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c2)

        fb.local_get(l_c0)
        fb.i32_const(49)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c1)
        fb.i32_const(48)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)
        fb.local_get(l_c2)
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_len)
        fb.i32_const(8)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.local_get(l_c0)
        fb.i32_const(49)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c1)
        fb.i32_const(57)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)
        fb.local_get(l_c2)
        fb.i32_const(50)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.local_get(l_ptr)
        fb.i32_const(3)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.local_get(l_ptr)
        fb.i32_const(4)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(49)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.local_get(l_ptr)
        fb.i32_const(5)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(54)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.local_get(l_ptr)
        fb.i32_const(6)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(56)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.local_get(l_ptr)
        fb.i32_const(7)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.emit_if()
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_len)
        fb.i32_const(7)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.local_get(l_c0)
        fb.i32_const(49)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c1)
        fb.i32_const(55)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)
        fb.local_get(l_c2)
        fb.i32_const(50)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.local_get(l_ptr)
        fb.i32_const(3)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)

        fb.emit_if()

        fb.local_get(l_ptr)
        fb.i32_const(4)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.i32_const(10)
        fb.byte(OP_I32_MUL)

        fb.local_get(l_ptr)
        fb.i32_const(5)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_sec)

        fb.local_get(l_sec)
        fb.i32_const(16)
        fb.byte(OP_I32_GE_S)
        fb.local_get(l_sec)
        fb.i32_const(31)
        fb.byte(OP_I32_LE_S)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_len)
        fb.i32_const(4)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.local_get(l_c0)
        fb.i32_const(102)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c1)
        fb.i32_const(99)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c1)
        fb.i32_const(100)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()

        fb.i32_const(0)
        fb.byte(OP_RETURN)

        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$net_ip_is_private"] = idx
        return idx
