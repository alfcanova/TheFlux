import re

s = open('src/CompilerLib/fmir/FmirBuilder.fdsl', encoding='utf-8').read()
ops = set(re.findall(r'fmirAddInstruction\(mod,\s*"([^"]+)"', s))
print("FMIR Opcodes count:", len(ops))
for op in sorted(ops):
    print(" ", op)
