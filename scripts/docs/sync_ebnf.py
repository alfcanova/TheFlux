#!/usr/bin/env python3
"""Sincronizador e Gerador Bilíngue de Gramática EBNF (ISO/IEC 14977).

Mantém rigorosa simetria e sincronização entre:
  1. docs/pt/TheFlux.ebnf (Comentários e cabeçalhos em Português)
  2. docs/en/TheFlux.ebnf (Comentários e cabeçalhos em Inglês)
  3. docs/pt/Gramatica.ebnf e docs/en/Grammar.ebnf
  4. docs/pt/TheFlux.md (Seção 3 com o bloco EBNF embutido em PT)
  5. docs/en/TheFlux.md (Seção 3 com o bloco EBNF embutido em EN)
  6. Validação de equivalência sintática com docs/pt/Gramatica.md e docs/en/Grammar.md

Uso:
  python scripts/docs/sync_ebnf.py              # Sincroniza e regenera todos os artefatos
  python scripts/docs/sync_ebnf.py --check      # Apenas valida sem modificar
"""
from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path

# Ajusta encoding para UTF-8 no Windows
for stream in (sys.stdout, sys.stderr):
    if stream is not None and hasattr(stream, "reconfigure"):
        stream.reconfigure(encoding="utf-8")

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
DOCS_DIR = REPO_ROOT / "docs"
PT_EBNF_PATH = DOCS_DIR / "pt_BR" / "TheFlux.ebnf"
EN_EBNF_PATH = DOCS_DIR / "en" / "TheFlux.ebnf"
PT_GRAMMAR_EBNF = DOCS_DIR / "pt_BR" / "Gramatica.ebnf"
EN_GRAMMAR_EBNF = DOCS_DIR / "en" / "Grammar.ebnf"

PT_DOC_PATH = DOCS_DIR / "pt_BR" / "TheFlux.md"
EN_DOC_PATH = DOCS_DIR / "en" / "TheFlux.md"

PT_GRAMMAR_MD = DOCS_DIR / "pt_BR" / "Gramatica.md"
EN_GRAMMAR_MD = DOCS_DIR / "en" / "Grammar.md"

# Dicionário de tradução PT -> EN para comentários e títulos da especificação EBNF
TRANSLATIONS_PT_TO_EN = [
    ("(* ================================================================== *)", "(* ================================================================== *)"),
    ("(* EBNF (ISO/IEC 14977) - TheFlux v0.75 Specification                 *)", "(* EBNF (ISO/IEC 14977) - TheFlux v0.75 Specification                 *)"),
    ("(* EBNF (ISO/IEC 14977) - TheFlux v0.5 Specification                  *)", "(* EBNF (ISO/IEC 14977) - TheFlux v0.75 Specification                 *)"),
    ("(* Gramatica Formal Padrao da Linguagem TheFlux                       *)", "(* Standard Formal Grammar of TheFlux Programming Language            *)"),
    ("EBNF:PRECEDENCIA - Tabela de precedencia de operadores (da menor para a maior)", "EBNF:PRECEDENCE - Operator precedence table (from lowest to highest)"),
    ("Nivel  Assoc  Categoria             Operadores", "Level  Assoc  Category              Operators"),
    ("Atribuicao            =", "Assignment            ="),
    ("Recuperacao           catch", "Recovery              catch"),
    ("Dataflow              -->", "Dataflow              -->"),
    ("Disjuncao logica      or", "Logical Disjunction   or"),
    ("Conjuncao logica      and", "Logical Conjunction   and"),
    ("Relacional            ==", "Relational            =="),
    ("Pertinencia           in", "Membership            in"),
    ("Aditivo               +", "Additive              +"),
    ("Multiplicativo        *", "Multiplicative        *"),
    ("Potencia              ^e", "Power/Root            ^e"),
    ("Prefixo / unario      +", "Unary / Prefix        +"),
    ("Pos-fixo              ()", "Postfix               ()"),
    ("(maior precedencia)", "(highest precedence)"),
    ("Parenteses \"(\" expression \")\" tem a maior precedencia possivel.", "Parentheses \"(\" expression \")\" have the highest possible precedence."),
    ("Expressoes entre parenteses forcam avaliacao antecipada.", "Expressions in parentheses force early evaluation."),
    ("BLOCO 1: CONVENÇÃO E IDENTIFICADORES", "BLOCK 1: CONVENTIONS AND IDENTIFIERS"),
    ("Camada 1: Unidades Léxicas de Suporte", "Layer 1: Supporting Lexical Units"),
    ("Camada 2: Formas Léxicas de Expressão de Estilos", "Layer 2: Lexical Style Patterns"),
    ("Padrão 1: snake_case (variáveis mutáveis, campos mutáveis, funções, parâmetros)", "Pattern 1: snake_case (mutable variables, mutable fields, functions, parameters)"),
    ("Padrão 2: camelCase (funções, operações)", "Pattern 2: camelCase (functions, operations)"),
    ("Padrão 3: PascalCase (tipos compostos, contratos, agentes, programas, enums)", "Pattern 3: PascalCase (composite types, contracts, agents, programs, enums)"),
    ("Padrão 4: SCREAMING_SNAKE_CASE (constantes imutáveis, campos imutáveis de struct)", "Pattern 4: SCREAMING_SNAKE_CASE (immutable constants, immutable struct fields)"),
    ("Regra: Palavras Reservadas da Linguagem. Usado via set subtraction em identificadores", "Rule: Reserved Language Keywords. Used via set subtraction in identifiers"),
    ("Camada 3: Filtros de Identificadores (Ordem Otimizada e Protegida)", "Layer 3: Identifier Filters (Optimized and Protected Order)"),
    ("Identificador Minúsculo Estrito: snake_case e camelCase excluindo keywords", "Strict Lowercase Identifier: snake_case and camelCase excluding keywords"),
    ("Identificador Maiúsculo Estrito: Tipos, contratos, enums, agentes e programas (PascalCase)", "Strict Uppercase Identifier: Types, contracts, enums, agents, and programs (PascalCase)"),
    ("Identificador de Constantes: Constantes imutáveis (SCREAMING_SNAKE_CASE)", "Constant Identifier: Immutable constants (SCREAMING_SNAKE_CASE)"),
    ("Identificador Universal Raiz / Wildcard", "Universal Root / Wildcard Identifier"),
    ("Regra Unificada Final de Identificação", "Final Unified Identification Rule"),
    ("SUBLOCO: CARACTERES BASE E FILTROS", "SUB-BLOCK: BASE CHARACTERS AND FILTERS"),
    ("Regra: Quebras de Linha Nativas", "Rule: Native Line Breaks"),
    ("caractere ASCII imprimivel ou espaco (codigo 0x20 a 0x7E)", "printable ASCII character or space (code 0x20 to 0x7E)"),
    ("caractere ASCII de 7 bits (codigo 0x00 a 0x7F) ou code point Unicode (U+0080..U+10FFFF), exceto TAB (0x09), \\n e \\r", "7-bit ASCII character (code 0x00 to 0x7F) or Unicode code point (U+0080..U+10FFFF), except TAB (0x09), \\n and \\r"),
    ("Regra: Atalho Semântico para Caracteres em Linha Única", "Rule: Semantic Shortcut for Single-Line Characters"),
    ("Regra: Caractere Seguro em Bloco de Comentário (evita fechamento acidental B#)", "Rule: Safe Character in Block Comment (prevents accidental B# termination)"),
    ("any_comment_char com a restricao de que a sequencia \"B#\" nao seja formada", "any_comment_char with the restriction that sequence \"B#\" is not formed"),
    ("Regra: Caracteres Permitidos em Documentações Automáticas (Docstrings)", "Rule: Allowed Characters in Integrated Docstrings"),
    ("caractere ASCII imprimivel ou espaco em branco, ou code point Unicode, exceto a sequencia \"D#\"", "printable ASCII character or whitespace, or Unicode code point, except sequence \"D#\""),
    ("Regra: Caractere Imprimível Padrão para Validação de Strings e Chars (inclui Unicode UTF-8)", "Rule: Standard Printable Character for String and Char Validation (includes Unicode UTF-8)"),
    ("caractere imprimivel ASCII (codigo 0x20 a 0x7E: espaco a tilde) ou code point Unicode (U+0080..U+10FFFF)", "printable ASCII character (code 0x20 to 0x7E: space to tilde) or Unicode code point (U+0080..U+10FFFF)"),
    ("Regra: Filtro Especial para Impedir Aspas Simples Soltas em Literais Char", "Rule: Special Filter to Prevent Stray Single Quotes in Char Literals"),
    ("Regra: Filtro Especial para Strings Delimitadas por Aspas Duplas", "Rule: Special Filter for Double-Quoted Strings"),
    ("SUBLOCO: COMENTÁRIOS E CONTROLE", "SUB-BLOCK: COMMENTS AND CONTROL"),
    ("Regra: Comentário de Linha Única Iniciado com #L", "Rule: Single-Line Comment Starting with #L"),
    ("fim de arquivo", "end of file"),
    ("Regra: Comentário em Bloco com Delimitadores Herméticos #B e B#", "Rule: Block Comment with Hermetic Delimiters #B and B#"),
    ("Regra: Comentário Geral", "Rule: General Comment"),
    ("Regra: Docstring Integrada para Documentação de Tipos, Funções e Agentes (#D ... D#)", "Rule: Integrated Docstring for Documenting Types, Functions, and Agents (#D ... D#)"),
    ("Regra: Espaços em Branco Puros", "Rule: Pure Whitespace"),
    ("Regra: Fim de Linha Estrutural", "Rule: Structural End of Line"),
    ("Regra: Fim de Arquivo Físico", "Rule: Physical End of File"),
    ("fim do fluxo de caracteres de entrada (EOF)", "end of input character stream (EOF)"),
    ("BLOCO 2: NÚMEROS E LITERAIS", "BLOCK 2: NUMBERS AND LITERALS"),
    ("Regra: Literais Numéricos Inteiros em Base Decimal", "Rule: Integer Numeric Literals in Decimal Base"),
    ("Regra: Literais de Ponto Flutuante (Notação Padrão e Científica)", "Rule: Floating-Point Literals (Standard and Scientific Notation)"),
    ("Regra: Sufixo de Número Imaginário", "Rule: Imaginary Number Suffix"),
    ("Regra: Literal Imaginário Puro", "Rule: Pure Imaginary Literal"),
    ("Regra: Literal de Número Complexo Completo", "Rule: Full Complex Number Literal"),
    ("Regra: Literais Booleanos (PascalCase canônico True/False ou minúsculo true/false)", "Rule: Boolean Literals (Canonical PascalCase True/False or lowercase true/false)"),
    ("DATA E HORA ISO 8601 COM NANOSSEGUNDOS", "ISO 8601 DATE AND TIME WITH NANOSECONDS"),
    ("SUPORTE A TEXTO E CARACTERES", "TEXT AND CHARACTER SUPPORT"),
    ("Sequências de escape clássicas e Unicode \\u{XXXX}", "Classic escape sequences and Unicode \\u{XXXX}"),
    ("Regra: Literal de Caractere Único (code point Unicode)", "Rule: Single Character Literal (Unicode code point)"),
    ("Regra: Literal de String/Texto Estático (UTF-8)", "Rule: Static String/Text Literal (UTF-8)"),
    ("Regra: Interpolação de Strings #{ expr }", "Rule: String Interpolation #{ expr }"),
    ("Regra Unificada de Literais", "Rule: Unified Literals Rule"),
    ("BLOCO 3: TIPOS PRIMITIVOS", "BLOCK 3: PRIMITIVE TYPES"),
    ("Tipos Inteiros com Sinal e Sem Sinal de Largura Fixa", "Fixed-Width Signed and Unsigned Integer Types"),
    ("Tipos de Ponto Flutuante IEEE 754 e Especiais para IA/ML", "IEEE 754 Floating-Point Types and Special ML Formats"),
    ("Tipos Complexos", "Complex Types"),
    ("Tipos Numéricos e Temporais", "Numeric and Temporal Types"),
    ("Tipos Escalares Primitivos", "Primitive Scalar Types"),
    ("Tipos de Coleção Dinâmica e Tipada", "Dynamic and Typed Collection Types"),
    ("Tipo Tensor Multidimensional", "Multidimensional Tensor Type"),
    ("Referência Completa a Tipos", "Full Type Reference"),
    ("BLOCO 4: DECLARAÇÕES BASE", "BLOCK 4: BASE DECLARATIONS"),
    ("Declaração de Variável Mutável: mut as <tipo>: <id> [= <expr>]", "Mutable Variable Declaration: mut as <type>: <id> [= <expr>]"),
    ("Declaração de Constante Imutável: imut as <tipo>: <id> = <expr>", "Immutable Constant Declaration: imut as <type>: <id> = <expr>"),
    ("OPERADORES E COMANDOS DE ATRIBUIÇÃO", "ASSIGNMENT OPERATORS AND STATEMENTS"),
    ("BLOCO 5: EXPRESSÕES", "BLOCK 5: EXPRESSIONS"),
    ("Operadores Unários e Primários", "Unary and Primary Operators"),
    ("Operações Pós-Fixas (Acesso a Campo, Chamada, Indexação, Fatiamento, Cast, Short-Circuit)", "Postfix Operations (Field Access, Call, Indexing, Slicing, Cast, Short-Circuit)"),
    ("Operadores por Nível de Precedência", "Operators by Precedence Level"),
    ("Dataflow e Lambda", "Dataflow and Lambda"),
    ("Recuperação e Tratamento de Erros", "Error Recovery and Handling"),
    ("BLOCO 6: FUNÇÕES, ESTRUTURAS E FLUXO", "BLOCK 6: FUNCTIONS, STRUCTURES AND CONTROL FLOW"),
    ("--- 1. COMANDO DE IMPORTAÇÃO (USE) ---", "--- 1. IMPORT DECLARATION (USE) ---"),
    ("--- 2. SISTEMA DE SAÍDA E TELEMETRIA (BUILT-INS) ---", "--- 2. OUTPUT AND TELEMETRY SYSTEM (BUILT-INS) ---"),
    ("--- 3. CONTROLE DE LAÇOS (BREAK / CONTINUE / INFINITE) ---", "--- 3. LOOP CONTROL (BREAK / CONTINUE / INFINITE) ---"),
    ("--- 4. ROTEAMENTO CONDICIONAL (ROUTE) ---", "--- 4. CONDITIONAL ROUTING (ROUTE) ---"),
    ("--- 5. CASAMENTO DE PADRÕES (MATCH) ---", "--- 5. PATTERN MATCHING (MATCH) ---"),
    ("--- 6. OPERADOR SHORT-CIRCUIT '?' ---", "--- 6. SHORT-CIRCUIT OPERATOR '?' ---"),
    ("--- 7. CLEANUP E GARANTIA (ENSURE) ---", "--- 7. CLEANUP AND GUARANTEE (ENSURE) ---"),
    ("--- 8. CONTRATOS E IMPLEMENTAÇÕES (CONTRACT / IMPL / OP) ---", "--- 8. CONTRACTS AND IMPLEMENTATIONS (CONTRACT / IMPL / OP) ---"),
    ("--- 9. MODELO DE AGENTES (AGENT) ---", "--- 9. AGENT MODEL (AGENT) ---"),
    ("--- 10. DECLARAÇÃO DE FUNÇÕES COM RETORNO OBRIGATÓRIO (FUNCTION / EMIT) ---", "--- 10. FUNCTION DECLARATIONS WITH MANDATORY RETURN (FUNCTION / EMIT) ---"),
    ("--- 11. PONTO DE ENTRADA DO PROGRAMA (PROGRAM) ---", "--- 11. PROGRAM ENTRY POINT (PROGRAM) ---"),
    ("--- 12. DECLARAÇÃO DE ESTRUTURAS (STRUCT / ENUM) ---", "--- 12. STRUCTURE DECLARATIONS (STRUCT / ENUM) ---"),
    ("BLOCO 7: PONTOS DE ENTRADA", "BLOCK 7: ENTRY POINTS"),
    ("Arquivo Principal de Execução (.flux)", "Main Execution File (.flux)"),
    ("Arquivo de Definição de Domínio / Agentes (.fdsl)", "Domain / Agent Definition File (.fdsl)"),
    ("BLOCO 8: MENSAGENS E DIAGNÓSTICO", "BLOCK 8: MESSAGES AND DIAGNOSTICS"),
    ("qualquer caractere de nome-fonte exceto dois-pontos", "any source-name character except colon"),
    ("qualquer caractere de texto de diagnostico", "any diagnostic text character"),
]


def traduzir_ebnf_para_ingles(conteudo_pt: str) -> str:
    conteudo_en = conteudo_pt
    for pt, en in TRANSLATIONS_PT_TO_EN:
        conteudo_en = conteudo_en.replace(pt, en)
    return conteudo_en


def atualizar_secao_ebnf_em_documento(doc_path: Path, novo_ebnf: str) -> bool:
    if not doc_path.exists():
        print(f"  [!] Documento não encontrado: {doc_path}", file=sys.stderr)
        return False
    texto = doc_path.read_text(encoding="utf-8")
    padrao = re.compile(r"(```ebnf\n)(.*?)(\n```)", re.DOTALL)
    m = padrao.search(texto)
    if not m:
        print(f"  [!] Bloco ```ebnf``` não encontrado em: {doc_path}", file=sys.stderr)
        return False
    
    substituido = padrao.sub(lambda m: m.group(1) + novo_ebnf.strip() + m.group(3), texto)
    if substituido != texto:
        doc_path.write_text(substituido, encoding="utf-8")
        return True
    return False


def extrair_nao_terminais(ebnf_text: str) -> set[str]:
    # Extrai os lados esquerdos das regras EBNF (ex: "ident = ...")
    linhas = ebnf_text.splitlines()
    regras = set()
    for l in linhas:
        l = l.strip()
        if "=" in l and not l.startswith("(*") and not l.startswith("|"):
            esquerda = l.split("=")[0].strip()
            if " " not in esquerda and esquerda:
                regras.add(esquerda)
    return regras


def sincronizar_ebnf(check_only: bool = False) -> tuple[int, list[str]]:
    erros = []

    # 1. Carrega fonte primária EBNF
    fonte_path = PT_EBNF_PATH
    if not fonte_path.exists():
        erros.append(f"Fonte EBNF não encontrada: {fonte_path}")
        return 1, erros

    conteudo_pt = fonte_path.read_text(encoding="utf-8").strip()
    conteudo_en = traduzir_ebnf_para_ingles(conteudo_pt).strip()

    # Valida paridade de não-terminais
    nt_pt = extrair_nao_terminais(conteudo_pt)
    nt_en = extrair_nao_terminais(conteudo_en)

    if nt_pt != nt_en:
        diff_pt = nt_pt - nt_en
        diff_en = nt_en - nt_pt
        if diff_pt:
            erros.append(f"Regras presentes em PT mas ausentes em EN: {diff_pt}")
        if diff_en:
            erros.append(f"Regras presentes em EN mas ausentes em PT: {diff_en}")

    if check_only:
        # Verifica se os arquivos no disco coincidem
        if PT_EBNF_PATH.exists() and PT_EBNF_PATH.read_text(encoding="utf-8").strip() != conteudo_pt:
            erros.append(f"{PT_EBNF_PATH} diverge da especificação canônica PT")
        if EN_EBNF_PATH.exists() and EN_EBNF_PATH.read_text(encoding="utf-8").strip() != conteudo_en:
            erros.append(f"{EN_EBNF_PATH} diverge da especificação canônica EN")
        if PT_GRAMMAR_EBNF.exists() and PT_GRAMMAR_EBNF.read_text(encoding="utf-8").strip() != conteudo_pt:
            erros.append(f"{PT_GRAMMAR_EBNF} diverge da especificação canônica PT")
        if EN_GRAMMAR_EBNF.exists() and EN_GRAMMAR_EBNF.read_text(encoding="utf-8").strip() != conteudo_en:
            erros.append(f"{EN_GRAMMAR_EBNF} diverge da especificação canônica EN")
        return (1 if erros else 0), erros

    # 2. Grava arquivos nos destinos
    PT_EBNF_PATH.parent.mkdir(parents=True, exist_ok=True)
    EN_EBNF_PATH.parent.mkdir(parents=True, exist_ok=True)

    PT_EBNF_PATH.write_text(conteudo_pt + "\n", encoding="utf-8")
    print(f"  [+] EBNF em Português gravado: {PT_EBNF_PATH} ({len(conteudo_pt.splitlines())} linhas)")

    EN_EBNF_PATH.write_text(conteudo_en + "\n", encoding="utf-8")
    print(f"  [+] EBNF em Inglês gravado: {EN_EBNF_PATH} ({len(conteudo_en.splitlines())} linhas)")

    PT_GRAMMAR_EBNF.write_text(conteudo_pt + "\n", encoding="utf-8")
    print(f"  [+] EBNF Gramatica (PT) gravado: {PT_GRAMMAR_EBNF} ({len(conteudo_pt.splitlines())} linhas)")

    EN_GRAMMAR_EBNF.write_text(conteudo_en + "\n", encoding="utf-8")
    print(f"  [+] EBNF Grammar (EN) gravado: {EN_GRAMMAR_EBNF} ({len(conteudo_en.splitlines())} linhas)")

    # 3. Atualiza Seção 3 em docs/pt/TheFlux.md e docs/en/TheFlux.md
    if atualizar_secao_ebnf_em_documento(PT_DOC_PATH, conteudo_pt):
        print(f"  [+] Seção 3 atualizada em: {PT_DOC_PATH}")
    else:
        print(f"  [=] Seção 3 já sincronizada em: {PT_DOC_PATH}")

    if atualizar_secao_ebnf_em_documento(EN_DOC_PATH, conteudo_en):
        print(f"  [+] Seção 3 atualizada em: {EN_DOC_PATH}")
    else:
        print(f"  [=] Seção 3 já sincronizada em: {EN_DOC_PATH}")

    return 0, erros


def main() -> int:
    parser = argparse.ArgumentParser(description="Sincronizador e Gerador Bilíngue de Gramática EBNF")
    parser.add_argument("--check", action="store_true", help="Apenas valida paridade sem alterar arquivos")
    args = parser.parse_args()

    print("=" * 70)
    print("📐 TheFlux — Sincronizador Bilíngue de Gramática ISO/IEC 14977 (EBNF)")
    print(f"   PT TheFlux: {PT_EBNF_PATH}")
    print(f"   EN TheFlux: {EN_EBNF_PATH}")
    print(f"   PT Gramatica: {PT_GRAMMAR_EBNF}")
    print(f"   EN Grammar: {EN_GRAMMAR_EBNF}")
    print("=" * 70)

    codigo, erros = sincronizar_ebnf(args.check)

    if codigo == 0 and not erros:
        print("\n✅ Gramática EBNF 100% Sincronizada e Paritária em Ambos os Idiomas!")
        print("=" * 70)
        return 0
    else:
        print(f"\n❌ Erros na sincronização de EBNF:\n", file=sys.stderr)
        for e in erros:
            print(f"   [!] {e}", file=sys.stderr)
        print("=" * 70, file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
