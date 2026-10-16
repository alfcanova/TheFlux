#!/usr/bin/env python3
"""Unified Documentation Build Orchestrator for TheFlux.

Executes the complete documentation pipeline in strict order:
  1. scripts/docs/sync_ebnf.py            - Synchronize formal EBNF grammars (PT/EN) and TheFlux.md
  2. scripts/docs/check_i18n_parity.py    - Verify 1:1 structural, schema, and EBNF parity
  3. scripts/sync_errors_catalog.py       - Compile diagnostic catalogs (Python, C, PT/EN Docs)
  4. scripts/docs/generate_index.py        - Generate keyword indexes (PT and EN)
  5. scripts/docs/generate_html.py         - Generate standalone interactive HTML docs

Usage:
  python scripts/docs/build_docs.py
  python scripts/docs/build_docs.py --quick     # Skips parity verification
  python scripts/docs/build_docs.py --lang pt   # Build only Portuguese artifacts
  python scripts/docs/build_docs.py --lang en   # Build only English artifacts
"""
from __future__ import annotations

import argparse
import os
import subprocess
import sys
import time

REPO_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))


def run_step(step_name: str, cmd: list[str]) -> bool:
    print(f"\n==================================================")
    print(f"🚀 [Passo] {step_name}")
    print(f"   Comando: {' '.join(cmd)}")
    print(f"==================================================")
    start = time.perf_counter()
    res = subprocess.run(cmd, cwd=REPO_ROOT)
    elapsed = time.perf_counter() - start
    if res.returncode != 0:
        print(f"❌ [Falha] {step_name} falhou com código de saída {res.returncode} ({elapsed:.2f}s)!", file=sys.stderr)
        return False
    print(f"✅ [Sucesso] {step_name} concluído com êxito ({elapsed:.2f}s).")
    return True


def main() -> int:
    for stream in (sys.stdout, sys.stderr):
        if stream is not None:
            try:
                stream.reconfigure(encoding="utf-8")
            except (AttributeError, ValueError):
                pass

    parser = argparse.ArgumentParser(description="Unified Documentation Builder for TheFlux")
    parser.add_argument("--lang", choices=["pt", "en", "all"], default="all",
                        help="Target documentation language (default: all)")
    parser.add_argument("--quick", action="store_true",
                        help="Skip i18n parity check and run generators directly")
    parser.add_argument("--with-docx", action="store_true",
                        help="Synchronize DOCX White Papers (PT and EN) and update TOCs via Word COM")
    args = parser.parse_args()

    python_exe = sys.executable
    scripts_dir = os.path.join(REPO_ROOT, "scripts")
    docs_scripts_dir = os.path.join(scripts_dir, "docs")

    start_total = time.perf_counter()
    print("=" * 60)
    print("📚 Início da Construção Unificada da Documentação — TheFlux")
    print(f"   Idioma: {args.lang.upper()} | Raiz: {REPO_ROOT}")
    print("=" * 60)

    # Passo 1: Sincronização da Gramática Formal EBNF (ISO/IEC 14977)
    sync_ebnf_script = os.path.join(docs_scripts_dir, "sync_ebnf.py")
    if not run_step("Sincronização da Gramática Formal EBNF (PT e EN)", [python_exe, sync_ebnf_script]):
        return 1

    # Passo 2: Verificação de Paridade de I18n
    if not args.quick:
        parity_script = os.path.join(docs_scripts_dir, "check_i18n_parity.py")
        if not run_step("Verificação de Paridade I18n (PT <-> EN)", [python_exe, parity_script]):
            print("\n🚨 Interrompendo build devido a divergências de internacionalização.", file=sys.stderr)
            return 1

    # Passo 3: Sincronização do Catálogo de Diagnósticos (AOT Python, C e Docs)
    sync_errors_script = os.path.join(scripts_dir, "sync_errors_catalog.py")
    if not run_step("Compilação AOT do Catálogo de Diagnósticos", [python_exe, sync_errors_script, "--lang", args.lang]):
        return 1

    # Passo 4: Geração de Índices de Palavras-Chave (KW_index.yaml)
    gen_index_script = os.path.join(docs_scripts_dir, "generate_index.py")
    if not run_step("Geração de Índices de Palavras-Chave", [python_exe, gen_index_script, "--lang", args.lang]):
        return 1

    # Passo 5: Geração das Páginas HTML Estáticas
    gen_html_script = os.path.join(docs_scripts_dir, "generate_html.py")
    if not run_step("Geração de HTML Interativo", [python_exe, gen_html_script, "--lang", args.lang]):
        return 1

    # Passo 6 (Opcional): Sincronização do White Paper DOCX (PT e EN)
    if args.with_docx:
        sync_docx_script = os.path.join(docs_scripts_dir, "sync_whitepaper_docx.py")
        if not run_step("Sincronização dos White Papers DOCX (PT e EN)", [python_exe, sync_docx_script]):
            return 1

    total_time = time.perf_counter() - start_total
    print("\n" + "=" * 60)
    print(f"🎉 DOCUMENTAÇÃO CONSTRUÍDA COM SUCESSO EM {total_time:.2f}s!")
    print("   Arquivos gerados/atualizados:")
    print("     - docs/pt/TheFlux.ebnf")
    print("     - docs/en/TheFlux.ebnf")
    print("     - docs/pt/Gramatica.ebnf")
    print("     - docs/en/Grammar.ebnf")
    print("     - docs/pt/TheFlux.md (Seção 3)")
    print("     - docs/en/TheFlux.md (Seção 3)")
    print("     - docs/pt/Errors.md")
    print("     - docs/en/Errors.md")
    print("     - docs/pt/keywords/KW_index.yaml")
    print("     - docs/en/keywords/KW_index.yaml")
    print("     - docs/site/theflux_docs_pt.html")
    print("     - docs/site/theflux_docs_en.html")
    print("     - docs/site/index.html (Language Portal)")
    print("     - src/flux_proto/diagnostics/catalog_data.py")
    print("     - src/flux_proto/llvm/runtime/flux_errors.h")
    print("=" * 60)
    return 0


if __name__ == "__main__":
    sys.exit(main())
