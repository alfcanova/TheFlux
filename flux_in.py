"""TheFlux Backend Driver: IN (AST/FMIR Interpreter via .\\src)."""
from __future__ import annotations
import sys
sys.dont_write_bytecode = True
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SRC = ROOT / "src"
if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

from flux_proto.cli import main

if __name__ == "__main__":
    try:
        idx = sys.argv.index("--target")
        sys.argv[idx + 1] = "run"
    except ValueError:
        sys.argv.insert(1, "--target")
        sys.argv.insert(2, "run")
    raise SystemExit(main())
