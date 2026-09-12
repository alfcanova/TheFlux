"""Generate KW_index.yaml from all KW_*.yaml documentation files.
Supports --lang pt (Portuguese, default) and --lang en (English).
"""
import os
import glob
import yaml
import argparse

DOCS_DIR = os.path.dirname(os.path.abspath(__file__))
OUTPUT_FILE = os.path.join(DOCS_DIR, "KW_index.yaml")
OUTPUT_FILE_EN = os.path.join(DOCS_DIR, "en", "KW_index.yaml")

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


def load_all_yamls(lang="pt"):
    if lang == "en":
        base_dir = os.path.join(DOCS_DIR, "en")
    else:
        base_dir = DOCS_DIR
    files = sorted(glob.glob(os.path.join(base_dir, "KW_*.yaml")))
    entries = []
    for fpath in files:
        fname = os.path.basename(fpath)
        if fname == "KW_index.yaml":
            continue
        with open(fpath, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)
        if data and "keyword" in data:
            entries.append({
                "file": fname,
                "keyword": data["keyword"],
                "category": data.get("category", "Outros" if lang == "pt" else "Others"),
                "description": data.get("description", "").split(".")[0].strip() + ".",
            })
    return entries


def build_index(entries, lang="pt"):
    # Group by category
    groups = {}
    for e in entries:
        cat = e["category"]
        groups.setdefault(cat, []).append(e)

    # Sort categories
    category_order = CATEGORY_ORDER_PT if lang == "pt" else CATEGORY_ORDER_EN
    actual_cats = list(groups.keys())
    sorted_cats = [c for c in category_order if c in actual_cats]
    remaining = [c for c in sorted(actual_cats) if c not in category_order]
    sorted_cats += remaining

    title = "TheFlux Language - Documentation Index" if lang == "en" else "TheFlux Language - Indice de Documentacao"

    # Build index structure
    index = {
        "title": title,
        "version": "v0.1",
        "updated": "2026-07-03",
        "total_entries": len(entries),
        "categories": [],
    }

    for cat in sorted_cats:
        items = groups[cat]
        cat_entry = {
            "name": cat,
            "count": len(items),
            "entries": [],
        }
        for e in items:
            cat_entry["entries"].append({
                "keyword": e["keyword"],
                "file": e["file"],
                "description": e["description"],
            })
        index["categories"].append(cat_entry)

    return index


def main():
    parser = argparse.ArgumentParser(description="Generate TheFlux documentation index")
    parser.add_argument("--lang", choices=["pt", "en"], default="pt",
                        help="Language: pt (Portuguese, default) or en (English)")
    args = parser.parse_args()

    entries = load_all_yamls(args.lang)
    print(f"Carregados {len(entries)} arquivos YAML ({args.lang}).")

    index = build_index(entries, lang=args.lang)

    if args.lang == "en":
        output = OUTPUT_FILE_EN
    else:
        output = OUTPUT_FILE

    with open(output, "w", encoding="utf-8") as f:
        yaml.dump(index, f, allow_unicode=True, default_flow_style=False, sort_keys=False, width=120)

    print(f"Indice gerado: {output}")


if __name__ == "__main__":
    main()
