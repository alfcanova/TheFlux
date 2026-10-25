"""Binary, Hex and Base64 file I/O helpers for TheFlux."""
from __future__ import annotations

import base64
import os
from pathlib import Path


def _resolve_path(path_str: str) -> Path:
    p = Path(path_str)
    if p.exists():
        return p
    flux_p = Path("flux") / p.name
    if flux_p.exists():
        return flux_p
    return p


def io_read_binary_file(path_str: str) -> str:
    p = _resolve_path(path_str)
    try:
        with open(p, "rb") as f:
            raw = f.read()
        return raw.decode("latin-1")
    except Exception:
        return ""


def io_write_binary_file(path_str: str, content: str) -> str:
    try:
        p = Path(path_str)
        if p.parent and not p.parent.exists():
            p.parent.mkdir(parents=True, exist_ok=True)
        try:
            raw = content.encode("latin-1")
        except UnicodeEncodeError:
            raw = content.encode("utf-8")
        with open(p, "wb") as f:
            f.write(raw)
        return content
    except Exception:
        return ""


def io_read_hex_file(path_str: str) -> str:
    p = _resolve_path(path_str)
    try:
        with open(p, "rb") as f:
            raw = f.read()
        return raw.hex()
    except Exception:
        return ""


def io_write_hex_file(path_str: str, hex_content: str) -> str:
    try:
        p = Path(path_str)
        if p.parent and not p.parent.exists():
            p.parent.mkdir(parents=True, exist_ok=True)
        clean_hex = "".join(hex_content.split())
        raw = bytes.fromhex(clean_hex)
        with open(p, "wb") as f:
            f.write(raw)
        return hex_content
    except Exception:
        return ""


def io_read_base64_file(path_str: str) -> str:
    p = _resolve_path(path_str)
    try:
        with open(p, "rb") as f:
            raw = f.read()
        return base64.b64encode(raw).decode("ascii")
    except Exception:
        return ""


def io_write_base64_file(path_str: str, b64_content: str) -> str:
    try:
        p = Path(path_str)
        if p.parent and not p.parent.exists():
            p.parent.mkdir(parents=True, exist_ok=True)
        raw = base64.b64decode(b64_content)
        with open(p, "wb") as f:
            f.write(raw)
        return b64_content
    except Exception:
        return ""
