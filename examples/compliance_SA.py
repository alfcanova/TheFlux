"""Runner e validador de conformidade self-hosted para Numerical Recipes v3 em TheFlux.

Executa os exemplos em `examples/NumericalRecipes/` nas 5 colunas agregadas
(`in`, `vm` [vm+vmr], `llvm`, `wat` [wat+watr], `was` [was+wasr]) + `result`,
compara com o baseline fixo `examples/00_Standarts/compliance_NR00.md` e gera
`examples/00_Standarts/compliance_NR01.md` com relatorio de regressao.

Uso:
  python examples/compliance_NR.py             # Modo incremental (baseado em NR01.md)
  python examples/compliance_NR.py --force     # Forca reteste de todos os arquivos
  python examples/compliance_NR.py --filter X  # Testa apenas arquivos contendo 'X'
  python examples/compliance_NR.py --jobs N    # Executa com N workers em paralelo
  python examples/compliance_NR.py --no-md     # Apenas roda os testes sem gravar .md
"""
from __future__ import annotations

import os
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", line_buffering=True)
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8", line_buffering=True)

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

import compliance_CA as bc

os.chdir(bc.RAIZ)

NR_DIR = bc.EXAMPLES_DIR / "ScientificAlgorithms"
COMPLIANCE_BASE_MD = bc.STANDARTS_DIR / "compliance_SA00.md"
COMPLIANCE_OUT_MD = bc.STANDARTS_DIR / "compliance_SA01.md"

COL_NAME_WIDTH = 77

CHAPTER_TITLES = {
    "01_foundations": "Fundamentos",
    "02_data_structures": "Estruturas de dados",
    "03_graphs": "Grafos",
    "04_strings": "Cadeias de caracteres",
    "05_mathematics": "Matemática",
    "06_numerical_physics": "Física numérica",
    "07_optimization_stat": "Otimização estatística",
    "08_artificial_intel": "Inteligência artificial",
    "09_systems_infra": "Sistemas de equações",
    "10_bio_quantum": "Biologia quantica",
    "11_dsp_multimedia": "Processamento digital de sinais",
    "12_robotics_control": "Robótica de controle",
    "13_classical_crypto": "Crypto classica",
}

ler_tabela_md = bc.ler_tabela_md


def formatar_linha_md(fname: str, linha: dict[str, bool]) -> str:
    """Formata uma linha da tabela Markdown com 77 caracteres na coluna de nome."""
    return bc.formatar_linha_md_agrupada(fname, linha, COL_NAME_WIDTH)


def testar_arquivo_referencia(path: Path, stdin_text: str = "") -> str | None:
    """Executa o arquivo no interpretador AST de referencia (`in`) e captura a saida."""
    return bc.saida_interp(path, stdin_text)


SUITE_CONFIG = bc.GroupedSuiteConfig(
    suite_name="nr",
    suite_label="Numerical Recipes (22 capítulos)",
    suite_dir=NR_DIR,
    base_md=COMPLIANCE_BASE_MD,
    out_md=COMPLIANCE_OUT_MD,
    category_titles=CHAPTER_TITLES,
    fallback_prefix="Capítulo",
    col_name_width=COL_NAME_WIDTH,
    md_header_lines=(
        "# 📊 Tabela de Conformidade Multi-Backend: Numerical Recipes v3\n\n",
        "> **Suíte**: `examples/NumericalRecipes/` (22 capítulos clássicos)\n",
        "> **Colunas**: `in` (AST interpretado), `vm` (`vm` + `vmr`), `llvm` (LLVM nativo), `wat` (`wat` + `watr`), `was` (`was` + `wasr`), `result`\n\n",
    ),
    trailing_group_blank_lines=3,
    include_consolidated_heading=True,
    summary_blank_lines=2,
    show_progress_per_item=True,
)


def run_nr_compliance(
    filter_arg: str | None = None,
    force: bool = False,
    write_md: bool = True,
    jobs: int = 1,
) -> int:
    """Executa a verificacao dos 5 backends agregados para Numerical Recipes."""
    return bc.executar_suite_agrupada(
        SUITE_CONFIG,
        filter_arg=filter_arg,
        force=force,
        write_md=write_md,
        jobs=jobs,
    )


def main() -> int:
    parser = bc.criar_parser_suite(
        "Validador de conformidade multi-backend self-hosted para Numerical Recipes v3",
        COMPLIANCE_OUT_MD.name,
    )
    args = parser.parse_args()
    return run_nr_compliance(
        filter_arg=args.filter,
        force=args.force,
        write_md=not args.no_md,
        jobs=max(1, args.jobs),
    )


if __name__ == "__main__":
    raise SystemExit(main())
