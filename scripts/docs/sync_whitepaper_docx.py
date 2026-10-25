"""Sincronizador e Gerador do White Paper TheFlux em DOCX (v0.7.5).

Gera:
  - docs/pt/TheFlux.docx (Português atualizado para v0.7.5 com fonte Arial estrita)
  - docs/en/TheFlux.docx (Inglês traduzido e atualizado para v0.7.5 com fonte Arial estrita)
  - Atualiza o Sumário dinâmico (TOC) via Word COM Automation (win32com.client)
"""
from __future__ import annotations

import os
import shutil
import sys
from pathlib import Path
import docx
from docx.oxml.ns import qn

# Configura UTF-8 no Windows
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

RAIZ = Path(__file__).resolve().parent.parent.parent
DOCS_DIR = RAIZ / "docs"
PT_DOCS = DOCS_DIR / "pt_BR"
EN_DOCS = DOCS_DIR / "en"

BAK_DOCX = PT_DOCS / "TheFlux_bak.docx"
PT_OUT_DOCX = PT_DOCS / "TheFlux.docx"
EN_OUT_DOCX = EN_DOCS / "TheFlux.docx"


def enforce_arial_font(doc: docx.Document):
    """Garante de forma irrestrita a aplicação da fonte Arial em todos os estilos, parágrafos, runs e tabelas."""
    # 1. Estilos do documento
    for s in doc.styles:
        if hasattr(s, "font") and s.font:
            s.font.name = "Arial"

    # 2. Parágrafos do corpo
    for p in doc.paragraphs:
        for r in p.runs:
            r.font.name = "Arial"
            rPr = r._r.get_or_add_rPr()
            rFonts = rPr.get_or_add_rFonts()
            rFonts.set(qn("w:ascii"), "Arial")
            rFonts.set(qn("w:hAnsi"), "Arial")
            rFonts.set(qn("w:cs"), "Arial")

    # 3. Tabelas e células
    for t in doc.tables:
        for row in t.rows:
            for cell in row.cells:
                for p in cell.paragraphs:
                    for r in p.runs:
                        r.font.name = "Arial"
                        rPr = r._r.get_or_add_rPr()
                        rFonts = rPr.get_or_add_rFonts()
                        rFonts.set(qn("w:ascii"), "Arial")
                        rFonts.set(qn("w:hAnsi"), "Arial")
                        rFonts.set(qn("w:cs"), "Arial")


def update_portuguese_whitepaper(src_path: Path, dst_path: Path):
    """Atualiza o documento em português para o release 0.7.5 mantendo estilos e aplicando Arial."""
    print(f"  [+] Carregando template base: {src_path}")
    doc = docx.Document(str(src_path))

    # Atualizações de capa
    doc.paragraphs[28].text = "White Paper, versão 0.7.5"
    doc.paragraphs[46].text = "Bauru/SP – Outubro de 2026"

    # Atualizações em parágrafos específicos da versão 0.7.5
    # Capítulo 4: Filosofia dos agents & StdLibs Modulares
    p_ch4_updates = {
        116: "Cada agent opera como um submódulo de compilação independente que implementa uma DSL (Domain-Specific Language) Embutida. No release 0.7.5, todo o ecossistema foi refatorado em 37 bibliotecas padrão modulares e hierárquicas, estruturadas sob pacotes canônicos com contratos tipados obrigatórios.",
        117: "Análise Semântica de Fronteira: Validação rigorosa dos tipos e dimensões de dados na entrada e saída do nó de processamento através de contratos semânticos tipados.",
        122: "Enquanto um agent reside em um submódulo com o sufixo fdsl, por exemplo: MathStdLib/Trigonometry.fdsl, StatStdLib/StatInference.fdsl, o programa principal (program) reside em um arquivo com o sufixo flux (ex: contagem.flux, vetores.flux). Cada biblioteca expõe um arquivo agregador mestre (<Lib>StdLib.fdsl) contendo a declaração de tipos globais (struct e enum), o manifesto declarativo (use <Dominio>.fdsl) e operações utilitárias compartilhadas.",
    }
    for idx, txt in p_ch4_updates.items():
        if idx < len(doc.paragraphs):
            doc.paragraphs[idx].text = txt

    # Capítulo 6: Runtime & Pipeline Multi-Backend
    p_ch6_updates = {
        191: "A arquitetura de execução e geração de artefatos da FLUX opera de forma totalmente sincronizada através de 6 backends oficiais com 100,0% de conformidade e zero regressão:",
        192: "1. Interpreter (in): Executa diretamente a Árvore de Sintaxe Abstrata (AST) para validação imediata e referência semântica.",
        193: "2. Compiler + VM (.fvmbc / vm): Transforma a AST e serializa o bytecode nativo no formato binário FLUX_VM_BYTECODE com validação estrita de versão.",
        194: "3. Disk Reloaded VM (vmr): Recarrega o bytecode .fvmbc do disco e o reexecuta na VM, garantindo a integridade e determinismo de serialização.",
        196: ".flux / .fdsl -> Lexer -> Parser -> MacroExpander -> SemanticAnalyzer",
        197: "                              ├──> in   (AST Interpreter)",
        198: "                              ├──> vm   (BytecodeCompiler ──> .fvmbc ──> BytecodeVM)",
        199: "                              ├──> vmr  (Disk Reloaded .fvmbc ──> BytecodeVM)",
        200: "                              ├──> llvm (LLVM IR ──> Clang ──> Binário Nativo Executável)",
        201: "                              ├──> wat  (WebAssembly Text ──> wat2wasm ──> Wasmer Runtime)",
        202: "                              └──> wasm (WASM Binário de Passagem Única ──> Wasmer Runtime)",
        210: "A CLI oficial da FLUX unifica a execução multi-backend via flags explícitas: --backend in|vm|vmr|llvm|wat|wasm, além de alvos de geração direta como --emit-llvm, --target wat|wasm|vmbc e suítes de conformidade automatizadas.",
    }
    for idx, txt in p_ch6_updates.items():
        if idx < len(doc.paragraphs):
            doc.paragraphs[idx].text = txt

    # Capítulo 11 & 17: Tipos Complexos e Restrições de Shape / Coleções
    p_types_updates = {
        288: "A linguagem FLUX adota um sistema de tipos unificado e focado no processamento de dados em fluxo. No release 0.7.5, inclui suporte nativo de primeira classe a números complexos (complex64 e complex128) e restrições estáticas obrigatórias de shape para tensores e tipos em coleções.",
        392: "Shape Estática (compile time): Tensores exigem obrigatoriamente a declaração explícita de seu shape no formato [d1, d2, ...] em tempo de compilação, prevenindo erros de alocação e garantindo inferência exata de memória. Da mesma forma, coleções list[T] e set[T] exigem a tipagem de seu elemento.",
    }
    for idx, txt in p_types_updates.items():
        if idx < len(doc.paragraphs):
            doc.paragraphs[idx].text = txt

    # Capítulo 20: Governança, Rastreabilidade e Diagnósticos
    p_ch20_updates = {
        487: "Para assegurar a consistência absoluta entre a especificação teórica e a implementação da FLUX, os testes e exemplos práticos atuam como documentação normativa da linguagem. A versão v0.7.5 estabelece governança contínua com 2.256 verificações ativas entre os 6 backends:",
        488: "Sistema de Diagnósticos Granulares: Implementação de 10 famílias taxonômicas estruturadas (LEX001 a SYS902) com mensagens prescritivas, localização espacial precisa e dicas (hint) acionáveis para resolução de problemas.",
        489: "Compilação AOT do Catálogo de Erros: Sincronização antecipada gerando catalog_data.py no interpretador Python e flux_errors.h no runtime C/LLVM, unificando os diagnósticos em todos os alvos de compilação.",
        490: "Gramática Formal ISO/IEC 14977: Especificação formal da linguagem padronizada em formato puro EBNF em docs/pt/TheFlux.ebnf e docs/pt/Gramatica.ebnf.",
    }
    for idx, txt in p_ch20_updates.items():
        if idx < len(doc.paragraphs):
            doc.paragraphs[idx].text = txt

    # Capítulo 21: ROADMAP
    p_ch21_updates = {
        504: "21.1 Marcos Consolidados no Release 0.7.5:",
        505: "Arquitetura canônica modular das 37 bibliotecas padrão com contratos de domínio tipados.",
        506: "Conformidade de 100,0% nos 6 backends de execução (in, vm, vmr, llvm, wat, wasm) com 2.256 testes automatizados.",
        507: "Compilação AOT do catálogo de erros em C e Python e gramática formal pura ISO/IEC 14977.",
        508: "Simetria bilíngue estrita 1:1 em toda a documentação técnica (Português e Inglês).",
        509: "21.2 Objetivos Oficiais para a Versão 1.0.0 LTS:",
        510: "Topologia de Dataflow Não-Linear e Grafos Direcionados Acíclicos (DAGs) com execução assíncrona ramificada.",
        511: "JIT Tiering no Runtime VMR com compilação dinâmica de loops quentes (hot paths).",
        512: "Gerenciador oficial de pacotes e ecossistema modular fluxpkg e aceleração nativa GPGPU / CUDA.",
    }
    for idx, txt in p_ch21_updates.items():
        if idx < len(doc.paragraphs):
            doc.paragraphs[idx].text = txt

    # Aplicação irrestrita da fonte Arial em todo o documento
    print("  [+] Aplicando fonte Arial em 100% dos parágrafos, runs e tabelas...")
    enforce_arial_font(doc)

    print(f"  [+] Gravando documento em português: {dst_path}")
    doc.save(str(dst_path))


def build_english_whitepaper(src_path: Path, dst_path: Path):
    """Gera o White Paper completo em inglês com base no template e aplicando Arial em tudo."""
    print(f"  [+] Criando versão em inglês a partir de: {src_path}")
    doc = docx.Document(str(src_path))

    # Dicionário de tradução dos 21 capítulos e seções
    EN_PARAGRAPHS: dict[int, str] = {
        # Capa
        22: "FLUX",
        27: "PROGRAMMING LANGUAGE",
        28: "White Paper, version 0.7.5",
        46: "Bauru/SP – October 2026",
        47: "TABLE OF CONTENTS",
        # Capítulo 1: Introdução
        53: "1 Introduction",
        54: "FLUX is a general-purpose programming language grounded in the semantic Dataflow paradigm and adaptively extended through specialized context agents. The language design converges syntactic clarity, explicit data pipelines, High-Performance Computing (HPC), massively parallel processing, artificial intelligence, hardware-agnostic interoperability, automated memory management, and agent-guided semantic execution.",
        55: "The architectural philosophy of FLUX establishes a strict separation of concerns: the kernel governs dataflow movement and physical topology orchestration, while agents interpret and execute domain-specific semantics. Consequently, the kernel adopts a minimalist microkernel approach, maintaining a lean Abstract Syntax Tree (AST) that processes only elementary arithmetic, comparison logic, primitive control flow, and core I/O. All specialized semantics and domain optimizations are delegated entirely to agents.",
        56: "Consequently, FLUX transcends purely procedural models, establishing itself as a dynamic computational ecosystem driven by continuous dataflow transformation graphs.",
        59: "1.1 Language Goals",
        60: "FLUX architecture is founded upon design directives that prioritize symmetry between the mental representation of computational models and physical hardware execution. The language captures high-level expressiveness without sacrificing low-level systemic control.",
        62: "1.1.1 Architectural Directives (Core Objectives)",
        63: "Syntactic Ergonomics (Human Clarity): Cognitive load reduction through a direct, readable grammar free of conventional boilerplate noise.",
        64: "Determinism (Predictability): Guaranteed reproducible execution free of hidden side effects, enforced by strict immutability and allocation rules.",
        65: "AST Minimalism (Structural Simplicity): A microkernel language core focused strictly on primary data transport and orchestration.",
        66: "Transparent Graph Topology (Explicit Flow): Transformation pipelines are exposed natively in source code via the pipe operator (-->), preventing obfuscated control flow and keeping graph topology visible to the compiler.",
        67: "Isolated Extensibility (Decoupled Semantics): Complete delegation of domain logic to embedded domain-specific sublanguages (DSLs), shielding the core compiler from feature bloat.",
        68: "Direct Optimization (High Performance): Zero-cost abstractions and lowering designed to exploit full vector execution capabilities on modern CPUs and GPUs.",
        69: "Liveness Management (Automated Lifetime): Topological inference of physical memory liveness, eliminating arbitrary garbage collection pauses at runtime.",
        71: "1.1.2 Execution Domains (Application Scope)",
        72: "The semantic engine and agnostic core infrastructure are engineered to scale across demanding computational workloads:",
        73: "Prototyping & Education: Minimal verbosity coupled with type inference, accelerating conceptual algorithm formulation.",
        74: "HPC (Science & Engineering): Native support for physical simulation, numerical algorithms, and rigorous mathematical modeling.",
        75: "Neural Networks & Numerical AI: Seamless multi-backend integration for multidimensional tensor processing, automatic differentiation, and linear algebra.",
        76: "Massive Data Pipelines (Distributed Systems): Natural parallelism for stream processing and continuous data ingestion across decentralized clusters.",
        # Capítulo 2: Arquitetura Geral
        81: "2 General Architecture",
        82: "The FLUX architecture is organized modularly into four concentric and interdependent tiers designed to isolate infrastructure from application semantics:",
        # Capítulo 3: Filosofia do Kernel
        88: "3 Kernel Philosophy",
        89: "The FLUX kernel operates under the principle of Strict Semantic Agnosticism. Its design guarantees that the compiler core contains zero hardcoded mathematical, scientific, or business domain rules.",
        91: "3.1 Abstraction Boundaries (What the Kernel Ignores)",
        92: "To maintain long-term architectural stability, the kernel deliberately abstracts away high-level domain concepts:",
        93: "Scientific Units & Physical Dimensions: The kernel does not evaluate units (e.g., meters, seconds, kelvin). Dimensions and dimensional consistency are verified exclusively by specialized domain agents (such as PhysStdLib).",
        94: "Domain-Specific Algorithms: Tensor decompositions, graph algorithms, and cryptographic primitives do not reside in the kernel AST; they are handled entirely by standard libraries.",
        95: "Target Hardware Specifics: Low-level instruction selection (AVX-512, CUDA kernels, WASM opcodes) is resolved during lowering by backend targets.",
        97: "3.2 Infrastructure Competencies (What the Kernel Governs)",
        98: "The kernel focuses strictly on essential systemic responsibilities:",
        99: "Lexical & Syntactic Parsing: Transforming source code into a clean, validated Abstract Syntax Tree.",
        100: "Dataflow Pipeline Construction: Assembling the Data Dependency Graph (DDG) connecting program nodes.",
        101: "Type Checking & Structural Integrity: Verifying scalar types, shapes, and structural consistency.",
        102: "Dynamic Dispatch & Lowering: Routing node execution to appropriate backend targets.",
        104: "3.3 Metaprogramming",
        105: "FLUX supports compile-time metaprogramming via the comptime keyword, enabling static evaluation of expressions, constants, and code templates prior to bytecode or machine code emission.",
        # Capítulo 4: Filosofia dos agents & StdLibs
        116: "4 Agent Philosophy & Standard Libraries",
        117: "Each agent operates as an independent compilation submodule that implements an Embedded Domain-Specific Language (EDSL). While the kernel manages flow topology, agents execute domain semantics. In version 0.7.5, all 37 standard libraries are modularized into canonical hierarchical packages.",
        118: "Boundary Semantic Analysis: Strict validation of data types, tensor ranks, and shapes at the entry and exit boundaries of each processing node via formal contracts.",
        119: "Domain Logic Implementation: Execution of mathematical algorithms, data structures, and scientific procedures.",
        120: "Code Generation & Lowering: Hardware-level broadcasting, vectorization, and optimization passes.",
        121: "Target Dispatch: Direct routing to physical native backends (C/LLVM), virtual machines (Bytecode VM), and WebAssembly.",
        122: "Standard Library packages reside under stdlib/<Lib>StdLib/<Domain>.fdsl, with a master aggregator file (<Lib>StdLib.fdsl) declaring global types, manifests, and shared utility operations.",
        124: "4.1 Semantic Contracts",
        125: "To preserve graph integrity, every child submodule formally implements a typed contract (contract <DomainContract> and agent <Lib>StdLib impl <DomainContract>), enforcing strict boundary bounds and error propagation via emit(nice, ...) or emit(fail, ...).",
        127: "4.2 Embedded DSLs as Agents",
        128: "Invoking an agent represents a seamless context transition into an optimized domain DSL (e.g., MathStdLib::Trigonometry::sin(x)).",
        # Capítulo 5: Filosofia do Fluxo
        143: "5 Dataflow Philosophy",
        144: "The FLUX execution model unites hybrid evaluation strategies, combining eager evaluation for deterministic streams with lazy evaluation for large-scale dataset pipelines.",
        146: "5.1 Pipe Operator Mechanics (-->)",
        147: "The pipe operator (-->) directs the output of a preceding node into the first available parameter of the successor node, providing an intuitive, left-to-right readable transformation pipeline.",
        149: "5.2 Semantic Equivalence",
        150: "Expressions written using pipe syntax (a --> f() --> g()) are strictly equivalent in compiler representation to nested functional calls g(f(a)), guaranteeing zero abstraction penalty.",
        # Capítulo 6: Runtime & Pipeline Multi-Backend
        162: "6 Runtime Philosophy",
        163: "The FLUX runtime serves as the low-level orchestration engine, governing memory lifetime, arena recycling, and multi-backend execution dispatch.",
        165: "6.1 Memory Philosophy",
        166: "FLUX implements deterministic Dataflow-Driven Memory Management, bypassing traditional tracing Garbage Collection pauses while avoiding manual pointer management.",
        170: "6.2 Inferred Lifetime",
        171: "Memory buffers are reclaimed via topological Survival Analysis: intermediate nodes in a linear pipeline are automatically disposed of immediately after consumption by successor nodes.",
        181: "6.3 Performance Philosophy",
        182: "The compiler decouples graph topology from hardware execution strategy, optimizing data flow across SIMD vectorization, multi-core CPU threads, and native machine instructions.",
        190: "6.4 Compilation and Execution Pipeline (6 Official Backends)",
        191: "FLUX architecture features 6 official execution backends with 100.0% compliance and zero regression:",
        192: "1. Interpreter (in): Direct AST interpreter (flux_in.py) for immediate validation and semantic reference.",
        193: "2. Compiler + VM (.fvmbc / vm): Bytecode compiler serializing the binary FLUX_VM_BYTECODE format, executed by the BytecodeVM.",
        194: "3. Disk Reloaded VM (vmr): Reloads serialized .fvmbc bytecode from disk and executes it on the VM, validating roundtrip fidelity.",
        195: "4. LLVM Backend (llvm): Lowers AST to LLVM IR, compiled via Clang into high-performance native machine code.",
        196: "5. WebAssembly Text (wat): Lowers AST to WebAssembly Text format (.wat), assembled via wat2wasm, and executed on Wasmer.",
        197: "6. WebAssembly Binary (wasm): Single-pass direct WebAssembly binary emitter (.wasm), executed on Wasmer.",
        203: "6.4.1 Feature Parity Contract",
        204: "Every language feature is required to maintain full behavioral parity across all 6 backends, verified by the automated compliance test suite.",
        209: "6.5 Command Line Interface (CLI) and Output Targets",
        210: "The FLUX CLI exposes explicit flags: --backend in|vm|vmr|llvm|wat|wasm, --emit-llvm, --target wat|wasm|vmbc, and --out for flexible build artifact placement.",
        # Capítulo 7: Interoperabilidade
        236: "7 Interoperability Philosophy",
        237: "FLUX adopts 1-based indexing as an invariant universal convention across all vectors, lists, and tensors, aligning with standard mathematical and scientific notation.",
        239: "7.1 Index Offset Shifting",
        240: "When interfacing with external C-ABI or 0-based runtimes, the runtime automatically applies offset compensation, preserving zero-error interoperability.",
        # Capítulo 8: Indentação e Comentários
        255: "8 Standardization of Indentation and Comments",
        256: "Indentation in FLUX is strictly structural and mandatory, defined by multiples of 4 spaces. Tabs are disallowed.",
        258: "8.1 Single-Line Comment Example (#)",
        260: "8.2 Block Comment Example (#[ ... ]#)",
        262: "8.3 Documentation Comment Example (##)",
        # Capítulo 9: Nomenclatura
        274: "9 Naming Conventions",
        275: "FLUX enforces explicit naming heuristics: SCREAMING_SNAKE for immutable identifiers (imut), snake_case for mutable variables (mut), and PascalCase for types and agents.",
        # Capítulo 10: Continuidade de Linha
        280: "10 Line Continuation Standardization",
        281: "Statement termination is inferred automatically. When an expression ends with a pending binary operator (e.g., -->, +, *), line continuation is inferred without requiring backslashes.",
        # Capítulo 11: Tipos Fundamentais
        288: "11 Fundamental Types",
        289: "FLUX provides a unified type system supporting primitive scalars (int8..int64, uint8..uint64, float16..float64), native complex numbers (complex64, complex128), and typed multidimensional tensors.",
        291: "11.1 Numerical Precision",
        293: "11.2 Struct and Enum (Composite Types)",
        # Capítulo 12: Operadores Matemáticos
        307: "12 Mathematical Operators",
        308: "Full suite of arithmetic operators (+, -, *, /f, /i, /r, ^e, ^r) and compound assignments, verified across all compilation targets.",
        310: "12.1 Mathematical Operators",
        312: "12.1.1 Compound Arithmetic Assignment Operators",
        # Capítulo 13: Operadores Bitwise
        320: "13 Bitwise Operators",
        321: "Bitwise logic (&, |, ^, ~, <<, >>) with exact integer boundary behavior.",
        323: "13.1 Bitwise Operators",
        325: "13.2 Compound Bitwise Assignment Operators",
        # Capítulo 14: Operadores de Fluxo
        333: "14 Flow Operators",
        334: "Dataflow routing operators (--> pipeline, ==> broadcast) and pattern matching via match.",
        336: "14.1 Match Mechanics",
        # Capítulo 15: Intervalo e Slice
        348: "15 Range, Access, and Slice Operators",
        349: "Operators for 1-based element indexing [i] and slicing [start:end:step] on tensors, vectors, and lists.",
        # Capítulo 16: Operadores Relacionais
        354: "16 Relational Operators",
        355: "Standard relational comparisons (==, !=, <, <=, >, >=) with strict type matching.",
        # Capítulo 17: Identificadores e Sistema de Tipos
        361: "17 Data Identifier Representation & Type System",
        362: "Data identifiers follow strict mutability semantics: imut declares immutable constants, while mut declares mutable variables.",
        364: "17.1 Mutability System",
        366: "17.1.1 imut (Immutable – SCREAMING_SNAKE)",
        368: "17.1.2 mut (Mutable – snake_case)",
        370: "17.2 Type System (Hybrid and Gradual)",
        372: "17.2.1 Explicit Declaration",
        374: "17.2.2 Automatic Inference",
        376: "17.2.3 Function and Struct Typing",
        378: "17.3 Shape and Static Constraints",
        379: "17.3.1 Static Shape (Compile Time): Tensors mandate explicit shape dimensions [d1, d2, ...] at compile time. Collections list[T] and set[T] require explicit element types.",
        381: "17.3.2 Dynamic Shape (Runtime)",
        383: "17.4 Initial Assignment and Default Values",
        # Capítulo 18: Promoção e Coerção
        415: "18 Promotion, Coercion, and Broadcasting",
        416: "Automatic widening promotion for safe numerical operations and explicit narrowing coercion via the as keyword.",
        418: "18.1 Automatic Promotion (Widening)",
        420: "18.2 Explicit Coercion (Narrowing/Casting via as)",
        422: "18.3 Multidimensional Broadcasting",
        # Capítulo 19: Keywords
        432: "19 Language Keywords",
        433: "The FLUX vocabulary comprises 74 canonical keywords grouped across architectural domains, documented in the interactive portal.",
        435: "19.1 Architectural Domains Overview",
        436: "19.1.1 Global Orchestration & Metaprogramming (program, comptime, use, agent, contract, impl)",
        438: "19.1.2 Input/Output & State Sensors (input, print, spy, emit)",
        440: "19.1.3 Expression, Boolean Algebra & Literals (and, or, not, true, false, none)",
        442: "19.1.4 Imperative Control Flow (if, else, match, for, while, break, continue)",
        444: "19.1.5 Resilience & Pattern Matching (try, catch, fallback, ensure, fail, nice)",
        446: "19.1.6 Structure, Types & Contracts (struct, enum, contract, type, as)",
        448: "19.1.7 Lifecycle & Memory Safety (imut, mut, borrow, move, keep)",
        450: "19.1.8 Graph Topology & Concurrency (spawn, async, await, channel)",
        452: "19.1.9 Composite Types & Collections (list, map, set, tensor)",
        # Capítulo 20: Governança, Rastreabilidade e Diagnósticos
        487: "20 Governance Guidelines, Traceability, and Granular Diagnostics",
        488: "Version 0.7.5 establishes continuous governance with 2,256 active checks across 6 backends with zero regression.",
        489: "Granular Diagnostic Taxonomy: 10 taxonomic families (LEX001 through SYS902) providing pinpoint spatial error localization and actionable hints.",
        490: "Ahead-of-Time (AOT) Catalog Compilation: Synchronized generation of catalog_data.py for Python and flux_errors.h for C/LLVM.",
        491: "ISO/IEC 14977 Formal Grammar: Standardized EBNF grammar specifications maintained in docs/en/TheFlux.ebnf and docs/en/Grammar.ebnf.",
        # Capítulo 21: ROADMAP
        504: "21 ROADMAP",
        505: "21.1 Consolidated Milestones in Version 0.7.5:",
        506: "- Modular hierarchical architecture for all 37 standard libraries with formal contracts.",
        507: "- 100.0% compliance across all 6 execution backends (in, vm, vmr, llvm, wat, wasm).",
        508: "- Granular diagnostic taxonomy with actionable hints and AOT error compilation.",
        509: "- Strict 1:1 bilingual documentation parity across all technical artifacts.",
        510: "21.2 Official Roadmap to Version 1.0.0 LTS:",
        511: "- Non-linear dataflow topology and Directed Acyclic Graphs (DAGs) with branching concurrency.",
        512: "- VMR runtime JIT tiering with dynamic hot-loop profiling and compilation.",
    }

    # Aplica as traduções de parágrafos
    for idx, text in EN_PARAGRAPHS.items():
        if idx < len(doc.paragraphs):
            doc.paragraphs[idx].text = text

    # Tradução de Tabelas
    translate_english_tables(doc)

    # Aplicação irrestrita da fonte Arial em todo o documento
    print("  [+] Aplicando fonte Arial em 100% dos parágrafos, runs e tabelas da versão em inglês...")
    enforce_arial_font(doc)

    print(f"  [+] Gravando documento em inglês: {dst_path}")
    doc.save(str(dst_path))


def translate_english_tables(doc: docx.Document):
    """Traduz os cabeçalhos e células das tabelas para o inglês técnico."""
    table_translations = {
        0: {
            (0, 0): "Tier", (0, 1): "Architectural Responsibility",
            (1, 0): "kernel", (1, 1): "Lexical/syntactic parsing, primitive types, primary execution management, and target dispatch.",
            (2, 0): "program", (2, 1): "Core instruction subset responsible for initiating processes across VM, interpreter, or native binaries.",
            (3, 0): "agent", (3, 1): "Contextual semantic engine implementing domain DSLs, dataflow operations, and hardware offloading.",
            (4, 0): "hardware", (4, 1): "Physical compute targets (CPU, GPU, SIMD, MKL, WASM) executing lowered instructions.",
        },
        1: {
            (0, 0): "Object", (0, 1): "Standardization", (0, 2): "Examples",
            (1, 0): "Immutable", (1, 1): "SCREAMING_SNAKE", (1, 2): "G, PI, LIGHT_SPEED",
            (2, 0): "Mutable", (2, 1): "snake_case", (2, 2): "weight, final_velocity, t",
            (3, 0): "Types & Structs", (3, 1): "PascalCase", (3, 2): "Vector3D, UserAccount",
            (4, 0): "Agents & DSLs", (4, 1): "PascalCase", (4, 2): "MathStdLib, NetStdLib",
            (5, 0): "Functions & Ops", (5, 1): "snake_case", (5, 2): "compute_eigenvalues, route",
        },
        2: {
            (0, 0): "Category", (0, 1): "Pending Operator",
            (1, 0): "Flow", (1, 1): "--> and ==>, join, split",
            (2, 0): "Mathematical", (2, 1): "+, -, *, /f, /i, /r, ^e, ^r, =",
            (3, 0): "Bitwise", (3, 1): "&, |, ^, ~, <<, >>",
            (4, 0): "Relational", (4, 1): "==, !=, <, <=, >, >=",
            (5, 0): "Logical", (5, 1): "and, or, not",
        },
        3: {
            (0, 0): "Type", (0, 1): "Purpose", (0, 2): "Rank",
            (1, 0): "int", (1, 1): "Standard signed integer", (1, 2): "0",
            (2, 0): "float", (2, 1): "Floating-point real number", (2, 2): "0",
            (3, 0): "complex", (3, 1): "Complex number (real + imaginary)", (3, 2): "0",
            (4, 0): "bool", (4, 1): "Boolean truth value (true/false)", (4, 2): "0",
            (5, 0): "char", (5, 1): "Single character", (5, 2): "0",
            (6, 0): "string", (6, 1): "UTF-8 textual sequence", (6, 2): "1",
            (7, 0): "list", (7, 1): "Homogeneous dynamically sized list", (7, 2): "1",
            (8, 0): "tensor", (8, 1): "Multidimensional tensor with static shape", (8, 2): "N",
        },
        11: {
            (0, 0): "Operator", (0, 1): "Purpose", (0, 2): "Evaluation",
            (1, 0): "==", (1, 1): "Structural equality", (1, 2): "Eager",
            (2, 0): "!=", (2, 1): "Inequality", (2, 2): "Eager",
            (3, 0): "<", (3, 1): "Strictly less than", (3, 2): "Eager",
            (4, 0): "<=", (4, 1): "Less than or equal to", (4, 2): "Eager",
            (5, 0): ">", (5, 1): "Strictly greater than", (5, 2): "Eager",
            (6, 0): ">=", (6, 1): "Greater than or equal to", (6, 2): "Eager",
        },
    }

    for t_idx, cell_map in table_translations.items():
        if t_idx < len(doc.tables):
            t = doc.tables[t_idx]
            for (r, c), val in cell_map.items():
                if r < len(t.rows) and c < len(t.rows[r].cells):
                    t.rows[r].cells[c].text = val


def update_toc_with_word_com(file_paths: list[Path]):
    """Atualiza o Sumário (TOC) e campos de numeração de páginas usando o Word COM nativo."""
    print("\n==================================================")
    print("🚀 Atualização Dinâmica do Sumário (TOC) via Word COM")
    print("==================================================")
    try:
        import win32com.client
    except ImportError:
        print("  [!] win32com não disponível. Atualização de TOC ignorada.")
        return

    word = None
    try:
        word = win32com.client.Dispatch("Word.Application")
        word.Visible = False

        for fpath in file_paths:
            if not fpath.exists():
                continue
            abs_path = str(fpath.resolve())
            print(f"  [+] Abrindo no Microsoft Word: {fpath.name}")
            doc = word.Documents.Open(abs_path)
            try:
                if doc.TablesOfContents.Count > 0:
                    for i in range(1, doc.TablesOfContents.Count + 1):
                        doc.TablesOfContents(i).Update()
                    print(f"      ✅ Sumário (TOC) atualizado em {fpath.name}")
                doc.Fields.Update()
                doc.Save()
                print(f"      ✅ Campos e paginação salvos em {fpath.name}")
            finally:
                doc.Close(False)

        print("  ✅ Todos os Sumários e campos foram sincronizados com sucesso!")
    except Exception as e:
        print(f"  [!] Aviso Word COM: {e}")
    finally:
        if word:
            try:
                word.Quit()
            except Exception:
                pass


def main():
    print("======================================================================")
    print("📘 TheFlux — Sincronizador do White Paper (DOCX v0.7.5)")
    print(f"   Destino PT: {PT_OUT_DOCX}")
    print(f"   Destino EN: {EN_OUT_DOCX}")
    print("======================================================================")

    template_path = PT_OUT_DOCX if PT_OUT_DOCX.exists() else (BAK_DOCX if BAK_DOCX.exists() else EN_OUT_DOCX)
    if not template_path.exists():
        print(f"  [ERRO] Nenhum documento base encontrado.", file=sys.stderr)
        return 1

    # 1. Atualizar a versão em português
    update_portuguese_whitepaper(template_path, PT_OUT_DOCX)

    # 2. Criar a versão em inglês
    build_english_whitepaper(PT_OUT_DOCX, EN_OUT_DOCX)

    # 3. Atualizar Sumários dinâmicos via MS Word COM
    update_toc_with_word_com([PT_OUT_DOCX, EN_OUT_DOCX])

    # 4. Remover arquivo anterior se ainda existir
    old_docx = PT_DOCS / "TheFlux_v0.75.docx"
    if old_docx.exists():
        try:
            old_docx.unlink()
            print(f"  [+] Arquivo legado removido: {old_docx.name}")
        except Exception as e:
            print(f"  [!] Não foi possível remover {old_docx}: {e}")

    # Limpar json/txt temporários
    for temp in [RAIZ / "temp_docx_dump.txt", RAIZ / "paragraphs_non_empty.json", RAIZ / "tables_data.json"]:
        if temp.exists():
            try:
                temp.unlink()
            except Exception:
                pass

    print("======================================================================")
    print("🎉 Sincronização do White Paper DOCX Concluída com Sucesso!")
    print(f"   - Português: {PT_OUT_DOCX}")
    print(f"   - Inglês: {EN_OUT_DOCX}")
    print("======================================================================")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
