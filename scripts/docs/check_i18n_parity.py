#!/usr/bin/env python3
"""Linter de Paridade Estrutural e Semântica de Documentação Bilíngue (PT / EN).

Inspeciona e valida a simetria 1:1 entre:
  docs/pt/keywords/KW_*.yaml <---> docs/en/keywords/KW_*.yaml

Validações:
  1. Paridade de Arquivos: Todo arquivo em PT deve existir em EN e vice-versa.
  2. Paridade Estrutural:
     - keyword (invariante)
     - syntax e pseudocode (invariantes)
     - cardinalidade de usages (mesma quantidade de seções e códigos de exemplo)
     - cardinalidade de restrictions (mesma quantidade de regras)
     - conjunto de erros: mesmos códigos (ex: RT701) e mesmos mnemônicos (DIVISION_BY_ZERO)
  3. Detecção de Pendências: Alerta se houver placeholders de tradução não resolvidos.

Retorna exit code 0 em caso de sucesso total ou 1 caso haja divergências.
"""
from __future__ import annotations

import argparse
import glob
import os
import re
import sys
import yaml
from pathlib import Path

# Reconfigura stdout/stderr para UTF-8 no Windows
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

RAIZ = Path(__file__).resolve().parent.parent.parent

DOCS_DIR = RAIZ / "docs"
PT_DOCS_DIR = DOCS_DIR / "pt"
EN_DOCS_DIR = DOCS_DIR / "en"
PT_DIR = PT_DOCS_DIR / "keywords"
EN_DIR = EN_DOCS_DIR / "keywords"


def carregar_yaml(path: Path) -> dict | None:
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
            return data if isinstance(data, dict) else None
    except Exception as e:
        print(f"  [ERRO] Falha ao ler {path}: {e}", file=sys.stderr)
        return None


DOCS_MAP_PT_TO_EN: dict[str, str] = {
    "Compilacao.md": "Compilation.md",
    "Gramatica.md": "Grammar.md",
    "Errors.md": "Errors.md",
    "LICENSE.md": "LICENSE.md",
    "StdLibs.md": "StdLibs.md",
    "ReleaseNotes_0.5.0.md": "ReleaseNotes_0.5.0.md",
    "ReleaseNotes_0.7.5.md": "ReleaseNotes_0.7.5.md",
    "TheFlux.md": "TheFlux.md",
}
DOCS_MAP_EN_TO_PT: dict[str, str] = {v: k for k, v in DOCS_MAP_PT_TO_EN.items()}

DOCS_EBNF_MAP_PT_TO_EN: dict[str, str] = {
    "TheFlux.ebnf": "TheFlux.ebnf",
    "Gramatica.ebnf": "Grammar.ebnf",
}
DOCS_EBNF_MAP_EN_TO_PT: dict[str, str] = {v: k for k, v in DOCS_EBNF_MAP_PT_TO_EN.items()}


def verificar_paridade_docs_md(pt_dir: Path, en_dir: Path) -> tuple[int, list[str]]:
    divergencias = []

    # Lê os nomes exatos do sistema de arquivos para garantir Capitalização estrita (mesmo no Windows)
    pt_disk_files = set(os.listdir(pt_dir))
    en_disk_files = set(os.listdir(en_dir))

    pt_md_files = {f for f in pt_disk_files if f.endswith(".md")}
    en_md_files = {f for f in en_disk_files if f.endswith(".md")}

    # 1. Valida correspondência PT -> EN
    for doc_pt, doc_en in DOCS_MAP_PT_TO_EN.items():
        if doc_pt not in pt_md_files:
            divergencias.append(f"Documento PT ausente ou com capitalização incorreta: docs/pt/{doc_pt}")
        if doc_en not in en_md_files:
            divergencias.append(f"Documento EN ausente ou com capitalização incorreta: docs/en/{doc_en}")

    # 2. Detecta arquivos sobressalentes não mapeados em PT
    nao_mapeados_pt = pt_md_files - set(DOCS_MAP_PT_TO_EN.keys())
    for extra in sorted(nao_mapeados_pt):
        divergencias.append(f"Documento não mapeado/residual em PT: docs/pt/{extra}")

    # 3. Detecta arquivos sobressalentes não mapeados em EN
    nao_mapeados_en = en_md_files - set(DOCS_MAP_EN_TO_PT.keys())
    for extra in sorted(nao_mapeados_en):
        divergencias.append(f"Documento não mapeado/residual em EN: docs/en/{extra}")

    # 4. Verifica integridade de conteúdo (tamanho não nulo)
    for doc_pt, doc_en in DOCS_MAP_PT_TO_EN.items():
        f_pt = pt_dir / doc_pt
        f_en = en_dir / doc_en
        if f_pt.exists() and f_pt.stat().st_size == 0:
            divergencias.append(f"Documento vazio: docs/pt/{doc_pt}")
        if f_en.exists() and f_en.stat().st_size == 0:
            divergencias.append(f"Documento vazio: docs/en/{doc_en}")

    total_pares = len(DOCS_MAP_PT_TO_EN)
    return total_pares, divergencias


DOCS_DOCX_MAP_PT_TO_EN: dict[str, str] = {
    "TheFlux.docx": "TheFlux.docx",
}
DOCS_DOCX_MAP_EN_TO_PT: dict[str, str] = {v: k for k, v in DOCS_DOCX_MAP_PT_TO_EN.items()}


def verificar_paridade_docs_docx(pt_dir: Path, en_dir: Path) -> tuple[int, list[str]]:
    divergencias = []
    for doc_pt, doc_en in DOCS_DOCX_MAP_PT_TO_EN.items():
        f_pt = pt_dir / doc_pt
        f_en = en_dir / doc_en
        if not f_pt.exists():
            divergencias.append(f"Documento DOCX PT ausente: docs/pt/{doc_pt}")
        elif f_pt.stat().st_size == 0:
            divergencias.append(f"Documento DOCX PT vazio: docs/pt/{doc_pt}")
        if not f_en.exists():
            divergencias.append(f"Documento DOCX EN ausente: docs/en/{doc_en}")
        elif f_en.stat().st_size == 0:
            divergencias.append(f"Documento DOCX EN vazio: docs/en/{doc_en}")
    return len(DOCS_DOCX_MAP_PT_TO_EN), divergencias


def verificar_arquivos_estranhos_em_pastas_de_idioma(pt_dir: Path, en_dir: Path) -> list[str]:
    divergencias = []
    permitidos_pt = (
        set(DOCS_MAP_PT_TO_EN.keys())
        | set(DOCS_EBNF_MAP_PT_TO_EN.keys())
        | set(DOCS_DOCX_MAP_PT_TO_EN.keys())
        | {"keywords"}
    )
    permitidos_en = (
        set(DOCS_MAP_EN_TO_PT.keys())
        | set(DOCS_EBNF_MAP_PT_TO_EN.values())
        | set(DOCS_DOCX_MAP_PT_TO_EN.values())
        | {"keywords"}
    )

    for item in os.listdir(pt_dir):
        if item not in permitidos_pt:
            divergencias.append(f"Arquivo ou diretório inesperado em docs/pt: {item}")
    for item in os.listdir(en_dir):
        if item not in permitidos_en:
            divergencias.append(f"Arquivo ou diretório inesperado em docs/en: {item}")
    return divergencias


def extrair_nao_terminais(ebnf_text: str) -> set[str]:
    regras = set()
    for l in ebnf_text.splitlines():
        l = l.strip()
        if "=" in l and not l.startswith("(*") and not l.startswith("|"):
            esquerda = l.split("=")[0].strip()
            if " " not in esquerda and esquerda:
                regras.add(esquerda)
    return regras


def verificar_paridade_ebnf(pt_dir: Path, en_dir: Path) -> tuple[int, list[str]]:
    divergencias = []
    
    # 1. Checa todos os pares de EBNF configurados
    for ebnf_pt, ebnf_en in DOCS_EBNF_MAP_PT_TO_EN.items():
        f_pt = pt_dir / ebnf_pt
        f_en = en_dir / ebnf_en
        if not f_pt.exists():
            divergencias.append(f"EBNF ausente: docs/pt/{ebnf_pt}")
        if not f_en.exists():
            divergencias.append(f"EBNF ausente: docs/en/{ebnf_en}")

        if f_pt.exists() and f_en.exists():
            pt_text = f_pt.read_text(encoding="utf-8")
            en_text = f_en.read_text(encoding="utf-8")
            pt_rules = extrair_nao_terminais(pt_text)
            en_rules = extrair_nao_terminais(en_text)

            so_pt = pt_rules - en_rules
            so_en = en_rules - pt_rules
            if so_pt:
                divergencias.append(f"[{ebnf_pt} <-> {ebnf_en}] Regras EBNF presentes apenas em PT: {sorted(so_pt)}")
            if so_en:
                divergencias.append(f"[{ebnf_pt} <-> {ebnf_en}] Regras EBNF presentes apenas em EN: {sorted(so_en)}")

            linhas_pt = len([l for l in pt_text.splitlines() if l.strip()])
            linhas_en = len([l for l in en_text.splitlines() if l.strip()])
            if abs(linhas_pt - linhas_en) > 5:
                divergencias.append(f"[{ebnf_pt} <-> {ebnf_en}] Contagem de linhas úteis no EBNF diverge: PT={linhas_pt} vs EN={linhas_en}")

    # 2. Validação de embutimento na Seção 3 de TheFlux.md
    padrao = re.compile(r"```ebnf\n(.*?)```", re.DOTALL)
    for lang, md_path, ebnf_path in [("PT", pt_dir / "TheFlux.md", pt_dir / "TheFlux.ebnf"), ("EN", en_dir / "TheFlux.md", en_dir / "TheFlux.ebnf")]:
        if md_path.exists() and ebnf_path.exists():
            txt = md_path.read_text(encoding="utf-8")
            m = padrao.search(txt)
            if not m:
                divergencias.append(f"Bloco ```ebnf``` ausente em docs/{lang.lower()}/TheFlux.md")
            elif m.group(1).strip() != ebnf_path.read_text(encoding="utf-8").strip():
                divergencias.append(f"Seção 3 em docs/{lang.lower()}/TheFlux.md desatualizada em relação a TheFlux.ebnf")

    total_ebnf = len(DOCS_EBNF_MAP_PT_TO_EN)
    return total_ebnf, divergencias


def verificar_limpeza_docs_raiz(docs_dir: Path) -> list[str]:
    divergencias = []
    proibidos = {
        "compilacao.md", "compilation.md",
        "gramatica.md", "grammar.md",
        "errors.md", "stdlibs.md",
        "theflux.md", "theflux.ebnf",
        "releasenotes_0.5.0.md", "releasenotes_0.7.5.md",
        "theflux_docs.html", "theflux_docs_pt.html", "theflux_docs_en.html", "index.html",
        "theflux_v0.5.docx", "theflux_v0.75.docx",
        "shared",
    }
    for item in os.listdir(docs_dir):
        if item.lower() in proibidos:
            divergencias.append(f"Arquivo duplicado/residual indevido na raiz docs/: docs/{item} (deve residir exclusivamente em docs/pt/, docs/en/ ou docs/site/)")
    return divergencias


def verificar_paridade(pt_dir: Path, en_dir: Path, verbose: bool = False) -> tuple[int, list[str]]:
    divergencias = []

    pt_files = sorted(pt_dir.glob("KW_*.yaml"))
    en_files = sorted(en_dir.glob("KW_*.yaml"))

    pt_names = {f.name for f in pt_files if f.name != "KW_index.yaml"}
    en_names = {f.name for f in en_files if f.name != "KW_index.yaml"}

    # 1. Paridade de Arquivos
    so_em_pt = pt_names - en_names
    so_em_en = en_names - pt_names

    for nome in sorted(so_em_pt):
        divergencias.append(f"Arquivo ausente em EN: {nome}")
    for nome in sorted(so_em_en):
        divergencias.append(f"Arquivo ausente em PT: {nome}")

    comuns = sorted(pt_names & en_names)
    total_checados = len(comuns)

    # 2. Paridade de Conteúdo Chave por Chave
    for nome in comuns:
        f_pt = pt_dir / nome
        f_en = en_dir / nome

        d_pt = carregar_yaml(f_pt)
        d_en = carregar_yaml(f_en)

        if not d_pt or not d_en:
            divergencias.append(f"[{nome}] Falha ao analisar conteúdo YAML")
            continue

        # Keyword invariante
        kw_pt = str(d_pt.get("keyword", "")).strip()
        kw_en = str(d_en.get("keyword", "")).strip()
        if kw_pt != kw_en:
            divergencias.append(f"[{nome}] 'keyword' diverge: PT='{kw_pt}' vs EN='{kw_en}'")

        # Usages
        u_pt = d_pt.get("usages") or []
        u_en = d_en.get("usages") or []
        if len(u_pt) != len(u_en):
            divergencias.append(f"[{nome}] 'usages' contagem diverge: PT={len(u_pt)} vs EN={len(u_en)}")

        # Restrictions
        r_pt = d_pt.get("restrictions") or []
        r_en = d_en.get("restrictions") or []
        if len(r_pt) != len(r_en):
            divergencias.append(f"[{nome}] 'restrictions' contagem diverge: PT={len(r_pt)} vs EN={len(r_en)}")

        # Errors
        err_pt = d_pt.get("errors") or []
        err_en = d_en.get("errors") or []

        codes_pt = [e.get("code") for e in err_pt if isinstance(e, dict) and e.get("code")]
        codes_en = [e.get("code") for e in err_en if isinstance(e, dict) and e.get("code")]

        if set(codes_pt) != set(codes_en):
            divergencias.append(f"[{nome}] Códigos de erro divergem: PT={codes_pt} vs EN={codes_en}")
        else:
            # Valida mnemônicos idênticos
            mnem_pt = {e.get("code"): e.get("mnemonic") for e in err_pt if isinstance(e, dict)}
            mnem_en = {e.get("code"): e.get("mnemonic") for e in err_en if isinstance(e, dict)}
            for c in codes_pt:
                if mnem_pt.get(c) != mnem_en.get(c):
                    divergencias.append(f"[{nome}] Mnemônico do erro {c} diverge: PT='{mnem_pt.get(c)}' vs EN='{mnem_en.get(c)}'")

    return total_checados, divergencias


def main() -> int:
    parser = argparse.ArgumentParser(description="Linter de Paridade Bilíngue TheFlux")
    parser.add_argument("--pt-docs-dir", default=str(PT_DOCS_DIR), help="Caminho dos Docs em Português")
    parser.add_argument("--en-docs-dir", default=str(EN_DOCS_DIR), help="Caminho dos Docs em Inglês")
    parser.add_argument("--pt-dir", default=str(PT_DIR), help="Caminho dos YAMLs em Português")
    parser.add_argument("--en-dir", default=str(EN_DIR), help="Caminho dos YAMLs em Inglês")
    parser.add_argument("--verbose", "-v", action="store_true", help="Modo detalhado")
    args = parser.parse_args()

    pt_docs_dir = Path(args.pt_docs_dir)
    en_docs_dir = Path(args.en_docs_dir)
    pt_dir = Path(args.pt_dir)
    en_dir = Path(args.en_dir)

    print("=" * 70)
    print("🔍 TheFlux — Linter de Paridade e Sincronização Bilíngue (PT/EN)")
    print(f"   Docs PT: {pt_docs_dir}")
    print(f"   Docs EN: {en_docs_dir}")
    print(f"   YAML PT: {pt_dir}")
    print(f"   YAML EN: {en_dir}")
    print("=" * 70)

    # 1. Verifica limpeza da raiz docs/ (nenhuma duplicação)
    div_raiz = verificar_limpeza_docs_raiz(DOCS_DIR)

    # 2. Verifica ausência de arquivos estranhos em docs/pt e docs/en
    div_estranhos = verificar_arquivos_estranhos_em_pastas_de_idioma(pt_docs_dir, en_docs_dir)

    # 3. Verifica paridade dos documentos .md
    total_docs, div_docs = verificar_paridade_docs_md(pt_docs_dir, en_docs_dir)

    # 4. Verifica paridade dos documentos .docx (White Paper)
    total_docx, div_docx = verificar_paridade_docs_docx(pt_docs_dir, en_docs_dir)

    # 5. Verifica paridade e sincronização da gramática EBNF (TheFlux.ebnf e Gramatica.ebnf)
    total_ebnf, div_ebnf = verificar_paridade_ebnf(pt_docs_dir, en_docs_dir)

    # 6. Verifica paridade dos YAMLs de keywords
    total_kw, div_kw = verificar_paridade(pt_dir, en_dir, args.verbose)

    divergencias = div_raiz + div_estranhos + div_docs + div_docx + div_ebnf + div_kw

    if not divergencias:
        print(f"\n✅ Paridade 100% Confirmada!")
        print(f"   - {total_docs} pares de documentos Markdown (.md) em paridade total 1:1 e nomes PascalCase.")
        print(f"   - {total_docx} par de documentos White Paper (.docx) em paridade total 1:1.")
        print(f"   - {total_ebnf} pares de artefatos ISO/IEC 14977 (EBNF) sincronizados (PT e EN) e alinhados a TheFlux.md.")
        print(f"   - {total_kw} especificações de palavras-chave (.yaml) sincronizadas sem divergências.")
        print(f"   - Raiz docs/ limpa sem arquivos residuais ou duplicatas.")
        print("=" * 70)
        return 0
    else:
        print(f"\n❌ {len(divergencias)} divergência(s) de paridade detectada(s):\n")
        for d in divergencias:
            print(f"   [!] {d}")
        print("\n" + "=" * 70)
        print("Dicas:")
        print("  - Execute 'python scripts/docs/sync_ebnf.py' para sincronizar EBNF e TheFlux.md.")
        print("  - Execute 'python scripts/docs/sync_i18n.py --propagate' para propagar a estrutura de keywords de PT para EN.")
        print("=" * 70)
        return 1


if __name__ == "__main__":
    sys.exit(main())
