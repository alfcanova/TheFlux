import re
import sys
from pathlib import Path


VERSION = '1.1.0'
EXTRACT_DATE = '2026-07-23'
MIN_PRODUCTIONS = 200

# Tag used to mark comment blocks that should be preserved in EBNF output
PRESERVE_TAG = 'EBNF:'


def read_source(path: Path) -> str:
    return path.read_text(encoding='utf-8')


def write_output(path: Path, lines: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    ascii_lines = [l.encode('ascii', errors='replace').decode('ascii') for l in lines]
    path.write_text('\n'.join(ascii_lines) + '\n', encoding='ascii')


def find_section(text: str, title: str) -> int:
    idx = text.find(title)
    return idx if idx >= 0 else -1


def find_grammar_sections(text: str) -> tuple[int, int]:
    start = find_section(text, '1. CARACTERES E IDENTIFICADORES')
    end = find_section(text, '13. FLUXO DE COMPILACAO')
    if start < 0:
        print('ERROR: Could not find section 1')
        return -1, -1
    if end < 0:
        end = len(text)
    diag_start = find_section(text, '14. CONTRATO DE DIAGNOSTICO')
    diag_end = find_section(text, '15. TABELA ASCII')
    if diag_start >= 0:
        diag_end = diag_end if diag_end >= 0 else len(text)
        return start, diag_end
    return start, end


def join_multiline_names(text: str) -> str:
    return re.sub(
        r'^([\w_]+)\s*\n\s+(::=)',
        r'\1 \2',
        text,
        flags=re.MULTILINE
    )


def strip_c_comments(text: str) -> str:
    return re.sub(r'/\*.*?\*/', '', text, flags=re.DOTALL)


def extract_preserved_ebnf_notes(text: str) -> tuple[str, list[str]]:
    notes: list[str] = []

    def _replacer(m: re.Match) -> str:
        inner = m.group(0)
        inner = re.sub(r'^/\*\s*', '', inner)
        inner = re.sub(r'\s*\*/$', '', inner)
        notes.append('(*\n' + inner + '\n*)')
        return ''

    modified = re.sub(
        r'/\*[^*]*' + re.escape(PRESERVE_TAG) + r'.*?\*/',
        _replacer,
        text,
        flags=re.DOTALL,
    )
    return modified, notes


def is_table_row(t: str) -> bool:
    return t.startswith('|') and t.endswith('|') and t.count('|') >= 3


def is_horizontal_rule(t: str) -> bool:
    return bool(re.match(r'^\|-+\|$', t)) or t in ('---', '--- ')


def is_skip_line(t: str) -> bool:
    if not t:
        return True
    if t.startswith('/*') or t.startswith('*/') or t == '*':
        return True
    if t.startswith('##'):
        return True
    if is_table_row(t) or is_horizontal_rule(t):
        return True
    if t.startswith('- ['):
        return True
    if re.match(r'^\d+\.\s', t):
        return True
    return False


PRODUCTION_TOKENS = {'EOF', 'INDENT', 'DEDENT', 'NEWLINE', 'IDENT_LOWER',
    'IDENT_UPPER', 'IDENT_MIXED', 'DOCSTRING'}


def is_narrative_text(t: str) -> bool:
    first_word = t.split()[0] if t.split() else ''
    if first_word in PRODUCTION_TOKENS:
        return False
    if t.endswith(';'):
        return False
    return bool(re.match(r'^[A-Z][a-z]{3,}\s', t)) or bool(re.match(r'^[A-Z]{3,}\s', t))


def extract_productions(lines: list[str],
                        preserved_notes: list[str] | None = None) -> list[str]:
    output_lines = []
    output_lines.append('(* ================================================================== *)')
    output_lines.append(f'(* EBNF (ISO/IEC 14977) - TheFlux v0.5                                 *)')
    output_lines.append(f'(* Extracted from docs/grammar.md on {EXTRACT_DATE}                     *)')
    output_lines.append(f'(* Script: extract_ebnf.py v{VERSION}                                  *)')
    output_lines.append('(* ================================================================== *)')
    output_lines.append('')

    in_prod = False
    has_assign = False
    prod = ''
    notes_injected = False

    for line in lines:
        t = line.strip()

        if is_skip_line(t):
            if in_prod and prod:
                output_lines.append(re.sub(r'\s+', ' ', prod).strip())
                prod = ''
                in_prod = False
                has_assign = False
            continue

        # Inject preserved EBNF notes before the first production of section 9
        if preserved_notes and not notes_injected and '::=' in t:
            for note in preserved_notes:
                for note_line in note.split('\n'):
                    output_lines.append(note_line)
                output_lines.append('')
            notes_injected = True

        m = re.match(r'^([\w_]+)\s+::=', t)
        if m:
            if in_prod and prod:
                output_lines.append(re.sub(r'\s+', ' ', prod).strip())
            prod = t
            in_prod = True
            has_assign = True
            if t.endswith(';'):
                cleaned = re.sub(r'\s+', ' ', prod).strip()
                output_lines.append(cleaned)
                prod = ''
                in_prod = False
                has_assign = False
            continue

        if re.match(r'^[\w_]+$', t) and len(t) > 2:
            if in_prod and has_assign:
                prod += ' ' + t
                continue
            if in_prod and prod:
                output_lines.append(re.sub(r'\s+', ' ', prod).strip())
            prod = t
            in_prod = True
            has_assign = False
            continue

        if in_prod:
            if t.startswith('*') or t.startswith('/*') or t.startswith('*/'):
                continue
            if is_narrative_text(t):
                if prod:
                    output_lines.append(re.sub(r'\s+', ' ', prod).strip())
                prod = ''
                in_prod = False
                has_assign = False
                continue
            prod += ' ' + t
            if t.endswith(';'):
                cleaned = strip_c_comments(re.sub(r'\s+', ' ', prod).strip())
                cleaned = re.sub(r'\s+', ' ', cleaned).strip()
                output_lines.append(cleaned)
                prod = ''
                in_prod = False
                has_assign = False
            continue

    if in_prod and prod:
        cleaned = strip_c_comments(re.sub(r'\s+', ' ', prod).strip())
        cleaned = re.sub(r'\s+', ' ', cleaned).strip()
        output_lines.append(cleaned)
        in_prod = False
        has_assign = False

    return output_lines


def fix_known_productions(output_lines: list[str]) -> list[str]:
    for i, line in enumerate(output_lines):
        if line.startswith('datetime_literal ::=') and not line.rstrip().endswith(';'):
            output_lines[i] = (
                'datetime_literal ::= digit digit digit digit "-" digit digit "-" '
                'digit digit "T" digit digit ":" digit digit ":" digit digit "." '
                'digit digit digit digit digit digit digit digit digit '
                '(* 9 digitos OBRIGATORIOS - nanossegundos *) "Z" ;'
            )
    return output_lines


def validate_production_count(output_lines: list[str], min_expected: int = MIN_PRODUCTIONS) -> bool:
    count = sum(1 for l in output_lines if re.match(r'^[\w_]+\s+=', l))
    ok = count >= min_expected
    status = 'PASS' if ok else 'FAIL'
    print(f'  Production count: {count} (min {min_expected}) -> {status}')
    return ok


def validate_ascii_encoding(output_path: Path) -> bool:
    raw = output_path.read_bytes()
    bad = [b for b in raw if b > 127]
    ok = len(bad) == 0
    status = 'PASS' if ok else 'FAIL'
    print(f'  ASCII encoding: {len(bad)} non-ASCII bytes -> {status}')
    return ok


def is_markdown_artifact_line(line: str) -> str | None:
    t = line.strip()
    if t.startswith('##'):
        return '##'
    if is_horizontal_rule(t):
        return '---'
    if t.startswith('- ['):
        return '- ['
    if is_table_row(t):
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
    text = read_source(source_path)

    start, end = find_grammar_sections(text)
    if start < 0:
        return 1

    ebnf_text = text[start:end]
    ebnf_text, preserved_notes = extract_preserved_ebnf_notes(ebnf_text)
    ebnf_text = join_multiline_names(ebnf_text)
    lines = ebnf_text.split('\n')
    output_lines = extract_productions(lines, preserved_notes)
    output_lines = fix_known_productions(output_lines)
    output_lines = [l.replace('::=', '=') for l in output_lines]

    write_output(output_path, output_lines)

    prod_count = sum(1 for l in output_lines if re.match(r'^[\w_]+\s+=', l))
    print(f'Extraction complete: {len(output_lines)} lines, {prod_count} productions')
    print(f'Output: {output_path}')

    run_all_validations(output_lines, output_path)
    return 0


T13_SINGLE_LINE_INPUT = '''letter ::= lower_letter | upper_letter ;
'''

T13_SINGLE_LINE_EXPECTED = 1

T14_MULTI_LINE_INPUT = '''nonzero_digit ::= "1" | "2" | "3" | "4" | "5"
                       | "6" | "7" | "8" | "9" ;
'''

T14_MULTI_LINE_EXPECTED = 1

T15_NARRATIVE_INPUT = '''digit ::= "0" | "1" ;
This is narrative text that should be excluded.
another ::= "a" ;
'''

T15_NARRATIVE_EXPECTED = 2

T16_MD_ARTIFACTS_INPUT = '''digit ::= "0" | "1" ;
## Section Header
| Cell1 | Cell2 |
- list item
another ::= "a" ;
'''

T16_MD_ARTIFACTS_EXPECTED = 2

PRE_NOTE_INPUT = '''/* EBNF:PRECEDENCIA — test note */
expression ::= assignment_expr ;
'''

T22_PRE_NOTE_EXPECTED = 1


def run_tests() -> bool:
    print('--- US1 Tests ---')
    all_pass = True

    res1 = extract_productions(T13_SINGLE_LINE_INPUT.split('\n'))
    actual1 = sum(1 for l in res1 if '::=' in l)
    ok1 = actual1 == T13_SINGLE_LINE_EXPECTED
    print(f'  T013 Single-line production: {actual1} prods (expected {T13_SINGLE_LINE_EXPECTED}) -> {"PASS" if ok1 else "FAIL"}')
    if not ok1:
        all_pass = False

    res2 = extract_productions(T14_MULTI_LINE_INPUT.split('\n'))
    actual2 = sum(1 for l in res2 if '::=' in l)
    ok2 = actual2 == T14_MULTI_LINE_EXPECTED
    print(f'  T014 Multi-line production: {actual2} prods (expected {T14_MULTI_LINE_EXPECTED}) -> {"PASS" if ok2 else "FAIL"}')
    if not ok2:
        all_pass = False

    res3 = extract_productions(T15_NARRATIVE_INPUT.split('\n'))
    actual3 = sum(1 for l in res3 if '::=' in l)
    ok3 = actual3 == T15_NARRATIVE_EXPECTED
    print(f'  T015 No narrative text: {actual3} prods (expected {T15_NARRATIVE_EXPECTED}) -> {"PASS" if ok3 else "FAIL"}')
    if not ok3:
        all_pass = False

    res4 = extract_productions(T16_MD_ARTIFACTS_INPUT.split('\n'))
    actual4 = sum(1 for l in res4 if '::=' in l)
    ok4 = actual4 == T16_MD_ARTIFACTS_EXPECTED
    print(f'  T016 No Markdown artifacts: {actual4} prods (expected {T16_MD_ARTIFACTS_EXPECTED}) -> {"PASS" if ok4 else "FAIL"}')
    if not ok4:
        all_pass = False

    res5 = extract_productions(PRE_NOTE_INPUT.split('\n'),
                               preserved_notes=['(*(* EBNF:PRECEDENCIA -- test note *)'])
    actual5 = sum(1 for l in res5 if '::=' in l)
    note_count = sum(1 for l in res5 if 'EBNF:PRECEDENCIA' in l)
    ok5 = actual5 == T22_PRE_NOTE_EXPECTED and note_count == 1
    print(f'  T022 Preserved note injection: {actual5} prods, {note_count} notes (expected {T22_PRE_NOTE_EXPECTED}, 1) -> {"PASS" if ok5 else "FAIL"}')
    if not ok5:
        all_pass = False

    return all_pass


def run_tests_us2() -> bool:
    print('--- US2 Tests ---')
    all_pass = True

    test_ascii_fail = 'test \xff non-ascii'
    tmp = Path('__test_ascii.tmp')
    tmp.write_bytes(test_ascii_fail.encode('latin-1'))
    v1 = not validate_ascii_encoding(tmp)
    tmp.unlink()
    print(f'  T019 ASCII validator detects non-ASCII: {"PASS" if v1 else "FAIL"}')
    if not v1:
        all_pass = False

    few_lines = ['a ::= b;']
    v2 = not validate_production_count(few_lines, min_expected=10)
    print(f'  T020 Production count validator fails when < min: {"PASS" if v2 else "FAIL"}')
    if not v2:
        all_pass = False

    md_lines = [
        'a ::= b;',
        '## header',
        '| table | row |',
    ]
    md_ok = not validate_no_markdown_artifacts(md_lines)
    print(f'  T021 Markdown artifact detector catches artifacts: {"PASS" if md_ok else "FAIL"}')
    if not md_ok:
        all_pass = False

    return all_pass


if __name__ == '__main__':
    if '--test' in sys.argv:
        t1 = run_tests()
        t2 = run_tests_us2()
        sys.exit(0 if t1 and t2 else 1)
    source = Path('docs/grammar.md')
    output = Path('docs/TheFlux.ebnf')
    sys.exit(extract_ebnf(source, output))
