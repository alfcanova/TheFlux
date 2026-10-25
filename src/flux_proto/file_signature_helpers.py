"""File signature, hashing and magic number helper routines for TheFlux."""
from __future__ import annotations

import hashlib
import hmac
import os
from pathlib import Path
import zlib

CHUNK_SIZE = 65536


def _resolve_candidate(path_str: str) -> Path | None:
    if not path_str:
        return None
    p = Path(path_str)
    if p.exists() and p.is_file():
        return p
    # Fallback to look inside parent directories or flux/
    for base in (
        Path("."),
        Path(".."),
        Path("flux"),
        Path("../flux"),
        Path(__file__).resolve().parent.parent.parent,
        Path(__file__).resolve().parent.parent.parent.parent,
    ):
        cand = base / p.name if not p.is_absolute() else p
        if cand.exists() and cand.is_file():
            return cand
        cand_sub = base / p
        if cand_sub.exists() and cand_sub.is_file():
            return cand_sub
    return None


def file_sha256(path_str: str) -> str:
    p = _resolve_candidate(path_str)
    if not p:
        return ""
    try:
        h = hashlib.sha256()
        with open(p, "rb") as f:
            while chunk := f.read(CHUNK_SIZE):
                h.update(chunk)
        return h.hexdigest()
    except Exception:
        return ""


def file_md5(path_str: str) -> str:
    p = _resolve_candidate(path_str)
    if not p:
        return ""
    try:
        h = hashlib.md5()
        with open(p, "rb") as f:
            while chunk := f.read(CHUNK_SIZE):
                h.update(chunk)
        return h.hexdigest()
    except Exception:
        return ""


def file_sha1(path_str: str) -> str:
    p = _resolve_candidate(path_str)
    if not p:
        return ""
    try:
        h = hashlib.sha1()
        with open(p, "rb") as f:
            while chunk := f.read(CHUNK_SIZE):
                h.update(chunk)
        return h.hexdigest()
    except Exception:
        return ""


def file_crc32(path_str: str) -> int:
    p = _resolve_candidate(path_str)
    if not p:
        return 0
    try:
        crc = 0
        with open(p, "rb") as f:
            while chunk := f.read(CHUNK_SIZE):
                crc = zlib.crc32(chunk, crc)
        return crc & 0xFFFFFFFF
    except Exception:
        return 0


def file_hmac_sha256(path_str: str, key: str) -> str:
    p = _resolve_candidate(path_str)
    if not p:
        return ""
    try:
        h = hmac.new(key.encode("utf-8"), digestmod=hashlib.sha256)
        with open(p, "rb") as f:
            while chunk := f.read(CHUNK_SIZE):
                h.update(chunk)
        return h.hexdigest()
    except Exception:
        return ""


def file_hmac_md5(path_str: str, key: str) -> str:
    p = _resolve_candidate(path_str)
    if not p:
        return ""
    try:
        h = hmac.new(key.encode("utf-8"), digestmod=hashlib.md5)
        with open(p, "rb") as f:
            while chunk := f.read(CHUNK_SIZE):
                h.update(chunk)
        return h.hexdigest()
    except Exception:
        return ""


def file_magic_bytes(path_str: str, num_bytes: int) -> str:
    if num_bytes <= 0:
        return ""
    p = _resolve_candidate(path_str)
    if not p:
        return ""
    try:
        with open(p, "rb") as f:
            head = f.read(int(num_bytes))
        return head.hex()
    except Exception:
        return ""


def file_detect_type(path_str: str) -> str:
    p = _resolve_candidate(path_str)
    if not p:
        return "unknown"
    try:
        with open(p, "rb") as f:
            head = f.read(512)
        if not head:
            return "empty"
        if head.startswith(b"\x89PNG\r\n\x1a\n"):
            return "png"
        if head.startswith(b"%PDF"):
            return "pdf"
        if head.startswith(b"\x00asm"):
            return "wasm"
        if head.startswith((b"PK\x03\x04", b"PK\x05\x06")):
            return "zip"
        if head.startswith(b"\xff\xd8\xff"):
            return "jpeg"
        if head.startswith((b"GIF87a", b"GIF89a")):
            return "gif"
        if head.startswith(b"\x7fELF"):
            return "elf"
        if head.startswith(b"MZ"):
            return "exe"
        if head.startswith(b"\x1f\x8b"):
            return "gzip"
        # Check text vs binary
        if b"\x00" in head:
            return "binary"
        try:
            head.decode("utf-8")
            return "text"
        except UnicodeDecodeError:
            return "binary"
    except Exception:
        return "unknown"


def file_is_binary(path_str: str) -> bool:
    p = _resolve_candidate(path_str)
    if not p:
        return False
    try:
        with open(p, "rb") as f:
            head = f.read(1024)
        if not head:
            return False
        if b"\x00" in head:
            return True
        try:
            head.decode("utf-8")
            return False
        except UnicodeDecodeError:
            return True
    except Exception:
        return False
