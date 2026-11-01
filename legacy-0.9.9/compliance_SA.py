"""Runner e validador de conformidade para a suíte de algoritmos científicos (SciAlgo).

Executado diretamente dentro de examples/SciAlgo/:
1. Copia compliance_SA00.md -> compliance_SA01.md como baseline.
2. Não retesta arquivos que já estejam 100% validados (6/6 OK) na tabela anterior (modo incremental).
3. Testa novos arquivos ou arquivos não validados nos 6 backends:
     in, vm, vmr, llvm, wat, wasm
4. Acrescenta na tabela os novos arquivos na sua respectiva categoria e em ordem alfabética.
5. Compara os resultados atuais com o OLD e reporta eventuais regressões no terminal e no MD.
6. A coluna de nome de arquivo reserva 77 caracteres úteis (+10 caracteres de margem).

Uso:
  python compliance_SA.py             # Modo incremental (pula validados, testa novos)
  python compliance_SA.py --force     # Força reteste de todos os arquivos
  python compliance_SA.py --filter X  # Testa apenas arquivos contendo 'X'
  python compliance_SA.py --no-md     # Apenas roda os testes sem alterar os arquivos .md
"""
from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

SCRIPT_DIR = Path(__file__).resolve().parent
RAIZ = SCRIPT_DIR if (SCRIPT_DIR / "src").exists() else SCRIPT_DIR.parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))
if str(RAIZ) not in sys.path:
    sys.path.insert(0, str(RAIZ))

try:
    import compliance_BE as bc
except ImportError:
    import backend_compliance as bc

ALGO_DIR = SCRIPT_DIR if (SCRIPT_DIR / "01_foundations").exists() else SCRIPT_DIR.parent / "examples" / "SciAlgo"
if not ALGO_DIR.exists():
    ALGO_DIR = RAIZ / "examples" / "SciAlgo"
COMPLIANCE_MD = SCRIPT_DIR / "compliance_SA00.md"
COMPLIANCE_OLD_MD = SCRIPT_DIR / "compliance_SA01.md"

COL_NAME_WIDTH = 77  # 67 + 10 caracteres adicionados para prevenir qualquer estouro de coluna

DOMAIN_TITLES = {
    "01_foundations": "Domínio I: Fundamentos, Busca e Ordenação (01_foundations)",
    "02_data_structures": "Domínio II: Estruturas de Dados Avançadas & Streaming (02_data_structures)",
    "03_graphs": "Domínio III: Teoria dos Grafos & Redes (03_graphs)",
    "04_strings": "Domínio IV: Strings, Texto & Teoria da Informação (04_strings)",
    "05_mathematics": "Domínio V: Matemática Computacional, Teoria dos Números & Álgebra (05_mathematics)",
    "06_numerical_physics": "Domínio VI: Métodos Numéricos, Geometria & Física Computacional (06_numerical_physics)",
    "07_optimization_stat": "Domínio VII: Otimização & Estatística Científica (07_optimization_stat)",
    "08_artificial_intel": "Domínio VIII: Inteligência Artificial, ML & Deep Learning (08_artificial_intel)",
    "09_systems_infra": "Domínio IX: Sistemas Computacionais, Compiladores & Infraestrutura (09_systems_infra)",
    "10_bio_quantum": "Domínio X: Bioinformática, Computação Quântica & Criptografia Pós-Quântica (10_bio_quantum)",
    "11_dsp_multimedia": "Domínio XI: Processamento Digital de Sinais (DSP), Áudio & Multimídia (11_dsp_multimedia)",
    "12_robotics_control": "Domínio XII: Robótica, Cinemática, Controle & Navegação (12_robotics_control)",
    "13_classical_crypto": "Domínio XIII: Criptografia Fundamental Clássica & Segurança (13_classical_crypto)",
}


def ler_tabela_md(md_path: Path) -> dict[str, dict[str, bool]]:
    """Lê um arquivo markdown de conformidade e extrai resultados por nome de arquivo e backend."""
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
    """Formata uma linha da tabela Markdown com 77 caracteres na coluna de nome."""
    cells = []
    for col in bc.COLS:
        icon = "✅" if linha.get(col, False) else "❌"
        cells.append(f"  {icon}  ")
    all_ok = all(linha.get(col, False) for col in bc.COLS)
    res_icon = "   ✅   " if all_ok else "   ❌   "
    return f"| {fname:<{COL_NAME_WIDTH}} |" + "|".join(cells) + f"|{res_icon}|\n"


def gerar_compliance_SA_md(
    results: dict[str, dict[str, bool]],
    all_flux_files: list[Path],
    old_results: dict[str, dict[str, bool]],
) -> list[tuple[str, dict[str, bool], dict[str, bool]]]:
    """Gera o arquivo compliance_SA00.md estruturado por categorias e com seção de regressão."""
    cat_files: dict[str, list[tuple[str, Path]]] = {}
    for path in all_flux_files:
        rel = path.resolve().relative_to(ALGO_DIR.resolve())
        cat_key = rel.parts[0] if len(rel.parts) > 1 else "geral"
        cat_files.setdefault(cat_key, []).append((path.name, path))

    header = (
        f"| {'arquivo':<{COL_NAME_WIDTH}} |  in   |  vm  |  vmr | llvm |  wat | wasm  | result |\n"
        f"| {'-' * COL_NAME_WIDTH} | ----- | ---- | ---- | ---- | ---- | ----- | ------ |\n"
    )

    linhas: list[str] = []
    totais = {c: 0 for c in bc.COLS}
    total_checks = 0
    total_checks_ok = 0
    total_arquivos = len(all_flux_files)

    for cat_key in sorted(cat_files.keys()):
        titulo = DOMAIN_TITLES.get(cat_key, f"Categoria {cat_key}")
        linhas.append(f"### Tabela de conformidade — {titulo}\n\n")
        linhas.append(header)

        for fname, path in sorted(cat_files[cat_key], key=lambda x: x[0].lower()):
            linha = results.get(fname, {c: False for c in bc.COLS})
            for col in bc.COLS:
                total_checks += 1
                if linha.get(col, False):
                    totais[col] += 1
                    total_checks_ok += 1

            linhas.append(formatar_linha_md(fname, linha))

        linhas.append("\n")

    # Sumário consolidado de backends
    linhas.append(f"-   IN : ✅  {totais['in']:>2} of  {total_arquivos:>2} — ✅\n")
    linhas.append(f"-   VM : ✅  {totais['vm']:>2} of  {total_arquivos:>2} — ✅\n")
    linhas.append(f"-  VMR : ✅  {totais['vmr']:>2} of  {total_arquivos:>2} — ✅\n")
    linhas.append(f"- LLVM : ✅  {totais['llvm']:>2} of  {total_arquivos:>2} — ✅\n")
    linhas.append(f"-  WAT : ✅  {totais['wat']:>2} of  {total_arquivos:>2} — ✅\n")
    linhas.append(f"- WASM : ✅  {totais['wasm']:>2} of  {total_arquivos:>2} — ✅\n")
    linhas.append(f"-  ALL : ✅  {total_checks_ok:>2} of  {total_checks:>2} — ✅\n\n")

    # --- Seção de Regressão ---
    regressoes: list[tuple[str, dict[str, bool], dict[str, bool]]] = []
    if old_results:
        for fname, linha_nova in results.items():
            if fname in old_results:
                linha_antiga = old_results[fname]
                if any(linha_antiga.get(c, False) and not linha_nova.get(c, False) for c in bc.COLS):
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
    """Executa o arquivo no interpretador AST de referência (in) e captura a saída."""
    return bc.run_interpreter(path, stdin_text)


def run_scientific_compliance(
    filter_arg: str | None = None,
    force: bool = False,
    write_md: bool = True,
) -> int:
    """Executa a verificação dos 6 backends para os algoritmos de SciAlgo."""
    # 1. Copia compliance_SA00.md -> compliance_SA01.md se existir
    if COMPLIANCE_MD.exists():
        try:
            shutil.copyfile(COMPLIANCE_MD, COMPLIANCE_OLD_MD)
            print(f"Baseline copiado: {COMPLIANCE_MD.name} -> {COMPLIANCE_OLD_MD.name}")
        except Exception:
            pass

    old_results = ler_tabela_md(COMPLIANCE_OLD_MD) if COMPLIANCE_OLD_MD.exists() else {}
    if not old_results and COMPLIANCE_MD.exists():
        old_results = ler_tabela_md(COMPLIANCE_MD)

    bc.limpar_t()
    for d in (bc.T_FVMBC, bc.T_LLVM, bc.T_WAT, bc.T_WASM):
        d.mkdir(parents=True, exist_ok=True)

    all_flux_files = sorted(ALGO_DIR.glob("**/*.flux"))
    target_files = all_flux_files
    if filter_arg:
        target_files = [f for f in target_files if filter_arg.lower() in f.name.lower()]
        print(f"Executando filtro '{filter_arg}': {len(target_files)} arquivo(s) selecionado(s)")

    if not target_files:
        print(f"Nenhum arquivo .flux encontrado em {ALGO_DIR}")
        return 0

    results: dict[str, dict[str, bool]] = {}
    outs: dict[str, dict[str, str | None]] = {}
    falhas = []
    pulados = 0
    testados = 0

    print()
    print("Iniciando verificação multi-backend...")

    for path in all_flux_files:
        fname = path.name

        # Se houver filtro ativo e o arquivo não for alvo do filtro, reaproveita resultado prévio se existir
        if filter_arg and path not in target_files:
            if fname in old_results:
                results[fname] = old_results[fname]
            continue

        # 2. Pula arquivos já 100% validados no baseline se não for --force
        if not force and fname in old_results and all(old_results[fname].get(c, False) for c in bc.COLS):
            results[fname] = old_results[fname]
            pulados += 1
            continue

        # Arquivo novo, com falha prévia ou selecionado para reteste
        testados += 1
        stdin_text = bc.obter_stdin_para_arquivo(path)
        print(f"  ⚡ Testando nos 6 backends: {fname}...")

        linha: dict[str, bool] = {}
        outs[fname] = {}

        ref = testar_arquivo_referencia(path, stdin_text)
        outs[fname]["in"] = ref
        for col in bc.COLS:
            if col == "in":
                linha[col] = ref is not None
            else:
                out = bc.BACKENDS[col](path, stdin_text)
                outs[fname][col] = out
                ref_norm = bc.normalizar_saida(ref.rstrip("\n")) if ref is not None else None
                out_norm = bc.normalizar_saida(out.rstrip("\n")) if out is not None else None
                ok = ref_norm is not None and out_norm is not None and out_norm == ref_norm
                linha[col] = ok
                if not ok:
                    falhas.append((fname, col, ref, out))
        results[fname] = linha

    # Sumário da rodada no console
    print("-" * 72)
    print(f"Arquivos processados: {len(results)} total | {testados} testados agora | {pulados} mantidos (já validados 6/6 OK)")
    print("-" * 72)

    col_w = {c: max(len(c), 3) for c in bc.COLS}
    larg = max(len(n) for n in results) if results else 10
    cab = "algoritmo".ljust(larg) + "  " + "  ".join(c.rjust(col_w[c]) for c in bc.COLS)
    print(cab)
    print("-" * len(cab))

    totais = {c: 0 for c in bc.COLS}
    for fname, linha in sorted(results.items()):
        cel = []
        for c in bc.COLS:
            if linha.get(c, False):
                totais[c] += 1
                cel.append(bc.GREEN.rjust(col_w[c] + 4))
            else:
                cel.append(bc.RED.rjust(col_w[c] + 4))
        print(fname.ljust(larg) + "    " + "    ".join(cel))
    print("-" * len(cab))

    ok_arquivos = sum(1 for linha in results.values() if all(linha.values()))
    print(f"Resultado Geral: {ok_arquivos}/{len(results)} arquivo(s) com todos os 6 backends OK")
    for c in bc.COLS:
        print(f"  {c}: {totais[c]}/{len(results)} OK")

    regressoes: list[tuple[str, dict[str, bool], dict[str, bool]]] = []
    if write_md:
        regressoes = gerar_compliance_SA_md(results, all_flux_files, old_results)
    else:
        if old_results:
            for fname, linha_nova in results.items():
                if fname in old_results:
                    linha_antiga = old_results[fname]
                    if any(linha_antiga.get(c, False) and not linha_nova.get(c, False) for c in bc.COLS):
                        regressoes.append((fname, linha_antiga, linha_nova))

    # Relatório de regressões no console
    print()
    if not old_results:
        print("Rastreamento de regressão: Nenhum baseline anterior para comparação.")
    elif regressoes:
        print(f"⚠️ ATENÇÃO: {len(regressoes)} regressão(ões) detectada(s) em relação ao baseline OLD:")
        for fname, l_old, l_new in regressoes:
            detalhes = [c for c in bc.COLS if l_old.get(c, False) and not l_new.get(c, False)]
            print(f"  ❌ {fname} regrediu nos backends: {', '.join(detalhes)}")
    else:
        print("Rastreamento de regressão: ✅ Nenhuma regressão detectada em relação ao compliance_SA01.md!")

    if falhas:
        print("\nFalhas detalhadas:")
        for fname, col, ref, out in falhas:
            print(f"\n❌ {fname} no backend [{col}]:")
            if ref is None:
                print("   Interpretador de referência falhou.")
            elif out is None:
                print(f"   Backend {col} falhou na execução/compilação.")
            else:
                for l in bc.diff_em_colunas(fname, col, ref, out):
                    print("  ", l)
        return 1

    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Testa e gera matriz de conformidade da suíte SciAlgo.")
    parser.add_argument("--filter", "-f", help="Filtra por substring no nome do arquivo", default=None)
    parser.add_argument("--force", action="store_true", help="Força o reteste de todos os arquivos, mesmo já validados")
    parser.add_argument("--no-md", action="store_true", help="Não atualiza o arquivo compliance_SA00.md")
    args = parser.parse_args()
    return run_scientific_compliance(filter_arg=args.filter, force=args.force, write_md=not args.no_md)


if __name__ == "__main__":
    sys.exit(main())
