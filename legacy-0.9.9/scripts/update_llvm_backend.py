# Update LlvmBackend.fdsl with enhanced FDSL lowering
with open('src/CompilerLib/backends/llvm/LlvmBackend.fdsl', 'r', encoding='utf-8') as f:
    content = f.read()

# Normalize to \n first for consistent matching
c = content.replace('\r\n', '\n')

# 1. Header declarations
old_hdr = """            ir = ir + "target triple = \\"x86_64-pc-windows-msvc\\"" + nl + nl

            ir = ir + "declare void @flux_runtime_init_args(i32, i8**)" + nl"""

new_hdr = """            ir = ir + "target triple = \\"x86_64-pc-windows-msvc\\"" + nl + nl

            ir = ir + "%flux.result = type { i8*, i64, double, i8* }" + nl + nl
            ir = ir + "declare %flux.result @f_diagnosticExplain(i8*)" + nl
            ir = ir + "declare %flux.result @f_diagnosticGetHeader(i8*, i8*)" + nl
            ir = ir + "declare %flux.result @f_diagnosticGetHint(i8*)" + nl
            ir = ir + "declare %flux.result @f_parseFile(i8*)" + nl
            ir = ir + "declare %flux.result @f_parseDumpAst(i8*)" + nl
            ir = ir + "declare %flux.result @f_semanticAnalyze(i8*, i64)" + nl
            ir = ir + "declare %flux.result @f_fmirBuildFromAst(i8*, i64)" + nl
            ir = ir + "declare %flux.result @f_fmirDumpText(i8*)" + nl
            ir = ir + "declare %flux.result @f_backendCompile(i8*, i8*, i8*)" + nl + nl

            ir = ir + "declare void @flux_runtime_init_args(i32, i8**)" + nl"""

assert old_hdr in c, 'Header target not found'
c = c.replace(old_hdr, new_hdr, 1)

# 2. Additional runtime declarations
old_decl = """            ir = ir + "declare void @flux_list_push(i8*, i64)" + nl"""
new_decl = """            ir = ir + "declare void @flux_list_push(i8*, i64)" + nl
            ir = ir + "declare void @flux_list_push_val(i8*, i64)" + nl
            ir = ir + "declare i64 @flux_list_get_val(i8*, i64)" + nl"""
assert old_decl in c, 'Decl list target not found'
c = c.replace(old_decl, new_decl, 1)

old_mdecl = """            ir = ir + "declare void @flux_hashmap_set(i8*, i8*, i64)" + nl"""
new_mdecl = """            ir = ir + "declare i64 @flux_map_len(i8*)" + nl
            ir = ir + "declare void @flux_hashmap_set(i8*, i8*, i64)" + nl
            ir = ir + "declare void @flux_hashmap_set_val(i8*, i8*, i64)" + nl
            ir = ir + "declare i64 @flux_hashmap_get_val(i8*, i8*)" + nl"""
assert old_mdecl in c, 'Decl map target not found'
c = c.replace(old_mdecl, new_mdecl, 1)

# 3. UNARY_not
old_unot = """                                    opcode == "UNARY_not" or opcode == "UNARY_!" ==> {
                                          ir = ir + "  " + res + " = xor i1 " + a1 + ", 1" + nl
                                          reg_types[res] = "bool"
                                          block_terminated = false
                                    }"""

new_unot = """                                    opcode == "UNARY_not" or opcode == "UNARY_!" ==> {
                                          mut as string: a1_t = "bool"
                                          route { stdMapContainsKey(reg_types, a1) ==> { a1_t = reg_types[a1] } _ ==> {} }
                                          route {
                                                a1_t == "int" ==> {
                                                      ir = ir + "  " + res + " = icmp eq i64 " + a1 + ", 0" + nl
                                                }
                                                a1_t == "string" or a1_t == "map" or a1_t == "list" or a1_t == "struct" ==> {
                                                      ir = ir + "  " + res + " = icmp eq i8* " + a1 + ", null" + nl
                                                }
                                                _ ==> {
                                                      ir = ir + "  " + res + " = xor i1 " + a1 + ", 1" + nl
                                                }
                                          }
                                          reg_types[res] = "bool"
                                          block_terminated = false
                                    }"""
assert old_unot in c, 'UNARY_not target not found'
c = c.replace(old_unot, new_unot, 1)

# 4. LIST_PUSH
old_lpush = """                                          ir = ir + "  call void @flux_list_push(i8* " + a1 + ", i64 " + pval + ")" + nl"""
new_lpush = """                                          ir = ir + "  call void @flux_list_push_val(i8* " + a1 + ", i64 " + pval + ")" + nl"""
assert old_lpush in c, 'LIST_PUSH target not found'
c = c.replace(old_lpush, new_lpush, 1)

# 5. MAP_SET
old_mset = """                                          ir = ir + "  call void @flux_hashmap_set(i8* " + a1 + ", i8* " + kptr + ", i64 " + val_i64 + ")" + nl"""
new_mset = """                                          ir = ir + "  call void @flux_hashmap_set_val(i8* " + a1 + ", i8* " + kptr + ", i64 " + val_i64 + ")" + nl"""
assert old_mset in c, 'MAP_SET target not found'
c = c.replace(old_mset, new_mset, 1)

# 6. GET_FIELD and GET_INDEX
old_gfield_gindex = """                                    opcode == "GET_FIELD" ==> {
                                          gf_count = gf_count + 1
                                          mut as string: kptr = a2
                                          route {
                                                stdMapContainsKey(str_map, a2) ==> {
                                                      mut as string: slbl = str_map[a2]
                                                      mut as int64: slen = str_lens[a2]
                                                      ir = ir + "  %gf_fld_" + gf_count + " = getelementptr inbounds [" + slen + " x i8], [" + slen + " x i8]* " + slbl + ", i32 0, i32 0" + nl
                                                      kptr = "%gf_fld_" + gf_count
                                                }
                                                _ ==> {}
                                          }
                                          ir = ir + "  %" + cr + "_raw = call i64 @flux_hashmap_get(i8* " + a1 + ", i8* " + kptr + ", i64* null)" + nl
                                          ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                          reg_types[res] = "string"
                                          block_terminated = false
                                    }
                                    opcode == "GET_INDEX" ==> {
                                          mut as string: ct = "list"
                                          route { stdMapContainsKey(reg_types, a1) ==> { ct = reg_types[a1] } _ ==> {} }
                                          route {
                                                ct == "map" or ct == "struct" ==> {
                                                      ir = ir + "  %" + cr + "_raw = call i64 @flux_hashmap_get(i8* " + a1 + ", i8* " + a2 + ", i64* null)" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                      reg_types[res] = "string"
                                                }
                                                ct == "string" ==> {
                                                      ir = ir + "  " + res + " = call i8* @flux_str_slice(i8* " + a1 + ", i64 " + a2 + ", i64 " + a2 + ")" + nl
                                                      reg_types[res] = "string"
                                                }
                                                _ ==> {
                                                      ir = ir + "  %" + cr + "_raw = call i64 @flux_list_get(i8* " + a1 + ", i64 " + a2 + ")" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                      reg_types[res] = "string"
                                                }
                                          }
                                          block_terminated = false
                                    }"""

new_gfield_gindex = """                                    opcode == "GET_FIELD" ==> {
                                          gf_count = gf_count + 1
                                          mut as string: col_p = a1
                                          mut as string: ct1 = "map"
                                          route { stdMapContainsKey(reg_types, a1) ==> { ct1 = reg_types[a1] } _ ==> {} }
                                          route {
                                                ct1 == "int" or ct1 == "bool" ==> {
                                                      ir = ir + "  %gf_cp_" + gf_count + " = inttoptr i64 " + a1 + " to i8*" + nl
                                                      col_p = "%gf_cp_" + gf_count
                                                }
                                                _ ==> {}
                                          }
                                          mut as string: kptr = a2
                                          route {
                                                stdMapContainsKey(str_map, a2) ==> {
                                                      mut as string: slbl = str_map[a2]
                                                      mut as int64: slen = str_lens[a2]
                                                      ir = ir + "  %gf_fld_" + gf_count + " = getelementptr inbounds [" + slen + " x i8], [" + slen + " x i8]* " + slbl + ", i32 0, i32 0" + nl
                                                      kptr = "%gf_fld_" + gf_count
                                                }
                                                _ ==> {}
                                          }
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
                                                _ ==> {
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                      reg_types[res] = "map"
                                                }
                                          }
                                          block_terminated = false
                                    }
                                    opcode == "GET_INDEX" ==> {
                                          gf_count = gf_count + 1
                                          mut as string: ct = "list"
                                          route { stdMapContainsKey(reg_types, a1) ==> { ct = reg_types[a1] } _ ==> {} }
                                          mut as string: col_p = a1
                                          route {
                                                ct == "int" or ct == "bool" ==> {
                                                      ir = ir + "  %gi_cp_" + gf_count + " = inttoptr i64 " + a1 + " to i8*" + nl
                                                      col_p = "%gi_cp_" + gf_count
                                                }
                                                _ ==> {}
                                          }
                                          mut as bool: is_map_key = false
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
                                                            _ ==> {
                                                                  ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                                  reg_types[res] = "map"
                                                            }
                                                      }
                                                }
                                                _ ==> {
                                                      ir = ir + "  %" + cr + "_raw = call i64 @flux_list_get_val(i8* " + col_p + ", i64 " + a2 + ")" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                      reg_types[res] = "string"
                                                }
                                          }
                                          block_terminated = false
                                    }"""
assert old_gfield_gindex in c, 'GET_FIELD/GET_INDEX target not found'
c = c.replace(old_gfield_gindex, new_gfield_gindex, 1)

# 7. COLL_LEN
old_clen = """                                    opcode == "COLL_LEN" ==> {
                                          mut as string: ct = "list"
                                          route { stdMapContainsKey(reg_types, a1) ==> { ct = reg_types[a1] } _ ==> {} }
                                          route {
                                                ct == "string" ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_str_len(i8* " + a1 + ")" + nl
                                                }
                                                _ ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_list_len(i8* " + a1 + ")" + nl
                                                }
                                          }
                                          reg_types[res] = "int"
                                          block_terminated = false
                                    }"""

new_clen = """                                    opcode == "COLL_LEN" ==> {
                                          mut as string: ct = "list"
                                          route { stdMapContainsKey(reg_types, a1) ==> { ct = reg_types[a1] } _ ==> {} }
                                          route {
                                                ct == "string" ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_str_len(i8* " + a1 + ")" + nl
                                                }
                                                ct == "map" or ct == "struct" ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_map_len(i8* " + a1 + ")" + nl
                                                }
                                                _ ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_list_len(i8* " + a1 + ")" + nl
                                                }
                                          }
                                          reg_types[res] = "int"
                                          block_terminated = false
                                    }"""
assert old_clen in c, 'COLL_LEN target not found'
c = c.replace(old_clen, new_clen, 1)

# 8. CALL
old_call = """                                    opcode == "CALL" ==> {
                                          mut as int64: a2_cpos = 0
                                          mut as int64: a2_len = stdCollectionLength(a2)
                                          mut as int64: a2_k = 1
                                          infinite {
                                                route {
                                                      a2_k > a2_len ==> { break }
                                                      a2[a2_k] == "," ==> {
                                                            a2_cpos = a2_k
                                                            break
                                                      }
                                                      _ ==> { a2_k = a2_k + 1 }
                                                }
                                          }
                                          mut as string: call_arg1 = a2
                                          mut as string: call_arg2 = ""
                                          route {
                                                a2_cpos > 0 ==> {
                                                      call_arg1 = a2[1..(a2_cpos - 1)]
                                                      call_arg2 = a2[(a2_cpos + 1)..a2_len]
                                                }
                                                _ ==> {}
                                          }
                                          route {
                                                a1 == "stdIoFileExists" ==> {
                                                      ir = ir + "  %" + cr + "_i64 = call i64 @flux_std_io_file_exists(i8* " + call_arg1 + ")" + nl
                                                      ir = ir + "  " + res + " = trunc i64 %" + cr + "_i64 to i1" + nl
                                                      reg_types[res] = "bool"
                                                }
                                                a1 == "stdIoReadFile" ==> {
                                                      ir = ir + "  " + res + " = call i8* @flux_std_io_read_file(i8* " + call_arg1 + ")" + nl
                                                      reg_types[res] = "string"
                                                }
                                                a1 == "stdIoWriteFile" ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_std_io_write_file(i8* " + call_arg1 + ", i8* " + call_arg2 + ")" + nl
                                                      reg_types[res] = "int"
                                                }
                                                a1 == "stdCollectionLength" or a1 == "stdStringByteLength" ==> {
                                                      mut as string: arg1_t = "string"
                                                      route { stdMapContainsKey(reg_types, call_arg1) ==> { arg1_t = reg_types[call_arg1] } _ ==> {} }
                                                      route {
                                                            arg1_t == "list" or arg1_t == "map" or arg1_t == "struct" ==> {
                                                                  ir = ir + "  " + res + " = call i64 @flux_list_len(i8* " + call_arg1 + ")" + nl
                                                            }
                                                            _ ==> {
                                                                  ir = ir + "  " + res + " = call i64 @flux_str_len(i8* " + call_arg1 + ")" + nl
                                                            }
                                                      }
                                                      reg_types[res] = "int"
                                                }
                                                a1 == "stdOsExec" ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_std_os_exec(i8* " + call_arg1 + ")" + nl
                                                      reg_types[res] = "int"
                                                }
                                                a1 == "stdOsExit" ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_std_os_exit(i64 " + call_arg1 + ")" + nl
                                                      reg_types[res] = "int"
                                                }
                                                a1 == "stdRuntimeGetArgs" ==> {
                                                      ir = ir + "  " + res + " = call i8* @flux_std_runtime_get_args(i8* null, i8* null)" + nl
                                                      reg_types[res] = "list"
                                                }
                                                _ ==> {
                                                      ir = ir + "  " + res + " = add i64 0, 0" + nl
                                                      reg_types[res] = "int"
                                                }
                                          }
                                          block_terminated = false
                                    }"""

new_call = """                                    opcode == "CALL" ==> {
                                          mut as list of data: cargs = []
                                          mut as int64: a2_len = stdCollectionLength(a2)
                                          mut as int64: lp = 1
                                          mut as int64: a2_k = 1
                                          route {
                                                a2_len > 0 ==> {
                                                      infinite {
                                                            route {
                                                                  a2_k > a2_len ==> {
                                                                        route {
                                                                              lp <= a2_len ==> {
                                                                                    cargs = stdListPushBack(cargs, a2[lp..a2_len])
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                        break
                                                                  }
                                                                  a2[a2_k] == "," ==> {
                                                                        route {
                                                                              a2_k > lp ==> {
                                                                                    cargs = stdListPushBack(cargs, a2[lp..(a2_k - 1)])
                                                                              }
                                                                              _ ==> {
                                                                                    cargs = stdListPushBack(cargs, "")
                                                                              }
                                                                        }
                                                                        lp = a2_k + 1
                                                                        a2_k = a2_k + 1
                                                                  }
                                                                  _ ==> { a2_k = a2_k + 1 }
                                                            }
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          mut as int64: ncargs = stdCollectionLength(cargs)
                                          mut as string: call_arg1 = ""
                                          mut as string: call_arg2 = ""
                                          mut as string: call_arg3 = ""
                                          route { ncargs >= 1 ==> { call_arg1 = "" + cargs[1] } _ ==> {} }
                                          route { ncargs >= 2 ==> { call_arg2 = "" + cargs[2] } _ ==> {} }
                                          route { ncargs >= 3 ==> { call_arg3 = "" + cargs[3] } _ ==> {} }
                                          route {
                                                a1 == "CompilerLib::diagnosticExplain" ==> {
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_diagnosticExplain(i8* " + call_arg1 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "string"
                                                }
                                                a1 == "CompilerLib::diagnosticGetHeader" ==> {
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_diagnosticGetHeader(i8* " + call_arg1 + ", i8* " + call_arg2 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "string"
                                                }
                                                a1 == "CompilerLib::diagnosticGetHint" ==> {
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_diagnosticGetHint(i8* " + call_arg1 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "string"
                                                }
                                                a1 == "CompilerLib::parseFile" ==> {
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_parseFile(i8* " + call_arg1 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "map"
                                                }
                                                a1 == "CompilerLib::parseDumpAst" ==> {
                                                      ir = ir + "  %" + cr + "_res = call %flux.result @f_parseDumpAst(i8* " + call_arg1 + ")" + nl
                                                      ir = ir + "  %" + cr + "_val = extractvalue %flux.result %" + cr + "_res, 1" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_val to i8*" + nl
                                                      reg_types[res] = "string"
                                                }
                                                a1 == "CompilerLib::semanticAnalyze" ==> {
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
                                                }
                                                a1 == "stdIoFileExists" ==> {
                                                      ir = ir + "  %" + cr + "_i64 = call i64 @flux_std_io_file_exists(i8* " + call_arg1 + ")" + nl
                                                      ir = ir + "  " + res + " = trunc i64 %" + cr + "_i64 to i1" + nl
                                                      reg_types[res] = "bool"
                                                }
                                                a1 == "stdIoReadFile" ==> {
                                                      ir = ir + "  " + res + " = call i8* @flux_std_io_read_file(i8* " + call_arg1 + ")" + nl
                                                      reg_types[res] = "string"
                                                }
                                                a1 == "stdIoWriteFile" ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_std_io_write_file(i8* " + call_arg1 + ", i8* " + call_arg2 + ")" + nl
                                                      reg_types[res] = "int"
                                                }
                                                a1 == "stdCollectionLength" or a1 == "stdStringByteLength" ==> {
                                                      mut as string: arg1_t = "string"
                                                      route { stdMapContainsKey(reg_types, call_arg1) ==> { arg1_t = reg_types[call_arg1] } _ ==> {} }
                                                      route {
                                                            arg1_t == "map" or arg1_t == "struct" ==> {
                                                                  ir = ir + "  " + res + " = call i64 @flux_map_len(i8* " + call_arg1 + ")" + nl
                                                            }
                                                            arg1_t == "list" ==> {
                                                                  ir = ir + "  " + res + " = call i64 @flux_list_len(i8* " + call_arg1 + ")" + nl
                                                            }
                                                            _ ==> {
                                                                  ir = ir + "  " + res + " = call i64 @flux_str_len(i8* " + call_arg1 + ")" + nl
                                                            }
                                                      }
                                                      reg_types[res] = "int"
                                                }
                                                a1 == "stdOsExec" ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_std_os_exec(i8* " + call_arg1 + ")" + nl
                                                      reg_types[res] = "int"
                                                }
                                                a1 == "stdOsExit" ==> {
                                                      ir = ir + "  " + res + " = call i64 @flux_std_os_exit(i64 " + call_arg1 + ")" + nl
                                                      reg_types[res] = "int"
                                                }
                                                a1 == "stdRuntimeGetArgs" ==> {
                                                      ir = ir + "  " + res + " = call i8* @flux_std_runtime_get_args(i8* null, i8* null)" + nl
                                                      reg_types[res] = "list"
                                                }
                                                _ ==> {
                                                      ir = ir + "  " + res + " = add i64 0, 0" + nl
                                                      reg_types[res] = "int"
                                                }
                                          }
                                          block_terminated = false
                                    }"""
assert old_call in c, 'CALL target not found'
c = c.replace(old_call, new_call, 1)

# Write back with CRLF
with open('src/CompilerLib/backends/llvm/LlvmBackend.fdsl', 'w', encoding='utf-8', newline='\r\n') as f:
    f.write(c)

print('Successfully updated LlvmBackend.fdsl with all enhancements!')
