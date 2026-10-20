from pathlib import Path

path = Path("src/CompilerLib/backends/interp/InterpBackend.fdsl")
content = path.read_text(encoding="utf-8")

# 1. Remove PC print
content = content.replace('                              print("[PC " + (pc as string) + "]: " + opcode)\n', '')

# 2. Remove BINOP_+ start print
content = content.replace('                                          print("  -> BINOP_+ start: a1=[" + a1 + "], a2=[" + a2 + "], res=[" + res + "]")\n', '')

# 3. Clean string arm if needed
content = content.replace('                                                      print("    + arm string: reading s1")\n', '')
content = content.replace('                                                      print("    + arm string: reading s2")\n', '')
content = content.replace('                                                      print("    + arm string: s1=[" + s1 + "], s2=[" + s2 + "]")\n', '')
content = content.replace('                                                      print("    + arm string: stored")\n', '')

path.write_text(content, encoding="utf-8")
print("Cleaned InterpBackend completely")
