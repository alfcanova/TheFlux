import sys
import re

if len(sys.argv) < 2:
    sys.exit(0)

ll_path = sys.argv[1]

try:
    with open(ll_path, 'r', encoding='utf-8') as f:
        ll = f.read()
except Exception:
    sys.exit(0)

pat = re.compile(
    r'  (%t\d+) = (getelementptr inbounds \[\d+ x i8\], \[\d+ x i8\]\* @\.str\.\d+, i32 0, i32 0)\n'
    r'  (%t\d+) = add i64 0, 0\n'
    r'  store i64 \3, i64\* (%(?:h_line|sep|payload|raw_[a-zA-Z0-9_]+)), align 8'
)

if not pat.search(ll):
    sys.exit(0)

if '@flux_runtime_input_string' not in ll:
    decl = "declare i8* @flux_runtime_input_string(i8*, i8*)\n"
    idx = ll.find('define ')
    if idx != -1:
        ll = ll[:idx] + decl + ll[idx:]

def repl(m):
    tA = m.group(1)
    prompt_gep = m.group(2)
    tB = m.group(3)
    var = m.group(4)
    return (
        f"  {tA} = {prompt_gep}\n"
        f"  {tB}_ptr = call i8* @flux_runtime_input_string(i8* {tA}, i8* null)\n"
        f"  {tB} = ptrtoint i8* {tB}_ptr to i64\n"
        f"  store i64 {tB}, i64* {var}, align 8"
    )

new_ll, count = pat.subn(repl, ll)
if count > 0:
    with open(ll_path, 'w', encoding='utf-8') as f:
        f.write(new_ll)
    print(f"    [*] Patch de I/O stdin (@flux_runtime_input_string) aplicado ({count} chamada(s)).")
