"""Compression, decompression, safe quotas and stream telemetry helpers for TheFlux."""
from __future__ import annotations

import bz2
import gzip
import io
import lzma
import struct
import zlib

try:
    import zstandard as zstd
except ImportError:
    zstd = None

try:
    import brotli
except ImportError:
    brotli = None

try:
    import snappy
except ImportError:
    snappy = None


# ==============================================================================
# Byte / String Conversions (8-bit clean lossless Latin-1 / UTF-8)
# ==============================================================================

def to_bytes(data: str | bytes) -> bytes:
    if isinstance(data, bytes):
        return data
    if not isinstance(data, str):
        data = str(data)
    try:
        return data.encode("latin-1")
    except UnicodeEncodeError:
        return data.encode("utf-8")


def to_str(b: bytes) -> str:
    if isinstance(b, str):
        return b
    return b.decode("latin-1")


# ==============================================================================
# Quota-Safe Decompression (Physical Hardware Protection against Zip Bombs)
# ==============================================================================

def _extract_quota(quota: dict | object | int | None) -> tuple[int, bool]:
    if quota is None:
        return (0, False)
    if isinstance(quota, int):
        return (quota, False)
    if isinstance(quota, dict):
        mb = quota.get("max_bytes", 0)
        sa = quota.get("strict_abort", False)
        return (int(mb) if mb is not None else 0, bool(sa))
    mb = getattr(quota, "max_bytes", 0)
    sa = getattr(quota, "strict_abort", False)
    return (int(mb) if mb is not None else 0, bool(sa))


def decompress_with_quota(decompress_stream_func, raw_bytes: bytes, quota: dict | object | int | None) -> bytes:
    max_bytes, strict_abort = _extract_quota(quota)
    if max_bytes <= 0:
        return decompress_stream_func(raw_bytes)

    # Decompress and check length
    out = decompress_stream_func(raw_bytes)
    if len(out) > max_bytes:
        if strict_abort:
            raise ValueError(f"decompression quota exceeded: limit {max_bytes} bytes, expanded to {len(out)} bytes")
        return out[:max_bytes]
    return out


# ==============================================================================
# 1. Deflate (RFC 1951 - Raw Bitstream)
# ==============================================================================

def compress_deflate(input_data: str | bytes) -> str:
    return compress_deflate_level(input_data, 6)


def compress_deflate_level(input_data: str | bytes, level: int) -> str:
    raw = to_bytes(input_data)
    lvl = max(0, min(9, int(level)))
    comp = zlib.compressobj(lvl, zlib.DEFLATED, -zlib.MAX_WBITS)
    out = comp.compress(raw) + comp.flush()
    return to_str(out)


def decompress_deflate(compressed_data: str | bytes) -> str:
    raw = to_bytes(compressed_data)
    decomp = zlib.decompressobj(-zlib.MAX_WBITS)
    out = decomp.decompress(raw) + decomp.flush()
    return to_str(out)


def decompress_deflate_safe(compressed_data: str | bytes, quota: dict | object | int | None) -> str:
    raw = to_bytes(compressed_data)

    def _do_decomp(b: bytes) -> bytes:
        d = zlib.decompressobj(-zlib.MAX_WBITS)
        return d.decompress(b) + d.flush()

    try:
        out = decompress_with_quota(_do_decomp, raw, quota)
        return to_str(out)
    except Exception:
        return ""


def compress_is_deflate(compressed_data: str | bytes) -> bool:
    raw = to_bytes(compressed_data)
    if not raw:
        return False
    try:
        decomp = zlib.decompressobj(-zlib.MAX_WBITS)
        out = decomp.decompress(raw) + decomp.flush()
        return len(out) > 0 or len(raw) == 2
    except Exception:
        return False


# ==============================================================================
# 2. Zlib (RFC 1950 - CMF/FLG Header + Adler32 Checksum)
# ==============================================================================

def compress_zlib(input_data: str | bytes) -> str:
    return compress_zlib_level(input_data, 6)


def compress_zlib_level(input_data: str | bytes, level: int) -> str:
    raw = to_bytes(input_data)
    lvl = max(0, min(9, int(level)))
    out = zlib.compress(raw, lvl)
    return to_str(out)


def decompress_zlib(compressed_data: str | bytes) -> str:
    raw = to_bytes(compressed_data)
    try:
        out = zlib.decompress(raw)
        return to_str(out)
    except Exception:
        return ""


def decompress_zlib_safe(compressed_data: str | bytes, quota: dict | object | int | None) -> str:
    raw = to_bytes(compressed_data)
    try:
        out = decompress_with_quota(zlib.decompress, raw, quota)
        return to_str(out)
    except Exception:
        return ""


def compress_is_zlib(compressed_data: str | bytes) -> bool:
    raw = to_bytes(compressed_data)
    if len(raw) < 6:
        return False
    # Check RFC 1950 header
    cmf = raw[0]
    flg = raw[1]
    if (cmf * 256 + flg) % 31 != 0:
        return False
    cm = cmf & 0x0F
    if cm != 8:  # Deflate
        return False
    return True


def compress_zlib_adler32(compressed_data: str | bytes) -> int:
    raw = to_bytes(compressed_data)
    if len(raw) < 4:
        return 0
    return struct.unpack(">I", raw[-4:])[0]


# ==============================================================================
# 3. Gzip (RFC 1952 - Flags, Timestamp, Deflate, CRC32, ISIZE)
# ==============================================================================

def compress_gzip(input_data: str | bytes) -> str:
    return compress_gzip_level(input_data, 6)


def compress_gzip_level(input_data: str | bytes, level: int) -> str:
    raw = to_bytes(input_data)
    lvl = max(1, min(9, int(level)))
    out = gzip.compress(raw, compresslevel=lvl)
    return to_str(out)


def decompress_gzip(compressed_data: str | bytes) -> str:
    raw = to_bytes(compressed_data)
    try:
        out = gzip.decompress(raw)
        return to_str(out)
    except Exception:
        return ""


def decompress_gzip_safe(compressed_data: str | bytes, quota: dict | object | int | None) -> str:
    raw = to_bytes(compressed_data)
    try:
        out = decompress_with_quota(gzip.decompress, raw, quota)
        return to_str(out)
    except Exception:
        return ""


def compress_is_gzip(compressed_data: str | bytes) -> bool:
    raw = to_bytes(compressed_data)
    return len(raw) >= 10 and raw.startswith(b"\x1f\x8b")


def compress_gzip_crc32(compressed_data: str | bytes) -> int:
    raw = to_bytes(compressed_data)
    if len(raw) < 8:
        return 0
    return struct.unpack("<I", raw[-8:-4])[0]


def compress_gzip_timestamp(compressed_data: str | bytes) -> int:
    raw = to_bytes(compressed_data)
    if len(raw) < 8:
        return 0
    return struct.unpack("<I", raw[4:8])[0]


# ==============================================================================
# 4. Bzip2 (Burrows-Wheeler Transform + Huffman)
# ==============================================================================

def compress_bzip2(input_data: str | bytes) -> str:
    return compress_bzip2_level(input_data, 9)


def compress_bzip2_level(input_data: str | bytes, level: int) -> str:
    raw = to_bytes(input_data)
    lvl = max(1, min(9, int(level)))
    out = bz2.compress(raw, compresslevel=lvl)
    return to_str(out)


def decompress_bzip2(compressed_data: str | bytes) -> str:
    raw = to_bytes(compressed_data)
    try:
        out = bz2.decompress(raw)
        return to_str(out)
    except Exception:
        return ""


def decompress_bzip2_safe(compressed_data: str | bytes, quota: dict | object | int | None) -> str:
    raw = to_bytes(compressed_data)
    try:
        out = decompress_with_quota(bz2.decompress, raw, quota)
        return to_str(out)
    except Exception:
        return ""


def compress_is_bzip2(compressed_data: str | bytes) -> bool:
    raw = to_bytes(compressed_data)
    return len(raw) >= 4 and raw.startswith(b"BZ")


# ==============================================================================
# 5. LZMA / LZMA1 (Alone Format)
# ==============================================================================

def compress_lzma(input_data: str | bytes) -> str:
    return compress_lzma_level(input_data, 6)


def compress_lzma_level(input_data: str | bytes, level: int) -> str:
    raw = to_bytes(input_data)
    lvl = max(0, min(9, int(level)))
    out = lzma.compress(raw, format=lzma.FORMAT_ALONE, preset=lvl)
    return to_str(out)


def decompress_lzma(compressed_data: str | bytes) -> str:
    raw = to_bytes(compressed_data)
    try:
        out = lzma.decompress(raw, format=lzma.FORMAT_ALONE)
        return to_str(out)
    except Exception:
        # Fallback to auto
        try:
            out = lzma.decompress(raw, format=lzma.FORMAT_AUTO)
            return to_str(out)
        except Exception:
            return ""


def decompress_lzma_safe(compressed_data: str | bytes, quota: dict | object | int | None) -> str:
    raw = to_bytes(compressed_data)

    def _do_decomp(b: bytes) -> bytes:
        try:
            return lzma.decompress(b, format=lzma.FORMAT_ALONE)
        except Exception:
            return lzma.decompress(b, format=lzma.FORMAT_AUTO)

    try:
        out = decompress_with_quota(_do_decomp, raw, quota)
        return to_str(out)
    except Exception:
        return ""


def compress_is_lzma(compressed_data: str | bytes) -> bool:
    raw = to_bytes(compressed_data)
    if len(raw) < 13:
        return False
    # Check LZMA Alone header: prop byte < 225
    prop = raw[0]
    if prop >= 225:
        return False
    dict_size = struct.unpack("<I", raw[1:5])[0]
    return dict_size > 0


# ==============================================================================
# 6. LZMA2 & XZ (Container Format with Integrity Checksums)
# ==============================================================================

def compress_lzma2(input_data: str | bytes) -> str:
    return compress_lzma2_level(input_data, 6)


def compress_lzma2_level(input_data: str | bytes, level: int) -> str:
    raw = to_bytes(input_data)
    lvl = max(0, min(9, int(level)))
    filters = [{"id": lzma.FILTER_LZMA2, "preset": lvl}]
    out = lzma.compress(raw, format=lzma.FORMAT_RAW, filters=filters)
    return to_str(out)


def decompress_lzma2(compressed_data: str | bytes) -> str:
    raw = to_bytes(compressed_data)
    filters = [{"id": lzma.FILTER_LZMA2}]
    try:
        out = lzma.decompress(raw, format=lzma.FORMAT_RAW, filters=filters)
        return to_str(out)
    except Exception:
        return ""


def decompress_lzma2_safe(compressed_data: str | bytes, quota: dict | object | int | None) -> str:
    raw = to_bytes(compressed_data)
    filters = [{"id": lzma.FILTER_LZMA2}]

    def _do_decomp(b: bytes) -> bytes:
        return lzma.decompress(b, format=lzma.FORMAT_RAW, filters=filters)

    try:
        out = decompress_with_quota(_do_decomp, raw, quota)
        return to_str(out)
    except Exception:
        return ""


def compress_xz(input_data: str | bytes) -> str:
    return compress_xz_level(input_data, 6)


def compress_xz_level(input_data: str | bytes, level: int) -> str:
    raw = to_bytes(input_data)
    lvl = max(0, min(9, int(level)))
    out = lzma.compress(raw, format=lzma.FORMAT_XZ, preset=lvl)
    return to_str(out)


def decompress_xz(compressed_data: str | bytes) -> str:
    raw = to_bytes(compressed_data)
    try:
        out = lzma.decompress(raw, format=lzma.FORMAT_XZ)
        return to_str(out)
    except Exception:
        return ""


def decompress_xz_safe(compressed_data: str | bytes, quota: dict | object | int | None) -> str:
    raw = to_bytes(compressed_data)

    def _do_decomp(b: bytes) -> bytes:
        return lzma.decompress(b, format=lzma.FORMAT_XZ)

    try:
        out = decompress_with_quota(_do_decomp, raw, quota)
        return to_str(out)
    except Exception:
        return ""


def compress_is_xz(compressed_data: str | bytes) -> bool:
    raw = to_bytes(compressed_data)
    return len(raw) >= 6 and raw.startswith(b"\xfd7zXZ\x00")


# ==============================================================================
# 7. Zstandard / Zstd (RFC 8878 - High Speed Real-Time Compression)
# ==============================================================================

def compress_zstd(input_data: str | bytes) -> str:
    return compress_zstd_level(input_data, 3)


def compress_zstd_level(input_data: str | bytes, level: int) -> str:
    if zstd is None:
        raise RuntimeError("zstandard module is not available")
    raw = to_bytes(input_data)
    lvl = max(1, min(22, int(level)))
    cctx = zstd.ZstdCompressor(level=lvl)
    out = cctx.compress(raw)
    return to_str(out)


def decompress_zstd(compressed_data: str | bytes) -> str:
    if zstd is None:
        raise RuntimeError("zstandard module is not available")
    raw = to_bytes(compressed_data)
    try:
        dctx = zstd.ZstdDecompressor()
        out = dctx.decompress(raw)
        return to_str(out)
    except Exception:
        return ""


def decompress_zstd_safe(compressed_data: str | bytes, quota: dict | object | int | None) -> str:
    if zstd is None:
        raise RuntimeError("zstandard module is not available")
    raw = to_bytes(compressed_data)

    def _do_decomp(b: bytes) -> bytes:
        dctx = zstd.ZstdDecompressor()
        return dctx.decompress(b)

    try:
        out = decompress_with_quota(_do_decomp, raw, quota)
        return to_str(out)
    except Exception:
        return ""


def compress_is_zstd(compressed_data: str | bytes) -> bool:
    raw = to_bytes(compressed_data)
    return len(raw) >= 4 and raw.startswith(b"\x28\xb5\x2f\xfd")


def compress_zstd_frame_size(compressed_data: str | bytes) -> int:
    if zstd is None:
        return -1
    raw = to_bytes(compressed_data)
    if not compress_is_zstd(raw):
        return -1
    try:
        return int(zstd.frame_content_size(raw))
    except Exception:
        return -1


# ==============================================================================
# 8. Brotli (RFC 7932 - Web Standard)
# ==============================================================================

def compress_brotli(input_data: str | bytes) -> str:
    return compress_brotli_level(input_data, 4)


def compress_brotli_level(input_data: str | bytes, level: int) -> str:
    if brotli is None:
        raise RuntimeError("brotli module is not available")
    raw = to_bytes(input_data)
    lvl = max(0, min(11, int(level)))
    out = brotli.compress(raw, quality=lvl)
    return to_str(out)


def decompress_brotli(compressed_data: str | bytes) -> str:
    if brotli is None:
        raise RuntimeError("brotli module is not available")
    raw = to_bytes(compressed_data)
    try:
        out = brotli.decompress(raw)
        return to_str(out)
    except Exception:
        return ""


def decompress_brotli_safe(compressed_data: str | bytes, quota: dict | object | int | None) -> str:
    if brotli is None:
        raise RuntimeError("brotli module is not available")
    raw = to_bytes(compressed_data)
    try:
        out = decompress_with_quota(brotli.decompress, raw, quota)
        return to_str(out)
    except Exception:
        return ""


def compress_is_brotli(compressed_data: str | bytes) -> bool:
    if brotli is None:
        return False
    raw = to_bytes(compressed_data)
    if not raw:
        return False
    try:
        brotli.decompress(raw)
        return True
    except Exception:
        return False


# ==============================================================================
# 9. Inspection, Format Auto-Detection and Metrics
# ==============================================================================

def compress_detect_format(compressed_data: str | bytes) -> str:
    raw = to_bytes(compressed_data)
    if not raw:
        return "UNKNOWN"
    if compress_is_gzip(raw):
        return "GZIP"
    if compress_is_xz(raw):
        return "XZ"
    if compress_is_zstd(raw):
        return "ZSTD"
    if compress_is_bzip2(raw):
        return "BZIP2"
    if compress_is_zlib(raw):
        return "ZLIB"
    if len(raw) >= 6 and raw.startswith(b"7z\xbc\xaf\x27\x1c"):
        return "SEVEN_ZIP"
    if len(raw) >= 4 and raw.startswith((b"PK\x03\x04", b"PK\x05\x06", b"PK\x07\x08")):
        return "ZIP"
    if len(raw) >= 7 and raw.startswith((b"Rar!\x1a\x07\x00", b"Rar!\x1a\x07\x01\x00")):
        return "RAR"
    if len(raw) >= 262 and raw[257:262] == b"ustar":
        return "TAR"
    if compress_is_lzma(raw):
        return "LZMA"
    if compress_is_deflate(raw):
        return "DEFLATE"
    return "UNKNOWN"


def compress_estimate_decompressed_size(compressed_data: str | bytes) -> int:
    raw = to_bytes(compressed_data)
    if not raw:
        return 0
    # Gzip ISIZE (last 4 bytes)
    if compress_is_gzip(raw) and len(raw) >= 10:
        return struct.unpack("<I", raw[-4:])[0]
    # Zstd Frame Content Size
    if compress_is_zstd(raw) and zstd is not None:
        sz = compress_zstd_frame_size(raw)
        if sz >= 0:
            return sz
    # LZMA Alone header (bytes 5 to 13 is 64-bit uncompressed size)
    if compress_is_lzma(raw) and len(raw) >= 13:
        sz = struct.unpack("<Q", raw[5:13])[0]
        if sz != 0xFFFFFFFFFFFFFFFF:
            return sz
    # Fallback to auto-decompression size check
    try:
        decomp = decompress_auto(raw)
        return len(to_bytes(decomp))
    except Exception:
        return -1


def decompress_auto(compressed_data: str | bytes) -> str:
    fmt = compress_detect_format(compressed_data)
    if fmt == "GZIP":
        return decompress_gzip(compressed_data)
    if fmt == "ZLIB":
        return decompress_zlib(compressed_data)
    if fmt == "XZ":
        return decompress_xz(compressed_data)
    if fmt == "ZSTD":
        return decompress_zstd(compressed_data)
    if fmt == "BZIP2":
        return decompress_bzip2(compressed_data)
    if fmt == "LZMA":
        return decompress_lzma(compressed_data)
    if fmt == "DEFLATE":
        return decompress_deflate(compressed_data)
    if fmt == "BROTLI":
        return decompress_brotli(compressed_data)
    # Default try deflate / gzip / zlib
    for fn in (decompress_zlib, decompress_gzip, decompress_deflate, decompress_xz, decompress_bzip2):
        res = fn(compressed_data)
        if res:
            return res
    return ""


def compress_stats(uncompressed: str | bytes, compressed: str | bytes) -> dict:
    u_raw = to_bytes(uncompressed)
    c_raw = to_bytes(compressed)
    u_sz = len(u_raw)
    c_sz = len(c_raw)
    ratio = round(c_sz / u_sz, 4) if u_sz > 0 else 1.0
    savings = round((1.0 - ratio) * 100.0, 2)
    fmt_str = compress_detect_format(c_raw)
    return {
        "uncompressed_size": u_sz,
        "compressed_size": c_sz,
        "ratio": ratio,
        "savings_percent": savings,
        "format": fmt_str,
    }


def compress_is_effective(uncompressed: str | bytes, compressed: str | bytes) -> bool:
    u_sz = len(to_bytes(uncompressed))
    c_sz = len(to_bytes(compressed))
    return c_sz < u_sz


def compress_is_format_supported(format_name: str) -> bool:
    fn = str(format_name).upper().strip()
    if fn in ("DEFLATE", "ZLIB", "GZIP", "BZIP2", "LZMA", "LZMA2", "XZ", "TAR", "ZIP"):
        return True
    if fn == "ZSTD":
        return zstd is not None
    if fn == "BROTLI":
        return brotli is not None
    if fn in ("7Z", "SEVEN_ZIP"):
        import shutil
        import os
        return shutil.which("7z") is not None or os.path.exists(r"C:\Program Files\7-Zip\7z.exe")
    return False
