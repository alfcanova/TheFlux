with open('src/CompilerLib/backends/llvm/LlvmBackend.fdsl', 'r', encoding='utf-8') as f:
    content = f.read()

c = content.replace('\r\n', '\n')

# 1. Add reg_str_vals map to Pass 2
old_pass2_init = """            #L 4. Segunda Passagem: Emissao de Instrucoes
            mut as map: reg_types = map{}
            mut as map: var_types = map{}"""

new_pass2_init = """            #L 4. Segunda Passagem: Emissao de Instrucoes
            mut as map: reg_types = map{}
            mut as map: var_types = map{}
            mut as map: reg_str_vals = map{}"""

assert old_pass2_init in c, 'Pass 2 init target not found'
c = c.replace(old_pass2_init, new_pass2_init, 1)

# 2. Record string literal in CONST_STR
old_const_str = """                                    opcode == "CONST_STR" ==> {
                                          mut as string: slbl = str_map[a1]
                                          mut as int64: slen = str_lens[a1]
                                          ir = ir + "  " + res + " = getelementptr inbounds [" + slen + " x i8], [" + slen + " x i8]* " + slbl + ", i32 0, i32 0" + nl
                                          reg_types[res] = "string"
                                          block_terminated = false
                                    }"""

new_const_str = """                                    opcode == "CONST_STR" ==> {
                                          mut as string: slbl = str_map[a1]
                                          mut as int64: slen = str_lens[a1]
                                          ir = ir + "  " + res + " = getelementptr inbounds [" + slen + " x i8], [" + slen + " x i8]* " + slbl + ", i32 0, i32 0" + nl
                                          reg_types[res] = "string"
                                          reg_str_vals[res] = a1
                                          block_terminated = false
                                    }"""

assert old_const_str in c, 'CONST_STR target not found'
c = c.replace(old_const_str, new_const_str, 1)

# 3. In GET_INDEX, resolve key_str
old_gi_part = """                                          mut as bool: is_map_key = false
                                          mut as string: kptr = a2
                                          route {
                                                stdMapContainsKey(str_map, a2) ==> {
                                                      is_map_key = true
                                                      mut as string: slbl = str_map[a2]
                                                      mut as int64: slen = str_lens[a2]
                                                      ir = ir + "  %gi_k_" + gf_count + " = getelementptr inbounds [" + slen + " x i8], [" + slen + " x i8]* " + slbl + ", i32 0, i32 0" + nl
                                                      kptr = "%gi_k_" + gf_count
                                                }
                                                _ ==> {
                                                      mut as string: a2_t = "int"
                                                      route { stdMapContainsKey(reg_types, a2) ==> { a2_t = reg_types[a2] } _ ==> {} }
                                                      route {
                                                            a2_t == "string" ==> {
                                                                  is_map_key = true
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                          }
                                          route {
                                                ct == "string" ==> {
                                                      ir = ir + "  " + res + " = call i8* @flux_str_slice(i8* " + col_p + ", i64 " + a2 + ", i64 " + a2 + ")" + nl
                                                      reg_types[res] = "string"
                                                }
                                                is_map_key or ct == "map" or ct == "struct" ==> {
                                                      ir = ir + "  %" + cr + "_raw = call i64 @flux_hashmap_get_val(i8* " + col_p + ", i8* " + kptr + ")" + nl
                                                      route {
                                                            a2 == "success" or a2 == "ok" ==> {
                                                                  ir = ir + "  " + res + " = icmp ne i64 %" + cr + "_raw, 0" + nl
                                                                  reg_types[res] = "bool"
                                                            }
                                                            a2 == "root_id" or a2 == "count" or a2 == "line" or a2 == "col" ==> {
                                                                  ir = ir + "  " + res + " = add i64 0, %" + cr + "_raw" + nl
                                                                  reg_types[res] = "int"
                                                            }
                                                            a2 == "error" or a2 == "message" or a2 == "target" or a2 == "name" or a2 == "val" or a2 == "file_path" or a2 == "ir_file" ==> {
                                                                  ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                                  reg_types[res] = "string"
                                                            }
                                                            _ ==> {
                                                                  ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                                  reg_types[res] = "map"
                                                            }
                                                      }
                                                }"""

new_gi_part = """                                          mut as bool: is_map_key = false
                                          mut as string: kptr = a2
                                          mut as string: key_str = a2
                                          route {
                                                stdMapContainsKey(reg_str_vals, a2) ==> {
                                                      key_str = reg_str_vals[a2]
                                                      is_map_key = true
                                                }
                                                stdMapContainsKey(str_map, a2) ==> {
                                                      is_map_key = true
                                                      mut as string: slbl = str_map[a2]
                                                      mut as int64: slen = str_lens[a2]
                                                      ir = ir + "  %gi_k_" + gf_count + " = getelementptr inbounds [" + slen + " x i8], [" + slen + " x i8]* " + slbl + ", i32 0, i32 0" + nl
                                                      kptr = "%gi_k_" + gf_count
                                                }
                                                _ ==> {
                                                      mut as string: a2_t = "int"
                                                      route { stdMapContainsKey(reg_types, a2) ==> { a2_t = reg_types[a2] } _ ==> {} }
                                                      route {
                                                            a2_t == "string" ==> {
                                                                  is_map_key = true
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                          }
                                          route {
                                                ct == "string" ==> {
                                                      ir = ir + "  " + res + " = call i8* @flux_str_slice(i8* " + col_p + ", i64 " + a2 + ", i64 " + a2 + ")" + nl
                                                      reg_types[res] = "string"
                                                }
                                                is_map_key or ct == "map" or ct == "struct" ==> {
                                                      ir = ir + "  %" + cr + "_raw = call i64 @flux_hashmap_get_val(i8* " + col_p + ", i8* " + kptr + ")" + nl
                                                      route {
                                                            key_str == "success" or key_str == "ok" ==> {
                                                                  ir = ir + "  " + res + " = icmp ne i64 %" + cr + "_raw, 0" + nl
                                                                  reg_types[res] = "bool"
                                                            }
                                                            key_str == "root_id" or key_str == "count" or key_str == "line" or key_str == "col" ==> {
                                                                  ir = ir + "  " + res + " = add i64 0, %" + cr + "_raw" + nl
                                                                  reg_types[res] = "int"
                                                            }
                                                            key_str == "error" or key_str == "message" or key_str == "target" or key_str == "name" or key_str == "val" or key_str == "file_path" or key_str == "ir_file" ==> {
                                                                  ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                                  reg_types[res] = "string"
                                                            }
                                                            _ ==> {
                                                                  ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                                  reg_types[res] = "map"
                                                            }
                                                      }
                                                }"""

assert old_gi_part in c, 'old_gi_part target not found'
c = c.replace(old_gi_part, new_gi_part, 1)

# 4. SemanticAnalyze and FmirBuildFromAst call argument coercion
old_sem_fmir = """                                                a1 == "CompilerLib::semanticAnalyze" ==> {
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_semanticAnalyze(i8* " + call_arg1 + ", i64 " + call_arg2 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "map"
                                                }
                                                a1 == "CompilerLib::fmirBuildFromAst" ==> {
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_fmirBuildFromAst(i8* " + call_arg1 + ", i64 " + call_arg2 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "map"
                                                }
                                                a1 == "CompilerLib::fmirDumpText" ==> {
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_fmirDumpText(i8* " + call_arg1 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "string"
                                                }
                                                a1 == "CompilerLib::backendCompile" ==> {
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_backendCompile(i8* " + call_arg1 + ", i8* " + call_arg2 + ", i8* " + call_arg3 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "map"
                                                }"""

new_sem_fmir = """                                                a1 == "CompilerLib::semanticAnalyze" ==> {
                                                      mut as string: sa_a2 = call_arg2
                                                      mut as string: sa_a2_t = "int"
                                                      route { stdMapContainsKey(reg_types, call_arg2) ==> { sa_a2_t = reg_types[call_arg2] } _ ==> {} }
                                                      route {
                                                            sa_a2_t != "int" ==> {
                                                                  ir = ir + "  %" + cr + "_sa_i64 = ptrtoint i8* " + call_arg2 + " to i64" + nl
                                                                  sa_a2 = "%" + cr + "_sa_i64"
                                                            }
                                                            _ ==> {}
                                                      }
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_semanticAnalyze(i8* " + call_arg1 + ", i64 " + sa_a2 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "map"
                                                }
                                                a1 == "CompilerLib::fmirBuildFromAst" ==> {
                                                      mut as string: fb_a2 = call_arg2
                                                      mut as string: fb_a2_t = "int"
                                                      route { stdMapContainsKey(reg_types, call_arg2) ==> { fb_a2_t = reg_types[call_arg2] } _ ==> {} }
                                                      route {
                                                            fb_a2_t != "int" ==> {
                                                                  ir = ir + "  %" + cr + "_fb_i64 = ptrtoint i8* " + call_arg2 + " to i64" + nl
                                                                  fb_a2 = "%" + cr + "_fb_i64"
                                                            }
                                                            _ ==> {}
                                                      }
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_fmirBuildFromAst(i8* " + call_arg1 + ", i64 " + fb_a2 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "map"
                                                }
                                                a1 == "CompilerLib::fmirDumpText" ==> {
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_fmirDumpText(i8* " + call_arg1 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "string"
                                                }
                                                a1 == "CompilerLib::backendCompile" ==> {
                                                      mut as string: bc_a1 = call_arg1
                                                      mut as string: bc_a2 = call_arg2
                                                      mut as string: bc_a3 = call_arg3
                                                      route {
                                                            stdMapContainsKey(reg_types, call_arg1) ==> {
                                                                  route { reg_types[call_arg1] == "int" ==> {
                                                                        ir = ir + "  %" + cr + "_bca1 = inttoptr i64 " + call_arg1 + " to i8*" + nl
                                                                        bc_a1 = "%" + cr + "_bca1"
                                                                  } _ ==> {} }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            stdMapContainsKey(reg_types, call_arg2) ==> {
                                                                  route { reg_types[call_arg2] == "int" ==> {
                                                                        ir = ir + "  %" + cr + "_bca2 = inttoptr i64 " + call_arg2 + " to i8*" + nl
                                                                        bc_a2 = "%" + cr + "_bca2"
                                                                  } _ ==> {} }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            stdMapContainsKey(reg_types, call_arg3) ==> {
                                                                  route { reg_types[call_arg3] == "int" ==> {
                                                                        ir = ir + "  %" + cr + "_bca3 = inttoptr i64 " + call_arg3 + " to i8*" + nl
                                                                        bc_a3 = "%" + cr + "_bca3"
                                                                  } _ ==> {} }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_backendCompile(i8* " + bc_a1 + ", i8* " + bc_a2 + ", i8* " + bc_a3 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "map"
                                                }"""

assert old_sem_fmir in c, 'old_sem_fmir target not found'
c = c.replace(old_sem_fmir, new_sem_fmir, 1)

with open('src/CompilerLib/backends/llvm/LlvmBackend.fdsl', 'w', encoding='utf-8', newline='\r\n') as f:
    f.write(c)

print('Successfully applied stage 2 lowering improvements!')
