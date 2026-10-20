from pathlib import Path

path = Path("src/CompilerLib/backends/interp/InterpBackend.fdsl")
content = path.read_text(encoding="utf-8")

old = """                                                (stdMapContainsKey(reg_types, a1) and reg_types[a1] == "string") or (stdMapContainsKey(reg_types, a2) and reg_types[a2] == "string") ==> {
                                                      mut as string: s1 = "" + regs[a1]
                                                      mut as string: s2 = "" + regs[a2]
                                                      regs[res] = s1 + s2
                                                      reg_types[res] = "string"
                                                }"""

new = """                                                (stdMapContainsKey(reg_types, a1) and reg_types[a1] == "string") or (stdMapContainsKey(reg_types, a2) and reg_types[a2] == "string") ==> {
                                                      print("    + arm string: reading s1")
                                                      mut as string: s1 = "" + regs[a1]
                                                      print("    + arm string: reading s2")
                                                      mut as string: s2 = "" + regs[a2]
                                                      print("    + arm string: s1=[" + s1 + "], s2=[" + s2 + "]")
                                                      regs[res] = s1 + s2
                                                      reg_types[res] = "string"
                                                      print("    + arm string: stored")
                                                }"""

assert old in content, "old pattern not found"
content = content.replace(old, new, 1)
path.write_text(content, encoding="utf-8")
print("InterpBackend patched successfully")
