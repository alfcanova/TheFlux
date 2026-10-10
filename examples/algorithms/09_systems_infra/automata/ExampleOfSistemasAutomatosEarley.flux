#L ============================================================================
#L Algoritmo: Earley Parser (Algoritmo Dinamico com Estados Pontilhados)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(n^3) no caso geral | O(n) para gramaticas deterministicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosEarley) {
      println("==================================================")
      println("  SciAlgo: Earley Parsing Algorithm               ")
      println("==================================================")

      #L Gramatica Livre de Contexto para Expressoes:
      #L Simbolos:
      #L Nao-terminais: 1 = Gamma (start S'), 2 = E, 3 = T
      #L Terminais: 101 = 'id', 102 = '+'
      #L
      #L Regras:
      #L Regra 1: S' -> E       (LHS: 1, RHS: [2], len: 1)
      #L Regra 2: E  -> E + T   (LHS: 2, RHS: [2, 102, 3], len: 3)
      #L Regra 3: E  -> T       (LHS: 2, RHS: [3], len: 1)
      #L Regra 4: T  -> id      (LHS: 3, RHS: [101], len: 1)

      mut as int64: num_rules = 4
      mut as list of int64: rule_lhs = [1, 2, 2, 3]
      mut as list of int64: rule_len = [1, 3, 1, 1]
      mut as list of int64: rule_rhs = [
            2, 0, 0,    #L Regra 1: [E]
            2, 102, 3,  #L Regra 2: [E, '+', T]
            3, 0, 0,    #L Regra 3: [T]
            101, 0, 0   #L Regra 4: ['id']
      ]

      println("1. Gramatica CFG:")
      println("   S' -> E")
      println("   E  -> E + T | T")
      println("   T  -> id")

      #L Entrada a ser analisada: "id + id"
      #L Tokens: [101, 102, 101] (n = 3)
      mut as int64: n = 3
      mut as list of int64: tokens = [101, 102, 101]

      println("2. Entrada de Tokens: ['id', '+', 'id'] (n = 3)")

      #L Itens de Earley representados como quadrupla linearizada:
      #L (rule_id, dot_pos, origin_pos, chart_idx)
      #L Maximo de itens: 50
      mut as int64: max_items = 50
      mut as list of int64: item_rule = [
            1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as list of int64: item_dot = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as list of int64: item_origin = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as list of int64: item_chart = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: item_count = 1 #L Item 1: (S' -> . E, origin=0, chart=0)

      println("3. Executando Operacoes do Earley Parser (Predict, Scan, Complete)...")

      #L Itera sobre charts k = 0..n
      mut as int64: k = 0
      infinite (k <= n) {
            mut as int64: it = 1
            infinite (it <= item_count) {
                  route {
                        item_chart[it] == k ==> {
                              mut as int64: r = item_rule[it]
                              mut as int64: dot = item_dot[it]
                              mut as int64: orig = item_origin[it]
                              mut as int64: r_len = rule_len[r]

                              route {
                                    dot < r_len ==> {
                                          mut as int64: next_sym = rule_rhs[(r - 1) * 3 + (dot + 1)]

                                          #L Caso 1: Nao-terminal (Predictor)
                                          route {
                                                next_sym <= 10 ==> {
                                                      mut as int64: cand_r = 1
                                                      infinite (cand_r <= num_rules) {
                                                            route {
                                                                  rule_lhs[cand_r] == next_sym ==> {
                                                                        mut as bool: exists = false
                                                                        mut as int64: chk = 1
                                                                        infinite (chk <= item_count) {
                                                                              route {
                                                                                    item_chart[chk] == k and item_rule[chk] == cand_r and item_dot[chk] == 0 and item_origin[chk] == k ==> {
                                                                                          exists = true
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                              chk = chk + 1
                                                                        }
                                                                        route {
                                                                              (not exists) and item_count < max_items ==> {
                                                                                    item_count = item_count + 1
                                                                                    item_rule[item_count] = cand_r
                                                                                    item_dot[item_count] = 0
                                                                                    item_origin[item_count] = k
                                                                                    item_chart[item_count] = k
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                            cand_r = cand_r + 1
                                                      }
                                                }
                                                _ ==> {
                                                      #L Caso 2: Terminal (Scanner com guarda isolada)
                                                      route {
                                                            k < n ==> {
                                                                  route {
                                                                        next_sym == tokens[k + 1] ==> {
                                                                              route {
                                                                                    item_count < max_items ==> {
                                                                                          item_count = item_count + 1
                                                                                          item_rule[item_count] = r
                                                                                          item_dot[item_count] = dot + 1
                                                                                          item_origin[item_count] = orig
                                                                                          item_chart[item_count] = k + 1
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                          }
                                    }
                                    _ ==> {
                                          #L Caso 3: Ponto no final da regra (Completer)
                                          mut as int64: completed_var = rule_lhs[r]
                                          mut as int64: prev_it = 1
                                          infinite (prev_it <= item_count) {
                                                route {
                                                      item_chart[prev_it] == orig ==> {
                                                            mut as int64: pr_r = item_rule[prev_it]
                                                            mut as int64: pr_dot = item_dot[prev_it]
                                                            mut as int64: pr_orig = item_origin[prev_it]
                                                            mut as int64: pr_len = rule_len[pr_r]

                                                            route {
                                                                  pr_dot < pr_len ==> {
                                                                        mut as int64: sym_after = rule_rhs[(pr_r - 1) * 3 + (pr_dot + 1)]
                                                                        route {
                                                                              sym_after == completed_var ==> {
                                                                                    mut as bool: dup = false
                                                                                    mut as int64: d_chk = 1
                                                                                    infinite (d_chk <= item_count) {
                                                                                          route {
                                                                                                item_chart[d_chk] == k and item_rule[d_chk] == pr_r and item_dot[d_chk] == pr_dot + 1 and item_origin[d_chk] == pr_orig ==> {
                                                                                                      dup = true
                                                                                                }
                                                                                                _ ==> {}
                                                                                          }
                                                                                          d_chk = d_chk + 1
                                                                                    }
                                                                                    route {
                                                                                          (not dup) and item_count < max_items ==> {
                                                                                                item_count = item_count + 1
                                                                                                item_rule[item_count] = pr_r
                                                                                                item_dot[item_count] = pr_dot + 1
                                                                                                item_origin[item_count] = pr_orig
                                                                                                item_chart[item_count] = k
                                                                                          }
                                                                                          _ ==> {}
                                                                                    }
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                                prev_it = prev_it + 1
                                          }
                                    }
                              }
                        }
                        _ ==> {}
                  }
                  it = it + 1
            }
            k = k + 1
      }

      println("4. Resumo de Itens Earley por Conjunto S_k:")
      k = 0
      infinite (k <= n) {
            mut as int64: count_k = 0
            mut as int64: idx = 1
            infinite (idx <= item_count) {
                  route { item_chart[idx] == k ==> { count_k = count_k + 1 } _ ==> {} }
                  idx = idx + 1
            }
            println("   Conjunto S_" + k + ": " + count_k + " itens pontilhados gerados")
            k = k + 1
      }

      mut as bool: parsed_success = false
      mut as int64: check_final = 1
      infinite (check_final <= item_count) {
            route {
                  item_chart[check_final] == n and item_rule[check_final] == 1 and item_dot[check_final] == 1 and item_origin[check_final] == 0 ==> {
                        parsed_success = true
                  }
                  _ ==> {}
            }
            check_final = check_final + 1
      }

      println("5. Verificacao Final do Earley Parser:")
      println("   Expressao 'id + id' reconhecida com sucesso = " + parsed_success)

      println("Earley Parser concluido com sucesso.")
}
