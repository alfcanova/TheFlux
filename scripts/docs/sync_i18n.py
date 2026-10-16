#!/usr/bin/env python3
"""Sincronizador e Propagador Incremental Bilíngue TheFlux (PT -> EN).

Compara os arquivos estruturados em docs/pt/keywords e docs/en/keywords:
  1. Propaga seções ausentes (ex: 'errors:', 'restrictions:', 'usages:') de PT para EN.
  2. Preserva códigos TheFlux invariantes (syntax, pseudocode, code examples).
  3. Traduz gatilhos, mensagens canônicas e dicas prescritivas usando o Glossário Técnico Canônico.
  4. Garante conformidade e paridade estrutural 1:1 para aprovação no linter de paridade.

Uso:
  python scripts/docs/sync_i18n.py --propagate
  python scripts/docs/sync_i18n.py --check-only
"""
from __future__ import annotations

import argparse
import os
import sys
import yaml
from pathlib import Path

# Suporte a UTF-8 no Windows
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

RAIZ = Path(__file__).resolve().parent.parent.parent
DOCS_DIR = RAIZ / "docs"
PT_DIR = DOCS_DIR / "pt" / "keywords"
EN_DIR = DOCS_DIR / "en" / "keywords"

# ── Glossário de Tradução de Categorias ──────────────────────────────────────
CATEGORY_MAP = {
    "Declaração de Tipo": "Type Declaration",
    "Declaração de Variável": "Variable Declaration",
    "Declaração de Variável Imutável": "Immutable Variable Declaration",
    "Declaração de Função": "Function Declaration",
    "Declaração de Operação": "Operation Declaration",
    "Declaração de Contrato": "Contract Declaration",
    "Declaração de Agente": "Agent Declaration",
    "Implementação de Contrato": "Contract Implementation",
    "Ponto de Entrada": "Entry Point",
    "Declaração de Importação": "Import Declaration",
    "Estrutura de Loop": "Loop Structure",
    "Estrutura Condicional": "Conditional Structure",
    "Controle de Loop": "Loop Control",
    "Controle de Fluxo Condicional": "Conditional Flow Control",
    "Pattern Matching": "Pattern Matching",
    "Instrução de Saída": "Output Instruction",
    "Instrução de Retorno": "Return Instruction",
    "Status de Retorno": "Return Status",
    "Entrada de Dados": "Data Input",
    "Tipo Numérico - Inteiro": "Numeric Type - Integer",
    "Tipo Numérico - Ponto Flutuante": "Numeric Type - Floating Point",
    "Tipo Numérico - Complexo": "Numeric Type - Complex",
    "Tipo Escalar Primitivo": "Primitive Scalar Type",
    "Tipo Caractere": "Character Type",
    "Tipo String": "String Type",
    "Tipo de Coleção": "Collection Type",
    "Tipo de Coleção - Data": "Collection Type - Data",
    "Tipo de Coleção - List": "Collection Type - List",
    "Tipo de Coleção - Map": "Collection Type - Map",
    "Tipo de Coleção - Set": "Collection Type - Set",
    "Tipo Tensor": "Tensor Type",
    "Erro Fatal": "Fatal Error",
    "Expressão de Erro": "Error Expression",
    "Recuperação de Erro": "Error Recovery",
    "Execução Garantida": "Guaranteed Execution",
    "Propagação de Erro": "Error Propagation",
    "Tratamento Condicional Estatal": "Stateful Conditional Handling",
    "Operador Aritmético": "Arithmetic Operator",
    "Operador de Atribuição Aritmética": "Arithmetic Assignment Operator",
    "Operador de Atribuição Bitwise": "Bitwise Assignment Operator",
    "Operador de Comparação": "Comparison Operator",
    "Operador Lógico": "Logical Operator",
    "Operador Bitwise": "Bitwise Operator",
    "Operador de Dataflow": "Dataflow Operator",
    "Operador de Range / Slice": "Range / Slice Operator",
    "Tarefas Assíncronas": "Asynchronous Tasks",
    "Ownership (Propriedade)": "Ownership",
    "Bloco Inseguro": "Unsafe Block",
    "Metaprogramação (Compile-time)": "Metaprogramming (Compile-time)",
    "Literal": "Literal",
    "Literal Booleano": "Boolean Literal",
    "Literal de Data/Hora": "Datetime Literal",
    "Literal Numérico": "Numeric Literal",
    "Comentário / Documentação": "Comment / Documentation",
    "Interpolação de String": "String Interpolation",
    "Composição de Tipo": "Type Composition",
}

# ── Glossário de Diagnósticos e Mensagens Canônicas ─────────────────────────
ERROR_TRANSLATIONS = {
    # LEX
    "LEX001": {
        "trigger": "Use of '#' character without a valid qualifier ('#L', '#B', or '#D')",
        "message": "Invalid '#' character: expected '#L' for line comment, '#B...B#' for block or '#D...D#' for docstring",
        "hint": "Use '#L' for single-line comments or '#B ... B#' for block comments",
    },
    "LEX002": {
        "trigger": "String literal opened with double quotes without closing quotes before end of line",
        "message": "Unterminated string literal before end of line",
        "hint": "Close string literal with double quotes '\"' before the newline",
    },
    "LEX003": {
        "trigger": "Use of tabulation character ('\\t') in source code",
        "message": "Tabulation character '\\t' is prohibited in TheFlux source code; use multiples of 6 spaces",
        "hint": "Replace tabulation characters '\\t' with multiples of 6 spaces",
    },
    "LEX004": {
        "trigger": "Use of non-ASCII characters (< 0x20 or > 0x7E) outside of string literals or comments",
        "message": "Invalid non-ASCII character in source code",
        "hint": "Remove special characters or place Unicode text inside double-quoted string literals",
    },
    "LEX005": {
        "trigger": "Block comment '#B' opened without corresponding closing delimiter 'B#' before end of file",
        "message": "Block comment opened with '#B' was not closed before end of file",
        "hint": "Add 'B#' at the end of the block comment to close it properly",
    },
    "LEX006": {
        "trigger": "Docstring '#D' opened without corresponding closing delimiter 'D#' before end of file",
        "message": "Docstring opened with '#D' was not closed before end of file",
        "hint": "Add 'D#' at the end of the docstring to close it properly",
    },
    "LEX007": {
        "trigger": "Number containing multiple decimal separators or malformed exponent notation",
        "message": "Malformed floating point literal",
        "hint": "Use standard format with a single decimal dot (e.g. 3.14) and valid exponent (e.g. 1.0e-3)",
    },
    "LEX010": {
        "trigger": "Boolean literal written with invalid casing (e.g., True, TRUE, False, FALSE)",
        "message": "Invalid boolean literal casing; expected strictly 'true' or 'false' in lowercase",
        "hint": "Write boolean literals strictly in lowercase: 'true' or 'false'",
    },

    # SYN
    "SYN100": {
        "trigger": "Unexpected token encountered during syntactic analysis",
        "message": "Unexpected token in declaration",
        "hint": "Check TheFlux grammar syntax and replace invalid tokens with canonical forms",
    },
    "SYN105": {
        "trigger": "Variable declaration with mut/imut missing the mandatory 'as' keyword before type",
        "message": "Missing 'as' keyword in typed variable declaration",
        "hint": "Include 'as' before the type: 'mut as <type>: <name> = <val>' or 'imut as <type>: <NAME> = <val>'",
    },
    "SYN120": {
        "trigger": "Branch condition in route statement missing the double arrow '==>' connector",
        "message": "Expected '==>' after condition in route branch",
        "hint": "Add the '==>' connector between the condition and the execution block in the route branch",
    },
    "SYN130": {
        "trigger": "Operation inside 'contract' declared with execution body '==> { ... }'",
        "message": "Operations within 'contract' define signatures only and cannot have execution bodies",
        "hint": "Remove the operation body ('==> { ... }'); implementations belong exclusively to 'agent'",
    },
    "SYN140": {
        "trigger": "Unbalanced delimiters: parentheses, brackets, or curly braces not matching",
        "message": "Unbalanced delimiter: expected matching closing delimiter",
        "hint": "Ensure all '(', '[', and '{' have corresponding ')', ']', and '}' in the correct scope",
    },
    "SYN150": {
        "trigger": "Tensor declaration without canonical shape dimensions syntax 'tensor[dim1, dim2, ...]' or missing 'of <type>'",
        "message": "Tensor requires dimension shape and element type: 'tensor[D1, D2, ...] of <type>'",
        "hint": "Declare dimensions in brackets and element type with 'of': 'mut as tensor[3, 3] of float64: m'",
    },
    "SYN151": {
        "trigger": "Tensor literal elements count does not match the dimensions declared in the tensor shape",
        "message": "Tensor literal dimensions do not match the declared tensor shape",
        "hint": "Verify the number of elements in each row and column to match the declared shape",
    },
    "SYN160": {
        "trigger": "List declaration without 'of <type>' specifying element type",
        "message": "List declaration requires element type: 'list of <type>'",
        "hint": "Specify element type with 'of': 'mut as list of int64: my_list'",
    },
    "SYN161": {
        "trigger": "Set declaration without 'of <type>' specifying element type",
        "message": "Set declaration requires element type: 'set of <type>'",
        "hint": "Specify element type with 'of': 'mut as set of string: my_set'",
    },

    # IMP
    "IMP201": {
        "trigger": "Import directive 'use' referencing a module or .fdsl file that does not exist on disk",
        "message": "Imported module or file not found on disk",
        "hint": "Verify module spelling and ensure the .fdsl file exists in stdlib/ or import search path",
    },
    "IMP202": {
        "trigger": "Circular dependency detected between imported modules",
        "message": "Circular dependency detected among imported modules",
        "hint": "Refactor modules to break dependency cycle, extracting shared types or contracts into a common aggregator",
    },
    "IMP203": {
        "trigger": "Attempt to call private operation (prefixed with '_') from outside its defining module",
        "message": "Cannot access private operation; operations prefixed with '_' are private to their module",
        "hint": "Use public contract operations instead of calling internal private helpers ('op _*') directly",
    },
    "IMP204": {
        "trigger": "Multiple modules imported with conflicting aliases or identifiers in the same scope",
        "message": "Import alias conflict: identifier already in use by another module",
        "hint": "Provide a distinct alias with 'as': 'use ModuleA as MA' and 'use ModuleB as MB'",
    },

    # SEM
    "SEM301": {
        "trigger": "Integer literal outside range supported by declared type",
        "message": "Integer literal value out of range for the specified integer type",
        "hint": "Use a wider integer type (e.g. int64) or adjust the literal within type limits",
    },
    "SEM303": {
        "trigger": "Assignment to variable that was not previously declared with 'mut' or 'imut'",
        "message": "Undefined identifier; variable must be declared before assignment",
        "hint": "Declare variable with 'mut as <type>: <name> = <val>' before reassigning it",
    },
    "SEM304": {
        "trigger": "Attempt to redeclare existing identifier in the same scope",
        "message": "Identifier already declared in the current scope",
        "hint": "Use a distinct variable name or reassign existing mutable variable without redeclaring it",
    },
    "SEM305": {
        "trigger": "Immutable identifier ('imut') declared without initial value",
        "message": "Immutable variable requires mandatory initial value during declaration",
        "hint": "Provide an initializer expression: 'imut as <type>: NAME = <value>'",
    },
    "SEM306": {
        "trigger": "Mutable variable ('mut') identifier not in snake_case",
        "message": "Mutable variable name must strictly follow snake_case convention",
        "hint": "Rename mutable identifier using lowercase letters and underscores: 'minha_variavel'",
    },
    "SEM307": {
        "trigger": "Immutable identifier ('imut') not in SCREAMING_SNAKE_CASE",
        "message": "Immutable variable name must strictly follow SCREAMING_SNAKE_CASE convention",
        "hint": "Rename immutable identifier using uppercase letters and underscores: 'VALOR_CONSTANTE'",
    },
    "SEM310": {
        "trigger": "Execution of code or statements outside of any function, agent operation, or program block",
        "message": "Statements not allowed at root file level; code must reside inside 'program', 'function', or 'agent'",
        "hint": "Wrap executable statements inside 'program (Name) { ... }'",
    },
    "SEM311": {
        "trigger": "More than one 'program' block declared in the same .flux file",
        "message": "Multiple 'program' blocks in the same file; only one entry point is allowed per file",
        "hint": "Consolidate logic into a single 'program (Name) { ... }' entry point",
    },
    "SEM312": {
        "trigger": "Program block identifier not matching filename or not in PascalCase",
        "message": "Program name must follow PascalCase and match file stem",
        "hint": "Ensure program name is in PascalCase: 'program (ExampleProgram)'",
    },
    "SEM320": {
        "trigger": "Wildcard pattern '_' in route statement positioned before other specific condition branches",
        "message": "Wildcard branch '_' must be the last branch in a route statement",
        "hint": "Move the wildcard fallback branch '_ ==> { ... }' to the very end of the route block",
    },
    "SEM330": {
        "trigger": "Contract identifier not in PascalCase",
        "message": "Contract name must strictly follow PascalCase convention",
        "hint": "Rename contract using PascalCase: 'contract (MyContract)'",
    },
    "SEM331": {
        "trigger": "Operation identifier inside contract not in camelCase",
        "message": "Contract operation name must strictly follow camelCase convention",
        "hint": "Rename operation using camelCase: 'op calculateTotal'",
    },
    "SEM340": {
        "trigger": "Agent implements contract without defining all operations specified by that contract",
        "message": "Agent missing contract operation implementation",
        "hint": "Implement all operations specified in the contract inside the agent block",
    },
    "SEM341": {
        "trigger": "Agent identifier not in PascalCase",
        "message": "Agent name must strictly follow PascalCase convention",
        "hint": "Rename agent using PascalCase: 'agent (MyAgent)'",
    },
    "SEM342": {
        "trigger": "Agent declared inside executable .flux file instead of modular .fdsl file",
        "message": "Agent declarations are prohibited in .flux files; agents must reside in .fdsl modules",
        "hint": "Move agent definition to a dedicated .fdsl file and import it with 'use'",
    },
    "SEM350": {
        "trigger": "Emit instruction using channel other than 'nice' or 'fail'",
        "message": "Invalid emit channel; expected 'nice' for success or 'fail' for failure",
        "hint": "Use canonical channel: 'emit(nice, value, \"ok\")' or 'emit(fail, value, \"error message\")'",
    },
    "SEM351": {
        "trigger": "Statements placed after terminal emit instruction within the same block",
        "message": "Unreachable code: emit is terminal and exits the current operation/function",
        "hint": "Remove statements following 'emit' or place them before the emit call",
    },
    "SEM360": {
        "trigger": "Struct identifier not in PascalCase",
        "message": "Struct name must strictly follow PascalCase convention",
        "hint": "Rename struct using PascalCase: 'struct (MyStruct)'",
    },
    "SEM361": {
        "trigger": "Field access on struct with name not declared in struct definition",
        "message": "Unknown struct field: field not declared in struct schema",
        "hint": "Verify struct schema and check field spelling",
    },
    "SEM362": {
        "trigger": "Mutable field in struct not in snake_case",
        "message": "Mutable struct field name must strictly follow snake_case convention",
        "hint": "Rename mutable field using snake_case: 'mut as int64: my_field'",
    },
    "SEM363": {
        "trigger": "Immutable field in struct not in SCREAMING_SNAKE_CASE",
        "message": "Immutable struct field name must strictly follow SCREAMING_SNAKE_CASE convention",
        "hint": "Rename immutable field using SCREAMING_SNAKE_CASE: 'imut as int64: MY_FIELD'",
    },
    "SEM370": {
        "trigger": "Enum identifier not in PascalCase",
        "message": "Enum name must strictly follow PascalCase convention",
        "hint": "Rename enum using PascalCase: 'enum (MyEnum)'",
    },
    "SEM371": {
        "trigger": "Pattern matching or instantiation of enum with variant name not declared in enum definition",
        "message": "Unknown enum variant: variant not declared in enum schema",
        "hint": "Check enum definition and match declared variant names",
    },
    "SEM372": {
        "trigger": "Enum variant name not in PascalCase",
        "message": "Enum variant name must strictly follow PascalCase convention",
        "hint": "Rename enum variant using PascalCase: 'VariantName'",
    },

    # TYP
    "TYP401": {
        "trigger": "Variable or parameter of type integer receives a floating point value (float)",
        "message": "Expected integer (int), got float",
        "hint": "Convert float to integer with 'as int64' or declare variable as float64",
    },
    "TYP402": {
        "trigger": "Variable or parameter of type integer receives a complex number",
        "message": "Expected integer (int), got complex",
        "hint": "Extract real part with '.real' and convert with 'as int64'",
    },
    "TYP403": {
        "trigger": "Variable or parameter of type integer receives a string text",
        "message": "Expected integer (int), got string",
        "hint": "Parse string to integer using ConvertStdLib::stringToInt64()",
    },
    "TYP404": {
        "trigger": "Variable or parameter of type integer receives a boolean",
        "message": "Expected integer (int), got bool",
        "hint": "Use conditional check: 'route { b ==> 1; _ ==> 0 }'",
    },
    "TYP411": {
        "trigger": "Variable or parameter of type complex receives an integer",
        "message": "Expected complex, got integer (int)",
        "hint": "Construct complex number: '10 + 0i' or use complex constructor",
    },
    "TYP412": {
        "trigger": "Variable or parameter of type complex receives a float",
        "message": "Expected complex, got float",
        "hint": "Construct complex number with zero imaginary part: '3.14 + 0i'",
    },
    "TYP413": {
        "trigger": "Variable or parameter of type complex receives a string text",
        "message": "Expected complex, got string",
        "hint": "Parse string to complex using ConvertStdLib parser",
    },
    "TYP414": {
        "trigger": "Variable or parameter of type complex receives a boolean",
        "message": "Expected complex, got bool",
        "hint": "Use explicit route branch to produce complex value",
    },
    "TYP421": {
        "trigger": "Variable or parameter of type float receives a complex number",
        "message": "Expected float, got complex",
        "hint": "Extract real part with '.real' or magnitude with 'abs()'",
    },
    "TYP422": {
        "trigger": "Variable or parameter of type float receives a string text",
        "message": "Expected float, got string",
        "hint": "Parse string to float using ConvertStdLib::stringToFloat64()",
    },
    "TYP423": {
        "trigger": "Variable or parameter of type float receives a boolean",
        "message": "Expected float, got bool",
        "hint": "Use conditional check: 'route { b ==> 1.0; _ ==> 0.0 }'",
    },
    "TYP431": {
        "trigger": "Variable or parameter of type string receives an integer",
        "message": "Expected string, got integer (int)",
        "hint": "Convert integer to string with ConvertStdLib::int64ToString() or string interpolation",
    },
    "TYP432": {
        "trigger": "Variable or parameter of type string receives a float",
        "message": "Expected string, got float",
        "hint": "Convert float to string with ConvertStdLib::float64ToString()",
    },
    "TYP433": {
        "trigger": "Variable or parameter of type string receives a complex number",
        "message": "Expected string, got complex",
        "hint": "Convert complex to string formatting real and imaginary parts",
    },
    "TYP434": {
        "trigger": "Variable or parameter of type string receives a boolean",
        "message": "Expected string, got bool",
        "hint": "Convert boolean to string: 'route { b ==> \"true\"; _ ==> \"false\" }'",
    },
    "TYP441": {
        "trigger": "Expression expects a boolean (bool) and received an integer",
        "message": "Expected bool, got integer (int)",
        "hint": "Use boolean comparison (e.g. 'val != 0') instead of bare integer",
    },
    "TYP442": {
        "trigger": "Expression expects a boolean (bool) and received a string",
        "message": "Expected bool, got string",
        "hint": "Compare string content (e.g. 's == \"true\"')",
    },
    "TYP443": {
        "trigger": "Expression expects a boolean (bool) and received a float",
        "message": "Expected bool, got float",
        "hint": "Use comparison (e.g. 'f != 0.0')",
    },
    "TYP450": {
        "trigger": "Value type emitted in emit does not match declared return type in operation signature",
        "message": "Emitted value type does not match operation declared return type",
        "hint": "Ensure the second argument in 'emit(channel, value, msg)' matches the operation return type",
    },
    "TYP499": {
        "trigger": "Type incompatibility: expected and actual types are not compatible",
        "message": "Generic type mismatch: types are incompatible",
        "hint": "Verify types of expressions and convert values explicitly with 'as <type>'",
    },

    # OWN
    "OWN501": {
        "trigger": "Attempt to reassign or mutate value of immutable identifier ('imut')",
        "message": "Cannot mutate immutable variable; variable declared with 'imut' is read-only",
        "hint": "Declare variable as mutable with 'mut' instead of 'imut' if reassignments are needed",
    },
    "OWN502": {
        "trigger": "Attempt to reassign immutable field of a struct",
        "message": "Struct field is immutable and cannot be reassigned",
        "hint": "Declare struct field with 'mut' instead of 'imut' in struct schema",
    },
    "OWN503": {
        "trigger": "Reading or using a variable after its ownership was transferred via move",
        "message": "Use of moved value; variable has transferred ownership and can no longer be accessed",
        "hint": "Borrow reference with 'borrow' or clone object instead of moving it",
    },
    "OWN504": {
        "trigger": "Conflicting borrow: attempting to access or borrow variable while active mutable borrow exists",
        "message": "Mutable borrow conflict: variable already borrowed exclusively",
        "hint": "Release or end the scope of the mutable borrow before accessing the original variable",
    },
    "OWN505": {
        "trigger": "Attempt to declare dynamic collection (list, set, map) with 'imut' modifier",
        "message": "Dynamic collections cannot be immutable; use 'mut as list of <type>:'",
        "hint": "Declare dynamic collection with 'mut as list of <type>:' or 'mut as set of <type>:'",
    },

    # CON
    "CON601": {
        "trigger": "FSM transition to target state that is not declared or permitted from current state",
        "message": "Invalid FSM state transition: target state not permitted from current state",
        "hint": "Verify FSM transitions definition and add transition rule or transition through allowed state",
    },
    "CON602": {
        "trigger": "Attempt to send message or data on a closed communication channel",
        "message": "Cannot send on closed channel: channel is no longer accepting messages",
        "hint": "Check channel state with channelIsOpen() before sending messages",
    },
    "CON603": {
        "trigger": "Agent mailbox overflow: pending messages capacity exceeded",
        "message": "Agent mailbox overflow: maximum pending messages capacity exceeded",
        "hint": "Increase agent mailbox quota or throttle message production rate",
    },

    # RT
    "RT701": {
        "trigger": "Division (/i or /f) or remainder (/r) operation where divisor is zero",
        "message": "Division by zero in runtime",
        "hint": "Add a conditional check ('route { divisor == 0 ==> ... }') before division",
    },
    "RT702": {
        "trigger": "Accessing collection index less than 1 or greater than collection length (1-based indexing)",
        "message": "Index out of collection bounds (1-based indexing)",
        "hint": "Ensure index is within range 1 to collection length",
    },
    "RT703": {
        "trigger": "Decompression payload exceeds maximum quota configured in DecompressQuota",
        "message": "Decompression quota exceeded in runtime (security limit violated)",
        "hint": "Increase DecompressQuota limit or check for compressed bomb payloads",
    },
    "RT704": {
        "trigger": "Excessive call stack depth from recursive functions without base case",
        "message": "Execution stack overflow (Stack Overflow): excessive recursion without termination condition",
        "hint": "Add a base case to terminate recursion or rewrite using iterative loops ('infinite')",
    },
    "RT705": {
        "trigger": "Heap memory allocation failure for tensors, buffers, or large objects",
        "message": "Out of memory: insufficient memory to allocate object in runtime",
        "hint": "Reduce tensor dimensions or process data in streaming chunks",
    },
    "RT706": {
        "trigger": "Logarithm calculation (log64, log10_64, log2_64) where argument is less than or equal to zero",
        "message": "Argument out of logarithm domain: expected x > 0",
        "hint": "Ensure value passed to logarithm is strictly positive (x > 0.0)",
    },
    "RT707": {
        "trigger": "Square root or even root calculation (^r 2, squareRoot64) where radicand is negative",
        "message": "Negative radicand in even root: expected x >= 0 for real numbers",
        "hint": "Verify radicand is non-negative (x >= 0.0) before computing root, or use complex numbers",
    },
    "RT708": {
        "trigger": "Inverse trigonometric function calculation (asin, acos) with argument outside interval [-1.0, 1.0]",
        "message": "Argument out of inverse trigonometric domain: expected -1.0 <= x <= 1.0",
        "hint": "Clamp argument to interval [-1.0, 1.0] before calling asin or acos",
    },
    "RT709": {
        "trigger": "Exponentiation calculation (^e or powerFloat64) with zero base and non-positive exponent",
        "message": "Undefined power for zero base and non-positive exponent",
        "hint": "Avoid raising zero to exponents less than or equal to zero (0^0 or 0^(-k))",
    },
}

# ── Glossário de Frases Comuns de Restrições ─────────────────────────────────
RESTRICTION_TRANSLATIONS = {
    "O nome do contrato deve estar em PascalCase.": "The contract name must be in PascalCase.",
    "O nome da operação deve estar em camelCase.": "The operation name must be in camelCase.",
    "Operações em contratos definem apenas assinaturas, sem corpo de execução (==>).": "Operations in contracts define signatures only, without execution bodies (==>).",
    "Agentes que implementam o contrato devem definir todas as operações declaradas.": "Agents implementing the contract must define all declared operations.",
    "Parâmetros de operações devem ter tipo explícito.": "Operation parameters must have explicit types.",
    "Operações podem ter múltiplos parâmetros separados por vírgula.": "Operations can have multiple comma-separated parameters.",
}


def traduzir_texto(txt: str) -> str:
    if not txt:
        return ""
    t = txt.strip()
    return RESTRICTION_TRANSLATIONS.get(t, t)


def sincronizar_arquivo(f_pt: Path, f_en: Path, propagate: bool = False) -> tuple[bool, list[str]]:
    modificado = False
    alteracoes = []

    with open(f_pt, "r", encoding="utf-8") as f:
        d_pt = yaml.safe_load(f) or {}

    d_en = {}
    if f_en.exists():
        with open(f_en, "r", encoding="utf-8") as f:
            d_en = yaml.safe_load(f) or {}

    # 1. Keyword (invariante)
    if d_en.get("keyword") != d_pt.get("keyword"):
        d_en["keyword"] = d_pt.get("keyword")
        modificado = True
        alteracoes.append("keyword sincronizada")

    # 2. Categoria
    cat_pt = d_pt.get("category", "")
    cat_en = CATEGORY_MAP.get(cat_pt, d_en.get("category", cat_pt))
    if d_en.get("category") != cat_en:
        d_en["category"] = cat_en
        modificado = True
        alteracoes.append("categoria traduzida")

    # 3. Description
    if "description" not in d_en:
        d_en["description"] = d_pt.get("description", "")
        modificado = True

    # 4. Syntax & Pseudocode (invariantes)
    if "syntax" in d_pt and d_en.get("syntax") != d_pt.get("syntax"):
        d_en["syntax"] = d_pt.get("syntax")
        modificado = True
    if "pseudocode" in d_pt and d_en.get("pseudocode") != d_pt.get("pseudocode"):
        d_en["pseudocode"] = d_pt.get("pseudocode")
        modificado = True

    # 5. Usages
    u_pt = d_pt.get("usages") or []
    u_en = d_en.get("usages") or []
    if len(u_pt) != len(u_en):
        d_en["usages"] = u_pt
        modificado = True
        alteracoes.append(f"usages sincronizados ({len(u_pt)} seções)")

    # 6. Restrictions
    r_pt = d_pt.get("restrictions") or []
    r_en = d_en.get("restrictions") or []
    if len(r_pt) != len(r_en):
        translated_restrictions = []
        for r in r_pt:
            if isinstance(r, str):
                translated_restrictions.append(traduzir_texto(r))
            else:
                translated_restrictions.append(r)
        d_en["restrictions"] = translated_restrictions
        modificado = True
        alteracoes.append(f"restrictions sincronizadas ({len(r_pt)} regras)")

    # 7. Errors Block
    err_pt = d_pt.get("errors") or []
    err_en = d_en.get("errors") or []
    codes_pt = [e.get("code") for e in err_pt if isinstance(e, dict) and e.get("code")]
    codes_en = [e.get("code") for e in err_en if isinstance(e, dict) and e.get("code")]

    if set(codes_pt) != set(codes_en):
        # Constrói bloco de erros em inglês usando dicionário canônico
        en_errors_list = []
        for e in err_pt:
            if not isinstance(e, dict):
                continue
            code = e.get("code", "")
            mnemonic = e.get("mnemonic", "")
            severity = e.get("severity", "Error")
            t_info = ERROR_TRANSLATIONS.get(code, {})

            entry = {
                "code": code,
                "mnemonic": mnemonic,
                "severity": severity,
                "trigger": t_info.get("trigger", e.get("trigger", "")),
                "message": t_info.get("message", e.get("message", "")),
                "hint": t_info.get("hint", e.get("hint", "")),
                "example_bad": e.get("example_bad", ""),
                "example_good": e.get("example_good", ""),
            }
            en_errors_list.append(entry)

        d_en["errors"] = en_errors_list
        modificado = True
        alteracoes.append(f"errors propagados ({len(en_errors_list)} diagnósticos)")

    if modificado and propagate:
        with open(f_en, "w", encoding="utf-8") as f:
            yaml.dump(d_en, f, allow_unicode=True, default_flow_style=False, sort_keys=False, width=120)

    return modificado, alteracoes


def main() -> int:
    parser = argparse.ArgumentParser(description="Sincronizador Incremental Bilíngue TheFlux")
    parser.add_argument("--propagate", action="store_true", help="Propaga alterações de PT para EN gravando nos arquivos")
    parser.add_argument("--pt-dir", default=str(PT_DIR))
    parser.add_argument("--en-dir", default=str(EN_DIR))
    args = parser.parse_args()

    pt_dir = Path(args.pt_dir)
    en_dir = Path(args.en_dir)
    en_dir.mkdir(parents=True, exist_ok=True)

    pt_files = sorted(pt_dir.glob("KW_*.yaml"))
    print("=" * 70)
    print("🔄 TheFlux — Sincronizador Incremental Bilíngue (PT -> EN)")
    print(f"   Modo: {'PROPAGAÇÃO ATIVA (--propagate)' if args.propagate else 'SOMENTE VERIFICAÇÃO'}")
    print("=" * 70)

    total_modificados = 0
    for f_pt in pt_files:
        if f_pt.name == "KW_index.yaml":
            continue
        f_en = en_dir / f_pt.name
        mod, alteracoes = sincronizar_arquivo(f_pt, f_en, propagate=args.propagate)
        if mod:
            total_modificados += 1
            print(f"  [+] {f_pt.name}: {', '.join(alteracoes)}")

    print("=" * 70)
    if total_modificados == 0:
        print("✅ Todos os arquivos já estão perfeitamente sincronizados!")
    else:
        if args.propagate:
            print(f"✅ Sincronização concluída com sucesso! {total_modificados} arquivos atualizados em {en_dir}.")
        else:
            print(f"⚠️ {total_modificados} arquivos necessitam de propagação. Execute com '--propagate' para aplicar.")
    print("=" * 70)
    return 0


if __name__ == "__main__":
    sys.exit(main())
