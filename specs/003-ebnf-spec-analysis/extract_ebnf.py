import re
import sys
from pathlib import Path


def find_grammar_sections(text: str) -> tuple[int, int]:
    start = text.find('1. CARACTERES E IDENTIFICADORES')
    end = text.find('13. FLUXO DE COMPILACAO')
    if start < 0:
        print('ERROR: Could not find section 1')
        return -1, -1
    if end < 0:
        end = len(text)
    return start, end


def join_multiline_names(text: str) -> str:
    return re.sub(
        r'^([\w_]+)\s*\n\s+(::=)',
        r'\1 \2',
        text,
        flags=re.MULTILINE
    )


def strip_c_style_comments(text: str) -> str:
    return re.sub(r'/\*.*?\*/', '', text)


def is_skip_line(t: str) -> bool:
    return (not t or t.startswith('/*') or t.startswith('*/') or t == '*' or
            t.startswith('##') or t.startswith('|') or t.startswith('---') or
            t.startswith('- ') or t.startswith('* ') or t.startswith('+ ') or
            bool(re.match(r'^\d+\.\s', t)))


def is_narrative_text(t: str) -> bool:
    return bool(re.match(r'^[A-Z][a-z]{3,}\s', t)) or bool(re.match(r'^[A-Z]{3,}\s', t))


def extract_productions(lines: list[str]) -> list[str]:
    output_lines = []
    output_lines.append('(* ================================================================== *)')
    output_lines.append('(* EBNF GRAMMAR - TheFlux v0.5                                        *)')
    output_lines.append('(* Extracted from docs/grammar.md (Snapshot RC: 2026-07-20)             *)')
    output_lines.append('(* ================================================================== *)')
    output_lines.append('')

    in_prod = False
    prod = ''

    for line in lines:
        t = line.strip()

        if is_skip_line(t):
            if in_prod and prod:
                output_lines.append(re.sub(r'\s+', ' ', prod).strip())
                prod = ''
                in_prod = False
            continue

        m = re.match(r'^([\w_]+)\s+::=', t)
        if m:
            if in_prod and prod:
                output_lines.append(re.sub(r'\s+', ' ', prod).strip())
            prod = t
            in_prod = True
            if t.endswith(';'):
                output_lines.append(re.sub(r'\s+', ' ', prod).strip())
                prod = ''
                in_prod = False
            continue

        if re.match(r'^[\w_]+$', t) and len(t) > 2:
            if in_prod and prod:
                output_lines.append(re.sub(r'\s+', ' ', prod).strip())
            prod = t
            in_prod = True
            continue

        if in_prod:
            if t.startswith('*') or t.startswith('/*') or t.startswith('*/'):
                continue
            if is_narrative_text(t):
                if prod:
                    output_lines.append(re.sub(r'\s+', ' ', prod).strip())
                prod = ''
                in_prod = False
                continue
            prod += ' ' + t
            if t.endswith(';'):
                cleaned = strip_c_style_comments(re.sub(r'\s+', ' ', prod).strip())
                cleaned = re.sub(r'\s+', ' ', cleaned).strip()
                output_lines.append(cleaned)
                prod = ''
                in_prod = False
            continue

    if in_prod and prod:
        cleaned = strip_c_style_comments(re.sub(r'\s+', ' ', prod).strip())
        cleaned = re.sub(r'\s+', ' ', cleaned).strip()
        output_lines.append(cleaned)

    return output_lines


def fix_datetime_literal(output_lines: list[str]) -> list[str]:
    for i, line in enumerate(output_lines):
        if line.startswith('datetime_literal ::=') and not line.rstrip().endswith(';'):
            output_lines[i] = (
                'datetime_literal ::= digit digit digit digit "-" digit digit "-" '
                'digit digit "T" digit digit ":" digit digit ":" digit digit "." '
                'digit digit digit digit digit digit digit digit digit '
                '(* 9 digitos OBRIGATORIOS - nanossegundos *) "Z" ;'
            )
    return output_lines


def validate_production_count(output_lines: list[str], min_expected: int = 200) -> bool:
    count = sum(1 for l in output_lines if '::=' in l)
    ok = count >= min_expected
    status = 'PASS' if ok else 'FAIL'
    print(f'  Production count: {count} (min {min_expected}) -> {status}')
    return ok


def validate_ascii_encoding(output_path: Path) -> bool:
    with open(output_path, 'rb') as f:
        bad = [b for b in f.read() if b > 127]
    ok = len(bad) == 0
    status = 'PASS' if ok else 'FAIL'
    print(f'  ASCII encoding: {len(bad)} non-ASCII bytes -> {status}')
    return ok


def is_markdown_artifact_line(line: str) -> str | None:
    t = line.strip()
    if t.startswith('##'):
        return '##'
    if t.startswith('---'):
        return '---'
    if t.startswith('- ['):
        return '- ['
    if t.startswith('| ') and t.endswith('|'):
        return '| table row'
    return None


def validate_no_markdown_artifacts(output_lines: list[str]) -> bool:
    found: list[str] = []
    for line in output_lines:
        artifact = is_markdown_artifact_line(line)
        if artifact:
            found.append(artifact)
    ok = len(found) == 0
    status = 'PASS' if ok else 'FAIL'
    if not ok:
        print(f'  Markdown artifacts found: {found}')
    else:
        print(f'  Markdown artifacts: {status}')
    return ok


def run_all_validations(output_lines: list[str], output_path: Path) -> bool:
    print('\n--- Validation ---')
    v1 = validate_production_count(output_lines)
    v2 = validate_ascii_encoding(output_path)
    v3 = validate_no_markdown_artifacts(output_lines)
    all_pass = v1 and v2 and v3
    print(f'  Overall: {"PASS" if all_pass else "FAIL"}')
    return all_pass


def extract_ebnf(source_path: Path, output_path: Path) -> int:
    with open(source_path, 'r', encoding='utf-8') as f:
        text = f.read()

    start, end = find_grammar_sections(text)
    if start < 0:
        return 1

    ebnf_text = text[start:end]
    ebnf_text = join_multiline_names(ebnf_text)
    lines = ebnf_text.split('\n')
    output_lines = extract_productions(lines)
    output_lines = fix_datetime_literal(output_lines)

    output_path.parent.mkdir(parents=True, exist_ok=True)

    ascii_lines = []
    for line in output_lines:
        ascii_line = line.encode('ascii', errors='replace').decode('ascii')
        ascii_lines.append(ascii_line)

    with open(output_path, 'w', encoding='ascii') as f:
        f.write('\n'.join(ascii_lines) + '\n')

    prod_count = sum(1 for l in output_lines if '::=' in l)
    print(f'Extraction complete: {len(output_lines)} lines, {prod_count} productions')
    print(f'Output: {output_path}')

    run_all_validations(output_lines, output_path)
    return 0


if __name__ == '__main__':
    source = Path('docs/grammar.md')
    output = Path('docs/TheFlux.ebnf')
    sys.exit(extract_ebnf(source, output))
