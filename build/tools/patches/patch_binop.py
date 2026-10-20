from pathlib import Path

p = Path("src/CompilerLib/backends/interp/InterpBackend.fdsl")
c = p.read_text(encoding="utf-8")

old_binop = """                                    opcode == "BINOP_+" ==> {
                                          route {"""

new_binop = """                                    opcode == "BINOP_+" ==> {
                                          print("  -> BINOP_+ start: a1=[" + a1 + "], a2=[" + a2 + "], res=[" + res + "]")
                                          route {"""

assert old_binop in c, "old_binop not found"
p.write_text(c.replace(old_binop, new_binop, 1), encoding="utf-8")
print("BINOP_+ start print added")
