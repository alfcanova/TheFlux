from __future__ import annotations

import struct
from typing import Any

try:
    import numpy as np
    _HAS_NUMPY = True
except ImportError:
    np = None
    _HAS_NUMPY = False


def _to_num(val: Any) -> float:
    if hasattr(val, "data"):
        val = val.data
    try:
        return float(val)
    except Exception:
        return 0.0


def _to_bool(val: Any) -> bool:
    if hasattr(val, "data"):
        val = val.data
    return bool(val)


def _to_float32(val: float) -> float:
    return struct.unpack("f", struct.pack("f", float(val)))[0]


def _unwrap_list(lst: Any) -> list[Any]:
    if hasattr(lst, "data") and isinstance(lst.data, list):
        return lst.data
    if isinstance(lst, list):
        return lst
    return []


def _unwrap_map(m: Any) -> dict[str, Any]:
    if hasattr(m, "data") and isinstance(m.data, dict):
        return m.data
    if isinstance(m, dict):
        return m
    return {}


# -----------------------------------------------------------------------------
# Vetores F32
# -----------------------------------------------------------------------------

def simd_vector_add_f32(a: Any, b: Any) -> list[float]:
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(la), len(lb))
    if _HAS_NUMPY and n > 0:
        arr_a = np.array([_to_num(x) for x in la[:n]], dtype=np.float32)
        arr_b = np.array([_to_num(x) for x in lb[:n]], dtype=np.float32)
        return [float(x) for x in np.add(arr_a, arr_b)]
    return [_to_float32(_to_num(la[i]) + _to_num(lb[i])) for i in range(n)]


def simd_vector_sub_f32(a: Any, b: Any) -> list[float]:
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(la), len(lb))
    if _HAS_NUMPY and n > 0:
        arr_a = np.array([_to_num(x) for x in la[:n]], dtype=np.float32)
        arr_b = np.array([_to_num(x) for x in lb[:n]], dtype=np.float32)
        return [float(x) for x in np.subtract(arr_a, arr_b)]
    return [_to_float32(_to_num(la[i]) - _to_num(lb[i])) for i in range(n)]


def simd_vector_mul_f32(a: Any, b: Any) -> list[float]:
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(la), len(lb))
    if _HAS_NUMPY and n > 0:
        arr_a = np.array([_to_num(x) for x in la[:n]], dtype=np.float32)
        arr_b = np.array([_to_num(x) for x in lb[:n]], dtype=np.float32)
        return [float(x) for x in np.multiply(arr_a, arr_b)]
    return [_to_float32(_to_num(la[i]) * _to_num(lb[i])) for i in range(n)]


def simd_vector_div_f32(a: Any, b: Any) -> list[float]:
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(la), len(lb))
    out: list[float] = []
    for i in range(n):
        den = _to_num(lb[i])
        out.append(_to_float32(_to_num(la[i]) / den) if den != 0.0 else 0.0)
    return out


# -----------------------------------------------------------------------------
# Vetores F64
# -----------------------------------------------------------------------------

def simd_vector_add_f64(a: Any, b: Any) -> list[float]:
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(la), len(lb))
    if _HAS_NUMPY and n > 0:
        arr_a = np.array([_to_num(x) for x in la[:n]], dtype=np.float64)
        arr_b = np.array([_to_num(x) for x in lb[:n]], dtype=np.float64)
        return [float(x) for x in np.add(arr_a, arr_b)]
    return [float(_to_num(la[i]) + _to_num(lb[i])) for i in range(n)]


def simd_vector_sub_f64(a: Any, b: Any) -> list[float]:
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(la), len(lb))
    if _HAS_NUMPY and n > 0:
        arr_a = np.array([_to_num(x) for x in la[:n]], dtype=np.float64)
        arr_b = np.array([_to_num(x) for x in lb[:n]], dtype=np.float64)
        return [float(x) for x in np.subtract(arr_a, arr_b)]
    return [float(_to_num(la[i]) - _to_num(lb[i])) for i in range(n)]


def simd_vector_mul_f64(a: Any, b: Any) -> list[float]:
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(la), len(lb))
    if _HAS_NUMPY and n > 0:
        arr_a = np.array([_to_num(x) for x in la[:n]], dtype=np.float64)
        arr_b = np.array([_to_num(x) for x in lb[:n]], dtype=np.float64)
        return [float(x) for x in np.multiply(arr_a, arr_b)]
    return [float(_to_num(la[i]) * _to_num(lb[i])) for i in range(n)]


def simd_vector_div_f64(a: Any, b: Any) -> list[float]:
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(la), len(lb))
    out: list[float] = []
    for i in range(n):
        den = _to_num(lb[i])
        out.append(float(_to_num(la[i]) / den) if den != 0.0 else 0.0)
    return out


# -----------------------------------------------------------------------------
# Reduções e Produto Escalar
# -----------------------------------------------------------------------------

def simd_dot_product_f32(a: Any, b: Any) -> float:
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(la), len(lb))
    if _HAS_NUMPY and n > 0:
        arr_a = np.array([_to_num(x) for x in la[:n]], dtype=np.float32)
        arr_b = np.array([_to_num(x) for x in lb[:n]], dtype=np.float32)
        return float(np.dot(arr_a, arr_b))
    total = 0.0
    for i in range(n):
        total += _to_num(la[i]) * _to_num(lb[i])
    return _to_float32(total)


def simd_dot_product_f64(a: Any, b: Any) -> float:
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(la), len(lb))
    if _HAS_NUMPY and n > 0:
        arr_a = np.array([_to_num(x) for x in la[:n]], dtype=np.float64)
        arr_b = np.array([_to_num(x) for x in lb[:n]], dtype=np.float64)
        return float(np.dot(arr_a, arr_b))
    total = 0.0
    for i in range(n):
        total += _to_num(la[i]) * _to_num(lb[i])
    return float(total)


def simd_vector_sum_f32(a: Any) -> float:
    la = _unwrap_list(a)
    if _HAS_NUMPY and len(la) > 0:
        arr = np.array([_to_num(x) for x in la], dtype=np.float32)
        return float(np.sum(arr))
    return _to_float32(sum(_to_num(x) for x in la))


def simd_vector_sum_f64(a: Any) -> float:
    la = _unwrap_list(a)
    if _HAS_NUMPY and len(la) > 0:
        arr = np.array([_to_num(x) for x in la], dtype=np.float64)
        return float(np.sum(arr))
    return float(sum(_to_num(x) for x in la))


# -----------------------------------------------------------------------------
# Matrizes 2D
# -----------------------------------------------------------------------------

def simd_matrix_mul_2d_f32(lhs: Any, rhs: Any) -> dict[str, Any]:
    ml = _unwrap_map(lhs)
    mr = _unwrap_map(rhs)

    shape_l = _unwrap_list(ml.get("shape", [1, 1]))
    shape_r = _unwrap_list(mr.get("shape", [1, 1]))
    rows_l = int(_to_num(shape_l[0])) if len(shape_l) > 0 else 1
    cols_l = int(_to_num(shape_l[1])) if len(shape_l) > 1 else 1
    rows_r = int(_to_num(shape_r[0])) if len(shape_r) > 0 else 1
    cols_r = int(_to_num(shape_r[1])) if len(shape_r) > 1 else 1

    data_l = [_to_num(x) for x in _unwrap_list(ml.get("data", []))]
    data_r = [_to_num(x) for x in _unwrap_list(mr.get("data", []))]

    if _HAS_NUMPY and rows_l > 0 and cols_l > 0 and cols_r > 0 and len(data_l) >= rows_l * cols_l and len(data_r) >= rows_r * cols_r:
        arr_l = np.array(data_l[:rows_l * cols_l], dtype=np.float32).reshape((rows_l, cols_l))
        arr_r = np.array(data_r[:rows_r * cols_r], dtype=np.float32).reshape((rows_r, cols_r))
        res_mat = np.matmul(arr_l, arr_r)
        flat_res = [float(x) for x in res_mat.flatten()]
    else:
        flat_res = []
        for i in range(rows_l):
            for j in range(cols_r):
                val = 0.0
                for k in range(cols_l):
                    idx_l = i * cols_l + k
                    idx_r = k * cols_r + j
                    vl = data_l[idx_l] if idx_l < len(data_l) else 0.0
                    vr = data_r[idx_r] if idx_r < len(data_r) else 0.0
                    val += vl * vr
                flat_res.append(_to_float32(val))

    return {
        "ndim": 2,
        "shape": [rows_l, cols_r],
        "strides": [cols_r, 1],
        "offset": 1,
        "data": flat_res,
    }


def simd_matrix_mul_2d_f64(lhs: Any, rhs: Any) -> dict[str, Any]:
    ml = _unwrap_map(lhs)
    mr = _unwrap_map(rhs)

    shape_l = _unwrap_list(ml.get("shape", [1, 1]))
    shape_r = _unwrap_list(mr.get("shape", [1, 1]))
    rows_l = int(_to_num(shape_l[0])) if len(shape_l) > 0 else 1
    cols_l = int(_to_num(shape_l[1])) if len(shape_l) > 1 else 1
    rows_r = int(_to_num(shape_r[0])) if len(shape_r) > 0 else 1
    cols_r = int(_to_num(shape_r[1])) if len(shape_r) > 1 else 1

    data_l = [_to_num(x) for x in _unwrap_list(ml.get("data", []))]
    data_r = [_to_num(x) for x in _unwrap_list(mr.get("data", []))]

    if _HAS_NUMPY and rows_l > 0 and cols_l > 0 and cols_r > 0 and len(data_l) >= rows_l * cols_l and len(data_r) >= rows_r * cols_r:
        arr_l = np.array(data_l[:rows_l * cols_l], dtype=np.float64).reshape((rows_l, cols_l))
        arr_r = np.array(data_r[:rows_r * cols_r], dtype=np.float64).reshape((rows_r, cols_r))
        res_mat = np.matmul(arr_l, arr_r)
        flat_res = [float(x) for x in res_mat.flatten()]
    else:
        flat_res = []
        for i in range(rows_l):
            for j in range(cols_r):
                val = 0.0
                for k in range(cols_l):
                    idx_l = i * cols_l + k
                    idx_r = k * cols_r + j
                    vl = data_l[idx_l] if idx_l < len(data_l) else 0.0
                    vr = data_r[idx_r] if idx_r < len(data_r) else 0.0
                    val += vl * vr
                flat_res.append(float(val))

    return {
        "ndim": 2,
        "shape": [rows_l, cols_r],
        "strides": [cols_r, 1],
        "offset": 1,
        "data": flat_res,
    }


# -----------------------------------------------------------------------------
# Clamp e Masking (Select)
# -----------------------------------------------------------------------------

def simd_vector_clamp_f32(a: Any, min_v: Any, max_v: Any) -> list[float]:
    la = _unwrap_list(a)
    lo = _to_num(min_v)
    hi = _to_num(max_v)
    if _HAS_NUMPY and len(la) > 0:
        arr = np.array([_to_num(x) for x in la], dtype=np.float32)
        return [float(x) for x in np.clip(arr, lo, hi)]
    return [_to_float32(max(lo, min(hi, _to_num(x)))) for x in la]


def simd_vector_clamp_f64(a: Any, min_v: Any, max_v: Any) -> list[float]:
    la = _unwrap_list(a)
    lo = _to_num(min_v)
    hi = _to_num(max_v)
    if _HAS_NUMPY and len(la) > 0:
        arr = np.array([_to_num(x) for x in la], dtype=np.float64)
        return [float(x) for x in np.clip(arr, lo, hi)]
    return [float(max(lo, min(hi, _to_num(x)))) for x in la]


def simd_select_f32(mask: Any, a: Any, b: Any) -> list[float]:
    lmask = _unwrap_list(mask)
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(lmask), len(la), len(lb))
    out: list[float] = []
    for i in range(n):
        cond = _to_bool(lmask[i])
        val = _to_num(la[i]) if cond else _to_num(lb[i])
        out.append(_to_float32(val))
    return out


def simd_select_f64(mask: Any, a: Any, b: Any) -> list[float]:
    lmask = _unwrap_list(mask)
    la = _unwrap_list(a)
    lb = _unwrap_list(b)
    n = min(len(lmask), len(la), len(lb))
    out: list[float] = []
    for i in range(n):
        cond = _to_bool(lmask[i])
        val = _to_num(la[i]) if cond else _to_num(lb[i])
        out.append(float(val))
    return out
