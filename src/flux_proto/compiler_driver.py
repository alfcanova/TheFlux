"""Hybrid Compiler Driver for TheFlux in .\\src.

Coordinates the modular TheFlux compiler libraries in src/CompilerLib/ and src/main.flux
with the 6 execution/codegen backends (in, vm, vmr, lv, wat, wasm).
"""
from __future__ import annotations

import os
import shutil
import subprocess
import sys
from pathlib import Path

SRC_DIR = Path(__file__).resolve().parent.parent
ROOT_DIR = SRC_DIR.parent
MAIN_FLUX = SRC_DIR / "main.flux"
COMPILER_LIB_DIR = SRC_DIR / "CompilerLib"
KEYWORDS_YAML_DIR = ROOT_DIR / "docs" / "pt" / "keywords"

TARGET_ALIASES: dict[str, str] = {
    "run": "run",
    "in": "run",
    "vmbc": "vmbc",
    "vm": "vmbc",
    "vmr": "vmbc",
    "wat": "wat",
    "wasm": "wasm",
    "was": "wasm",
    "llvm": "llvm",
    "lv": "llvm",
}


def normalize_target(target: str) -> str:
    return TARGET_ALIASES.get(target.lower(), target.lower())


def list_compiler_modules() -> list[Path]:
    """Return all modular .fdsl files inside src/CompilerLib/."""
    if not COMPILER_LIB_DIR.exists():
        return []
    return sorted(COMPILER_LIB_DIR.rglob("*.fdsl"))


def build_stage1_binary(output_exe: Path | None = None) -> Path:
    """Compile src/main.flux + src/CompilerLib/*.fdsl to native executable (Stage 1)."""
    from flux_proto.cli import main as cli_main

    bin_dir = ROOT_DIR / "bin"
    bin_dir.mkdir(parents=True, exist_ok=True)
    if output_exe is None:
        output_exe = bin_dir / "fluxc.exe"

    ll_base = bin_dir / "stage1"
    ll_path = bin_dir / "stage1.ll"
    rc = cli_main(["--target", "llvm", "-o", str(ll_base), str(MAIN_FLUX)])
    if rc != 0 or not ll_path.exists():
        raise RuntimeError(f"Failed to emit Stage 1 LLVM IR from {MAIN_FLUX}")

    clang = (
        shutil.which("clang")
        or (r"C:\Program Files\LLVM\bin\clang.exe" if Path(r"C:\Program Files\LLVM\bin\clang.exe").exists() else None)
    )
    if not clang:
        raise RuntimeError("Clang not found on PATH")

    runtime_c = SRC_DIR / "flux_proto" / "llvm" / "runtime" / "flux_input.c"
    res = subprocess.run(
        [clang, "-O2", "-Wno-deprecated-declarations", "-o", str(output_exe), str(ll_path), str(runtime_c)],
        capture_output=True,
        text=True,
    )
    if res.returncode != 0:
        raise RuntimeError(f"Clang link failed: {res.stderr}")
    return output_exe
