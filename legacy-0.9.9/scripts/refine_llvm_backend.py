with open('src/CompilerLib/backends/llvm/LlvmBackend.fdsl', 'r', encoding='utf-8') as f:
    content = f.read()

c = content.replace('\r\n', '\n')

# 1. Update BINOP_+
old_binop_plus = """                                    opcode == "BINOP_+" ==> {
                                          mut as string: t1 = "int"
                                          mut as string: t2 = "int"
                                          route { stdMapContainsKey(reg_types, a1) ==> { t1 = reg_types[a1] } _ ==> {} }
                                          route { stdMapContainsKey(reg_types, a2) ==> { t2 = reg_types[a2] } _ ==> {} }
                                          route {
                                                t1 == "string" or t2 == "string" ==> {
                                                      mut as string: op1 = a1
                                                      mut as string: op2 = a2
                                                      route {
                                                            t1 != "string" ==> {
                                                                  cv_count = cv_count + 1
                                                                  ir = ir + "  %cv_buf_" + cv_count + " = call i8* @malloc(i64 32)" + nl
                                                                  ir = ir + "  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_" + cv_count + ", i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 " + a1 + ")" + nl
                                                                  op1 = "%cv_buf_" + cv_count
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            t2 != "string" ==> {
                                                                  cv_count = cv_count + 1
                                                                  ir = ir + "  %cv_buf_" + cv_count + " = call i8* @malloc(i64 32)" + nl
                                                                  ir = ir + "  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_" + cv_count + ", i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 " + a2 + ")" + nl
                                                                  op2 = "%cv_buf_" + cv_count
                                                            }
                                                            _ ==> {}
                                                      }
                                                      ir = ir + "  " + res + " = call i8* @flux_str_concat(i8* " + op1 + ", i8* " + op2 + ")" + nl
                                                      reg_types[res] = "string"
                                                }"""

new_binop_plus = """                                    opcode == "BINOP_+" ==> {
                                          mut as string: t1 = "int"
                                          mut as string: t2 = "int"
                                          route { stdMapContainsKey(reg_types, a1) ==> { t1 = reg_types[a1] } _ ==> {} }
                                          route { stdMapContainsKey(reg_types, a2) ==> { t2 = reg_types[a2] } _ ==> {} }
                                          route {
                                                t1 == "string" or t2 == "string" ==> {
                                                      mut as string: op1 = a1
                                                      mut as string: op2 = a2
                                                      route {
                                                            t1 != "string" and t1 != "map" and t1 != "list" and t1 != "struct" ==> {
                                                                  route {
                                                                        t1 == "float" ==> {
                                                                              cv_count = cv_count + 1
                                                                              ir = ir + "  %cv_buf_" + cv_count + " = call i8* @malloc(i64 32)" + nl
                                                                              ir = ir + "  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_" + cv_count + ", i64 32, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.fmt_float_val, i32 0, i32 0), double " + a1 + ")" + nl
                                                                              op1 = "%cv_buf_" + cv_count
                                                                        }
                                                                        t1 == "bool" ==> {
                                                                              cv_count = cv_count + 1
                                                                              ir = ir + "  %cv_buf_" + cv_count + " = select i1 " + a1 + ", i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str_true, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str_false, i32 0, i32 0)" + nl
                                                                              op1 = "%cv_buf_" + cv_count
                                                                        }
                                                                        _ ==> {
                                                                              cv_count = cv_count + 1
                                                                              ir = ir + "  %cv_buf_" + cv_count + " = call i8* @malloc(i64 32)" + nl
                                                                              ir = ir + "  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_" + cv_count + ", i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 " + a1 + ")" + nl
                                                                              op1 = "%cv_buf_" + cv_count
                                                                        }
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      route {
                                                            t2 != "string" and t2 != "map" and t2 != "list" and t2 != "struct" ==> {
                                                                  route {
                                                                        t2 == "float" ==> {
                                                                              cv_count = cv_count + 1
                                                                              ir = ir + "  %cv_buf_" + cv_count + " = call i8* @malloc(i64 32)" + nl
                                                                              ir = ir + "  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_" + cv_count + ", i64 32, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.fmt_float_val, i32 0, i32 0), double " + a2 + ")" + nl
                                                                              op2 = "%cv_buf_" + cv_count
                                                                        }
                                                                        t2 == "bool" ==> {
                                                                              cv_count = cv_count + 1
                                                                              ir = ir + "  %cv_buf_" + cv_count + " = select i1 " + a2 + ", i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str_true, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str_false, i32 0, i32 0)" + nl
                                                                              op2 = "%cv_buf_" + cv_count
                                                                        }
                                                                        _ ==> {
                                                                              cv_count = cv_count + 1
                                                                              ir = ir + "  %cv_buf_" + cv_count + " = call i8* @malloc(i64 32)" + nl
                                                                              ir = ir + "  call i32 (i8*, i64, i8*, ...) @snprintf(i8* %cv_buf_" + cv_count + ", i64 32, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.fmt_int_val, i32 0, i32 0), i64 " + a2 + ")" + nl
                                                                              op2 = "%cv_buf_" + cv_count
                                                                        }
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      ir = ir + "  " + res + " = call i8* @flux_str_concat(i8* " + op1 + ", i8* " + op2 + ")" + nl
                                                      reg_types[res] = "string"
                                                }"""

assert old_binop_plus in c, 'BINOP_+ target not found'
c = c.replace(old_binop_plus, new_binop_plus, 1)

# 2. In GET_FIELD
old_gf = """                                                a2 == "root_id" or a2 == "count" or a2 == "line" or a2 == "col" ==> {
                                                      ir = ir + "  " + res + " = add i64 0, %" + cr + "_raw" + nl
                                                      reg_types[res] = "int"
                                                }
                                                _ ==> {
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                      reg_types[res] = "map"
                                                }"""

new_gf = """                                                a2 == "root_id" or a2 == "count" or a2 == "line" or a2 == "col" ==> {
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
                                                }"""
assert old_gf in c, 'GET_FIELD target not found'
c = c.replace(old_gf, new_gf, 1)

# 3. In GET_INDEX
old_gi = """                                                            a2 == "root_id" or a2 == "count" or a2 == "line" or a2 == "col" ==> {
                                                                  ir = ir + "  " + res + " = add i64 0, %" + cr + "_raw" + nl
                                                                  reg_types[res] = "int"
                                                            }
                                                            _ ==> {
                                                                  ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                                  reg_types[res] = "map"
                                                            }"""

new_gi = """                                                            a2 == "root_id" or a2 == "count" or a2 == "line" or a2 == "col" ==> {
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
                                                            }"""
assert old_gi in c, 'GET_INDEX target not found'
c = c.replace(old_gi, new_gi, 1)

with open('src/CompilerLib/backends/llvm/LlvmBackend.fdsl', 'w', encoding='utf-8', newline='\r\n') as f:
    f.write(c)

print('Successfully refined LlvmBackend.fdsl!')
