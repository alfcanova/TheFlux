"""Shortcut: run a FLUX source file with the AST interpreter."""
from __future__ import annotations
import sys
sys.dont_write_bytecode = True
from pathlib import Path

ROOT = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "src"))

from flux_proto.cli import main

if __name__ == "__main__":
    try:
        idx = sys.argv.index("--target")
        sys.argv[idx + 1] = "run"
    except ValueError:
        sys.argv.insert(1, "--target")
        sys.argv.insert(2, "run")
    raise SystemExit(main())
