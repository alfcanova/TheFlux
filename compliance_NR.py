"""Runner e validador de conformidade para a suíte Numerical Recipes v3 via Compilador Self-Hosted TheFlux.

Executado diretamente dentro de examples/NumericalRecipes/ ou da raiz do projeto:
1. Copia NumericalRecipes_selfhosted.md -> NumericalRecipes_selfhosted_OLD.md como baseline.
2. Não retesta arquivos que já estejam 100% validados (6/6 OK) na tabela anterior (modo incremental).
3. Testa novos arquivos ou arquivos não validados nos 6 backends via Compilador Self-Hosted:
     in, vm, vmr, llvm, wat, wasm
4. Acrescenta na tabela os novos arquivos no seu respectivo capítulo e em ordem alfabética.
5. Compara os resultados atuais com o OLD e reporta eventuais regressões no terminal e no MD.
6. A coluna de nome de arquivo reserva 77 caracteres úteis.

Uso:
  python NumericalRecipes_selfhosted.py             # Modo incremental (pula validados, testa novos)
  python NumericalRecipes_selfhosted.py --force     # Força reteste de todos os arquivos
  python NumericalRecipes_selfhosted.py --filter X  # Testa apenas arquivos contendo 'X'
  python NumericalRecipes_selfhosted.py --no-md     # Apenas roda os testes sem alterar os arquivos .md
"""
from __future__ import annotations

import argparse
import os
import shutil
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

SCRIPT_DIR = Path(__file__).resolve().parent
if (SCRIPT_DIR / "bin").exists() and (SCRIPT_DIR / "src").exists():
    RAIZ = SCRIPT_DIR
    NR_DIR = RAIZ / "examples" / "NumericalRecipes"
else:
    RAIZ = SCRIPT_DIR.parent.parent
    NR_DIR = SCRIPT_DIR

if str(RAIZ) not in sys.path:
    sys.path.insert(0, str(RAIZ))

os.chdir(RAIZ)

try:
    import compliance_BE as bsh
except ImportError:
    import backend_selfhosted as bsh

COMPLIANCE_MD = RAIZ / "compliance_NR00.md"
COMPLIANCE_OLD_MD = RAIZ / "compliance_NR01.md"

COL_NAME_WIDTH = 77

CHAPTER_TITLES = {
    "01_preliminaries": "Capítulo 01: Preliminares, Precisão de Máquina & Análise de Erro (01_preliminaries)",
    "02_linear_algebra": "Capítulo 02: Resolução de Sistemas de Equações Algébricas Lineares (02_linear_algebra)",
    "03_interpolation": "Capítulo 03: Interpolação e Extrapolação (03_interpolation)",
    "04_integration": "Capítulo 04: Integração Numérica de Funções (04_integration)",
    "05_function_evaluation": "Capítulo 05: Avaliação de Funções, Séries e Frações Contínuas (05_function_evaluation)",
    "06_special_functions": "Capítulo 06: Funções Especiais da Física Matemática (06_special_functions)",
    "07_random_numbers": "Capítulo 07: Geração de Números Aleatórios e Métodos de Monte Carlo (07_random_numbers)",
    "08_sorting_selection": "Capítulo 08: Algoritmos de Ordenação e Seleção Estatística (08_sorting_selection)",
    "09_root_finding": "Capítulo 09: Localização de Raízes e Sistemas de Equações Não-Lineares (09_root_finding)",
    "10_minimization": "Capítulo 10: Minimização e Maximização de Funções (10_minimization)",
    "11_eigensystems": "Capítulo 11: Sistemas de Autovalores e Autovetores (11_eigensystems)",
    "12_fast_fourier_transform": "Capítulo 12: Transformada Rápida de Fourier — FFT (12_fast_fourier_transform)",
    "13_fourier_spectral": "Capítulo 13: Aplicações Espectrais e Processamento de Sinais por Fourier (13_fourier_spectral)",
    "14_statistical_description": "Capítulo 14: Descrição Estatística de Dados (14_statistical_description)",
    "15_modeling_data": "Capítulo 15: Modelagem, Ajuste de Parâmetros e Teoria da Estimação (15_modeling_data)",
    "16_classification_inference": "Capítulo 16: Classificação, Agrupamento e Inferência Estatística (16_classification_inference)",
    "17_differential_equations": "Capítulo 17: Integração Numérica de EDOs (17_differential_equations)",
    "18_boundary_value_problems": "Capítulo 18: Problemas de Valor de Contorno em Dois Pontos — BVPs (18_boundary_value_problems)",
    "19_integral_equations": "Capítulo 19: Equações Integrais e Teoria Inversa (19_integral_equations)",
    "20_partial_differential_eqs": "Capítulo 20: Resolução Numérica de EDPs (20_partial_differential_eqs)",
    "21_computational_geometry": "Capítulo 21: Geometria Computacional (21_computational_geometry)",
    "22_less_numerical": "Capítulo 22: Algoritmos Discretos, Criptográficos e Menos Numéricos (22_less_numerical)",
}


def ler_tabela_md(md_path: Path) -> dict[str, dict[str, bool]]:
    if not md_path.exists():
        return {}
    res: dict[str, dict[str, bool]] = {}
    for line in md_path.read_text(encoding="utf-8").splitlines():
        line_s = line.strip()
        if not line_s.startswith("|") or line_s.startswith("| arquivo") or line_s.startswith("| -"):
            continue
        parts = [part.strip() for part in line_s.split("|")[1:-1]]
        if len(parts) >= 8 and parts[0].endswith(".flux"):
            nome = parts[0]
            res[nome] = {
                "in": "✅" in parts[1],
                "vm": "✅" in parts[2],
                "vmr": "✅" in parts[3],
                "llvm": "✅" in parts[4],
                "wat": "✅" in parts[5],
                "wasm": "✅" in parts[6],
            }
    return res


def formatar_linha_md(fname: str, linha: dict[str, bool]) -> str:
    cells = []
    for col in bsh.COLS:
        icon = "✅" if linha.get(col, False) else "❌"
        cells.append(f"  {icon}  ")
    all_ok = all(linha.get(col, False) for col in bsh.COLS)
    res_icon = "   ✅   " if all_ok else "   ❌   "
    return f"| {fname:<{COL_NAME_WIDTH}} |" + "|".join(cells) + f"|{res_icon}|\n"


def gerar_nr_compliance_md(
    results: dict[str, dict[str, bool]],
    all_flux_files: list[Path],
    old_results: dict[str, dict[str, bool]],
) -> list[tuple[str, dict[str, bool], dict[str, bool]]]:
    cat_files: dict[str, list[tuple[str, Path]]] = {}
    for path in all_flux_files:
        rel = path.resolve().relative_to(NR_DIR.resolve())
        cat_key = rel.parts[0] if len(rel.parts) > 1 else "geral"
        cat_files.setdefault(cat_key, []).append((path.name, path))

    header = (
        f"| {'arquivo':<{COL_NAME_WIDTH}} |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |\n"
        f"| {'-' * COL_NAME_WIDTH} | ----- | ---- | ---- | ---- | ---- | ----- | ------ |\n"
    )

    linhas: list[str] = [
        "# 📊 Tabela de Conformidade Multi-Backend: Numerical Recipes v3 (Self-Hosted Compiler)\n\n",
        "> **Compilador**: TheFlux Self-Hosted Compiler v1.0.0\n",
        "> **Suíte**: `examples/NumericalRecipes/` (22 capítulos clássicos)\n",
        "> **Backends**: `in` (AST interpretado), `vm` (FVM Bytecode), `vmr` (FVM Reloaded), `llvm` (LLVM nativo), `wat` (WebAssembly Text), `wasm` (WebAssembly Binário)\n\n",
    ]
    totais = {c: 0 for c in bsh.COLS}
    total_checks = 0
    total_checks_ok = 0
    total_arquivos = len(all_flux_files)

    for cat_key in sorted(cat_files.keys()):
        titulo = CHAPTER_TITLES.get(cat_key, f"Capítulo {cat_key}")
        linhas.append(f"### Tabela de conformidade — {titulo}\n\n")
        linhas.append(header)

        for fname, path in sorted(cat_files[cat_key], key=lambda x: x[0].lower()):
            linha = results.get(fname, {c: False for c in bsh.COLS})
            for col in bsh.COLS:
                total_checks += 1
                if linha.get(col, False):
                    totais[col] += 1
                    total_checks_ok += 1

            linhas.append(formatar_linha_md(fname, linha))

        linhas.append("\n\n\n")

    linhas.append("## 📈 Sumário Consolidado de Backends\n\n")
    linhas.append(f"-   IN : ✅  {totais['in']:>3} of  {total_arquivos:>3} — ✅\n")
    linhas.append(f"-   VM : ✅  {totais['vm']:>3} of  {total_arquivos:>3} — ✅\n")
    linhas.append(f"-  VMR : ✅  {totais['vmr']:>3} of  {total_arquivos:>3} — ✅\n")
    linhas.append(f"- LLVM : ✅  {totais['llvm']:>3} of  {total_arquivos:>3} — ✅\n")
    linhas.append(f"-  WAT : ✅  {totais['wat']:>3} of  {total_arquivos:>3} — ✅\n")
    linhas.append(f"- WASM : ✅  {totais['wasm']:>3} of  {total_arquivos:>3} — ✅\n")
    linhas.append(f"-  ALL : ✅  {total_checks_ok:>3} of  {total_checks:>3} — ✅\n\n\n\n")

    regressoes: list[tuple[str, dict[str, bool], dict[str, bool]]] = []
    if old_results:
        for fname, linha_nova in results.items():
            if fname in old_results:
                linha_antiga = old_results[fname]
                if any(linha_antiga.get(c, False) and not linha_nova.get(c, False) for c in bsh.COLS):
                    regressoes.append((fname, linha_antiga, linha_nova))

    linhas.append("### Regressão:\n\n")
    if regressoes:
        linhas.append(header)
        for fname, l_old, l_new in regressoes:
            linhas.append(formatar_linha_md(f"{fname} (OLD)", l_old))
            linhas.append(formatar_linha_md(f"{fname} (NEW)", l_new))
        linhas.append("\n")
    else:
        linhas.append("Nenhuma regressão detectada.\n")

    COMPLIANCE_MD.parent.mkdir(parents=True, exist_ok=True)
    with open(COMPLIANCE_MD, "w", encoding="utf-8") as f:
        f.writelines(linhas)

    print(f"\n📄 Tabela de conformidade atualizada em:\n   {COMPLIANCE_MD}")
    return regressoes


def testar_arquivo_referencia(path: Path, stdin_text: str = "") -> str | None:
    return bsh.saida_interp(path, stdin_text)


def run_nr_compliance(
    filter_arg: str | None = None,
    force: bool = False,
    write_md: bool = True,
    compiler_path: str | None = None,
) -> int:
    if compiler_path:
        bsh.COMPILER_CMD = bsh.resolver_compilador_selfhosted(compiler_path)

    if COMPLIANCE_MD.exists():
        try:
            shutil.copyfile(COMPLIANCE_MD, COMPLIANCE_OLD_MD)
            print(f"Baseline copiado: {COMPLIANCE_MD.name} -> {COMPLIANCE_OLD_MD.name}")
        except Exception:
            pass

    old_results = ler_tabela_md(COMPLIANCE_OLD_MD) if COMPLIANCE_OLD_MD.exists() else {}
    if not old_results and COMPLIANCE_MD.exists():
        old_results = ler_tabela_md(COMPLIANCE_MD)
    if not old_results and (NR_DIR / "NumericalRecipes.md").exists():
        old_results = ler_tabela_md(NR_DIR / "NumericalRecipes.md")

    bsh.limpar_t()
    for d in (bsh.T_FVMBC, bsh.T_LLVM, bsh.T_WAT, bsh.T_WASM):
        d.mkdir(parents=True, exist_ok=True)

    all_flux_files = sorted(NR_DIR.glob("**/*.flux"))
    target_files = all_flux_files
    if filter_arg:
        target_files = [f for f in target_files if filter_arg.lower() in f.name.lower()]
        print(f"Executando filtro '{filter_arg}': {len(target_files)} arquivo(s) selecionado(s)")

    if not target_files:
        print(f"Nenhum arquivo .flux encontrado em {NR_DIR}")
        return 0

    results: dict[str, dict[str, bool]] = {}
    outs: dict[str, dict[str, str | None]] = {}
    falhas = []
    pulados = 0
    testados = 0

    print()
    print(f"Iniciando verificação multi-backend de {len(all_flux_files)} algoritmos do Numerical Recipes (Self-Hosted)...")

    for path in all_flux_files:
        fname = path.name

        if filter_arg and path not in target_files:
            if fname in old_results:
                results[fname] = old_results[fname]
            continue

        if not force and fname in old_results and all(old_results[fname].get(c, False) for c in bsh.COLS):
            results[fname] = old_results[fname]
            pulados += 1
            continue

        testados += 1
        stdin_text = bsh.stdin_para(path)

        linha: dict[str, bool] = {}
        outs[fname] = {}

        ref = testar_arquivo_referencia(path, stdin_text)
        outs[fname]["in"] = ref
        for col in bsh.COLS:
            if col == "in":
                linha[col] = ref is not None
            else:
                out = bsh.BACKENDS[col](path, stdin_text)
                outs[fname][col] = out
                ref_norm = bsh.normalizar_saida(ref.rstrip("\n")) if ref is not None else None
                out_norm = bsh.normalizar_saida(out.rstrip("\n")) if out is not None else None
                ok = ref_norm is not None and out_norm is not None and out_norm == ref_norm
                linha[col] = ok
                if not ok:
                    falhas.append((fname, col, ref, out))
        results[fname] = linha
        if testados % 10 == 0 or testados == len(target_files):
            print(f"  ⚡ Processados: {testados}/{len(target_files)} algoritmos...")

    print("-" * 72)
    print(f"Arquivos processados: {len(results)} total | {testados} testados agora | {pulados} mantidos (já validados 6/6 OK)")
    print("-" * 72)

    col_w = {c: max(len(c), 3) for c in bsh.COLS}
    larg = max(len(n) for n in results) if results else 10
    cab = "algoritmo".ljust(larg) + "  " + "  ".join(c.rjust(col_w[c]) for c in bsh.COLS)
    print(cab)
    print("-" * len(cab))

    totais = {c: 0 for c in bsh.COLS}
    for fname, linha in sorted(results.items()):
        cel = []
        for c in bsh.COLS:
            if linha.get(c, False):
                totais[c] += 1
                cel.append(bsh.GREEN.rjust(col_w[c] + 4))
            else:
                cel.append(bsh.RED.rjust(col_w[c] + 4))
        print(fname.ljust(larg) + "    " + "    ".join(cel))
    print("-" * len(cab))

    ok_arquivos = sum(1 for linha in results.values() if all(linha.values()))
    print(f"Resultado Geral: {ok_arquivos}/{len(results)} arquivo(s) com todos os 6 backends OK")
    for c in bsh.COLS:
        print(f"  {c}: {totais[c]}/{len(results)} OK")

    regressoes: list[tuple[str, dict[str, bool], dict[str, bool]]] = []
    if write_md:
        regressoes = gerar_nr_compliance_md(results, all_flux_files, old_results)

    if regressoes:
        print(f"\n⚠️  ATENÇÃO: {len(regressoes)} regressão(ões) detectada(s)!")
        return 1
    else:
        print("\nRastreamento de regressão: ✅ Nenhuma regressão detectada!")

    return 0 if ok_arquivos == len(results) else 1


def main():
    parser = argparse.ArgumentParser(description="Validador de conformidade multi-backend para Numerical Recipes v3 via Compilador Self-Hosted")
    parser.add_argument("--filter", "-f", type=str, default=None, help="Filtra arquivos por substring no nome")
    parser.add_argument("--force", action="store_true", help="Força reteste de todos os arquivos, mesmo os 100%% OK")
    parser.add_argument("--no-md", action="store_true", help="Não regera o arquivo NumericalRecipes_selfhosted.md")
    parser.add_argument("--compiler", type=str, default=None, help="Caminho customizado do compilador self-hosted")
    args = parser.parse_args()

    rc = run_nr_compliance(filter_arg=args.filter, force=args.force, write_md=not args.no_md, compiler_path=args.compiler)
    sys.exit(rc)


if __name__ == "__main__":
    main()
