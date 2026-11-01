from __future__ import annotations

import re
from datetime import datetime as _dt, timedelta as _td, timezone as _tz
from typing import Any

from flux_proto.floating import FLOAT_FORMATS
from flux_proto.semantic.storage_types import _INT_RANGES

GRAY = "\x1b[90m"
RESET = "\x1b[0m"

_INT_TYPES = frozenset(_INT_RANGES)
_FLOAT_TYPES = frozenset(FLOAT_FORMATS)
_COMPLEX_TYPES = frozenset({"complex32", "complex64", "complex128"})

_DATETIME_RE = re.compile(
    r"^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.(\d{1,9}))?(Z|[+-]\d{2}(?::?\d{2})?)?$"
)


def _parse_iso_nanos(s: str) -> int:
    m = _DATETIME_RE.match(s)
    if m is None:
        raise ValueError(f"invalid datetime '{s}'")
    y, mo, d, h, mi, sec, frac, off = m.groups()
    frac = (frac or "") + "000000000"
    nanos = int(frac[:9])
    if not off or off == "Z":
        delta = _td(0)
    else:
        sign = 1 if off[0] == "+" else -1
        body = off[1:]
        if ":" in body:
            oh, om = int(body[:2]), int(body[3:5])
        elif len(body) == 4:
            oh, om = int(body[:2]), int(body[2:4])
        else:
            oh, om = int(body[:2]), 0
        delta = _td(hours=sign * oh, minutes=sign * om)
    utc = _dt(int(y), int(mo), int(d), int(h), int(mi), int(sec), tzinfo=_tz.utc) - delta
    return int(utc.timestamp()) * 1_000_000_000 + nanos


def _parse_complex(s: str) -> complex:
    text = s.strip().replace(" ", "").replace(",", ".")
    if text.endswith("i") or text.endswith("I") or text.endswith("J"):
        text = text[:-1] + "j"
    return complex(text)


def type_prompt_name(tname: str) -> str:
    if tname in _INT_TYPES or tname in ("int", "inteiro"):
        return "inteiro"
    if tname in _FLOAT_TYPES or tname == "float":
        return "float"
    if tname in _COMPLEX_TYPES or tname in ("complex", "complexo"):
        return "complexo"
    if tname == "char":
        return "caractere"
    if tname in ("bool", "boolean"):
        return "bool"
    if tname in ("datetime", "date"):
        return "date"
    return "texto"


_RETRY_TEMPLATES = {
    "inteiro": "Digite um inteiro, como: 35",
    "float": "Digite um float, como: 19.99",
    "complexo": "Digite um complexo, como: 3+4i",
    "caractere": "Digite um caractere, como: a",
    "bool": "Digite um bool, como: true/false",
    "date": "Digite um date, como: 2026-08-29T12:00:00Z",
    "texto": "Digite um texto, como: Olá mundo",
}


def retry_message(tname: str) -> str:
    prompt_name = type_prompt_name(tname)
    msg = _RETRY_TEMPLATES.get(prompt_name, f"Digite um {prompt_name}")
    return f"{GRAY}{msg}{RESET}"


def parse_input(line: str, tname: str) -> tuple[bool, Any]:
    text = line.rstrip("\r\n")
    if tname in _INT_TYPES:
        try:
            value = int(text, 0) if text.lower().startswith(("0x", "0b", "0o")) else int(text)
        except (ValueError, TypeError):
            return False, None
        lo, hi = _INT_RANGES[tname]
        if not (lo <= value <= hi):
            return False, None
        return True, value
    if tname in _FLOAT_TYPES:
        try:
            return True, float(text.strip().replace(",", "."))
        except (ValueError, TypeError):
            return False, None
    if tname in _COMPLEX_TYPES:
        try:
            return True, _parse_complex(text)
        except (ValueError, TypeError):
            return False, None
    if tname == "char":
        if len(text) == 1:
            return True, text
        return False, None
    if tname == "bool":
        low = text.lower()
        if low in ("true", "verdadeiro"):
            return True, True
        if low in ("false", "falso"):
            return True, False
        return False, None
    if tname == "datetime":
        try:
            return True, _parse_iso_nanos(text)
        except (ValueError, TypeError):
            return False, None
    return True, text
