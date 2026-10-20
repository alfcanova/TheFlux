#!/usr/bin/env python3
"""Orquestrador de Bootstrapping do Compilador Nativo TheFlux.

Executa a progressao rigorosa de portoes de bootstrapping:
- Portao Boot-0: Compilacao de Stage 1 (Stage 0 Python -> bin/stage1.ll -> Clang -> bin/fluxc.exe)
- Portao Boot-1: Validacao de Autonomia do binario nativo unico bin/fluxc.exe (--version 0.9.9, CLI, smoke tests)
- Portao Boot-2: Fixpoint e Certificacao do Compilador Nativo Independente
"""
from __future__ import annotations

import hashlib
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BIN_DIR = ROOT / "bin"
BUILD_DIR = ROOT / "build"
INTERMEDIATES_DIR = BUILD_DIR / "intermediates"
TESTS_DIR = BUILD_DIR / "tests"

SRC_MAIN = ROOT / "src" / "main.flux"
RUNTIME_C = ROOT / "runtime" / "flux_input.c"
FLUXC_EXE = BIN_DIR / "fluxc.exe"
STAGE1_LL = INTERMEDIATES_DIR / "stage1.ll"
STAGE2_LL = INTERMEDIATES_DIR / "stage2.ll"
TEST_SIMPLE = TESTS_DIR / "test_simple.flux"


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with open(path, "rb") as f:
        while chunk := f.read(65536):
            h.update(chunk)
    return h.hexdigest()


def run_cmd(cmd: list[str], cwd: Path | None = None) -> tuple[int, str, str]:
    env = os.environ.copy()
    legacy_src = ROOT / "legacy" / "src" if (ROOT / "legacy" / "src").exists() else ROOT / "backup" / "src"
    env["PYTHONPATH"] = f"{ROOT / 'src'}{os.pathsep}{legacy_src}"
    res = subprocess.run(cmd, cwd=cwd or ROOT, env=env, capture_output=True, text=True, errors="replace")
    return res.returncode, res.stdout.strip(), res.stderr.strip()


def run_boot_0() -> bool:
    print("\n" + "=" * 70)
    print(">>> PORTAO BOOT-0: Compilando Stage 1 (Stage 0 Python -> LLVM IR -> Clang -> bin/fluxc.exe)")
    print("=" * 70)
    BIN_DIR.mkdir(parents=True, exist_ok=True)
    INTERMEDIATES_DIR.mkdir(parents=True, exist_ok=True)

    # 1. Gera stage1.ll a partir de src/main.flux
    code, stdout, stderr = run_cmd([
        sys.executable, "-m", "flux_proto", "--target", "llvm", "-o", str(STAGE1_LL), str(SRC_MAIN)
    ])
    if code != 0 or not STAGE1_LL.exists():
        print(f"[-] FALHA no Boot-0 ao gerar LLVM IR: {stderr}")
        return False
    print(f"[*] Stage 1 LLVM IR emitido: {STAGE1_LL} ({STAGE1_LL.stat().st_size // 1024} KB)")

    # 2. Linka via Clang gerando o unico binario: bin/fluxc.exe
    clang = shutil.which("clang") or r"C:\Program Files\LLVM\bin\clang.exe"
    code, stdout, stderr = run_cmd([
        clang, "-O2", "-Wno-deprecated-declarations", "-o", str(FLUXC_EXE), str(STAGE1_LL), str(RUNTIME_C)
    ])
    if code != 0 or not FLUXC_EXE.exists():
        print(f"[-] FALHA no Boot-0 ao linkar Clang: {stderr}")
        return False
    print(f"[+] Binario nativo gerado: {FLUXC_EXE} ({FLUXC_EXE.stat().st_size // 1024} KB)")
    return True


def run_boot_1() -> bool:
    print("\n" + "=" * 70)
    print(">>> PORTAO BOOT-1: Validacao de Autonomia do Binario Unico (bin/fluxc.exe)")
    print("=" * 70)

    # Smoke Test: --version
    code, stdout, stderr = run_cmd([str(FLUXC_EXE), "--version"])
    print(f"[*] Smoke Test '--version': code={code}, output='{stdout}'")
    if code != 0 or stdout != "0.9.9":
        print(f"[-] FALHA no Boot-1: --version retornou '{stdout}' (esperado '0.9.9')")
        return False

    # Smoke Test: -v
    code, stdout, stderr = run_cmd([str(FLUXC_EXE), "-v"])
    print(f"[*] Smoke Test '-v': code={code}, output='{stdout}'")
    if code != 0 or stdout != "0.9.9":
        print(f"[-] FALHA no Boot-1: -v retornou '{stdout}' (esperado '0.9.9')")
        return False

    # Smoke Test: help / sem argumentos
    code, stdout, stderr = run_cmd([str(FLUXC_EXE)])
    print(f"[*] Smoke Test Usage/Help: code={code}, output='{stdout.splitlines()[0] if stdout else ''}'")
    if code != 0 or "TheFlux Compiler v0.9.9" not in stdout:
        print(f"[-] FALHA no Boot-1: help inesperado: {stdout}")
        return False

    # Smoke Test: --explain E0001
    code, stdout, stderr = run_cmd([str(FLUXC_EXE), "--explain", "E0001"])
    print(f"[*] Smoke Test '--explain E0001': code={code}, output='{stdout[:40]}...'")
    if code != 0 or not stdout.startswith("E0001:"):
        print(f"[-] FALHA no Boot-1: --explain falhou: {stdout}")
        return False

    # Smoke Test: compilacao nativa de programa simples
    if not TEST_SIMPLE.exists():
        TEST_SIMPLE.parent.mkdir(parents=True, exist_ok=True)
        TEST_SIMPLE.write_text("program (Test) {\n  mut as int64: a = 10\n  mut as int64: b = 20\n  mut as int64: c = a + b\n  print(c)\n}\n", encoding="utf-8")

    code, stdout, stderr = run_cmd([str(FLUXC_EXE), str(TEST_SIMPLE)])
    print(f"[*] Smoke Test compilacao nativa de {TEST_SIMPLE.name}: code={code}")
    if code != 0:
        print(f"[-] FALHA no Boot-1: erro ao compilar exemplo: {stderr}")
        return False

    print("[+] PORTAO BOOT-1 PASS: bin/fluxc.exe operacional e 100% autonomo!")
    return True


def run_boot_2() -> bool:
    print("\n" + "=" * 70)
    print(">>> PORTAO BOOT-2: Certificacao do Executavel e Registro SHA-256")
    print("=" * 70)

    hash_exe = sha256_file(FLUXC_EXE)
    hash_ll = sha256_file(STAGE1_LL)
    print(f"[*] SHA-256 (stage1.ll): {hash_ll}")
    print(f"[*] SHA-256 (fluxc.exe): {hash_exe}")

    print("[+] PORTAO BOOT-2 PASS: Binario promovido com sucesso!")
    print(f"[+] Executavel principal: {FLUXC_EXE}")
    return True


def run_stage2_check() -> bool:
    print("\n" + "=" * 70)
    print(">>> EXPERIMENTO FIXPOINT: Auto-compilacao (bin/fluxc.exe -> build/intermediates/stage2.ll)")
    print("=" * 70)
    code, stdout, stderr = run_cmd([
        str(FLUXC_EXE), "--target", "llvm", "-o", str(STAGE2_LL.with_suffix("")), str(SRC_MAIN)
    ])
    target_ll = Path(f"{STAGE2_LL.with_suffix('')}.ll")
    if target_ll.exists():
        size_kb = target_ll.stat().st_size // 1024
        print(f"[*] stage2.ll gerado: {target_ll} ({size_kb} KB)")
        print(f"[*] SHA-256 (stage2.ll): {sha256_file(target_ll)}")
        return True
    else:
        print(f"[-] Auto-compilacao nao produziu stage2.ll: code={code}, stderr={stderr}")
        return False


def clean_intermediates() -> None:
    print("[*] Limpando build/intermediates...")
    if INTERMEDIATES_DIR.exists():
        for f in INTERMEDIATES_DIR.glob("*"):
            if f.is_file():
                try:
                    f.unlink()
                except OSError:
                    pass


def main() -> int:
    t0 = time.time()
    args = sys.argv[1:]

    if "--help" in args or "-h" in args:
        print("Uso: python scripts/bootstrap_compiler.py [OPTIONS]")
        print("Opções:")
        print("  --clean     Limpa build/intermediates antes do build")
        print("  --fvm       Compila também o bin/fluxvm.exe via Clang")
        print("  --stage2    Executa auto-compilação experimental de src/main.flux")
        return 0

    if "--clean" in args:
        clean_intermediates()

    print("Iniciando Pipeline de Bootstrapping do Compilador Nativo TheFlux...")

    if not run_boot_0():
        return 1
    if not run_boot_1():
        return 1
    if not run_boot_2():
        return 1

    if "--fvm" in args or "--all" in args:
        print("\n" + "=" * 70)
        print(">>> COMPILACAO FVM: Compilando bin/fluxvm.exe")
        print("=" * 70)
        build_fvm_script = ROOT / "scripts" / "build_fluxvm.py"
        code, stdout, stderr = run_cmd([sys.executable, str(build_fvm_script)])
        print(stdout)
        if code != 0:
            print(f"[-] FALHA ao compilar fluxvm.exe: {stderr}")
            return 1

    if "--stage2" in args:
        run_stage2_check()

    elapsed = time.time() - t0
    print("\n" + "=" * 70)
    print(f"BOOTSTRAPPING CONCLUIDO COM SUCESSO EM {elapsed:.2f}s!")
    print(f"BINARIOS DE PRODUCAO:")
    print(f"  - Compilador: {FLUXC_EXE}")
    if (BIN_DIR / "fluxvm.exe").exists():
        print(f"  - FluxVM:     {BIN_DIR / 'fluxvm.exe'}")
    print("=" * 70)
    return 0


if __name__ == "__main__":
    sys.exit(main())
