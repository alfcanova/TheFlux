with open('src/CompilerLib/backends/llvm/LlvmBackend.fdsl', 'r', encoding='utf-8') as f:
    content = f.read()

c = content.replace('\r\n', '\n')

old_route = """                                          route {
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
                                                }
                                                _ ==> {
                                                      ir = ir + "  %" + cr + "_raw = call i64 @flux_list_get_val(i8* " + col_p + ", i64 " + a2 + ")" + nl
                                                      ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                      reg_types[res] = "string"
                                                }
                                          }"""

new_route = """                                          route {
                                                ct == "string" ==> {
                                                      ir = ir + "  " + res + " = call i8* @flux_str_slice(i8* " + col_p + ", i64 " + a2 + ", i64 " + a2 + ")" + nl
                                                      reg_types[res] = "string"
                                                }
                                                is_map_key ==> {
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
                                                            key_str == "errors" or key_str == "args" or key_str == "decl_nodes" or key_str == "node_ids" ==> {
                                                                  ir = ir + "  " + res + " = inttoptr i64 %" + cr + "_raw to i8*" + nl
                                                                  reg_types[res] = "list"
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
                                          }"""

assert old_route in c, 'old_route target not found'
c = c.replace(old_route, new_route, 1)

with open('src/CompilerLib/backends/llvm/LlvmBackend.fdsl', 'w', encoding='utf-8', newline='\r\n') as f:
    f.write(c)

print('Successfully fixed list vs map indexing in LlvmBackend.fdsl!')
