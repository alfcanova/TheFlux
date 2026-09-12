"""Shortcut: compile a FLUX source file to WAT (WebAssembly Text Format).

When WABT is on PATH, also generates the binary .wasm via wat2wasm.
"""
from __future__ import annotations
import subprocess
import sys
sys.dont_write_bytecode = True
from pathlib import Path

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

from flux_proto.cli import main

if __name__ == "__main__":
    try:
        idx = sys.argv.index("--target")
        sys.argv[idx + 1] = "wat"
    except ValueError:
        sys.argv.insert(1, "--target")
        sys.argv.insert(2, "wat")
    raise SystemExit(main())
