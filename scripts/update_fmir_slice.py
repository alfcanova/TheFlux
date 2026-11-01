with open('src/CompilerLib/fmir/FmirBuilder.fdsl', 'r', encoding='utf-8') as f:
    content = f.read()

c = content.replace('\r\n', '\n')

old_index_access = """                  kind == "INDEX_ACCESS" ==> {
                        mut as int64: obj_id = astArenaNodeLeft(arena, node_id)
                        mut as int64: idx_id = astArenaNodeRight(arena, node_id)
                        mut as map: o_res = fmirLowerExpr(arena, obj_id, mod, tc)
                        mod = o_res["module"]
                        tc = o_res["temp_counter"]
                        mut as map: i_res = fmirLowerExpr(arena, idx_id, mod, tc)
                        mod = i_res["module"]
                        tc = i_res["temp_counter"]
                        mut as string: idx_full = i_res["res_reg"]
                        mut as list of data: ichildren = astArenaNodeChildren(arena, node_id)
                        mut as int64: n_ichild = stdCollectionLength(ichildren)
                        route {
                              val == "MULTI" and n_ichild > 0 ==> {
                                    mut as int64: ici = 1
                                    infinite {
                                          route {
                                                ici > n_ichild ==> { break }
                                                _ ==> {
                                                      mut as map: ic_res = fmirLowerExpr(arena, ichildren[ici], mod, tc)
                                                      mod = ic_res["module"]
                                                      tc = ic_res["temp_counter"]
                                                      idx_full = idx_full + "," + ic_res["res_reg"]
                                                      ici = ici + 1
                                                }
                                          }
                                    }
                              }
                              _ ==> {}
                        }
                        tc = tc + 1
                        res_reg = "%t" + tc
                        mod = fmirAddInstruction(mod, "GET_INDEX", o_res["res_reg"], idx_full, res_reg)
                  }"""

new_index_access = """                  kind == "INDEX_ACCESS" ==> {
                        mut as int64: obj_id = astArenaNodeLeft(arena, node_id)
                        mut as int64: idx_id = astArenaNodeRight(arena, node_id)
                        mut as string: ikind = ""
                        mut as string: ival = ""
                        route {
                              idx_id > 0 ==> {
                                    ikind = astArenaNodeKind(arena, idx_id)
                                    ival = astArenaNodeValue(arena, idx_id)
                              }
                              _ ==> {}
                        }
                        route {
                              (ikind == "BINARY_EXPR" or ikind == "BIN_OP") and ival == ".." ==> {
                                    mut as int64: start_id = astArenaNodeLeft(arena, idx_id)
                                    mut as int64: end_id = astArenaNodeRight(arena, idx_id)
                                    mut as map: o_res = fmirLowerExpr(arena, obj_id, mod, tc)
                                    mod = o_res["module"]
                                    tc = o_res["temp_counter"]
                                    mut as string: start_reg = "1"
                                    route {
                                          start_id > 0 ==> {
                                                mut as map: s_res = fmirLowerExpr(arena, start_id, mod, tc)
                                                mod = s_res["module"]
                                                tc = s_res["temp_counter"]
                                                start_reg = s_res["res_reg"]
                                          }
                                          _ ==> {}
                                    }
                                    mut as string: end_reg = "1"
                                    route {
                                          end_id > 0 ==> {
                                                mut as map: en_res = fmirLowerExpr(arena, end_id, mod, tc)
                                                mod = en_res["module"]
                                                tc = en_res["temp_counter"]
                                                end_reg = en_res["res_reg"]
                                          }
                                          _ ==> {}
                                    }
                                    tc = tc + 1
                                    res_reg = "%t" + tc
                                    mod = fmirAddInstruction(mod, "GET_SLICE", o_res["res_reg"], start_reg + ":" + end_reg, res_reg)
                              }
                              _ ==> {
                                    mut as map: o_res = fmirLowerExpr(arena, obj_id, mod, tc)
                                    mod = o_res["module"]
                                    tc = o_res["temp_counter"]
                                    mut as map: i_res = fmirLowerExpr(arena, idx_id, mod, tc)
                                    mod = i_res["module"]
                                    tc = i_res["temp_counter"]
                                    mut as string: idx_full = i_res["res_reg"]
                                    mut as list of data: ichildren = astArenaNodeChildren(arena, node_id)
                                    mut as int64: n_ichild = stdCollectionLength(ichildren)
                                    route {
                                          val == "MULTI" and n_ichild > 0 ==> {
                                                mut as int64: ici = 1
                                                infinite {
                                                      route {
                                                            ici > n_ichild ==> { break }
                                                            _ ==> {
                                                                  mut as map: ic_res = fmirLowerExpr(arena, ichildren[ici], mod, tc)
                                                                  mod = ic_res["module"]
                                                                  tc = ic_res["temp_counter"]
                                                                  idx_full = idx_full + "," + ic_res["res_reg"]
                                                                  ici = ici + 1
                                                            }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    tc = tc + 1
                                    res_reg = "%t" + tc
                                    mod = fmirAddInstruction(mod, "GET_INDEX", o_res["res_reg"], idx_full, res_reg)
                              }
                        }
                  }"""

assert old_index_access in c, 'old_index_access target not found'
c = c.replace(old_index_access, new_index_access, 1)

with open('src/CompilerLib/fmir/FmirBuilder.fdsl', 'w', encoding='utf-8', newline='\r\n') as f:
    f.write(c)

print('Successfully updated FmirBuilder.fdsl with slice in INDEX_ACCESS!')
