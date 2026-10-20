from pathlib import Path
p = Path("src/CompilerLib/backends/interp/InterpBackend.fdsl")
c = p.read_text(encoding="utf-8")
old = '                              mut as string: res = "" + inst["res"]\n'
new = old + '                              print("[PC " + (pc as string) + "]: " + opcode)\n'
assert old in c, "old not found"
p.write_text(c.replace(old, new, 1), encoding="utf-8")
print("Trace added")
