import subprocess
for n in range(1, 35):
    with open('flux/ExampleOfChar.flux', 'r', encoding='utf-8') as src:
        lines = src.readlines()[:n]
    if not any('program' in l for l in lines):
        lines.append('program (Test) {}\n')
    elif not lines[-1].strip().endswith('}'):
        lines.append('}\n')
    with open('scratch/temp_char.flux', 'w', encoding='utf-8') as out:
        out.writelines(lines)
    r = subprocess.run(['bin/fluxc.exe', '--target', 'in', 'scratch/temp_char.flux'], capture_output=True, text=True, encoding='utf-8')
    if r.returncode != 0:
        print(f'CRASHED AT LINE {n}: code {r.returncode}')
        print('STDOUT:', r.stdout)
        print('STDERR:', r.stderr)
        break
    else:
        print(f'Line {n} OK')
