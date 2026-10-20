from __future__ import annotations

from flux_proto.wasm.binary import (
    FuncBody, I32, I64, F32, F64,
    OP_I32_LOAD, OP_I64_LOAD, OP_I32_STORE, OP_I64_STORE,
    OP_I32_CONST, OP_I64_CONST,
    OP_I32_EQZ, OP_I32_EQ, OP_I32_NE,
    OP_I64_EQ, OP_I64_NE,
    OP_I32_LT_U, OP_I32_GT_U, OP_I32_GE_U,
    OP_I32_ADD, OP_I32_SUB, OP_I32_MUL,
    OP_I32_OR,
    OP_F64_ADD, OP_F64_SUB, OP_F64_MUL, OP_F64_DIV,
    OP_F64_LT, OP_F64_GT, OP_F64_NE,
    OP_F32_ADD, OP_F32_SUB, OP_F32_MUL, OP_F32_DIV,
    OP_F32_NE,
    OP_F32_DEMOTE_F64, OP_F64_PROMOTE_F32,
    OP_I64_REINTERPRET_F64, OP_F64_REINTERPRET_I64,
    OP_I64_EXTEND_I32_U, OP_I32_WRAP_I64,
    OP_RETURN, OP_DROP, OP_SELECT, OP_IF, OP_ELSE, OP_END,
    OP_BR_IF, OP_BR,
    encode_memarg,
)


def _mem(fb: FuncBody, op: int, align: int, off: int = 0) -> None:
    fb.byte(op)
    fb.put(encode_memarg(align, off))


def _call(fb: FuncBody, idx: int) -> None:
    fb.byte(0x10)
    fb.uleb(idx)


def _br_depth(fb: FuncBody, pos: int) -> int:
    return fb.label_depth - pos


class SimdHelpers:
    """Builds SIMD helper functions in WASM binary format."""

    def __init__(self, cg) -> None:
        self.cg = cg
        self.mod = cg._mod
        self.helpers = cg._helper_funcs

    def build_all(self) -> None:
        self.build_simd_extract_double()
        self.build_simd_vector_binop()
        self.build_simd_dot_product()
        self.build_simd_vector_sum()
        self.build_simd_vector_clamp()
        self.build_simd_select()
        self.build_simd_matrix_mul_2d()

    def build_simd_extract_double(self) -> int:
        sig = self.mod.add_type([I32, I32], [F64])
        fb = FuncBody(num_params=2)
        fb.local_get(0)
        fb.local_get(1)
        _call(fb, self.helpers["$list_row_val"])
        fb.byte(OP_F64_REINTERPRET_I64)
        fb.byte(OP_RETURN)
        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$simd_extract_double"] = idx
        return idx

    def build_simd_vector_binop(self) -> int:
        sig = self.mod.add_type([I32, I32, I32, I32], [I32])
        fb = FuncBody(num_params=4)
        l_na = fb.new_i32()
        l_nb = fb.new_i32()
        l_n = fb.new_i32()
        l_out = fb.new_i32()
        l_i = fb.new_i32()
        l_va = fb.new_f64()
        l_vb = fb.new_f64()
        l_res = fb.new_f64()
        l_fa = fb.new_f32()
        l_fb = fb.new_f32()
        l_fres = fb.new_f32()

        # if a == 0 or b == 0: return list_build(0)
        fb.local_get(0)
        fb.byte(OP_I32_EQZ)
        fb.local_get(1)
        fb.byte(OP_I32_EQZ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.i32_const(0)
        _call(fb, self.helpers["$list_build"])
        fb.byte(OP_RETURN)
        fb.emit_end()

        # na = list_len(a); nb = list_len(b)
        fb.local_get(0)
        _call(fb, self.helpers["$list_len"])
        fb.local_set(l_na)
        fb.local_get(1)
        _call(fb, self.helpers["$list_len"])
        fb.local_set(l_nb)

        # n = select(na, nb, na < nb)
        fb.local_get(l_na)
        fb.local_get(l_nb)
        fb.local_get(l_na)
        fb.local_get(l_nb)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_SELECT)
        fb.local_set(l_n)

        # out = list_build(n)
        fb.local_get(l_n)
        _call(fb, self.helpers["$list_build"])
        fb.local_set(l_out)

        # out + 8 = 3 (etag)
        fb.local_get(l_out)
        fb.i32_const(8)
        fb.byte(OP_I32_ADD)
        fb.i32_const(3)
        _mem(fb, OP_I32_STORE, 2, 0)

        # i = 1
        fb.i32_const(1)
        fb.local_set(l_i)

        fb.emit_block()
        done = fb.label_depth
        fb.emit_loop()
        loop = fb.label_depth

        # if i > n: break
        fb.local_get(l_i)
        fb.local_get(l_n)
        fb.byte(OP_I32_GT_U)
        fb.br_if(_br_depth(fb, done))

        # va = simd_extract_double(a, i)
        fb.local_get(0)
        fb.local_get(l_i)
        _call(fb, self.helpers["$simd_extract_double"])
        fb.local_set(l_va)

        # vb = simd_extract_double(b, i)
        fb.local_get(1)
        fb.local_get(l_i)
        _call(fb, self.helpers["$simd_extract_double"])
        fb.local_set(l_vb)

        # if is_f32 (param 3)
        fb.local_get(3)
        fb.emit_if()
        fb.local_get(l_va)
        fb.byte(OP_F32_DEMOTE_F64)
        fb.local_set(l_fa)
        fb.local_get(l_vb)
        fb.byte(OP_F32_DEMOTE_F64)
        fb.local_set(l_fb)

        # if op == 0 (add)
        fb.local_get(2)
        fb.i32_const(0)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.local_get(l_fa)
        fb.local_get(l_fb)
        fb.byte(OP_F32_ADD)
        fb.local_set(l_fres)
        fb.emit_end()

        # if op == 1 (sub)
        fb.local_get(2)
        fb.i32_const(1)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.local_get(l_fa)
        fb.local_get(l_fb)
        fb.byte(OP_F32_SUB)
        fb.local_set(l_fres)
        fb.emit_end()

        # if op == 2 (mul)
        fb.local_get(2)
        fb.i32_const(2)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.local_get(l_fa)
        fb.local_get(l_fb)
        fb.byte(OP_F32_MUL)
        fb.local_set(l_fres)
        fb.emit_end()

        # if op == 3 (div)
        fb.local_get(2)
        fb.i32_const(3)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.local_get(l_fa)
        fb.local_get(l_fb)
        fb.byte(OP_F32_DIV)
        fb.f32_const(0.0)
        fb.local_get(l_fb)
        fb.f32_const(0.0)
        fb.byte(OP_F32_NE)
        fb.byte(OP_SELECT)
        fb.local_set(l_fres)
        fb.emit_end()

        fb.local_get(l_fres)
        fb.byte(OP_F64_PROMOTE_F32)
        fb.local_set(l_res)

        fb.emit_else()  # f64 branch

        # if op == 0 (add)
        fb.local_get(2)
        fb.i32_const(0)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.local_get(l_va)
        fb.local_get(l_vb)
        fb.byte(OP_F64_ADD)
        fb.local_set(l_res)
        fb.emit_end()

        # if op == 1 (sub)
        fb.local_get(2)
        fb.i32_const(1)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.local_get(l_va)
        fb.local_get(l_vb)
        fb.byte(OP_F64_SUB)
        fb.local_set(l_res)
        fb.emit_end()

        # if op == 2 (mul)
        fb.local_get(2)
        fb.i32_const(2)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.local_get(l_va)
        fb.local_get(l_vb)
        fb.byte(OP_F64_MUL)
        fb.local_set(l_res)
        fb.emit_end()

        # if op == 3 (div)
        fb.local_get(2)
        fb.i32_const(3)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.local_get(l_va)
        fb.local_get(l_vb)
        fb.byte(OP_F64_DIV)
        fb.f64_const(0.0)
        fb.local_get(l_vb)
        fb.f64_const(0.0)
        fb.byte(OP_F64_NE)
        fb.byte(OP_SELECT)
        fb.local_set(l_res)
        fb.emit_end()

        fb.emit_end()  # end if is_f32

        # list_set_row(out, i, 3, reinterpret(res))
        fb.local_get(l_out)
        fb.local_get(l_i)
        fb.i32_const(3)
        fb.local_get(l_res)
        fb.byte(OP_I64_REINTERPRET_F64)
        _call(fb, self.helpers["$list_set_row"])

        # i += 1
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(_br_depth(fb, loop))

        fb.emit_end()  # loop
        fb.emit_end()  # block

        fb.local_get(l_out)
        fb.byte(OP_RETURN)
        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$simd_vector_binop"] = idx
        return idx

    def build_simd_dot_product(self) -> int:
        sig = self.mod.add_type([I32, I32, I32], [F64])
        fb = FuncBody(num_params=3)
        l_na = fb.new_i32()
        l_nb = fb.new_i32()
        l_n = fb.new_i32()
        l_i = fb.new_i32()
        l_va = fb.new_f64()
        l_vb = fb.new_f64()
        l_sum = fb.new_f64()

        # if a == 0 or b == 0: return 0.0
        fb.local_get(0)
        fb.byte(OP_I32_EQZ)
        fb.local_get(1)
        fb.byte(OP_I32_EQZ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.f64_const(0.0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        _call(fb, self.helpers["$list_len"])
        fb.local_set(l_na)
        fb.local_get(1)
        _call(fb, self.helpers["$list_len"])
        fb.local_set(l_nb)

        fb.local_get(l_na)
        fb.local_get(l_nb)
        fb.local_get(l_na)
        fb.local_get(l_nb)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_SELECT)
        fb.local_set(l_n)

        fb.i32_const(1)
        fb.local_set(l_i)
        fb.f64_const(0.0)
        fb.local_set(l_sum)

        fb.emit_block()
        done = fb.label_depth
        fb.emit_loop()
        loop = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_n)
        fb.byte(OP_I32_GT_U)
        fb.br_if(_br_depth(fb, done))

        fb.local_get(0)
        fb.local_get(l_i)
        _call(fb, self.helpers["$simd_extract_double"])
        fb.local_set(l_va)

        fb.local_get(1)
        fb.local_get(l_i)
        _call(fb, self.helpers["$simd_extract_double"])
        fb.local_set(l_vb)

        fb.local_get(l_sum)
        fb.local_get(l_va)
        fb.local_get(l_vb)
        fb.byte(OP_F64_MUL)
        fb.byte(OP_F64_ADD)
        fb.local_set(l_sum)

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(_br_depth(fb, loop))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(2)
        fb.emit_if()
        fb.local_get(l_sum)
        fb.byte(OP_F32_DEMOTE_F64)
        fb.byte(OP_F64_PROMOTE_F32)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_sum)
        fb.byte(OP_RETURN)
        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$simd_dot_product"] = idx
        return idx

    def build_simd_vector_sum(self) -> int:
        sig = self.mod.add_type([I32, I32], [F64])
        fb = FuncBody(num_params=2)
        l_n = fb.new_i32()
        l_i = fb.new_i32()
        l_sum = fb.new_f64()

        fb.local_get(0)
        fb.byte(OP_I32_EQZ)
        fb.emit_if()
        fb.f64_const(0.0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        _call(fb, self.helpers["$list_len"])
        fb.local_set(l_n)

        fb.i32_const(1)
        fb.local_set(l_i)
        fb.f64_const(0.0)
        fb.local_set(l_sum)

        fb.emit_block()
        done = fb.label_depth
        fb.emit_loop()
        loop = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_n)
        fb.byte(OP_I32_GT_U)
        fb.br_if(_br_depth(fb, done))

        fb.local_get(l_sum)
        fb.local_get(0)
        fb.local_get(l_i)
        _call(fb, self.helpers["$simd_extract_double"])
        fb.byte(OP_F64_ADD)
        fb.local_set(l_sum)

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(_br_depth(fb, loop))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(1)
        fb.emit_if()
        fb.local_get(l_sum)
        fb.byte(OP_F32_DEMOTE_F64)
        fb.byte(OP_F64_PROMOTE_F32)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(l_sum)
        fb.byte(OP_RETURN)
        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$simd_vector_sum"] = idx
        return idx

    def build_simd_vector_clamp(self) -> int:
        sig = self.mod.add_type([I32, F64, F64, I32], [I32])
        fb = FuncBody(num_params=4)
        l_n = fb.new_i32()
        l_out = fb.new_i32()
        l_i = fb.new_i32()
        l_v = fb.new_f64()

        fb.local_get(0)
        fb.byte(OP_I32_EQZ)
        fb.emit_if()
        fb.i32_const(0)
        _call(fb, self.helpers["$list_build"])
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        _call(fb, self.helpers["$list_len"])
        fb.local_set(l_n)

        fb.local_get(l_n)
        _call(fb, self.helpers["$list_build"])
        fb.local_set(l_out)

        fb.local_get(l_out)
        fb.i32_const(8)
        fb.byte(OP_I32_ADD)
        fb.i32_const(3)
        _mem(fb, OP_I32_STORE, 2, 0)

        fb.i32_const(1)
        fb.local_set(l_i)

        fb.emit_block()
        done = fb.label_depth
        fb.emit_loop()
        loop = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_n)
        fb.byte(OP_I32_GT_U)
        fb.br_if(_br_depth(fb, done))

        fb.local_get(0)
        fb.local_get(l_i)
        _call(fb, self.helpers["$simd_extract_double"])
        fb.local_set(l_v)

        fb.local_get(l_v)
        fb.local_get(1)
        fb.byte(OP_F64_LT)
        fb.emit_if()
        fb.local_get(1)
        fb.local_set(l_v)
        fb.emit_end()

        fb.local_get(l_v)
        fb.local_get(2)
        fb.byte(OP_F64_GT)
        fb.emit_if()
        fb.local_get(2)
        fb.local_set(l_v)
        fb.emit_end()

        fb.local_get(3)
        fb.emit_if()
        fb.local_get(l_v)
        fb.byte(OP_F32_DEMOTE_F64)
        fb.byte(OP_F64_PROMOTE_F32)
        fb.local_set(l_v)
        fb.emit_end()

        fb.local_get(l_out)
        fb.local_get(l_i)
        fb.i32_const(3)
        fb.local_get(l_v)
        fb.byte(OP_I64_REINTERPRET_F64)
        _call(fb, self.helpers["$list_set_row"])

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(_br_depth(fb, loop))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_out)
        fb.byte(OP_RETURN)
        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$simd_vector_clamp"] = idx
        return idx

    def build_simd_select(self) -> int:
        sig = self.mod.add_type([I32, I32, I32, I32], [I32])
        fb = FuncBody(num_params=4)
        l_nm = fb.new_i32()
        l_na = fb.new_i32()
        l_nb = fb.new_i32()
        l_n = fb.new_i32()
        l_out = fb.new_i32()
        l_i = fb.new_i32()
        l_m = fb.new_i64()
        l_v = fb.new_f64()

        fb.local_get(0)
        fb.byte(OP_I32_EQZ)
        fb.local_get(1)
        fb.byte(OP_I32_EQZ)
        fb.byte(OP_I32_OR)
        fb.local_get(2)
        fb.byte(OP_I32_EQZ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.i32_const(0)
        _call(fb, self.helpers["$list_build"])
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        _call(fb, self.helpers["$list_len"])
        fb.local_set(l_nm)
        fb.local_get(1)
        _call(fb, self.helpers["$list_len"])
        fb.local_set(l_na)
        fb.local_get(2)
        _call(fb, self.helpers["$list_len"])
        fb.local_set(l_nb)

        fb.local_get(l_nm)
        fb.local_get(l_na)
        fb.local_get(l_nm)
        fb.local_get(l_na)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_SELECT)
        fb.local_set(l_n)

        fb.local_get(l_nb)
        fb.local_get(l_n)
        fb.byte(OP_I32_LT_U)
        fb.emit_if()
        fb.local_get(l_nb)
        fb.local_set(l_n)
        fb.emit_end()

        fb.local_get(l_n)
        _call(fb, self.helpers["$list_build"])
        fb.local_set(l_out)

        fb.local_get(l_out)
        fb.i32_const(8)
        fb.byte(OP_I32_ADD)
        fb.i32_const(3)
        _mem(fb, OP_I32_STORE, 2, 0)

        fb.i32_const(1)
        fb.local_set(l_i)

        fb.emit_block()
        done = fb.label_depth
        fb.emit_loop()
        loop = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_n)
        fb.byte(OP_I32_GT_U)
        fb.br_if(_br_depth(fb, done))

        fb.local_get(0)
        fb.local_get(l_i)
        _call(fb, self.helpers["$list_row_val"])
        fb.local_set(l_m)

        fb.local_get(l_m)
        fb.i64_const(0)
        fb.byte(OP_I64_NE)
        fb.emit_if()
        fb.local_get(1)
        fb.local_get(l_i)
        _call(fb, self.helpers["$simd_extract_double"])
        fb.local_set(l_v)
        fb.emit_else()
        fb.local_get(2)
        fb.local_get(l_i)
        _call(fb, self.helpers["$simd_extract_double"])
        fb.local_set(l_v)
        fb.emit_end()

        fb.local_get(3)
        fb.emit_if()
        fb.local_get(l_v)
        fb.byte(OP_F32_DEMOTE_F64)
        fb.byte(OP_F64_PROMOTE_F32)
        fb.local_set(l_v)
        fb.emit_end()

        fb.local_get(l_out)
        fb.local_get(l_i)
        fb.i32_const(3)
        fb.local_get(l_v)
        fb.byte(OP_I64_REINTERPRET_F64)
        _call(fb, self.helpers["$list_set_row"])

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(_br_depth(fb, loop))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_out)
        fb.byte(OP_RETURN)
        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$simd_select"] = idx
        return idx

    def build_simd_matrix_mul_2d(self) -> int:
        sig = self.mod.add_type([I32, I32, I32, I64, I64, I64, I64, I64], [I32])
        fb = FuncBody(num_params=8)
        l_shape_l = fb.new_i32()
        l_shape_r = fb.new_i32()
        l_data_l = fb.new_i32()
        l_data_r = fb.new_i32()
        l_rows_l = fb.new_i32()
        l_cols_l = fb.new_i32()
        l_rows_r = fb.new_i32()
        l_cols_r = fb.new_i32()
        l_total = fb.new_i32()
        l_out_data = fb.new_i32()
        l_out_shape = fb.new_i32()
        l_out_strides = fb.new_i32()
        l_out_map = fb.new_i32()
        l_i = fb.new_i32()
        l_j = fb.new_i32()
        l_k = fb.new_i32()
        l_sum = fb.new_f64()
        l_vl = fb.new_f64()
        l_vr = fb.new_f64()
        l_idx_l = fb.new_i32()
        l_idx_r = fb.new_i32()
        l_idx_out = fb.new_i32()

        fb.local_get(0)
        fb.byte(OP_I32_EQZ)
        fb.local_get(1)
        fb.byte(OP_I32_EQZ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.i32_const(0)
        _call(fb, self.helpers["$map_build"])
        fb.byte(OP_RETURN)
        fb.emit_end()

        # shape_l = wrap(map_get(lhs, k_shape))
        fb.local_get(0)
        fb.local_get(4)
        _call(fb, self.helpers["$map_get"])
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_shape_l)

        # shape_r = wrap(map_get(rhs, k_shape))
        fb.local_get(1)
        fb.local_get(4)
        _call(fb, self.helpers["$map_get"])
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_shape_r)

        # data_l = wrap(map_get(lhs, k_data))
        fb.local_get(0)
        fb.local_get(7)
        _call(fb, self.helpers["$map_get"])
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_data_l)

        # data_r = wrap(map_get(rhs, k_data))
        fb.local_get(1)
        fb.local_get(7)
        _call(fb, self.helpers["$map_get"])
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_data_r)

        # rows_l = 1; cols_l = 1
        fb.i32_const(1)
        fb.local_set(l_rows_l)
        fb.i32_const(1)
        fb.local_set(l_cols_l)
        fb.local_get(l_shape_l)
        fb.emit_if()
        fb.local_get(l_shape_l)
        _call(fb, self.helpers["$list_len"])
        fb.i32_const(1)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.local_get(l_shape_l)
        fb.i32_const(1)
        _call(fb, self.helpers["$list_row_val"])
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_rows_l)
        fb.emit_end()
        fb.local_get(l_shape_l)
        _call(fb, self.helpers["$list_len"])
        fb.i32_const(2)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.local_get(l_shape_l)
        fb.i32_const(2)
        _call(fb, self.helpers["$list_row_val"])
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_cols_l)
        fb.emit_end()
        fb.emit_end()

        # rows_r = 1; cols_r = 1
        fb.i32_const(1)
        fb.local_set(l_rows_r)
        fb.i32_const(1)
        fb.local_set(l_cols_r)
        fb.local_get(l_shape_r)
        fb.emit_if()
        fb.local_get(l_shape_r)
        _call(fb, self.helpers["$list_len"])
        fb.i32_const(1)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.local_get(l_shape_r)
        fb.i32_const(1)
        _call(fb, self.helpers["$list_row_val"])
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_rows_r)
        fb.emit_end()
        fb.local_get(l_shape_r)
        _call(fb, self.helpers["$list_len"])
        fb.i32_const(2)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.local_get(l_shape_r)
        fb.i32_const(2)
        _call(fb, self.helpers["$list_row_val"])
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_cols_r)
        fb.emit_end()
        fb.emit_end()

        # total = rows_l * cols_r
        fb.local_get(l_rows_l)
        fb.local_get(l_cols_r)
        fb.byte(OP_I32_MUL)
        fb.local_set(l_total)

        fb.local_get(l_total)
        _call(fb, self.helpers["$list_build"])
        fb.local_set(l_out_data)

        fb.local_get(l_out_data)
        fb.i32_const(8)
        fb.byte(OP_I32_ADD)
        fb.i32_const(3)
        _mem(fb, OP_I32_STORE, 2, 0)

        # i loop (0 .. rows_l)
        fb.i32_const(0)
        fb.local_set(l_i)
        fb.emit_block()
        done_i = fb.label_depth
        fb.emit_loop()
        loop_i = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_rows_l)
        fb.byte(OP_I32_GE_U)
        fb.br_if(_br_depth(fb, done_i))

        # j loop (0 .. cols_r)
        fb.i32_const(0)
        fb.local_set(l_j)
        fb.emit_block()
        done_j = fb.label_depth
        fb.emit_loop()
        loop_j = fb.label_depth

        fb.local_get(l_j)
        fb.local_get(l_cols_r)
        fb.byte(OP_I32_GE_U)
        fb.br_if(_br_depth(fb, done_j))

        fb.f64_const(0.0)
        fb.local_set(l_sum)

        # k loop (0 .. cols_l)
        fb.i32_const(0)
        fb.local_set(l_k)
        fb.emit_block()
        done_k = fb.label_depth
        fb.emit_loop()
        loop_k = fb.label_depth

        fb.local_get(l_k)
        fb.local_get(l_cols_l)
        fb.byte(OP_I32_GE_U)
        fb.br_if(_br_depth(fb, done_k))

        # idx_l = i * cols_l + k + 1
        fb.local_get(l_i)
        fb.local_get(l_cols_l)
        fb.byte(OP_I32_MUL)
        fb.local_get(l_k)
        fb.byte(OP_I32_ADD)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_idx_l)

        # idx_r = k * cols_r + j + 1
        fb.local_get(l_k)
        fb.local_get(l_cols_r)
        fb.byte(OP_I32_MUL)
        fb.local_get(l_j)
        fb.byte(OP_I32_ADD)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_idx_r)

        fb.local_get(l_data_l)
        fb.local_get(l_idx_l)
        _call(fb, self.helpers["$simd_extract_double"])
        fb.local_set(l_vl)

        fb.local_get(l_data_r)
        fb.local_get(l_idx_r)
        _call(fb, self.helpers["$simd_extract_double"])
        fb.local_set(l_vr)

        fb.local_get(l_sum)
        fb.local_get(l_vl)
        fb.local_get(l_vr)
        fb.byte(OP_F64_MUL)
        fb.byte(OP_F64_ADD)
        fb.local_set(l_sum)

        fb.local_get(l_k)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_k)
        fb.br(_br_depth(fb, loop_k))

        fb.emit_end()  # loop k
        fb.emit_end()  # block k

        fb.local_get(2)
        fb.emit_if()
        fb.local_get(l_sum)
        fb.byte(OP_F32_DEMOTE_F64)
        fb.byte(OP_F64_PROMOTE_F32)
        fb.local_set(l_sum)
        fb.emit_end()

        # idx_out = i * cols_r + j + 1
        fb.local_get(l_i)
        fb.local_get(l_cols_r)
        fb.byte(OP_I32_MUL)
        fb.local_get(l_j)
        fb.byte(OP_I32_ADD)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_idx_out)

        fb.local_get(l_out_data)
        fb.local_get(l_idx_out)
        fb.i32_const(3)
        fb.local_get(l_sum)
        fb.byte(OP_I64_REINTERPRET_F64)
        _call(fb, self.helpers["$list_set_row"])

        fb.local_get(l_j)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_j)
        fb.br(_br_depth(fb, loop_j))

        fb.emit_end()  # loop j
        fb.emit_end()  # block j

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(_br_depth(fb, loop_i))

        fb.emit_end()  # loop i
        fb.emit_end()  # block i

        # out_shape = list_build(2)
        fb.i32_const(2)
        _call(fb, self.helpers["$list_build"])
        fb.local_set(l_out_shape)
        fb.local_get(l_out_shape)
        fb.i32_const(1)
        fb.i32_const(0)
        fb.local_get(l_rows_l)
        fb.byte(OP_I64_EXTEND_I32_U)
        _call(fb, self.helpers["$list_set_row"])
        fb.local_get(l_out_shape)
        fb.i32_const(2)
        fb.i32_const(0)
        fb.local_get(l_cols_r)
        fb.byte(OP_I64_EXTEND_I32_U)
        _call(fb, self.helpers["$list_set_row"])

        # out_strides = list_build(2)
        fb.i32_const(2)
        _call(fb, self.helpers["$list_build"])
        fb.local_set(l_out_strides)
        fb.local_get(l_out_strides)
        fb.i32_const(1)
        fb.i32_const(0)
        fb.local_get(l_cols_r)
        fb.byte(OP_I64_EXTEND_I32_U)
        _call(fb, self.helpers["$list_set_row"])
        fb.local_get(l_out_strides)
        fb.i32_const(2)
        fb.i32_const(0)
        fb.i64_const(1)
        _call(fb, self.helpers["$list_set_row"])

        # out_map = map_build(0)
        fb.i32_const(0)
        _call(fb, self.helpers["$map_build"])
        fb.local_set(l_out_map)

        # map_set(out_map, k_ndim, 0, 2)
        fb.local_get(l_out_map)
        fb.local_get(3)
        fb.i32_const(0)
        fb.i64_const(2)
        _call(fb, self.helpers["$map_set"])
        fb.byte(OP_DROP)

        # map_set(out_map, k_shape, 5, extend(out_shape))
        fb.local_get(l_out_map)
        fb.local_get(4)
        fb.i32_const(5)
        fb.local_get(l_out_shape)
        fb.byte(OP_I64_EXTEND_I32_U)
        _call(fb, self.helpers["$map_set"])
        fb.byte(OP_DROP)

        # map_set(out_map, k_strides, 5, extend(out_strides))
        fb.local_get(l_out_map)
        fb.local_get(5)
        fb.i32_const(5)
        fb.local_get(l_out_strides)
        fb.byte(OP_I64_EXTEND_I32_U)
        _call(fb, self.helpers["$map_set"])
        fb.byte(OP_DROP)

        # map_set(out_map, k_offset, 0, 1)
        fb.local_get(l_out_map)
        fb.local_get(6)
        fb.i32_const(0)
        fb.i64_const(1)
        _call(fb, self.helpers["$map_set"])
        fb.byte(OP_DROP)

        # map_set(out_map, k_data, 5, extend(out_data))
        fb.local_get(l_out_map)
        fb.local_get(7)
        fb.i32_const(5)
        fb.local_get(l_out_data)
        fb.byte(OP_I64_EXTEND_I32_U)
        _call(fb, self.helpers["$map_set"])
        fb.byte(OP_DROP)

        fb.local_get(l_out_map)
        fb.byte(OP_RETURN)
        idx = self.mod.add_function(sig)
        self.mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self.helpers["$simd_matrix_mul_2d"] = idx
        return idx
