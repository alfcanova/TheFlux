#!/usr/bin/env python3
"""Translate docs/pt/grammar.md to docs/en/grammar.md while strictly preserving all EBNF productions.
"""
from __future__ import annotations

import os
import re

PT_PATH = os.path.join(REPO_ROOT, "docs", "pt", "Gramatica.md")
EN_PATH = os.path.join(REPO_ROOT, "docs", "en", "Grammar.md")

# Dictionary of phrase and block translations
REPLACEMENTS = [
    # Header
    ("GRAMATICA DA IMPLEMENTACAO ATUAL - TheFlux v0.5", "CURRENT IMPLEMENTATION GRAMMAR - TheFlux v0.5"),
    ("EBNF consolidada gerada a partir dos modulos lexer/parser", "Consolidated EBNF generated from lexer/parser modules"),
    ("src/flux_proto/*_flux.py.", "src/flux_proto/*_flux.py."),
    ("Snapshot RC: 2026-07-20.", "Snapshot RC: 2026-07-20."),
    ("Versoes: SPEC 0.5, CLI 0.5.0, fvmbc version 1,", "Versions: SPEC 0.5, CLI 0.5.0, fvmbc version 1,"),
    ("instruction_version 3, stdlib 0.5.0, WASM native lowering v0.5.", "instruction_version 3, stdlib 0.5.0, WASM native lowering v0.5."),
    ("ENCODING:", "ENCODING:"),
    ("- Codigo fonte em UTF-8. Identificadores, palavras-chave,", "- Source code in UTF-8. Identifiers, keywords,"),
    ("  operadores e delimitadores sao ASCII 7-bit; bytes fora da", "  operators, and delimiters are 7-bit ASCII; bytes outside the"),
    ("  faixa ASCII (codigo > 0x7F) sao aceitos apenas em strings,", "  ASCII range (code > 0x7F) are accepted only in strings,"),
    ("  chars, comentarios e docstrings.", "  chars, comments, and docstrings."),
    ("- string e codificada em UTF-8; len() conta bytes UTF-8.", "- string is UTF-8 encoded; len() counts UTF-8 bytes."),
    ("- char representa exatamente um code point Unicode", "- char represents exactly one Unicode code point"),
    ("  (U+0000..U+10FFFF), armazenado como valor de 32 bits", "  (U+0000..U+10FFFF), stored as a 32-bit value"),
    ("  (UTF-32) nos backends compilados (llvm/wat/wasm); a", "  (UTF-32) in compiled backends (llvm/wat/wasm);"),
    ("  conversao para UTF-8 (1-4 bytes) acontece apenas na", "  conversion to UTF-8 (1-4 bytes) occurs only during"),
    ("  impressao/concatencao com string.", "  printing/concatenation with string."),
    ("- O escape_sequence classico (\\\\', \\\\\", \\\\\\\\, \\\\n, \\\\t, \\\\r, \\\\0)", "- The classic escape_sequence (\\\\', \\\\\", \\\\\\\\, \\\\n, \\\\t, \\\\r, \\\\0)"),
    ("  e suportado em strings e chars, alem de \\\\u{XXXX} (1-6 hex,", "  is supported in strings and chars, plus \\\\u{XXXX} (1-6 hex,"),
    ("  sem surrogates, max U+10FFFF) para code points Unicode.", "  no surrogates, max U+10FFFF) for Unicode code points."),
    ("- Bytes nao-ASCII fora de strings/chars/comentarios/docstrings", "- Non-ASCII bytes outside of strings/chars/comments/docstrings"),
    ("  resultam em erro de leitura (LEX001).", "  result in a read error (LEX001)."),
    ("- Descreve a sintaxe atualmente aceita pelo prototipo Python.", "- Describes the syntax currently accepted by the Python prototype."),
    ("- Tokens reservados sao listados, com comentarios marcando", "- Reserved tokens are listed, with comments noting"),
    ("  constructos que sao rejeitados cedo ou falham explicitamente", "  constructs that are rejected early or fail explicitly"),
    ("  quando as semanticas de runtime estao indisponiveis.", "  when runtime semantics are unavailable."),
    ("- Restricoes semanticas como regras de capitalizacao, mutabilidade,", "- Semantic constraints such as capitalization rules, mutability,"),
    ("  verificacoes numericas de elementos tensor, e exclusividade de", "  numeric tensor element checks, and function/agent file"),
    ("  arquivo funcao/agent sao documentadas aqui como restricoes", "  exclusivity are documented here as grammar-level constraints."),
    ("  do lado da gramatica.", ""),

    # Section 0
    ("0. CONVENCOES EBNF", "0. EBNF CONVENTIONS"),
    ('"x"        texto literal fonte', '"x"        source literal text'),
    ("A | B      alternativa", "A | B      alternative"),
    ("[ A ]      opcional", "[ A ]      optional"),
    ("{ A }      repeticao, zero ou mais", "{ A }      repetition, zero or more"),
    ("A - B      exclusao informal", "A - B      informal exclusion"),
    ("Tokens artificiais emitidos pelo lexer:", "Artificial tokens emitted by the lexer:"),

    # Section 1
    ("1. CARACTERES E IDENTIFICADORES", "1. CHARACTERS AND IDENTIFIERS"),
    ("/* Restrição:\n   Identificadores não podem coincidir com keywords.\n   O filtro é aplicado via set subtraction (- keyword) nas\n   produções generic_lower_identifier, generic_upper_identifier,\n   constant_identifier e system_wildcard_identifier.\n*/",
     "/* Constraint:\n   Identifiers cannot coincide with keywords.\n   The filter is applied via set subtraction (- keyword) in\n   productions generic_lower_identifier, generic_upper_identifier,\n   constant_identifier, and system_wildcard_identifier.\n*/"),
    ("/*\n   Capitalizacao imposta pelo parser/analise semantica:\n\n   Categoria               | Producao                  | Exemplo\n   ------------------------|---------------------------|--------------------\n   Variavel imutavel       | constant_identifier       | MAX_VALOR, PI\n   Variavel mutavel        | generic_lower_identifier  | minha_variavel\n   Iterador infinite       | generic_lower_identifier  | item, valor\n   Funcao / op / alias     | generic_lower_identifier  | calcularTotal\n   Struct / init (callee)  | generic_lower_identifier  | meuPonto / ponto()\n   Enum / variante         | generic_lower_identifier  | status / ativo\n   Agent / alias           | generic_upper_identifier  | MeuServico\n   Contract                | generic_upper_identifier  | Validador\n   Program                 | generic_upper_identifier  | MeuPrograma\n\n   Violacoes emitem SUGGESTION com a capitalizacao correta.\n\n   Nota sobre alias:\n   \"alias\" na tabela acima e um conceito - o nome apelidado\n   via a palavra-chave \"as\". Nao ha keyword \"alias\" em Flux.\n   As formas concretas de alias sao as clausulas \"as\" em\n    use_declaration (Secao 11):\n      use Agent as Alias          (* alias de agente *)\n      use Agent::op as alias      (* alias de operacao *)\n      use Agent::{ op as alias }  (* alias em grupo *)\n    A capitalizacao exigida segue a categoria do alias:\n      - camelCase para alias de funcao/op (calcularTotal)\n      - PascalCase para alias de agent (MeuServico)\n*/",
     "/*\n   Capitalization enforced by parser/semantic analysis:\n\n   Category                | Production                | Example\n   ------------------------|---------------------------|--------------------\n   Immutable variable      | constant_identifier       | MAX_VALOR, PI\n   Mutable variable        | generic_lower_identifier  | my_variable\n   Infinite iterator       | generic_lower_identifier  | item, value\n   Function / op / alias   | generic_lower_identifier  | calculateTotal\n   Struct / init (callee)  | generic_lower_identifier  | myPoint / point()\n   Enum / variant          | generic_lower_identifier  | status / active\n   Agent / alias           | generic_upper_identifier  | MyService\n   Contract                | generic_upper_identifier  | Validator\n   Program                 | generic_upper_identifier  | MyProgram\n\n   Violations emit SUGGESTION with the correct capitalization.\n\n   Note on aliases:\n   \"alias\" in the table above is a concept - the name aliased\n   via the keyword \"as\". There is no \"alias\" keyword in Flux.\n   Concrete forms of aliases are \"as\" clauses in\n    use_declaration (Section 11):\n      use Agent as Alias          (* agent alias *)\n      use Agent::op as alias      (* operation alias *)\n      use Agent::{ op as alias }  (* group alias *)\n    The required capitalization follows the alias category:\n      - camelCase for function/op alias (calculateTotal)\n      - PascalCase for agent alias (MyService)\n*/"),

    # Section 2
    ("2. CONJUNTOS DE CARACTERES (usados em producoes posteriores)", "2. CHARACTER SETS (used in subsequent productions)"),
    ("/*\n   Notacao: producoes com prefixo \"any_ascii_\" abrangem caracteres\n   validos em codigo fonte (imprimiveis 0x20–0x7E + line_break).\n   Producoes com prefixo \"any_comment_\" abrangem o espectro completo\n   0x00–0x7F (exceto TAB), usadas exclusivamente em comentarios.\n   Producoes com prefixo \"ascii_\" abrangem subconjuntos\n   (ex: imprimiveis 0x20–0x7E). Definicoes usam ?...? (ISO 14977)\n   para faixas.\n*/",
     "/*\n   Notation: productions with prefix \"any_ascii_\" cover valid source\n   code characters (printable 0x20-0x7E + line_break).\n   Productions with prefix \"any_comment_\" cover the full range\n   0x00-0x7F (except TAB), used exclusively in comments.\n   Productions with prefix \"ascii_\" cover subsets\n   (e.g., printable 0x20-0x7E). Definitions use ?...? (ISO 14977)\n   for ranges.\n*/"),
    ("? caractere ASCII imprimivel ou espaco\n                            (codigo 0x20–0x7E) ?", "? printable ASCII character or space (code 0x20-0x7E) ?"),
    ("? caractere ASCII de 7 bits\n                             (codigo 0x00–0x7F) ou qualquer code point\n                             Unicode (U+0080..U+10FFFF),\n                             exceto TAB (0x09),\n                             \"\\n\" e \"\\r\" ?",
     "? 7-bit ASCII character (code 0x00-0x7F) or any Unicode code point (U+0080..U+10FFFF), except TAB (0x09), \"\\n\" and \"\\r\" ?"),
    ("NOTA DE IMPLEMENTACAO - Lookahead (1 char):", "IMPLEMENTATION NOTE - Lookahead (1 char):"),
    ("Quando o caractere atual e \"B\", o lexer da peek no proximo:", "When the current character is \"B\", the lexer peeks at the next:"),
    ("- Se \"#\": \"B#\" fecha o block_comment; \"B\" NAO e incluido.", "- If \"#\": \"B#\" closes the block_comment; \"B\" is NOT included."),
    ("- Senao: \"B\" e incluido no conteudo.", "- Otherwise: \"B\" is included in the content."),
    ("Sem backtracking.", "No backtracking."),
    ("NOTA DE IMPLEMENTACAO - Lookahead (1 char, mesmo padrao):", "IMPLEMENTATION NOTE - Lookahead (1 char, same pattern):"),
    ("Quando o caractere atual e \"D\", o lexer da peek no proximo:", "When the current character is \"D\", the lexer peeks at the next:"),
    ("- Se \"#\": \"D#\" fecha a docstring; \"D\" NAO e incluido.", "- If \"#\": \"D#\" closes the docstring; \"D\" is NOT included."),
    ("- Senao: \"D\" e incluido no conteudo.", "- Otherwise: \"D\" is included in the content."),

    # Section 3
    ("3. COMENTARIOS E DOCUMENTACAO", "3. COMMENTS AND DOCUMENTATION"),
    ("O conteudo de docstring e preservado pelo lexer e anexado a\n   declaracao/statement seguinte.", "The content of docstring is preserved by the lexer and attached to the following declaration/statement."),

    # Section 4
    ("4. LEXING ESTRUTURAL", "4. STRUCTURAL LEXING"),
    ("emitido ao final de linha logica", "emitted at the end of logical line"),
    ("emitido quando a indentacao aumenta em 6 espacos", "emitted when indentation increases by 6 spaces"),
    ("emitido quando a indentacao diminui", "emitted when indentation decreases"),
    ("fim do arquivo", "end of file"),
    ("Regras de indentacao:", "Indentation rules:"),
    ("- Um nivel = exatamente 6 espacos. TABs proibidos (TabulationError).", "- One level = exactly 6 spaces. TABs forbidden (TabulationError)."),
    ("- Saltos > 1 nivel sao rejeitados.", "- Indentation jumps > 1 level are rejected."),
    ("- Linhas vazias ou so de comentario nao alteram indentacao.", "- Empty lines or comment-only lines do not alter indentation."),
    ("- eol/indent/dedent suprimidos dentro de () e []. Chaves {} nao suprimem eol.", "- eol/indent/dedent suppressed inside () and []. Braces {} do not suppress eol."),
    ("NOTA DE IMPLEMENTACAO - Continuacao de linha:", "IMPLEMENTATION NOTE - Line continuation:"),

    # Section 5
    ("5. PRIORIDADE DE TOKENS DO LEXER", "5. LEXER TOKEN PRIORITY"),
    ("5. PRIORIDADE DE TOKENS DEL LEXER", "5. LEXER TOKEN PRIORITY"),
    ("O lexer prototipo usa a seguinte prioridade efetiva:", "The prototype lexer uses the following effective priority:"),

    # Section 6
    ("6. PALAVRAS-CHAVE E OPERADORES", "6. KEYWORDS AND OPERATORS"),

    # Section 7
    ("7. LITERAIS", "7. LITERALS"),
    ("NOTA DE IMPLEMENTACAO - Literais hexadecimais (0x...), octais (0o...)\n   e binarios (0b...) nao sao suportados nativamente.\n   Conversao entre bases e fornecida pela stdlib\n   (hex(), oct(), bin()) em tempo de execucao.",
     "IMPLEMENTATION NOTE - Hexadecimal (0x...), octal (0o...), and binary (0b...)\n   literals are handled via stdlib conversion functions\n   (hex(), oct(), bin()) at runtime."),

    # Section 8
    ("8. TIPOS", "8. TYPES"),

    # Section 9
    ("9. EXPRESSOES POR PRECEDENCIA", "9. EXPRESSIONS BY PRECEDENCE"),

    # Section 10
    ("10. BLOCOS E COMANDOS", "10. BLOCKS AND STATEMENTS"),

    # Section 11
    ("11. DECLARACOES", "11. DECLARATIONS"),

    # Section 13
    ("13. FLUXO DE COMPILACAO", "13. COMPILATION PIPELINE"),
    ("Pipeline de fases sequenciais do compilador TheFlux:", "Sequential compiler phase pipeline of TheFlux:"),
    ("FASE 0: CLI", "PHASE 0: CLI"),
    ("FASE 1: PRE-PROCESSAMENTO", "PHASE 1: PRE-PROCESSING"),
    ("FASE 2: LEXING", "PHASE 2: LEXING"),
    ("FASE 3: PARSING", "PHASE 3: PARSING"),
    ("FASE 4: EXPANSAO DE MACROS", "PHASE 4: MACRO EXPANSION"),
    ("FASE 5: ANALISE SEMANTICA", "PHASE 5: SEMANTIC ANALYSIS"),
    ("FASE 6: CONSTRUCAO DO DDG", "PHASE 6: DDG CONSTRUCTION"),
    ("FASE 7: EMISSAO DE BYTECODE", "PHASE 7: BYTECODE EMISSION"),
    ("FASE 8: BACKEND LLVM", "PHASE 8: LLVM BACKEND"),
    ("FASE 9: BACKEND WAT", "PHASE 9: WAT BACKEND"),
    ("FASE 10: BACKEND WASM", "PHASE 10: WASM BACKEND"),
    ("FASE 11: RUNTIME / EXECUCAO", "PHASE 11: RUNTIME / EXECUTION"),
    ("FASE 12: DIAGNOSTICOS", "PHASE 12: DIAGNOSTICS"),

    # Section 14
    ("14. CONTRATO DE DIAGNOSTICO", "14. DIAGNOSTIC CONTRACT"),
    ("qualquer caractere de nome-fonte exceto", "any source-name character except"),
    ("qualquer caractere de texto de diagnostico", "any diagnostic text character"),
    ("Todos os novos diagnostics de protecao seguem:", "All diagnostics follow the standard format:"),

    # Section 15
    ("15. TABELA ASCII COMPLETA - ENCODING INTERNO", "15. COMPLETE ASCII TABLE - INTERNAL ENCODING"),
    ("Tabela de todos os 128 codigos ASCII de 7 bits reconhecidos", "Table of all 128 7-bit ASCII codes recognized"),
    ("pelo lexer, com sua classificacao sintatica.", "by the lexer, with their syntactic classification."),
    ("ATENCAO: A sintaxe da linguagem (identificadores, palavras-chave,", "NOTE: Language syntax (identifiers, keywords,"),
    ("operadores, delimitadores) e estritamente ASCII. O suporte a", "operators, delimiters) is strictly ASCII. Unicode support"),
    ("Unicode (UTF-8 no codigo fonte) se restringe a strings, chars,", "(UTF-8 in source code) is restricted to strings, chars,"),
    ("comentarios e docstrings: um byte com codigo > 0x7F fora desses", "comments, and docstrings: a byte with code > 0x7F outside these"),
    ("contextos resulta em erro de leitura (LEX001).", "contexts results in a read error (LEX001)."),
    ("char e um code point Unicode (U+0000..U+10FFFF) de 32 bits", "char is a 32-bit Unicode code point (U+0000..U+10FFFF)"),
    ("(UTF-32) em backends compilados; string e UTF-8 (len em bytes).", "(UTF-32) in compiled backends; string is UTF-8 (len in bytes)."),
    ("Legenda das classificacoes:", "Classification Legend:"),
    ("- \"reconhecido\" - caractere faz parte de um token valido", "- \"recognized\" - character is part of a valid token"),
    ("- \"aceito em line_comment e block_comment\" - caractere nao faz parte", "- \"accepted in line_comment and block_comment\" - character is not part"),
    ("  de nenhum token, mas e aceito em comentarios de linha (#L ...)", "  of any token, but is accepted in line comments (#L ...)"),
    ("  e comentarios de bloco (#B ... B#); fora desses contextos o", "  and block comments (#B ... B#); outside these contexts the"),
    ("  lexer emite erro (LEX001)", "  lexer emits error (LEX001)"),
    ("- \"proibido - TabulationError\" - TAB (0x09) e detectado e", "- \"forbidden - TabulationError\" - TAB (0x09) is detected and"),
    ("  rejeitado com erro especifico", "  rejected with a specific error"),
    ("aceito em line_comment e block_comment", "accepted in line_comment and block_comment"),
    ("line_break - nova linha (\\n)", "line_break - newline (\\n)"),
    ("line_break - retorno de carro (\\r)", "line_break - carriage return (\\r)"),
    ("TAB - proibido, produz TabulationError", "TAB - forbidden, produces TabulationError"),
    ("space - caractere de indentacao", "space - indentation character"),
    ("operador unario de negacao", "unary negation operator"),
    ("delimitador de string_literal e interpolated_string", "delimiter of string_literal and interpolated_string"),
    ("inicio de comentario", "start of comment"),
    ("delimitador de char_literal", "delimiter of char_literal"),
    ("operador bitwise AND", "bitwise AND operator"),
    ("operador multiplicativo", "multiplicative operator"),
    ("operador aditivo", "additive operator"),
    ("operador relacional", "relational operator"),
    ("operador de propagacao de erro \"?\" (pos-fixo)", "error propagation operator \"?\" (postfix)"),
    ("operador de acesso", "access operator"),
    ("operador bitwise XOR", "bitwise XOR operator"),
    ("underscore - parte de identificadores", "underscore - part of identifiers"),
    ("operador bitwise OR", "bitwise OR operator"),
    ("operador bitwise NOT", "bitwise NOT operator"),
    ("inicio de sequencias", "start of sequences"),
    ("inicio de", "start of"),
]


def main():
    with open(PT_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    for pt_text, en_text in REPLACEMENTS:
        content = content.replace(pt_text, en_text)

    with open(EN_PATH, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"Generated English grammar doc: {EN_PATH} ({len(content.splitlines())} lines)")


if __name__ == "__main__":
    main()
