"""Orchestrate the full documentation generation pipeline for both languages.

Pipeline:
  1. 00_translate_docs.py  -> generates docs/keywords/en/KW_*.yaml from docs/keywords/KW_*.yaml
  2. 00_generate_index.py  -> generates KW_index.yaml (pt) and en/KW_index.yaml (en)
  3. 00_generate_html.py   -> generates theflux_docs.html (pt) and theflux_docs_en.html (en)

Usage:
    python 00_generate_all.py              # runs all steps for both languages
    python 00_generate_all.py --skip-translate   # skip translation step (if EN YAMLs exist)
    python 00_generate_all.py --lang pt          # only Portuguese
    python 00_generate_all.py --lang en          # only English
    python 00_generate_all.py --help             # show help
"""
import subprocess
import sys
import os
import argparse

DOCS_DIR = os.path.dirname(os.path.abspath(__file__))
PY = sys.executable

# ASCII-safe symbols for terminal output
CHECK = "[OK]"
FAIL = "[FAIL]"
SKIP = "[SKIP]"
HEADER = "=" * 60


def run(cmd, desc):
    print()
    print(HEADER)
    print(f"  {desc}")
    print(f"  $ {cmd}")
    print(HEADER)
    sys.stdout.flush()
    result = subprocess.run(cmd, shell=True, cwd=DOCS_DIR)
    if result.returncode != 0:
        print(f"\n  {FAIL} {desc} (exit code {result.returncode})")
        sys.exit(result.returncode)
    print(f"  {CHECK} {desc}")
    print()
    return result


def main():
    parser = argparse.ArgumentParser(
        description="Generate TheFlux documentation (translate + index + HTML) for both languages."
    )
    parser.add_argument(
        "--translate", action="store_true",
        help="Run the PT-to-EN automatic translation step (overwrites EN YAMLs)"
    )
    parser.add_argument(
        "--lang", choices=["pt", "en"],
        help="Only generate documentation for the specified language"
    )
    args = parser.parse_args()

    print()
    print(HEADER)
    print("  TheFlux Documentation -- Full Generation Pipeline")
    print(HEADER)

    languages = ["en", "pt"] if args.lang is None else [args.lang]

    # Step 1: Translate PT -> EN (only when explicitly requested)
    if "en" in languages and args.translate:
        run(f'"{PY}" 00_translate_docs.py', "Translate PT -> EN YAMLs")
    elif "en" in languages:
        print(f"  {SKIP} Translation (using curated English YAMLs in docs/keywords/en)")
    else:
        print(f"  {SKIP} Translation (Portuguese only)")

    # Step 2: Generate indices
    if "pt" in languages:
        run(f'"{PY}" 00_generate_index.py --lang pt', "Generate Portuguese index")
    if "en" in languages:
        run(f'"{PY}" 00_generate_index.py --lang en', "Generate English index")

    # Step 3: Generate HTML
    import shutil
    parent_docs_dir = os.path.dirname(DOCS_DIR)

    if "pt" in languages:
        run(f'"{PY}" 00_generate_html.py --lang pt', "Generate Portuguese HTML")
        shutil.copy(os.path.join(DOCS_DIR, "theflux_docs.html"), os.path.join(parent_docs_dir, "theflux_docs.html"))
    if "en" in languages:
        run(f'"{PY}" 00_generate_html.py --lang en', "Generate English HTML")
        shutil.copy(os.path.join(DOCS_DIR, "theflux_docs_en.html"), os.path.join(parent_docs_dir, "theflux_docs_en.html"))

    # Summary
    print()
    print(HEADER)
    print("  Pipeline complete!")
    print()
    if "pt" in languages:
        print("     PT -> theflux_docs.html (in docs/ and docs/keywords/)")
    if "en" in languages:
        print("     EN -> theflux_docs_en.html (in docs/ and docs/keywords/)")
    print(HEADER)
    print()


if __name__ == "__main__":
    main()

