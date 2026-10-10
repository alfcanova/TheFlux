#L ============================================================================
#L Algoritmo: Hopcroft DFA Minimization (Particionamento O(k * n log n))
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(|Sigma| * |Q| log |Q|) tempo | O(|Q|) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosHopcroftDFAMinimization) {
      println("==================================================")
      println("  SciAlgo: Hopcroft DFA Minimization Algorithm    ")
      println("==================================================")

      mut as int64: num_states = 6
      mut as int64: num_symbols = 2

      #L Transicoes: delta[(s - 1) * 2 + sym]
      #L 1: a -> 2, b -> 3
      #L 2: a -> 1, b -> 4
      #L 3: a -> 5, b -> 6
      #L 4: a -> 5, b -> 6
      #L 5 (final): a -> 5, b -> 5
      #L 6 (final): a -> 5, b -> 5
      mut as list of int64: delta = [
            2, 3, #L 1
            1, 4, #L 2
            5, 6, #L 3
            5, 6, #L 4
            5, 5, #L 5 (final)
            5, 5  #L 6 (final)
      ]

      mut as list of bool: is_accept = [
            false, false, false, false, true, true
      ]

      println("1. DFA de Entrada para Hopcroft:")
      println("   Estados: 1..6 | Finais: {5, 6}")

      #L Vetor de bloco para cada estado (1..num_states)
      #L Inicialmente: Bloco 1 = Finais {5, 6}, Bloco 2 = Nao-finais {1, 2, 3, 4}
      mut as list of int64: block_id = [2, 2, 2, 2, 1, 1]
      mut as int64: num_blocks = 2

      #L Fila de refinamento (worklist W) de IDs de blocos
      #L Representamos W como lista booleana in_w de tamanho maximo 10
      mut as list of bool: in_w = [
            false, true, false, false, false, false, false, false, false, false
      ] #L indice = block_id (bloco 1 adicionado)

      mut as int64: step = 0
      mut as bool: has_work = true

      println("2. Executando Refinamentos de Hopcroft...")

      infinite (has_work) {
            #L Busca proximo bloco em W
            mut as int64: a_block = 0
            mut as int64: b_search = 1
            infinite (b_search <= num_blocks and a_block == 0) {
                  route {
                        in_w[b_search] ==> {
                              a_block = b_search
                              in_w[b_search] = false
                        }
                        _ ==> {}
                  }
                  b_search = b_search + 1
            }

            route {
                  a_block == 0 ==> {
                        has_work = false
                  }
                  _ ==> {
                        step = step + 1
                        #L Para cada simbolo do alfabeto
                        mut as int64: sym = 1
                        infinite (sym <= num_symbols) {
                              #L Calcula X = delta^(-1)(A, sym)
                              #L x_set[s] = true se delta(s, sym) pertence ao bloco a_block
                              mut as list of bool: x_set = [false, false, false, false, false, false]
                              mut as int64: s = 1
                              infinite (s <= num_states) {
                                    mut as int64: dest = delta[(s - 1) * 2 + sym]
                                    route {
                                          block_id[dest] == a_block ==> {
                                                x_set[s] = true
                                          }
                                          _ ==> {}
                                    }
                                    s = s + 1
                              }

                              #L Para cada bloco Y existente
                              mut as int64: y = 1
                              mut as int64: current_num_blocks = num_blocks
                              infinite (y <= current_num_blocks) {
                                    #L Conta intersecao |Y cap X| e diferenca |Y \ X|
                                    mut as int64: count_in_x = 0
                                    mut as int64: count_not_in_x = 0
                                    s = 1
                                    infinite (s <= num_states) {
                                          route {
                                                block_id[s] == y ==> {
                                                      route {
                                                            x_set[s] ==> { count_in_x = count_in_x + 1 }
                                                            _ ==> { count_not_in_x = count_not_in_x + 1 }
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          s = s + 1
                                    }

                                    #L Se ambos forem > 0, o bloco Y deve ser dividido!
                                    route {
                                          count_in_x > 0 and count_not_in_x > 0 ==> {
                                                num_blocks = num_blocks + 1
                                                mut as int64: new_block = num_blocks
                                                #L Move os estados que estao em X para new_block
                                                s = 1
                                                infinite (s <= num_states) {
                                                      route {
                                                            block_id[s] == y and x_set[s] ==> {
                                                                  block_id[s] = new_block
                                                            }
                                                            _ ==> {}
                                                      }
                                                      s = s + 1
                                                }

                                                #L Atualiza worklist W
                                                route {
                                                      in_w[y] ==> {
                                                            in_w[new_block] = true
                                                      }
                                                      _ ==> {
                                                            route {
                                                                  count_in_x <= count_not_in_x ==> {
                                                                        in_w[new_block] = true
                                                                  }
                                                                  _ ==> {
                                                                        in_w[y] = true
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    y = y + 1
                              }
                              sym = sym + 1
                        }
                  }
            }
      }

      println("3. Particao Final de Hopcroft:")
      println("   Total de Blocos Minimizados: " + num_blocks)

      mut as int64: b = 1
      infinite (b <= num_blocks) {
            mut as string: membros = ""
            mut as int64: st = 1
            infinite (st <= num_states) {
                  route {
                        block_id[st] == b ==> {
                              membros = membros + st + " "
                        }
                        _ ==> {}
                  }
                  st = st + 1
            }
            println("   Bloco " + b + ": Estados { " + membros + "}")
            b = b + 1
      }

      println("4. Transicoes do Autômato Minimo (Hopcroft):")
      b = 1
      infinite (b <= num_blocks) {
            mut as int64: rep = 1
            infinite (rep <= num_states and block_id[rep] != b) {
                  rep = rep + 1
            }
            mut as int64: da = block_id[delta[(rep - 1) * 2 + 1]]
            mut as int64: db = block_id[delta[(rep - 1) * 2 + 2]]
            mut as bool: f_bl = is_accept[rep]
            println("   Bloco " + b + " (Final: " + f_bl + ") -- 'a' -> Bloco " + da + ", 'b' -> Bloco " + db)
            b = b + 1
      }

      println("Hopcroft DFA Minimization concluido com sucesso.")
}
