#!/usr/bin/env python3
"""Gera KW_index.yaml a partir de todos os arquivos KW_*.yaml da documentação.

Suporta:
  --lang pt (Português, padrão: docs/pt/keywords/KW_index.yaml)
  --lang en (Inglês: docs/en/keywords/KW_index.yaml)
  --lang all (Gera ambos os índices)
"""
import argparse
import glob
import os
import sys
import yaml
from pathlib import Path

# Suporte a UTF-8 no Windows
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

RAIZ = Path(__file__).resolve().parent.parent.parent
DOCS_DIR = RAIZ / "docs"
PT_DIR = DOCS_DIR / "pt" / "keywords"
EN_DIR = DOCS_DIR / "en" / "keywords"

CATEGORY_ORDER_PT = [
    "Ponto de Entrada", "Declaração de Variável", "Declaração de Variável Imutável",
    "Declaração de Tipo", "Declaração de Função", "Declaração de Operação",
    "Declaração de Agente", "Declaração de Contrato", "Implementação de Contrato",
    "Declaração de Importação", "Composição de Tipo",
    "Estrutura de Loop", "Controle de Loop", "Controle de Fluxo Condicional",
    "Pattern Matching", "Tratamento Condicional Estatal", "Iteração",
    "Execução Garantida", "Instrução de Retorno", "Status de Retorno", "Instrução de Saída",
    "Operador Aritmético", "Operador de Atribuição Aritmética", "Operador de Atribuição Bitwise",
    "Operador Bitwise", "Operador de Comparação", "Operador Lógico",
    "Operador de Dataflow", "Operador de Range / Slice", "Operador de Cast / Alias de Importação",
    "Tipo Escalar Primitivo", "Tipo Caractere", "Tipo String",
    "Tipo Numérico - Inteiro", "Tipo Numérico - Ponto Flutuante", "Tipo Numérico - Complexo",
    "Tipo de Coleção - Data", "Tipo de Coleção - List", "Tipo de Coleção - Map", "Tipo de Coleção - Set",
    "Tipo Tensor", "Literal", "Literal Booleano", "Literal de Data/Hora", "Literal Numérico",
    "Interpolação de String", "Comentário / Documentação", "Metaprogramação", "Outros",
]

CATEGORY_ORDER_EN = [
    "Entry Point", "Variable Declaration", "Immutable Variable Declaration",
    "Type Declaration", "Function Declaration", "Operation Declaration",
    "Agent Declaration", "Contract Declaration", "Contract Implementation",
    "Import Declaration", "Type Composition",
    "Loop Structure", "Loop Control", "Conditional Flow Control", "Conditional Structure",
    "Pattern Matching", "Stateful Conditional Handling", "Iteration",
    "Guaranteed Execution", "Return Instruction", "Return Status", "Output Instruction",
    "Arithmetic Operator", "Arithmetic Assignment Operator", "Bitwise Assignment Operator",
    "Bitwise Operator", "Comparison Operator", "Logical Operator",
    "Dataflow Operator", "Range / Slice Operator", "Cast Operator / Import Alias",
    "Primitive Scalar Type", "Character Type", "String Type",
    "Numeric Type - Integer", "Numeric Type - Floating Point", "Numeric Type - Complex",
    "Collection Type - Data", "Collection Type - List", "Collection Type - Map", "Collection Type - Set",
    "Collection Type", "Tensor Type", "Literal", "Boolean Literal", "Datetime Literal", "Numeric Literal",
    "String Interpolation", "Comment / Documentation", "Metaprogramming (Compile-time)", "Others",
]


def carregar_yamls(lang: str = "pt") -> list[dict]:
    base_dir = EN_DIR if lang == "en" else PT_DIR
    files = sorted(base_dir.glob("KW_*.yaml"))
    entries = []
    for fpath in files:
        if fpath.name == "KW_index.yaml":
            continue
        try:
            with open(fpath, "r", encoding="utf-8") as f:
                data = yaml.safe_load(f)
            if data and "keyword" in data:
                data["_filename"] = fpath.name
                entries.append(data)
        except Exception as e:
            print(f"Aviso: erro ao ler {fpath.name}: {e}", file=sys.stderr)
    return entries


def construir_indice(entries: list[dict], lang: str = "pt") -> dict:
    cat_order = CATEGORY_ORDER_EN if lang == "en" else CATEGORY_ORDER_PT
    cats: dict[str, list] = {}

    for entry in entries:
        cat = entry.get("category", "Outros" if lang == "pt" else "Others")
        if cat not in cats:
            cats[cat] = []
        kw_item = {
            "name": entry["keyword"],
            "file": entry["_filename"],
            "description": entry.get("description", ""),
        }
        if "syntax" in entry:
            first_syntax = entry["syntax"].strip().split("\n")[0]
            kw_item["syntax_summary"] = first_syntax
        cats[cat].append(kw_item)

    categories_list = []
    seen = set()
    for cat_name in cat_order:
        if cat_name in cats:
            categories_list.append({"name": cat_name, "keywords": cats[cat_name]})
            seen.add(cat_name)

    for cat_name, kws in sorted(cats.items()):
        if cat_name not in seen:
            categories_list.append({"name": cat_name, "keywords": kws})

    total_keywords = sum(len(c["keywords"]) for c in categories_list)
    title = "TheFlux Language Keywords and Operators Index" if lang == "en" else "Índice de Palavras-Chave e Operadores da Linguagem TheFlux"
    desc = ("Structured index of all keywords, operators, and special tokens of the TheFlux language, grouped by functional category."
            if lang == "en" else
            "Índice estruturado de todas as palavras-chave, operadores e tokens especiais da linguagem TheFlux, agrupados por categoria funcional.")

    return {
        "title": title,
        "language": lang,
        "total_categories": len(categories_list),
        "total_keywords": total_keywords,
        "description": desc,
        "categories": categories_list,
    }


def gerar_indice_lingua(lang: str):
    out_file = EN_DIR / "KW_index.yaml" if lang == "en" else PT_DIR / "KW_index.yaml"
    entries = carregar_yamls(lang)
    index_data = construir_indice(entries, lang)

    with open(out_file, "w", encoding="utf-8") as f:
        yaml.dump(index_data, f, allow_unicode=True, default_flow_style=False, sort_keys=False, width=120)

    print(f"  [+] Índice gerado ({lang.upper()}): {out_file} ({index_data['total_keywords']} palavras-chave, {index_data['total_categories']} categorias)")


def main():
    parser = argparse.ArgumentParser(description="Gera KW_index.yaml para documentação TheFlux.")
    parser.add_argument("--lang", choices=["pt", "en", "all"], default="all", help="Idioma do índice (pt, en ou all)")
    args = parser.parse_args()

    langs = ["pt", "en"] if args.lang == "all" else [args.lang]
    for lang in langs:
        gerar_indice_lingua(lang)


if __name__ == "__main__":
    main()
