"""Executa cada arquivo .flux em legacy e selfhosted, exibe as saidas lado a lado
na tela, aguarda a avaliacao do usuario — (C)erto ou (E)rrado — e atualiza a
tabela e a secao de erros ao final da tela e do arquivo compliance_in.md.

Tambem regenera docs/legacy_in.txt e docs/selfhosted_in.txt.

Uso:
    python compliance_in.py [filtro]
"""
from __future__ import annotations

import difflib
import io
import json
import os
import re
import subprocess
import sys
import unicodedata
from contextlib import redirect_stdout, redirect_stderr
from pathlib import Path

os.environ["FLUX_CI"] = "1"
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

RAIZ = Path(__file__).resolve().parent
SRC = RAIZ / "src"
LEGACY_SRC = RAIZ / "legacy" / "src"
FLUX_DIR = RAIZ / "flux"
DOCS_DIR = RAIZ / "docs"
LEGACY_TXT = DOCS_DIR / "legacy_in.txt"
SELFHOSTED_TXT = DOCS_DIR / "selfhosted_in.txt"
MD_PATH = RAIZ / "compliance_in.md"

if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

from flux_proto.cli import main as run_selfhosted_flux  # noqa: E402

GREEN = "\033[92m✓ CERTO\033[0m"
RED = "\033[91m✗ ERRADO\033[0m"
CYAN = "\033[96m"
YELLOW = "\033[93m"
RESET = "\033[0m"
MD_GREEN = "\U0001f7e2"
MD_RED = "\U0001f534"

STDIN_MAP: dict[str, str] = {
    "input.flux": "dado\n",
    "ExampleOfInput.flux": "Ana\n30\n9.99\ntrue\nA\n2+3i\n2026-08-28T12:00:00Z\n",
    "ExampleOfUseIoStdLib_IoInputContract.flux": "andre\nluiz\n",
}

EXPECT_ERROR_RE = re.compile(r"^#L\s+EXPECT_ERROR:\s*([A-Z]{2,4}\d{3})", re.MULTILINE)


def obter_erro_esperado(path: Path) -> str | None:
    if not path.name.startswith("ExampleOfError"):
        return None
    try:
        m = EXPECT_ERROR_RE.search(path.read_text(encoding="utf-8"))
        return m.group(1).upper() if m else None
    except Exception:
        return None


def erro_esperado_obtido(expected_code: str | None, ec: int, texto_erro: str) -> bool:
    if not expected_code or ec == 0:
        return False
    return (f"[{expected_code} - " in texto_erro) and ("💡 Dica:" in texto_erro)


# Script do worker persistente para executar o compilador legacy sem overhead de startup
_LEGACY_WORKER_CODE = r"""
import io, json, os, re, sys
from contextlib import redirect_stdout, redirect_stderr
from pathlib import Path
os.environ["FLUX_CI"] = "1"
sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")
from flux_proto.cli import main as run_flux

EXPECT_ERROR_RE = re.compile(r"^#L\s+EXPECT_ERROR:\s*([A-Z]{2,4}\d{3})", re.MULTILINE)

def obter_erro_esperado(p: Path) -> str | None:
    if not p.name.startswith("ExampleOfError"):
        return None
    try:
        m = EXPECT_ERROR_RE.search(p.read_text(encoding="utf-8"))
        return m.group(1).upper() if m else None
    except Exception:
        return None

real_stdout = sys.stdout
for raw in sys.stdin:
    req = json.loads(raw)
    path = req["path"]
    p_obj = Path(path)
    expected_code = obter_erro_esperado(p_obj)
    stdin_input = req["stdin"]
    old_stdin = sys.stdin
    sys.stdin = io.StringIO(stdin_input)
    out = io.StringIO()
    err = io.StringIO()
    try:
        with redirect_stdout(out), redirect_stderr(err):
            try:
                ec = run_flux([path])
            except SystemExit as se:
                ec = se.code if isinstance(se.code, int) else (0 if se.code is None else 1)
        output = out.getvalue()
        err_output = (err.getvalue() or output).strip()
        lines = []
        if ec == 0 and not expected_code:
            status = "OK"
            if output.strip():
                for linha in output.splitlines():
                    lines.append(f"  | {linha}")
            lines.append(f"  OK  {os.path.basename(path)}")
        elif expected_code and ec != 0 and (f"[{expected_code} - " in err_output) and ("💡 Dica:" in err_output):
            status = "OK"
            for linha in err_output.splitlines():
                lines.append(f"  | {linha}")
            lines.append(f"  OK  {os.path.basename(path)}")
        else:
            status = "FALHA"
            error_msg = err_output.split("\n")[-1] if err_output else f"esperava erro {expected_code}"
            lines.append(f"FALHA  {os.path.basename(path)}: {error_msg}")
    except Exception as exc:
        status = "FALHA"
        lines = [f"FALHA  {os.path.basename(path)}: {exc}"]
    finally:
        sys.stdin = old_stdin
    real_stdout.write(json.dumps({"status": status, "lines": lines}, ensure_ascii=False) + "\n")
    real_stdout.flush()
"""


class LegacyRunner:
    """Mantem um processo Python dedicado com PYTHONPATH=legacy/src, ou usa docs/legacy_in.txt se legacy/ nao existir."""

    def __init__(self) -> None:
        self.proc: subprocess.Popen[str] | None = None
        self.cached: dict[str, tuple[str, list[str]]] = {}
        if LEGACY_SRC.exists():
            env = dict(
                os.environ,
                PYTHONPATH=str(LEGACY_SRC),
                FLUX_CI="1",
                PYTHONUTF8="1",
                PYTHONIOENCODING="utf-8",
            )
            self.proc = subprocess.Popen(
                [sys.executable, "-c", _LEGACY_WORKER_CODE],
                cwd=str(RAIZ),
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True,
                encoding="utf-8",
                env=env,
            )
        elif LEGACY_TXT.exists():
            cur: list[str] = []
            for ln in LEGACY_TXT.read_text(encoding="utf-8", errors="replace").splitlines():
                if ln.startswith("  OK  ") or ln.startswith("FALHA  "):
                    partes = ln.split()
                    st = partes[0]
                    nm = partes[1].rstrip(":")
                    self.cached[nm] = (st, list(cur) + [ln])
                    cur = []
                elif ln.startswith("  | "):
                    cur.append(ln)

    def run_file(self, path: Path, stdin_input: str) -> tuple[str, list[str]]:
        if self.proc is None:
            return self.cached.get(path.name, ("FALHA", [f"FALHA  {path.name}: ausente em docs/legacy_in.txt"]))
        assert self.proc.stdin is not None and self.proc.stdout is not None
        payload = json.dumps({"path": str(path), "stdin": stdin_input}, ensure_ascii=False)
        self.proc.stdin.write(payload + "\n")
        self.proc.stdin.flush()
        resp_line = self.proc.stdout.readline()
        if not resp_line:
            return "FALHA", [f"FALHA  {path.name}: legacy worker encerrado"]
        data = json.loads(resp_line)
        return str(data["status"]), list(data["lines"])

    def close(self) -> None:
        try:
            if self.proc and self.proc.stdin:
                self.proc.stdin.close()
            if self.proc:
                self.proc.terminate()
        except Exception:
            pass


def limpar_scratch_dbs() -> None:
    """Remove bancos temporarios em scratch/ para garantir execucao deterministica."""
    for base in (RAIZ, RAIZ / "legacy"):
        scratch = base / "scratch"
        if scratch.exists():
            for pat in (
                "flux_*.db*",
                "flux_*.kv",
                "flux_*.unqlite",
                "flux_*.duckdb",
                "flux_*.kuzu",
                "flux_*.obx",
            ):
                for f in scratch.glob(pat):
                    try:
                        f.unlink()
                    except Exception:
                        pass


def executar_selfhosted(path: Path, stdin_input: str) -> tuple[str, list[str]]:
    """Executa um arquivo .flux no compilador selfhosted (src) e formata como exemplos_in.py."""
    nome = path.name
    expected_code = obter_erro_esperado(path)
    old_stdin = sys.stdin
    sys.stdin = io.StringIO(stdin_input)
    out = io.StringIO()
    err = io.StringIO()
    try:
        with redirect_stdout(out), redirect_stderr(err):
            try:
                ec = run_selfhosted_flux([str(path)])
            except SystemExit as se:
                ec = se.code if isinstance(se.code, int) else (0 if se.code is None else 1)
        output = out.getvalue()
        err_output = (err.getvalue() or output).strip()
        lines: list[str] = []
        if ec == 0 and not expected_code:
            status = "OK"
            if output.strip():
                for linha in output.splitlines():
                    lines.append(f"  | {linha}")
            lines.append(f"  OK  {nome}")
        elif erro_esperado_obtido(expected_code, ec, err_output):
            status = "OK"
            for linha in err_output.splitlines():
                lines.append(f"  | {linha}")
            lines.append(f"  OK  {nome}")
        else:
            status = "FALHA"
            error_msg = err_output.split("\n")[-1] if err_output else f"esperava erro {expected_code}"
            lines.append(f"FALHA  {nome}: {error_msg}")
    except Exception as exc:
        status = "FALHA"
        lines = [f"FALHA  {nome}: {exc}"]
    finally:
        sys.stdin = old_stdin
    return status, lines


def _largura_char(ch: str) -> int:
    if unicodedata.combining(ch):
        return 0
    cat = unicodedata.category(ch)
    if cat in ("Cc", "Cf"):
        return 0
    if unicodedata.east_asian_width(ch) in ("W", "F"):
        return 2
    return 1


def _largura_visual(texto: str) -> int:
    return sum(_largura_char(c) for c in texto)


def formatar_celula(texto: str, largura: int) -> str:
    limpo = texto.replace("\r", "").expandtabs(4)
    larg_total = _largura_visual(limpo)
    if larg_total <= largura:
        return limpo + (" " * (largura - larg_total))

    alvo = max(0, largura - 3)
    acum = 0
    partes: list[str] = []
    for ch in limpo:
        w = _largura_char(ch)
        if acum + w > alvo:
            break
        partes.append(ch)
        acum += w
    truncado = "".join(partes) + "..."
    faltam = largura - (acum + 3)
    return truncado + (" " * max(0, faltam))


def exibir_saida_lado_a_lado(
    idx: int,
    total: int,
    nome: str,
    linhas_leg: list[str],
    linhas_sh: list[str],
    col_w: int = 58,
) -> None:
    """1) Exibe as saidas em tela lado (legacy) a lado (selfhosted)."""
    sep_len = col_w * 2 + 5
    print()
    print("=" * sep_len)
    print(f"{CYAN}[{idx}/{total}] Arquivo: {nome}{RESET}")
    print("-" * sep_len)
    print(f"{'LEGACY (legacy/exemplos_in.py)':<{col_w}} | {'SELFHOSTED (exemplos_in.py)':<{col_w}}")
    print("-" * sep_len)

    max_linhas = max(len(linhas_leg), len(linhas_sh))
    for i in range(max_linhas):
        esq = linhas_leg[i] if i < len(linhas_leg) else ""
        dir_ = linhas_sh[i] if i < len(linhas_sh) else ""
        print(f"{formatar_celula(esq, col_w)} | {formatar_celula(dir_, col_w)}")
    print("=" * sep_len)


def ler_opcao_usuario(nome: str) -> str:
    """2) e 3) Aguarda um input do usuario: (C)erto ou (E)rrado."""
    prompt = f"{YELLOW}Avaliação para {nome} — Tecle (C)erto ou (E)rrado [C/E]: {RESET}"
    # Se estiver em terminal interativo no Windows, permite teclar C ou E diretamente
    if sys.stdin.isatty() and os.name == "nt":
        import msvcrt

        sys.stdout.write(prompt)
        sys.stdout.flush()
        while True:
            ch = msvcrt.getwch()
            if ch == "\x03":  # Ctrl+C
                print()
                raise KeyboardInterrupt
            if ch in ("\r", "\n", " ", "\t"):
                continue
            up = ch.upper()
            if up in ("C", "E"):
                label = "CERTO (C)" if up == "C" else "ERRADO (E)"
                print(label)
                return up
    else:
        while True:
            sys.stdout.write(prompt)
            sys.stdout.flush()
            linha = sys.stdin.readline()
            if not linha:
                # Fim de stream em modo redirecionado
                print("C (EOF)")
                return "C"
            up = linha.strip().lstrip("\ufeff").upper()
            if up in ("C", "CERTO", "E", "ERRADO"):
                escolha = "C" if up.startswith("C") else "E"
                label = "CERTO (C)" if escolha == "C" else "ERRADO (E)"
                print(label)
                return escolha
            print("Entrada inválida. Por favor, tecle C para (C)erto ou E para (E)rrado.")


def salvar_txt_regenerado(
    destino: Path,
    registros: list[tuple[str, str, list[str]]],
) -> None:
    """Salva o arquivo no formato exato de docs/legacy_in.txt e docs/selfhosted_in.txt."""
    DOCS_DIR.mkdir(parents=True, exist_ok=True)
    acertos = sum(1 for _, st, _ in registros if st == "OK")
    erros = sum(1 for _, st, _ in registros if st != "OK")
    todas_linhas: list[str] = []
    for _, _, lines in registros:
        todas_linhas.extend(lines)
    todas_linhas.append("")
    todas_linhas.append(f"{acertos} sucesso, {erros} falha(s)")
    destino.write_text("\n".join(todas_linhas) + "\n", encoding="utf-8")


def gerar_relatorio_md(
    avaliacoes: list[dict[str, object]],
) -> None:
    """4) e 5) Atualiza a tabela e imprime os erros ao final de compliance_in.md conforme entrada (E)."""
    total = len(avaliacoes)
    certos = sum(1 for a in avaliacoes if a["escolha"] == "C")
    errados = sum(1 for a in avaliacoes if a["escolha"] == "E")

    pos_items = [a for a in avaliacoes if not str(a["nome"]).startswith("ExampleOfError")]
    err_items = [a for a in avaliacoes if str(a["nome"]).startswith("ExampleOfError")]
    pos_ok = sum(1 for a in pos_items if a["escolha"] == "C")
    err_ok = sum(1 for a in err_items if a["escolha"] == "C")

    linhas: list[str] = [
        "# Relatório de Conformidade Interativo (`legacy` vs `selfhosted`)",
        "",
        "- **Fonte Legacy**: `docs/legacy_in.txt` (`legacy/exemplos_in.py`)",
        "- **Fonte Selfhosted**: `docs/selfhosted_in.txt` (`exemplos_in.py`)",
        "",
        "## 📊 Resumo da Avaliação do Usuário",
        "",
        f"- **Total de Arquivos Avaliados**: `{total}`",
        f"- **Marcados como (C)erto**: {MD_GREEN if certos == total else MD_RED} **`{certos}/{total}`**",
        f"- **Marcados como (E)rrado**: `{errados}/{total}`",
        f"- **Programas Regulares Certos**: `{pos_ok}/{len(pos_items)}`",
        f"- **Diagnósticos e Erros (`ExampleOfError_*`) Certos**: `{err_ok}/{len(err_items)}`",
        "",
        "## 📋 Tabela de Conformidade (Atualizada pela Entrada `C`/`E`)",
        "",
        "| Arquivo | Status Legacy | Status Selfhosted | Avaliação (`C`/`E`) | Resultado |",
        "| :--- | :---: | :---: | :---: | :---: |",
    ]

    for a in avaliacoes:
        nome = str(a["nome"])
        st_leg = str(a["status_leg"])
        st_sh = str(a["status_sh"])
        esc = str(a["escolha"])
        res_md = "✅ CERTO" if esc == "C" else "❌ ERRADO"
        linhas.append(f"| `{nome}` | `{st_leg}` | `{st_sh}` | **`{esc}`** | {res_md} |")

    erros_marcados = [a for a in avaliacoes if a["escolha"] == "E"]
    linhas.append("")
    linhas.append("## ❌ Erros Assinalados pelo Usuário (`E`)")
    linhas.append("")

    if not erros_marcados:
        linhas.append("> ✅ **Nenhum arquivo foi assinalado como `(E)rrado`.** Todos os testes foram validados como `(C)erto`.")
    else:
        for a in erros_marcados:
            nome = str(a["nome"])
            l_leg = list(a["linhas_leg"])  # type: ignore[arg-type]
            l_sh = list(a["linhas_sh"])  # type: ignore[arg-type]
            linhas.append(f"### ❌ `{nome}` (Marcado como `E` - Errado)")
            linhas.append("")
            linhas.append("| Linha | Saída Legacy (`docs/legacy_in.txt`) | Saída Selfhosted (`docs/selfhosted_in.txt`) |")
            linhas.append("| :---: | :--- | :--- |")
            max_l = max(len(l_leg), len(l_sh))
            for i in range(max_l):
                c_leg = (l_leg[i] if i < len(l_leg) else "(vazio)").replace("|", "\\|")
                c_sh = (l_sh[i] if i < len(l_sh) else "(vazio)").replace("|", "\\|")
                linhas.append(f"| {i + 1} | `{c_leg}` | `{c_sh}` |")
            linhas.append("")

            diff_u = list(
                difflib.unified_diff(
                    l_leg,
                    l_sh,
                    fromfile=f"legacy/{nome}",
                    tofile=f"selfhosted/{nome}",
                    lineterm="",
                )
            )
            linhas.append("#### Saída / Diferença Detalhada:")
            linhas.append("```diff")
            if diff_u:
                linhas.extend(diff_u)
            else:
                linhas.append("# Arquivo marcado manualmente como (E)rrado pelo usuário (saídas textuais idênticas):")
                for idx_l, ln in enumerate(l_sh, 1):
                    linhas.append(f"L{idx_l}: {ln}")
            linhas.append("```")
            linhas.append("")

    MD_PATH.write_text("\n".join(linhas) + "\n", encoding="utf-8")


def imprimir_resumo_e_erros_tela(avaliacoes: list[dict[str, object]], col_w: int = 55) -> None:
    """4) e 5) Imprime na tela a tabela atualizada com (C)/(E) e os erros marcados com (E) ao final."""
    if not avaliacoes:
        return

    larg_nome = max([len(str(a["nome"])) for a in avaliacoes] + [len("arquivo")])
    cab = (
        f"{'arquivo':<{larg_nome}}  | "
        f"{'legacy':^8} | "
        f"{'selfhosted':^10} | "
        f"{'tecla':^5} | "
        f"{'resultado':^12}"
    )
    print()
    print("=" * len(cab))
    print("TABELA DE CONFORMIDADE ATUALIZADA (CONFORME ENTRADA C / E)")
    print("=" * len(cab))
    print(cab)
    print("-" * len(cab))

    for a in avaliacoes:
        nome = str(a["nome"])
        st_leg = str(a["status_leg"])
        st_sh = str(a["status_sh"])
        esc = str(a["escolha"])
        badge = GREEN if esc == "C" else RED
        print(f"{nome:<{larg_nome}}  | {st_leg:^8} | {st_sh:^10} | {esc:^5} | {badge}")
    print("-" * len(cab))

    total = len(avaliacoes)
    certos = sum(1 for a in avaliacoes if a["escolha"] == "C")
    errados = sum(1 for a in avaliacoes if a["escolha"] == "E")

    print()
    print("=" * 80)
    print("RESUMO FINAL")
    print("=" * 80)
    print(f"  Total avaliados    : {total}")
    print(f"  (C)erto            : {certos}/{total}")
    print(f"  (E)rrado           : {errados}/{total}")
    print("=" * 80)

    erros_marcados = [a for a in avaliacoes if a["escolha"] == "E"]
    if erros_marcados:
        print("\nERROS ASSINALADOS PELO USUÁRIO (E):")
        sep_len = col_w * 2 + 5
        for a in erros_marcados:
            nome = str(a["nome"])
            l_leg = list(a["linhas_leg"])  # type: ignore[arg-type]
            l_sh = list(a["linhas_sh"])  # type: ignore[arg-type]
            print()
            print(f">>> {nome} (Marcado como ERRADO - E)")
            print("-" * sep_len)
            print(f"{'LEGACY':<{col_w}} | {'SELFHOSTED':<{col_w}}")
            print("-" * sep_len)
            max_l = max(len(l_leg), len(l_sh))
            for i in range(max_l):
                esq = l_leg[i] if i < len(l_leg) else ""
                dir_ = l_sh[i] if i < len(l_sh) else ""
                print(f"{formatar_celula(esq, col_w)} | {formatar_celula(dir_, col_w)}")
            print("-" * sep_len)
            diff_u = list(
                difflib.unified_diff(
                    l_leg,
                    l_sh,
                    fromfile=f"legacy/{nome}",
                    tofile=f"selfhosted/{nome}",
                    lineterm="",
                )
            )
            if diff_u:
                for d in diff_u:
                    print("  " + d)
    else:
        print("\nNenhum erro assinalado com (E) pelo usuário.")


def main() -> int:
    filtros = [a.lower() for a in sys.argv[1:] if not a.startswith("-")]
    todos_arquivos = sorted(FLUX_DIR.glob("*.flux"))
    if filtros:
        flux_files = [
            f for f in todos_arquivos if any(flt in f.name.lower() for flt in filtros)
        ]
    else:
        flux_files = todos_arquivos

    if not flux_files:
        print("Nenhum arquivo .flux encontrado para o filtro informado.")
        return 1

    legacy_runner = LegacyRunner()
    registros_leg: list[tuple[str, str, list[str]]] = []
    registros_sh: list[tuple[str, str, list[str]]] = []
    avaliacoes: list[dict[str, object]] = []

    total = len(flux_files)
    try:
        for idx, path in enumerate(flux_files, 1):
            nome = path.name
            stdin_input = STDIN_MAP.get(nome, "")

            if "DbStdLib" in nome:
                limpar_scratch_dbs()
            st_leg, linhas_leg = legacy_runner.run_file(path, stdin_input)

            if "DbStdLib" in nome:
                limpar_scratch_dbs()
            st_sh, linhas_sh = executar_selfhosted(path, stdin_input)

            registros_leg.append((nome, st_leg, linhas_leg))
            registros_sh.append((nome, st_sh, linhas_sh))

            # 1) Exibir as saidas em tela lado (legacy) a lado (selfhosted)
            exibir_saida_lado_a_lado(idx, total, nome, linhas_leg, linhas_sh)

            # 2) Aguardar input do usuario e 3) Teclar (C)erto ou (E)rrado
            escolha = ler_opcao_usuario(nome)

            avaliacoes.append(
                {
                    "nome": nome,
                    "status_leg": st_leg,
                    "status_sh": st_sh,
                    "linhas_leg": linhas_leg,
                    "linhas_sh": linhas_sh,
                    "escolha": escolha,
                }
            )

            # Atualiza compliance_in.md incrementalmente a cada entrada
            gerar_relatorio_md(avaliacoes)
    except KeyboardInterrupt:
        print("\nExecução interrompida pelo usuário. Gerando tabela e relatório parcial...")
    finally:
        legacy_runner.close()
        limpar_scratch_dbs()

    # Regenera docs/legacy_in.txt e docs/selfhosted_in.txt se executou a suite completa
    if not filtros and len(registros_leg) == len(todos_arquivos):
        salvar_txt_regenerado(LEGACY_TXT, registros_leg)
        salvar_txt_regenerado(SELFHOSTED_TXT, registros_sh)

    # 4) Atualizar a tabela com (C)/(E) e 5) Imprimir os erros marcados com (E) ao final
    imprimir_resumo_e_erros_tela(avaliacoes)
    gerar_relatorio_md(avaliacoes)
    print(f"\nRelatório atualizado em: {MD_PATH}")

    errados = sum(1 for a in avaliacoes if a["escolha"] == "E")
    return 0 if errados == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
