#!/usr/bin/env python3
"""Migrate and update TheFlux docx specification to v0.75 in docs/pt."""
import os
import re
import shutil
import zipfile
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
DOCS_DIR = REPO_ROOT / "docs"
SRC_DOCX = DOCS_DIR / "TheFlux_v0.5.docx"
DST_DOCX = DOCS_DIR / "pt" / "TheFlux_v0.75.docx"


def main():
    if not SRC_DOCX.exists():
        print(f"Source docx {SRC_DOCX} does not exist. Checking destination...")
        if DST_DOCX.exists():
            print(f"Destination docx {DST_DOCX} already exists.")
            return 0
        return 1

    print(f"Migrating {SRC_DOCX} -> {DST_DOCX} with v0.75...")

    # Read original zip
    with zipfile.ZipFile(SRC_DOCX, "r") as zin:
        with zipfile.ZipFile(DST_DOCX, "w", compression=zipfile.ZIP_DEFLATED) as zout:
            for item in zin.infolist():
                data = zin.read(item.filename)
                if item.filename == "word/document.xml":
                    text = data.decode("utf-8")
                    # Update version references
                    text = re.sub(r'vers[aã]o\s+0\.[15]', 'versão 0.75', text, flags=re.IGNORECASE)
                    text = re.sub(r'TheFlux\s+v0\.[15]', 'TheFlux v0.75', text, flags=re.IGNORECASE)
                    text = re.sub(r'v0\.5\.0', 'v0.75.0', text)
                    text = re.sub(r'v0\.5\b', 'v0.75', text)
                    data = text.encode("utf-8")
                zout.writestr(item, data)

    print(f"Created {DST_DOCX} ({DST_DOCX.stat().st_size} bytes)")

    # Remove source file from docs root
    SRC_DOCX.unlink()
    print(f"Removed source file from root: {SRC_DOCX}")
    return 0


if __name__ == "__main__":
    import sys
    sys.exit(main())
