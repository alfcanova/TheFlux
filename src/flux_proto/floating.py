"""Real IEEE-754 rounding for the reduced float formats.

All reduced formats are stored as float64 (f64) in memory and rounded to
their native precision with round-to-nearest-even whenever a value is
stored, assigned or produced by arithmetic.

Formats:
  float64    : no rounding (native)
  float32    : 23 mantissa bits, exponent [-126, 127]
  float16    : 10 mantissa bits, exponent [-14, 15] (IEEE half)
  bf16_e8m7  : 7 mantissa bits, exponent [-126, 127]
  tf32_e8m10 : 10 mantissa bits, exponent [-126, 127]
  fp8_e5m2   : 2 mantissa bits, exponent [-14, 15]
  fp8_e4m3   : 3 mantissa bits, exponent [-6, 7], no infinity
"""

import math
import struct

F64_MANTISSA = (1 << 52) - 1
F64_IMPLICIT = 1 << 52
F64_BIAS = 1023

# fmt -> (mantissa bits kept, max unbiased exponent, min unbiased normal exponent, allow infinity)
FLOAT_FORMATS: dict[str, tuple[int, int, int, bool]] = {
    "float64": (52, 1023, -1022, True),
    "float32": (23, 127, -126, True),
    "float16": (10, 15, -14, True),
    "bf16_e8m7": (7, 127, -126, True),
    "tf32_e8m10": (10, 127, -126, True),
    "fp8_e5m2": (2, 15, -14, True),
    "fp8_e4m3": (3, 7, -6, False),
}

REDUCED_FLOATS = {
    name for name, (mant, emax, emin, allow_inf) in FLOAT_FORMATS.items()
    if name != "float64"
}

FLOATISH = frozenset(FLOAT_FORMATS) | {"float", "f64"}

# (mant, emin, emax, allow_inf) as integer constants for backend emission
# (matches the param order of the emitted $round_fmt helpers).
FMT_CONSTS: dict[str, tuple[int, int, int, int]] = {
    name: (mant, emin, emax, 1 if allow_inf else 0)
    for name, (mant, emax, emin, allow_inf) in FLOAT_FORMATS.items()
}


def round_value(value: float, fmt: str) -> float:
    """Round value to the given format with round-to-nearest-even.

    Subnormals are rounded exactly (Python-side). NaN and infinities pass
    through, except formats without infinity (fp8_e4m3) which produce NaN.
    """
    if fmt not in FLOAT_FORMATS:
        return value
    mant, emax, emin, allow_inf = FLOAT_FORMATS[fmt]
    if value != value:
        return value
    if value in (math.inf, -math.inf):
        return value if allow_inf else math.nan
    if value == 0.0 or mant >= 52:
        return value
    sign = -1.0 if value < 0 else 1.0
    bits = struct.unpack("<Q", struct.pack("<d", abs(value)))[0]
    exp = (bits >> 52) & 0x7FF
    frac = bits & F64_MANTISSA
    if exp == 0:
        # subnormal f64 input: normalize (value = frac * 2**-1074)
        norm = 0
        f = frac
        while f < F64_IMPLICIT:
            f <<= 1
            norm += 1
        exp = 1 - norm
        frac = f - F64_IMPLICIT
        eu = exp - F64_BIAS
    else:
        eu = exp - F64_BIAS
        if eu > emax:
            return sign * math.inf if allow_inf else math.nan
    if eu >= emin:
        # normal range: round mantissa
        drop = 52 - mant
        half = 1 << (drop - 1)
        frac2 = (frac | F64_IMPLICIT) >> drop
        rem = frac & ((1 << drop) - 1)
        if rem > half or (rem == half and (frac2 & 1)):
            frac2 += 1
        if frac2 >= (1 << (mant + 1)):
            frac2 >>= 1
            eu += 1
        if eu > emax:
            return sign * math.inf if allow_inf else math.nan
        new_bits = ((eu + F64_BIAS) << 52) | ((frac2 << drop) & F64_MANTISSA)
        return sign * struct.unpack("<d", struct.pack("<Q", new_bits))[0]
    # subnormal range: round at granularity 2**(emin - mant)
    lsb = 2.0 ** (emin - mant)
    q = round(abs(value) / lsb)
    if q == 0:
        return sign * 0.0
    if q >= (1 << mant):
        return sign * 2.0**emin
    return sign * q * lsb

def norm_float_text(s: str) -> str:
    """Normaliza texto de literal float para forma aceita por LLVM IR e WAT.

    Fontes podem trazer ".5" (sem digito inteiro); LLVM e wat2wasm exigem
    um digito antes do ponto. repr(float(s)) produz sempre a forma canonica.
    """
    try:
        v = float(s)
    except ValueError:
        return s
    if v != v or v in (float("inf"), float("-inf")):
        return s
    r = repr(v)
    if "e" in r or "E" in r:
        parts = r.split("e" if "e" in r else "E")
        if "." not in parts[0]:
            r = f"{parts[0]}.0e{parts[1]}"
    elif "." not in r:
        r = f"{r}.0"
    return r
