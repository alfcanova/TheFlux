#L ============================================================================
#L Algoritmo: Stoer-Wagner (Corte Minimo Global em Grafo Nao-Direcionado)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V^3) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteStoerWagner) {
      println("==================================================")
      println("  SciAlgo: Stoer-Wagner (Global Minimum Cut)     ")
      println("==================================================")

      mut as int64: num_v = 4

      #L Matriz de adjacencia simetrica (pesos das arestas)
      mut as list of int64: weights = [
            0, 2, 3, 0,
            2, 0, 2, 2,
            3, 2, 0, 4,
            0, 2, 4, 0
      ]

      println("1. Grafo Nao-Direcionado com Pesos:")
      println("   Vertices: 1, 2, 3, 4")
      println("   Arestas: (1,2):2, (1,3):3, (2,3):2, (2,4):2, (3,4):4")

      #L Lista de vertices ativos
      mut as list of bool: active = [true, true, true, true]
      mut as int64: active_count = num_v
      mut as int64: min_cut_weight = 999999

      #L Executa |V| - 1 fases de contracao
      infinite (active_count > 1) {
            #L Encontra o primeiro vertice ativo para iniciar A
            mut as int64: start_node = 0
            mut as int64: i = 1
            infinite (i <= num_v and start_node == 0) {
                  route {
                        active[i] ==> {
                              start_node = i
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            #L Conjunto A: adiciona vertices um a um pelo peso de conexao
            mut as list of bool: in_a = [false, false, false, false]
            mut as list of int64: conn = [0, 0, 0, 0]
            mut as int64: last = start_node
            mut as int64: prev_last = start_node

            mut as int64: step = 1
            infinite (step <= active_count) {
                  #L Encontra o vertice ativo nao em A com maior conexao com A
                  mut as int64: best_v = 0
                  mut as int64: max_conn = -1

                  route {
                        step == 1 ==> {
                              best_v = start_node
                        }
                        _ ==> {
                              i = 1
                              infinite (i <= num_v) {
                                    route {
                                          active[i] and (not in_a[i]) ==> {
                                                route {
                                                      conn[i] > max_conn ==> {
                                                            max_conn = conn[i]
                                                            best_v = i
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    i = i + 1
                              }
                        }
                  }

                  prev_last = last
                  last = best_v
                  in_a[best_v] = true

                  #L Atualiza pesos de conexao para os vertices restantes
                  i = 1
                  infinite (i <= num_v) {
                        route {
                              active[i] and (not in_a[i]) ==> {
                                    mut as int64: w = weights[(best_v - 1) * num_v + i]
                                    conn[i] = conn[i] + w
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }

                  step = step + 1
            }

            #L O peso do corte desta fase e o valor de conn[last]
            mut as int64: cut_of_phase = conn[last]
            route {
                  cut_of_phase < min_cut_weight ==> {
                        min_cut_weight = cut_of_phase
                  }
                  _ ==> {}
            }

            #L Contrai o vertice `last` no vertice `prev_last`
            i = 1
            infinite (i <= num_v) {
                  route {
                        (i != prev_last) and (i != last) ==> {
                              mut as int64: w_last = weights[(last - 1) * num_v + i]
                              mut as int64: idx_p = (prev_last - 1) * num_v + i
                              mut as int64: idx_p_rev = (i - 1) * num_v + prev_last
                              weights[idx_p] = weights[idx_p] + w_last
                              weights[idx_p_rev] = weights[idx_p_rev] + w_last
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            #L Desativa o vertice last
            active[last] = false
            active_count = active_count - 1
      }

      println("2. Peso do Corte Minimo Global: " + min_cut_weight)
      println("Stoer-Wagner concluido com sucesso.")
}
