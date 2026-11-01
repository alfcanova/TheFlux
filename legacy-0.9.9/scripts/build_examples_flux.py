"""Generator for examples/examples_??.flux runners.
Emits 100% valid Flux code adhering to:
- Indentation in multiples of 6 spaces
- No semicolons
- Safe nested route guards for string slicing
- Shared CLI parser (--ca, --nr, --sa, --all, --filter, --help)
- Exact output format: Certo --> <rel_path> / Falha --> <rel_path>
- Final summary in 2 lines:
    Certos: <X>
    Falhas: <Y>
- Exit code 0 if Falhas == 0, else 1
"""

import os
import sys

TARGETS = [
    {
        "id": "in",
        "program": "ExamplesIn",
        "filename": "examples_in.flux",
        "title": "Examples IN (Interpretador)",
        "exe_name": "examples_in.exe",
    },
    {
        "id": "vm",
        "program": "ExamplesVm",
        "filename": "examples_vm.flux",
        "title": "Examples VM (Compilador de Bytecode)",
        "exe_name": "examples_vm.exe",
    },
    {
        "id": "vmr",
        "program": "ExamplesVmr",
        "filename": "examples_vmr.flux",
        "title": "Examples VMR (Virtual Machine Runtime)",
        "exe_name": "examples_vmr.exe",
    },
    {
        "id": "lv",
        "program": "ExamplesLv",
        "filename": "examples_lv.flux",
        "title": "Examples LV (Compilador AOT Nativo LLVM)",
        "exe_name": "examples_lv.exe",
    },
    {
        "id": "wat",
        "program": "ExamplesWat",
        "filename": "examples_wat.flux",
        "title": "Examples WAT (WebAssembly Text + Wasmer)",
        "exe_name": "examples_wat.exe",
    },
    {
        "id": "was",
        "program": "ExamplesWas",
        "filename": "examples_was.flux",
        "title": "Examples WAS (WebAssembly Binario + Wasmer)",
        "exe_name": "examples_was.exe",
    },
]

NR_CHAPTERS = [
    "01_preliminaries",
    "02_linear_algebra",
    "03_interpolation",
    "04_integration",
    "05_function_evaluation",
    "06_special_functions",
    "07_random_numbers",
    "08_sorting_selection",
    "09_root_finding",
    "10_minimization",
    "11_eigensystems",
    "12_fast_fourier_transform",
    "13_fourier_spectral",
    "14_statistical_description",
    "15_modeling_data",
    "16_classification_inference",
    "17_differential_equations",
    "18_boundary_value_problems",
    "19_integral_equations",
    "20_partial_differential_eqs",
    "21_computational_geometry",
    "22_less_numerical",
]

SA_DOMAINS = [
    "01_foundations",
    "02_data_structures",
    "03_graphs",
    "04_strings",
    "05_mathematics",
    "06_numerical_physics",
    "07_optimization_stat",
    "08_artificial_intel",
    "09_systems_infra",
    "10_bio_quantum",
    "11_dsp_multimedia",
    "12_robotics_control",
    "13_classical_crypto",
]


def emit_backend_test(emit, indent, target_id):
    """Emits the backend-specific compilation/execution check for a test file.
    Expects variables in Flux scope:
      - path: full relative path to .flux file (e.g. 'examples\\Canon\\ExampleOfPrint.flux')
      - stem: basename without .flux
      - stdin_file: path to file to redirect into stdin
      - is_err: boolean indicating if #L EXPECT_ERROR: is present
    Sets:
      - is_ok: boolean (true if test passed, false if failed)
    """
    emit("mut as bool: is_ok = false", indent)

    if target_id == "in":
        emit('mut as string: cmd = "cmd /c \\"set FLUX_CI=1 && " + fluxc_bin + " --target in \\"" + path + "\\" < " + stdin_file + " > nul 2>&1\\""', indent)
        emit("mut as int64: rc = stdOsExec(cmd)", indent)
        emit("route {", indent)
        emit("is_err ==> { is_ok = (rc != 0) }", indent + 1)
        emit("_      ==> { is_ok = (rc == 0) }", indent + 1)
        emit("}", indent)

    elif target_id == "vm":
        emit('mut as string: out_vm = "t_fvmbc\\\\" + stem', indent)
        emit('mut as string: fvmbc_file = "t_fvmbc\\\\" + stem + ".fvmbc"', indent)
        emit('mut as string: cmd = "cmd /c \\"set FLUX_CI=1 && " + fluxc_bin + " --target vm \\"" + path + "\\" -o \\"" + out_vm + "\\" --no-run < " + stdin_file + " > nul 2>&1\\""', indent)
        emit("mut as int64: rc = stdOsExec(cmd)", indent)
        emit("route {", indent)
        emit("is_err ==> { is_ok = (rc != 0) }", indent + 1)
        emit("_      ==> {", indent + 1)
        emit("route {", indent + 2)
        emit("rc == 0 and stdIoFileExists(fvmbc_file) ==> { is_ok = true }", indent + 3)
        emit("_ ==> { is_ok = false }", indent + 3)
        emit("}", indent + 2)
        emit("}", indent + 1)
        emit("}", indent)

    elif target_id == "vmr":
        emit('mut as string: out_vm = "t_fvmbc\\\\" + stem', indent)
        emit('mut as string: fvmbc_file = "t_fvmbc\\\\" + stem + ".fvmbc"', indent)
        emit('mut as string: cmd_c = "cmd /c \\"set FLUX_CI=1 && " + fluxc_bin + " --target vm \\"" + path + "\\" -o \\"" + out_vm + "\\" --no-run < " + stdin_file + " > nul 2>&1\\""', indent)
        emit("mut as int64: rc_c = stdOsExec(cmd_c)", indent)
        emit('mut as string: cmd_r = "cmd /c \\"set FLUX_CI=1 && " + fluxc_bin + " --target vmr \\"" + fvmbc_file + "\\" < " + stdin_file + " > nul 2>&1\\""', indent)
        emit("mut as int64: rc_r = stdOsExec(cmd_r)", indent)
        emit("route {", indent)
        emit("is_err ==> { is_ok = (rc_c != 0 or rc_r != 0) }", indent + 1)
        emit("_      ==> { is_ok = (rc_c == 0 and rc_r == 0) }", indent + 1)
        emit("}", indent)

    elif target_id == "lv":
        emit('mut as string: out_lv = "t_llvm\\\\" + stem', indent)
        emit('mut as string: exe_file = "t_llvm\\\\" + stem + ".exe"', indent)
        emit('mut as string: cmd_c = "cmd /c \\"set FLUX_CI=1 && " + fluxc_bin + " --target lv \\"" + path + "\\" -o \\"" + out_lv + "\\" --no-run < " + stdin_file + " > nul 2>&1\\""', indent)
        emit("mut as int64: rc_c = stdOsExec(cmd_c)", indent)
        emit('mut as string: cmd_r = "cmd /c \\"set FLUX_CI=1 && " + exe_file + " < " + stdin_file + " > nul 2>&1\\""', indent)
        emit("mut as int64: rc_r = stdOsExec(cmd_r)", indent)
        emit("route {", indent)
        emit("is_err ==> { is_ok = (rc_c != 0 or rc_r != 0) }", indent + 1)
        emit("_      ==> { is_ok = (rc_c == 0 and rc_r == 0) }", indent + 1)
        emit("}", indent)

    elif target_id == "wat":
        emit('mut as string: out_wat = "t_wat\\\\" + stem', indent)
        emit('mut as string: wat_file = "t_wat\\\\" + stem + ".wat"', indent)
        emit('mut as string: cmd_c = "cmd /c \\"set FLUX_CI=1 && " + fluxc_bin + " --target wat \\"" + path + "\\" -o \\"" + out_wat + "\\" --no-run < " + stdin_file + " > nul 2>&1\\""', indent)
        emit("mut as int64: rc_c = stdOsExec(cmd_c)", indent)
        emit('mut as string: cmd_r = "cmd /c \\"set FLUX_CI=1 && wasmer run " + wat_file + " < " + stdin_file + " > nul 2>&1\\""', indent)
        emit("mut as int64: rc_r = stdOsExec(cmd_r)", indent)
        emit("route {", indent)
        emit("is_err ==> { is_ok = (rc_c != 0 or rc_r != 0) }", indent + 1)
        emit("_      ==> { is_ok = (rc_c == 0 and rc_r == 0) }", indent + 1)
        emit("}", indent)

    elif target_id == "was":
        emit('mut as string: out_wasm = "t_wasm\\\\" + stem', indent)
        emit('mut as string: wasm_file = "t_wasm\\\\" + stem + ".wasm"', indent)
        emit('mut as string: cmd_c = "cmd /c \\"set FLUX_CI=1 && " + fluxc_bin + " --target wasm \\"" + path + "\\" -o \\"" + out_wasm + "\\" --no-run < " + stdin_file + " > nul 2>&1\\""', indent)
        emit("mut as int64: rc_c = stdOsExec(cmd_c)", indent)
        emit('mut as string: cmd_r = "cmd /c \\"set FLUX_CI=1 && wasmer run " + wasm_file + " < " + stdin_file + " > nul 2>&1\\""', indent)
        emit("mut as int64: rc_r = stdOsExec(cmd_r)", indent)
        emit("route {", indent)
        emit("is_err ==> { is_ok = (rc_c != 0 or rc_r != 0) }", indent + 1)
        emit("_      ==> { is_ok = (rc_c == 0 and rc_r == 0) }", indent + 1)
        emit("}", indent)


def generate_runner(target: dict) -> str:
    lines = []
    def emit(s="", indent=0):
        if not s:
            lines.append("")
        else:
            lines.append(" " * (indent * 6) + s)

    t_id = target["id"]
    t_prog = target["program"]
    t_file = target["filename"]
    t_title = target["title"]

    emit("#L ==============================================================================")
    emit(f"#L TheFlux Runner: {t_title}")
    emit(f"#L Arquivo: examples/{t_file}")
    emit("#L ==============================================================================")
    emit()
    emit("use RuntimeStdLib")
    emit("use IoStdLib")
    emit("use OsStdLib")
    emit()
    emit(f"program ({t_prog}) {{")

    # 1. CLI Parsing
    emit("#L 1. Parser de argumentos da linha de comando", 1)
    emit("mut as list of data: args = stdRuntimeGetArgs()", 1)
    emit("mut as int64: n_args = stdCollectionLength(args)", 1)
    emit("mut as bool: flag_ca = false", 1)
    emit("mut as bool: flag_nr = false", 1)
    emit("mut as bool: flag_sa = false", 1)
    emit("mut as bool: flag_all = false", 1)
    emit("mut as bool: flag_help = false", 1)
    emit('mut as string: filtro_raw = ""', 1)
    emit()
    emit("mut as int64: ai = 1", 1)
    emit("infinite {", 1)
    emit("route {", 2)
    emit("ai > n_args ==> { break }", 3)
    emit("_ ==> {", 3)
    emit('mut as string: a = "" + args[ai]', 4)

    # Self detection
    self_checks = [
        f'a == "{t_file}"',
        f'a == ".\\\\{t_file}"',
        f'a == "./{t_file}"',
        f'a == "examples\\\\{t_file}"',
        f'a == "examples/{t_file}"',
        f'a == ".\\\\examples\\\\{t_file}"',
        f'a == "./examples/{t_file}"',
        f'a == "examples_{t_id}.exe"',
        f'a == ".\\\\examples_{t_id}.exe"',
        f'a == "bin\\\\examples_{t_id}.exe"',
        f'a == ".\\\\bin\\\\examples_{t_id}.exe"',
        f'a == "exemplos_{t_id}.flux"',
        f'a == ".\\\\exemplos_{t_id}.flux"',
        f'a == "./exemplos_{t_id}.flux"',
        f'a == "exemplos_{t_id}.exe"',
        f'a == ".\\\\exemplos_{t_id}.exe"',
        f'a == "bin\\\\exemplos_{t_id}.exe"',
        f'a == ".\\\\bin\\\\exemplos_{t_id}.exe"',
        'a == "--"',
        'a == "run"',
        f'a == "{t_id}"',
    ]
    self_cond = " or ".join(self_checks)
    emit(f"mut as bool: is_self = ({self_cond})", 4)
    emit("route {", 4)
    emit("is_self ==> {}", 5)
    emit('a == "--ca" ==> { flag_ca = true }', 5)
    emit('a == "--nr" ==> { flag_nr = true }', 5)
    emit('a == "--sa" ==> { flag_sa = true }', 5)
    emit('a == "--all" ==> { flag_all = true }', 5)
    emit('a == "--help" or a == "-h" ==> { flag_help = true }', 5)
    emit('a == "--filter" or a == "-f" ==> {', 5)
    emit("ai = ai + 1", 6)
    emit("route {", 6)
    emit("ai <= n_args ==> {", 7)
    emit('filtro_raw = "" + args[ai]', 8)
    emit("}", 7)
    emit("_ ==> {}", 7)
    emit("}", 6)
    emit("}", 5)
    emit("_ ==> {", 5)
    emit("mut as int64: alen = stdCollectionLength(a)", 6)
    emit("route {", 6)
    emit("alen > 0 ==> {", 7)
    emit("mut as string: ch0 = a[1]", 8)
    emit("route {", 8)
    emit('ch0 != "-" ==> {', 9)
    emit("route {", 10)
    emit('filtro_raw == "" ==> {', 11)
    emit("filtro_raw = a", 12)
    emit("}", 11)
    emit("_ ==> {}", 11)
    emit("}", 10)
    emit("}", 9)
    emit("_ ==> {}", 9)
    emit("}", 8)
    emit("}", 7)
    emit("_ ==> {}", 7)
    emit("}", 6)
    emit("}", 5)
    emit("}", 4)
    emit("ai = ai + 1", 4)
    emit("}", 3)
    emit("}", 2)
    emit("}", 1)
    emit()

    # 2. Help check
    emit("#L 2. Verificacao de ajuda (--help) ou execucao sem suite", 1)
    emit("route {", 1)
    emit("flag_help or (not flag_ca and not flag_nr and not flag_sa and not flag_all) ==> {", 2)
    emit(f'println("TheFlux Runner: {t_title}")', 3)
    emit(f'println("Uso: examples_{t_id} [opções]")', 3)
    emit('println("")', 3)
    emit('println("Opções de Suíte:")', 3)
    emit('println("  --ca              Executa a suíte canônica (examples/Canon)")', 3)
    emit('println("  --nr              Executa a suíte Numerical Recipes (examples/NumericalRecipes)")', 3)
    emit('println("  --sa              Executa a suíte Scientific Algorithms (examples/ScientificAlgorithms)")', 3)
    emit('println("  --all             Executa todas as 3 suítes na sequência (--ca, --nr, --sa)")', 3)
    emit('println("")', 3)
    emit('println("Opções Gerais:")', 3)
    emit('println("  --filter <termo>  Filtra os arquivos a serem testados por substring (case-insensitive)")', 3)
    emit('println("  --help, -h        Exibe esta mensagem de ajuda")', 3)
    emit('println("")', 3)
    emit('println("Exemplos:")', 3)
    emit(f'println("  examples_{t_id} --ca --filter ExampleOfPrint.flux")', 3)
    emit(f'println("  examples_{t_id} --nr --filter 01_preliminaries")', 3)
    emit(f'println("  examples_{t_id} --sa --filter BoyerMoore")', 3)
    emit(f'println("  examples_{t_id} --all")', 3)
    emit("stdOsExit(0)", 3)
    emit("}", 2)
    emit("_ ==> {}", 2)
    emit("}", 1)
    emit()

    # 3. Normalization of suites
    emit("#L 3. Normalizacao de flags de suite", 1)
    emit("route {", 1)
    emit("flag_all ==> {", 2)
    emit("flag_ca = true", 3)
    emit("flag_nr = true", 3)
    emit("flag_sa = true", 3)
    emit("}", 2)
    emit("_ ==> {}", 2)
    emit("}", 1)
    emit()

    # 4. Filter lowercasing
    emit("#L 4. Conversao do filtro para minusculo", 1)
    emit('mut as string: filtro_lower = ""', 1)
    emit("mut as int64: flen = stdCollectionLength(filtro_raw)", 1)
    emit("mut as int64: fi = 1", 1)
    emit("infinite {", 1)
    emit("route {", 2)
    emit("fi > flen ==> { break }", 3)
    emit("_ ==> {", 3)
    emit("mut as string: ch = filtro_raw[fi]", 4)
    emit("route {", 4)
    for upper_ch in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
        emit(f'ch == "{upper_ch}" ==> {{ ch = "{upper_ch.lower()}" }}', 5)
    emit("_ ==> {}", 5)
    emit("}", 4)
    emit("filtro_lower = filtro_lower + ch", 4)
    emit("fi = fi + 1", 4)
    emit("}", 3)
    emit("}", 2)
    emit("}", 1)
    emit()

    # Helper to emit native cleanup of temp dirs and files
    def emit_temp_cleanup(prefix="cl", indent=1):
        emit(f"#L Verificacao e limpeza nativa de arquivos nas pastas t_* (preservando .gitkeep)", indent)
        emit(f'mut as list of data: {prefix}_dirs = ["t_fvmbc", "t_llvm", "t_wasm", "t_wat"]', indent)
        emit(f"mut as int64: {prefix}_di = 1", indent)
        emit(f"infinite {{", indent)
        emit(f"route {{", indent + 1)
        emit(f"{prefix}_di > 4 ==> {{ break }}", indent + 2)
        emit(f"_ ==> {{", indent + 2)
        emit(f'mut as string: {prefix}_cur_dir = "" + {prefix}_dirs[{prefix}_di]', indent + 3)
        emit(f"route {{", indent + 3)
        emit(f"stdIoDirExists({prefix}_cur_dir) ==> {{", indent + 4)
        emit(f"mut as list of data: {prefix}_entries = stdIoListDir({prefix}_cur_dir)", indent + 5)
        emit(f"mut as int64: {prefix}_n_entries = stdCollectionLength({prefix}_entries)", indent + 5)
        emit(f"mut as int64: {prefix}_ei = 1", indent + 5)
        emit(f"infinite {{", indent + 5)
        emit(f"route {{", indent + 6)
        emit(f"{prefix}_ei > {prefix}_n_entries ==> {{ break }}", indent + 7)
        emit(f"_ ==> {{", indent + 7)
        emit(f'mut as string: {prefix}_fname = "" + {prefix}_entries[{prefix}_ei]', indent + 8)
        emit(f"route {{", indent + 8)
        emit(f'{prefix}_fname != ".gitkeep" ==> {{', indent + 9)
        emit(f'mut as string: {prefix}_fp = {prefix}_cur_dir + "\\\\" + {prefix}_fname', indent + 10)
        emit(f"route {{", indent + 10)
        emit(f"stdIoFileExists({prefix}_fp) ==> {{", indent + 11)
        emit(f"stdIoDeleteFile({prefix}_fp)", indent + 12)
        emit(f"}}", indent + 11)
        emit(f"_ ==> {{}}", indent + 11)
        emit(f"}}", indent + 10)
        emit(f"}}", indent + 9)
        emit(f"_ ==> {{}}", indent + 9)
        emit(f"}}", indent + 8)
        emit(f"{prefix}_ei = {prefix}_ei + 1", indent + 8)
        emit(f"}}", indent + 7)
        emit(f"}}", indent + 6)
        emit(f"}}", indent + 5)
        emit(f"}}", indent + 4)
        emit(f"_ ==> {{", indent + 4)
        emit(f"stdIoCreateDir({prefix}_cur_dir)", indent + 5)
        emit(f"}}", indent + 4)
        emit(f"}}", indent + 3)
        emit(f"route {{", indent + 3)
        emit(f'stdIoFileExists({prefix}_cur_dir + "\\\\.gitkeep") ==> {{}}', indent + 4)
        emit(f"_ ==> {{", indent + 4)
        emit(f'stdIoWriteFile({prefix}_cur_dir + "\\\\.gitkeep", "")', indent + 5)
        emit(f"}}", indent + 4)
        emit(f"}}", indent + 3)
        emit(f"{prefix}_di = {prefix}_di + 1", indent + 3)
        emit(f"}}", indent + 2)
        emit(f"}}", indent + 1)
        emit(f"}}", indent)
        emit(f'mut as list of data: {prefix}_root_tmps = ["t_stdin.tmp", "t_input_interactive.txt", "t_input_contract.txt", "t_in.tmp", "t_vm.tmp", "t_vm_c.tmp", "t_vmr.tmp", "t_lv.tmp", "t_lv_c.tmp", "t_wat.tmp", "t_wat_c.tmp", "t_was.tmp", "t_was_c.tmp"]', indent)
        emit(f"mut as int64: {prefix}_ri = 1", indent)
        emit(f"infinite {{", indent)
        emit(f"route {{", indent + 1)
        emit(f"{prefix}_ri > 13 ==> {{ break }}", indent + 2)
        emit(f"_ ==> {{", indent + 2)
        emit(f'mut as string: {prefix}_rtf = "" + {prefix}_root_tmps[{prefix}_ri]', indent + 3)
        emit(f"route {{", indent + 3)
        emit(f"stdIoFileExists({prefix}_rtf) ==> {{", indent + 4)
        emit(f"stdIoDeleteFile({prefix}_rtf)", indent + 5)
        emit(f"}}", indent + 4)
        emit(f"_ ==> {{}}", indent + 4)
        emit(f"}}", indent + 3)
        emit(f"{prefix}_ri = {prefix}_ri + 1", indent + 3)
        emit(f"}}", indent + 2)
        emit(f"}}", indent + 1)
        emit(f"}}", indent)

    # 5. Stdin and temp dirs
    emit("#L 5. Limpeza inicial de arquivos/pastas t_* e preparacao de ambiente", 1)
    emit_temp_cleanup("cl_init", 1)
    emit('stdIoWriteFile("t_stdin.tmp", "")', 1)
    emit('stdIoWriteFile("t_input_interactive.txt", "Ana\\n30\\n9.99\\ntrue\\nA\\n2+3i\\n2026-08-28T12:00:00Z\\n")', 1)
    emit('stdIoWriteFile("t_input_contract.txt", "andre\\nluiz\\n")', 1)
    emit()

    # 6. Resolve compiler
    emit("#L 6. Localizacao dinamica do binario fluxc", 1)
    emit('mut as string: fluxc_bin = ".\\\\bin\\\\fluxc.exe"', 1)
    emit("route {", 1)
    emit('stdIoFileExists(".\\\\bin\\\\fluxc.exe") ==> { fluxc_bin = ".\\\\bin\\\\fluxc.exe" }', 2)
    emit('stdIoFileExists("bin\\\\fluxc.exe")    ==> { fluxc_bin = "bin\\\\fluxc.exe" }', 2)
    emit('stdIoFileExists("fluxc.exe")        ==> { fluxc_bin = "fluxc.exe" }', 2)
    emit('_                                    ==> { fluxc_bin = "fluxc" }', 2)
    emit("}", 1)
    emit()

    # 7. Counters
    emit("#L 7. Contadores globais de Certos e Falhas", 1)
    emit("mut as int64: grand_certos = 0", 1)
    emit("mut as int64: grand_falhas = 0", 1)
    emit()

    # =========================================================================
    # SUITE 1: CANON
    # =========================================================================
    emit("#L ==========================================================================", 1)
    emit("#L SUÍTE 1: CANON (--ca)", 1)
    emit("#L ==========================================================================", 1)
    emit("route {", 1)
    emit("flag_ca ==> {", 2)
    emit('mut as list of data: ca_entries = stdIoListDir("examples\\\\Canon")', 3)
    emit("mut as int64: n_ca_entries = stdCollectionLength(ca_entries)", 3)
    emit("mut as list of data: ca_files = []", 3)
    emit("mut as list of data: ca_files_lower = []", 3)
    emit("mut as int64: n_ca = 0", 3)
    emit("mut as int64: cei = 1", 3)
    emit("infinite {", 3)
    emit("route {", 4)
    emit("cei > n_ca_entries ==> { break }", 5)
    emit("_ ==> {", 5)
    emit('mut as string: fname = "" + ca_entries[cei]', 6)
    emit("mut as int64: fnlen = stdCollectionLength(fname)", 6)
    emit("route {", 6)
    emit("fnlen >= 5 ==> {", 7)
    emit("mut as string: fext = fname[(fnlen - 4)..fnlen]", 8)
    emit("route {", 8)
    emit('fext == ".flux" ==> {', 9)
    # lowercase fname
    emit('mut as string: fn_low = ""', 10)
    emit("mut as int64: fni = 1", 10)
    emit("infinite {", 10)
    emit("route {", 11)
    emit("fni > fnlen ==> { break }", 12)
    emit("_ ==> {", 12)
    emit("mut as string: fch = fname[fni]", 13)
    emit("route {", 13)
    for upper_ch in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
        emit(f'fch == "{upper_ch}" ==> {{ fch = "{upper_ch.lower()}" }}', 14)
    emit("_ ==> {}", 14)
    emit("}", 13)
    emit("fn_low = fn_low + fch", 13)
    emit("fni = fni + 1", 13)
    emit("}", 12)
    emit("}", 11)
    emit("}", 10)

    # filter match
    emit("mut as bool: match_ca = false", 10)
    emit("route {", 10)
    emit('filtro_lower == "" ==> { match_ca = true }', 11)
    emit("_ ==> {", 11)
    emit("route {", 12)
    emit("fnlen >= flen ==> {", 13)
    emit("mut as int64: mi = 1", 14)
    emit("infinite {", 14)
    emit("route {", 15)
    emit("mi + flen - 1 > fnlen ==> { break }", 16)
    emit("_ ==> {", 16)
    emit("mut as string: sub = fn_low[mi..(mi + flen - 1)]", 17)
    emit("route {", 17)
    emit("sub == filtro_lower ==> {", 18)
    emit("match_ca = true", 19)
    emit("break", 19)
    emit("}", 18)
    emit("_ ==> { mi = mi + 1 }", 18)
    emit("}", 17)
    emit("}", 16)
    emit("}", 15)
    emit("}", 14)
    emit("}", 13)
    emit("_ ==> {}", 13)
    emit("}", 12)
    emit("}", 11)
    emit("}", 10)

    emit("route {", 10)
    emit("match_ca ==> {", 11)
    emit("n_ca = n_ca + 1", 12)
    emit("ca_files[n_ca] = fname", 12)
    emit("ca_files_lower[n_ca] = fn_low", 12)
    emit("}", 11)
    emit("_ ==> {}", 11)
    emit("}", 10)

    emit("}", 9)
    emit("_ ==> {}", 9)
    emit("}", 8)
    emit("}", 7)
    emit("_ ==> {}", 7)
    emit("}", 6)
    emit("cei = cei + 1", 6)
    emit("}", 5)
    emit("}", 4)
    emit("}", 3)

    # Sort Canon files
    emit("#L Ordenacao deterministica A-Z de Canon", 3)
    emit("mut as int64: csi = 1", 3)
    emit("infinite {", 3)
    emit("route {", 4)
    emit("csi >= n_ca ==> { break }", 5)
    emit("_ ==> {", 5)
    emit("mut as int64: csj = csi + 1", 6)
    emit("infinite {", 6)
    emit("route {", 7)
    emit("csj > n_ca ==> { break }", 8)
    emit("_ ==> {", 8)
    emit('mut as string: a_low = "" + ca_files_lower[csi]', 9)
    emit('mut as string: b_low = "" + ca_files_lower[csj]', 9)
    emit("mut as bool: swap = false", 9)
    emit("route {", 9)
    emit("a_low > b_low ==> { swap = true }", 10)
    emit("a_low == b_low ==> {", 10)
    emit('mut as string: a_orig = "" + ca_files[csi]', 11)
    emit('mut as string: b_orig = "" + ca_files[csj]', 11)
    emit("route {", 11)
    emit("a_orig > b_orig ==> { swap = true }", 12)
    emit("_ ==> {}", 12)
    emit("}", 11)
    emit("}", 10)
    emit("_ ==> {}", 10)
    emit("}", 9)
    emit("route {", 9)
    emit("swap ==> {", 10)
    emit("mut as data: tmp = ca_files[csi]", 11)
    emit("ca_files[csi] = ca_files[csj]", 11)
    emit("ca_files[csj] = tmp", 11)
    emit("mut as data: tmp_low = ca_files_lower[csi]", 11)
    emit("ca_files_lower[csi] = ca_files_lower[csj]", 11)
    emit("ca_files_lower[csj] = tmp_low", 11)
    emit("}", 10)
    emit("_ ==> {}", 10)
    emit("}", 9)
    emit("csj = csj + 1", 9)
    emit("}", 8)
    emit("}", 7)
    emit("}", 6)
    emit("csi = csi + 1", 6)
    emit("}", 5)
    emit("}", 4)
    emit("}", 3)

    # Execute Canon tests
    emit("mut as int64: cti = 1", 3)
    emit("infinite {", 3)
    emit("route {", 4)
    emit("cti > n_ca ==> { break }", 5)
    emit("_ ==> {", 5)
    emit('mut as string: nome = "" + ca_files[cti]', 6)
    emit('mut as string: path = "examples\\\\Canon\\\\" + nome', 6)
    emit('mut as string: rel_name = nome', 6)
    emit("mut as int64: nlen = stdCollectionLength(nome)", 6)

    # Scratch cleanup for DbStdLib
    emit("route {", 6)
    emit("nlen >= 8 ==> {", 7)
    emit("mut as int64: di = 1", 8)
    emit("infinite {", 8)
    emit("route {", 9)
    emit("di + 7 > nlen ==> { break }", 10)
    emit("_ ==> {", 10)
    emit("mut as string: dsub = nome[di..(di + 7)]", 11)
    emit("route {", 11)
    emit('dsub == "DbStdLib" ==> {', 12)
    emit('stdOsExec("cmd /c del /q /f scratch\\\\flux_*.db* scratch\\\\flux_*.kv scratch\\\\flux_*.unqlite scratch\\\\flux_*.duckdb scratch\\\\flux_*.kuzu scratch\\\\flux_*.obx 2>nul")', 13)
    emit("break", 13)
    emit("}", 12)
    emit("_ ==> { di = di + 1 }", 12)
    emit("}", 11)
    emit("}", 10)
    emit("}", 9)
    emit("}", 8)
    emit("}", 7)
    emit("_ ==> {}", 7)
    emit("}", 6)

    # Stdin setup
    emit('mut as string: stdin_file = "t_stdin.tmp"', 6)
    emit("route {", 6)
    emit('nome == "ExampleOfInput.flux" ==> { stdin_file = "t_input_interactive.txt" }', 7)
    emit('nome == "ExampleOfUseIoStdLib_IoInputContract.flux" ==> { stdin_file = "t_input_contract.txt" }', 7)
    emit("_ ==> {}", 7)
    emit("}", 6)

    # Stem extraction
    emit("mut as string: stem = nome", 6)
    emit("route {", 6)
    emit("nlen > 5 ==> {", 7)
    emit("mut as string: sext = nome[(nlen - 4)..nlen]", 8)
    emit("route {", 8)
    emit('sext == ".flux" ==> { stem = nome[1..(nlen - 5)] }', 9)
    emit("_ ==> {}", 9)
    emit("}", 8)
    emit("}", 7)
    emit("_ ==> {}", 7)
    emit("}", 6)

    # Check EXPECT_ERROR
    emit("mut as string: src_code = stdIoReadFile(path)", 6)
    emit("mut as int64: src_len = stdCollectionLength(src_code)", 6)
    emit("mut as bool: is_err = false", 6)
    emit("route {", 6)
    emit("src_len >= 17 ==> {", 7)
    emit("mut as string: exp_pref = src_code[1..17]", 8)
    emit("route {", 8)
    emit('exp_pref == "#L EXPECT_ERROR: " ==> { is_err = true }', 9)
    emit("_ ==> {}", 9)
    emit("}", 8)
    emit("}", 7)
    emit("_ ==> {}", 7)
    emit("}", 6)

    # Backend execution
    emit_backend_test(emit, 6, t_id)

    # Print result
    emit("route {", 6)
    emit("is_ok ==> {", 7)
    emit("grand_certos = grand_certos + 1", 8)
    emit('println("Certo --> " + rel_name)', 8)
    emit("}", 7)
    emit("_ ==> {", 7)
    emit("grand_falhas = grand_falhas + 1", 8)
    emit('println("Falha --> " + rel_name)', 8)
    emit("}", 7)
    emit("}", 6)

    emit("cti = cti + 1", 6)
    emit("}", 5)
    emit("}", 4)
    emit("}", 3)

    emit("}", 2)
    emit("_ ==> {}", 2)
    emit("}", 1)
    emit()

    # =========================================================================
    # SUITE 2: NUMERICAL RECIPES
    # =========================================================================
    emit("#L ==========================================================================", 1)
    emit("#L SUÍTE 2: NUMERICAL RECIPES (--nr)", 1)
    emit("#L ==========================================================================", 1)
    emit("route {", 1)
    emit("flag_nr ==> {", 2)
    emit("mut as list of data: nr_chap_dirs = [", 3)
    for c in NR_CHAPTERS:
        emit(f'"{c}",', 4)
    emit("]", 3)

    emit("mut as int64: n_nr_chaps = 22", 3)
    emit("mut as int64: nri = 1", 3)
    emit("infinite {", 3)
    emit("route {", 4)
    emit("nri > n_nr_chaps ==> { break }", 5)
    emit("_ ==> {", 5)
    emit('mut as string: chap = "" + nr_chap_dirs[nri]', 6)
    emit('mut as string: chap_dir = "examples\\\\NumericalRecipes\\\\" + chap', 6)
    emit("mut as list of data: nr_entries = stdIoListDir(chap_dir)", 6)
    emit("mut as int64: n_nr_entries = stdCollectionLength(nr_entries)", 6)
    emit("mut as list of data: nr_files = []", 6)
    emit("mut as list of data: nr_files_lower = []", 6)
    emit("mut as int64: n_nr = 0", 6)
    emit("mut as int64: nei = 1", 6)
    emit("infinite {", 6)
    emit("route {", 7)
    emit("nei > n_nr_entries ==> { break }", 8)
    emit("_ ==> {", 8)
    emit('mut as string: fname = "" + nr_entries[nei]', 9)
    emit("mut as int64: fnlen = stdCollectionLength(fname)", 9)
    emit("route {", 9)
    emit("fnlen >= 5 ==> {", 10)
    emit("mut as string: fext = fname[(fnlen - 4)..fnlen]", 11)
    emit("route {", 11)
    emit('fext == ".flux" ==> {', 12)
    emit('mut as string: rel_name = chap + "\\\\" + fname', 13)
    emit("mut as int64: rnlen = stdCollectionLength(rel_name)", 13)

    # lowercase rel_name
    emit('mut as string: rn_low = ""', 13)
    emit("mut as int64: rni = 1", 13)
    emit("infinite {", 13)
    emit("route {", 14)
    emit("rni > rnlen ==> { break }", 15)
    emit("_ ==> {", 15)
    emit("mut as string: rch = rel_name[rni]", 16)
    emit("route {", 16)
    for upper_ch in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
        emit(f'rch == "{upper_ch}" ==> {{ rch = "{upper_ch.lower()}" }}', 17)
    emit("_ ==> {}", 17)
    emit("}", 16)
    emit("rn_low = rn_low + rch", 16)
    emit("rni = rni + 1", 16)
    emit("}", 15)
    emit("}", 14)
    emit("}", 13)

    # filter match
    emit("mut as bool: match_nr = false", 13)
    emit("route {", 13)
    emit('filtro_lower == "" ==> { match_nr = true }', 14)
    emit("_ ==> {", 14)
    emit("route {", 15)
    emit("rnlen >= flen ==> {", 16)
    emit("mut as int64: mi = 1", 17)
    emit("infinite {", 17)
    emit("route {", 18)
    emit("mi + flen - 1 > rnlen ==> { break }", 19)
    emit("_ ==> {", 19)
    emit("mut as string: sub = rn_low[mi..(mi + flen - 1)]", 20)
    emit("route {", 20)
    emit("sub == filtro_lower ==> {", 21)
    emit("match_nr = true", 22)
    emit("break", 22)
    emit("}", 21)
    emit("_ ==> { mi = mi + 1 }", 21)
    emit("}", 20)
    emit("}", 19)
    emit("}", 18)
    emit("}", 17)
    emit("}", 16)
    emit("_ ==> {}", 16)
    emit("}", 15)
    emit("}", 14)
    emit("}", 13)

    emit("route {", 13)
    emit("match_nr ==> {", 14)
    emit("n_nr = n_nr + 1", 15)
    emit("nr_files[n_nr] = fname", 15)
    emit("nr_files_lower[n_nr] = rn_low", 15)
    emit("}", 14)
    emit("_ ==> {}", 14)
    emit("}", 13)

    emit("}", 12)
    emit("_ ==> {}", 12)
    emit("}", 11)
    emit("}", 10)
    emit("_ ==> {}", 10)
    emit("}", 9)
    emit("nei = nei + 1", 9)
    emit("}", 8)
    emit("}", 7)
    emit("}", 6)

    # Sort files in this chapter
    emit("mut as int64: nsi = 1", 6)
    emit("infinite {", 6)
    emit("route {", 7)
    emit("nsi >= n_nr ==> { break }", 8)
    emit("_ ==> {", 8)
    emit("mut as int64: nsj = nsi + 1", 9)
    emit("infinite {", 9)
    emit("route {", 10)
    emit("nsj > n_nr ==> { break }", 11)
    emit("_ ==> {", 11)
    emit('mut as string: a_low = "" + nr_files_lower[nsi]', 12)
    emit('mut as string: b_low = "" + nr_files_lower[nsj]', 12)
    emit("mut as bool: swap = false", 12)
    emit("route {", 12)
    emit("a_low > b_low ==> { swap = true }", 13)
    emit("a_low == b_low ==> {", 13)
    emit('mut as string: a_orig = "" + nr_files[nsi]', 14)
    emit('mut as string: b_orig = "" + nr_files[nsj]', 14)
    emit("route {", 14)
    emit("a_orig > b_orig ==> { swap = true }", 15)
    emit("_ ==> {}", 15)
    emit("}", 14)
    emit("}", 13)
    emit("_ ==> {}", 13)
    emit("}", 12)
    emit("route {", 12)
    emit("swap ==> {", 13)
    emit("mut as data: tmp = nr_files[nsi]", 14)
    emit("nr_files[nsi] = nr_files[nsj]", 14)
    emit("nr_files[nsj] = tmp", 14)
    emit("mut as data: tmp_low = nr_files_lower[nsi]", 14)
    emit("nr_files_lower[nsi] = nr_files_lower[nsj]", 14)
    emit("nr_files_lower[nsj] = tmp_low", 14)
    emit("}", 13)
    emit("_ ==> {}", 13)
    emit("}", 12)
    emit("nsj = nsj + 1", 12)
    emit("}", 11)
    emit("}", 10)
    emit("}", 9)
    emit("nsi = nsi + 1", 9)
    emit("}", 8)
    emit("}", 7)
    emit("}", 6)

    # Execute files in this chapter
    emit("mut as int64: nti = 1", 6)
    emit("infinite {", 6)
    emit("route {", 7)
    emit("nti > n_nr ==> { break }", 8)
    emit("_ ==> {", 8)
    emit('mut as string: nome = "" + nr_files[nti]', 9)
    emit('mut as string: path = chap_dir + "\\\\" + nome', 9)
    emit('mut as string: rel_name = chap + "\\\\" + nome', 9)
    emit("mut as int64: nlen = stdCollectionLength(nome)", 9)

    emit('mut as string: stdin_file = "t_stdin.tmp"', 9)

    # Stem extraction
    emit("mut as string: stem = nome", 9)
    emit("route {", 9)
    emit("nlen > 5 ==> {", 10)
    emit("mut as string: sext = nome[(nlen - 4)..nlen]", 11)
    emit("route {", 11)
    emit('sext == ".flux" ==> { stem = nome[1..(nlen - 5)] }', 12)
    emit("_ ==> {}", 12)
    emit("}", 11)
    emit("}", 10)
    emit("_ ==> {}", 10)
    emit("}", 9)

    # Check EXPECT_ERROR
    emit("mut as string: src_code = stdIoReadFile(path)", 9)
    emit("mut as int64: src_len = stdCollectionLength(src_code)", 9)
    emit("mut as bool: is_err = false", 9)
    emit("route {", 9)
    emit("src_len >= 17 ==> {", 10)
    emit("mut as string: exp_pref = src_code[1..17]", 11)
    emit("route {", 11)
    emit('exp_pref == "#L EXPECT_ERROR: " ==> { is_err = true }', 12)
    emit("_ ==> {}", 12)
    emit("}", 11)
    emit("}", 10)
    emit("_ ==> {}", 10)
    emit("}", 9)

    # Backend execution
    emit_backend_test(emit, 9, t_id)

    # Print result
    emit("route {", 9)
    emit("is_ok ==> {", 10)
    emit("grand_certos = grand_certos + 1", 11)
    emit('println("Certo --> " + rel_name)', 11)
    emit("}", 10)
    emit("_ ==> {", 10)
    emit("grand_falhas = grand_falhas + 1", 11)
    emit('println("Falha --> " + rel_name)', 11)
    emit("}", 10)
    emit("}", 9)

    emit("nti = nti + 1", 9)
    emit("}", 8)
    emit("}", 7)
    emit("}", 6)

    emit("nri = nri + 1", 6)
    emit("}", 5)
    emit("}", 4)
    emit("}", 3)

    emit("}", 2)
    emit("_ ==> {}", 2)
    emit("}", 1)
    emit()

    # =========================================================================
    # SUITE 3: SCIENTIFIC ALGORITHMS
    # =========================================================================
    emit("#L ==========================================================================", 1)
    emit("#L SUÍTE 3: SCIENTIFIC ALGORITHMS (--sa)", 1)
    emit("#L ==========================================================================", 1)
    emit("route {", 1)
    emit("flag_sa ==> {", 2)
    emit("mut as list of data: sa_dom_dirs = [", 3)
    for d in SA_DOMAINS:
        emit(f'"{d}",', 4)
    emit("]", 3)

    emit("mut as int64: n_sa_doms = 13", 3)
    emit("mut as int64: sai = 1", 3)
    emit("infinite {", 3)
    emit("route {", 4)
    emit("sai > n_sa_doms ==> { break }", 5)
    emit("_ ==> {", 5)
    emit('mut as string: dom = "" + sa_dom_dirs[sai]', 6)
    emit('mut as string: dom_dir = "examples\\\\ScientificAlgorithms\\\\" + dom', 6)
    emit("mut as list of data: sa_entries = stdIoListDir(dom_dir)", 6)
    emit("mut as int64: n_sa_entries = stdCollectionLength(sa_entries)", 6)
    emit("mut as list of data: sa_files = []", 6)
    emit("mut as list of data: sa_files_lower = []", 6)
    emit("mut as int64: n_sa = 0", 6)
    emit("mut as int64: sei = 1", 6)
    emit("infinite {", 6)
    emit("route {", 7)
    emit("sei > n_sa_entries ==> { break }", 8)
    emit("_ ==> {", 8)
    emit('mut as string: fname = "" + sa_entries[sei]', 9)
    emit("mut as int64: fnlen = stdCollectionLength(fname)", 9)
    emit("route {", 9)
    emit("fnlen >= 5 ==> {", 10)
    emit("mut as string: fext = fname[(fnlen - 4)..fnlen]", 11)
    emit("route {", 11)
    emit('fext == ".flux" ==> {', 12)
    emit('mut as string: rel_name = dom + "\\\\" + fname', 13)
    emit("mut as int64: rnlen = stdCollectionLength(rel_name)", 13)

    # lowercase rel_name
    emit('mut as string: rn_low = ""', 13)
    emit("mut as int64: rni = 1", 13)
    emit("infinite {", 13)
    emit("route {", 14)
    emit("rni > rnlen ==> { break }", 15)
    emit("_ ==> {", 15)
    emit("mut as string: rch = rel_name[rni]", 16)
    emit("route {", 16)
    for upper_ch in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
        emit(f'rch == "{upper_ch}" ==> {{ rch = "{upper_ch.lower()}" }}', 17)
    emit("_ ==> {}", 17)
    emit("}", 16)
    emit("rn_low = rn_low + rch", 16)
    emit("rni = rni + 1", 16)
    emit("}", 15)
    emit("}", 14)
    emit("}", 13)

    # filter match
    emit("mut as bool: match_sa = false", 13)
    emit("route {", 13)
    emit('filtro_lower == "" ==> { match_sa = true }', 14)
    emit("_ ==> {", 14)
    emit("route {", 15)
    emit("rnlen >= flen ==> {", 16)
    emit("mut as int64: mi = 1", 17)
    emit("infinite {", 17)
    emit("route {", 18)
    emit("mi + flen - 1 > rnlen ==> { break }", 19)
    emit("_ ==> {", 19)
    emit("mut as string: sub = rn_low[mi..(mi + flen - 1)]", 20)
    emit("route {", 20)
    emit("sub == filtro_lower ==> {", 21)
    emit("match_sa = true", 22)
    emit("break", 22)
    emit("}", 21)
    emit("_ ==> { mi = mi + 1 }", 21)
    emit("}", 20)
    emit("}", 19)
    emit("}", 18)
    emit("}", 17)
    emit("}", 16)
    emit("_ ==> {}", 16)
    emit("}", 15)
    emit("}", 14)
    emit("}", 13)

    emit("route {", 13)
    emit("match_sa ==> {", 14)
    emit("n_sa = n_sa + 1", 15)
    emit("sa_files[n_sa] = fname", 15)
    emit("sa_files_lower[n_sa] = rn_low", 15)
    emit("}", 14)
    emit("_ ==> {}", 14)
    emit("}", 13)

    emit("}", 12)
    emit("_ ==> {}", 12)
    emit("}", 11)
    emit("}", 10)
    emit("_ ==> {}", 10)
    emit("}", 9)
    emit("sei = sei + 1", 9)
    emit("}", 8)
    emit("}", 7)
    emit("}", 6)

    # Sort files in this domain
    emit("mut as int64: ssi = 1", 6)
    emit("infinite {", 6)
    emit("route {", 7)
    emit("ssi >= n_sa ==> { break }", 8)
    emit("_ ==> {", 8)
    emit("mut as int64: ssj = ssi + 1", 9)
    emit("infinite {", 9)
    emit("route {", 10)
    emit("ssj > n_sa ==> { break }", 11)
    emit("_ ==> {", 11)
    emit('mut as string: a_low = "" + sa_files_lower[ssi]', 12)
    emit('mut as string: b_low = "" + sa_files_lower[ssj]', 12)
    emit("mut as bool: swap = false", 12)
    emit("route {", 12)
    emit("a_low > b_low ==> { swap = true }", 13)
    emit("a_low == b_low ==> {", 13)
    emit('mut as string: a_orig = "" + sa_files[ssi]', 14)
    emit('mut as string: b_orig = "" + sa_files[ssj]', 14)
    emit("route {", 14)
    emit("a_orig > b_orig ==> { swap = true }", 15)
    emit("_ ==> {}", 15)
    emit("}", 14)
    emit("}", 13)
    emit("_ ==> {}", 13)
    emit("}", 12)
    emit("route {", 12)
    emit("swap ==> {", 13)
    emit("mut as data: tmp = sa_files[ssi]", 14)
    emit("sa_files[ssi] = sa_files[ssj]", 14)
    emit("sa_files[ssj] = tmp", 14)
    emit("mut as data: tmp_low = sa_files_lower[ssi]", 14)
    emit("sa_files_lower[ssi] = sa_files_lower[ssj]", 14)
    emit("sa_files_lower[ssj] = tmp_low", 14)
    emit("}", 13)
    emit("_ ==> {}", 13)
    emit("}", 12)
    emit("ssj = ssj + 1", 12)
    emit("}", 11)
    emit("}", 10)
    emit("}", 9)
    emit("ssi = ssi + 1", 9)
    emit("}", 8)
    emit("}", 7)
    emit("}", 6)

    # Execute files in this domain
    emit("mut as int64: sti = 1", 6)
    emit("infinite {", 6)
    emit("route {", 7)
    emit("sti > n_sa ==> { break }", 8)
    emit("_ ==> {", 8)
    emit('mut as string: nome = "" + sa_files[sti]', 9)
    emit('mut as string: path = dom_dir + "\\\\" + nome', 9)
    emit('mut as string: rel_name = dom + "\\\\" + nome', 9)
    emit("mut as int64: nlen = stdCollectionLength(nome)", 9)

    emit('mut as string: stdin_file = "t_stdin.tmp"', 9)

    # Stem extraction
    emit("mut as string: stem = nome", 9)
    emit("route {", 9)
    emit("nlen > 5 ==> {", 10)
    emit("mut as string: sext = nome[(nlen - 4)..nlen]", 11)
    emit("route {", 11)
    emit('sext == ".flux" ==> { stem = nome[1..(nlen - 5)] }', 12)
    emit("_ ==> {}", 12)
    emit("}", 11)
    emit("}", 10)
    emit("_ ==> {}", 10)
    emit("}", 9)

    # Check EXPECT_ERROR
    emit("mut as string: src_code = stdIoReadFile(path)", 9)
    emit("mut as int64: src_len = stdCollectionLength(src_code)", 9)
    emit("mut as bool: is_err = false", 9)
    emit("route {", 9)
    emit("src_len >= 17 ==> {", 10)
    emit("mut as string: exp_pref = src_code[1..17]", 11)
    emit("route {", 11)
    emit('exp_pref == "#L EXPECT_ERROR: " ==> { is_err = true }', 12)
    emit("_ ==> {}", 12)
    emit("}", 11)
    emit("}", 10)
    emit("_ ==> {}", 10)
    emit("}", 9)

    # Backend execution
    emit_backend_test(emit, 9, t_id)

    # Print result
    emit("route {", 9)
    emit("is_ok ==> {", 10)
    emit("grand_certos = grand_certos + 1", 11)
    emit('println("Certo --> " + rel_name)', 11)
    emit("}", 10)
    emit("_ ==> {", 10)
    emit("grand_falhas = grand_falhas + 1", 11)
    emit('println("Falha --> " + rel_name)', 11)
    emit("}", 10)
    emit("}", 9)

    emit("sti = sti + 1", 9)
    emit("}", 8)
    emit("}", 7)
    emit("}", 6)

    emit("sai = sai + 1", 6)
    emit("}", 5)
    emit("}", 4)
    emit("}", 3)

    emit("}", 2)
    emit("_ ==> {}", 2)
    emit("}", 1)
    emit()

    # 7. Final cleanup
    emit("#L 7. Limpeza final de arquivos e pastas temporarias t_*", 1)
    emit_temp_cleanup("cl_fin", 1)
    emit()

    # Totalizer in 2 lines and exit code
    emit("#L 8. Totalizador final em 2 linhas e codigo de saida", 1)
    emit('println("")', 1)
    emit('println("Certos: " + grand_certos)', 1)
    emit('println("Falhas: " + grand_falhas)', 1)
    emit("route {", 1)
    emit("grand_falhas == 0 ==> { stdOsExit(0) }", 2)
    emit("_                 ==> { stdOsExit(1) }", 2)
    emit("}", 1)

    emit("}")
    emit()
    return "\n".join(lines)


def main():
    os.makedirs("examples", exist_ok=True)
    for target in TARGETS:
        out_path = os.path.join("examples", target["filename"])
        content = generate_runner(target)
        with open(out_path, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"[OK] Generated {out_path} ({len(content.splitlines())} lines)")


if __name__ == "__main__":
    main()
