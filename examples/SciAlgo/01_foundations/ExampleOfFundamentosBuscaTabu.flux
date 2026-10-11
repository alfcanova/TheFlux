#L ============================================================================
#L Algoritmo: Tabu Search (Busca Tabu)
#L Dominio: 01_foundations / Busca
#L Complexidade: O(max_iter * vizinhos) tempo | O(tam_tabu) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaTabu) {
      println("==================================================")
      println("  SciAlgo: Tabu Search (Busca Tabu)               ")
      println("==================================================")

      #L Otimizacao da funcao f(x) = (x - 7)^2 + 3
      #L Minimo global ocorre em x = 7, f(7) = 3
      mut as int64: current_x = 1
      mut as int64: best_x = current_x
      mut as int64: best_cost = (current_x - 7) * (current_x - 7) + 3

      println("1. Estado Inicial: x = " + current_x + " | Custo: " + best_cost)

      #L Lista tabu armazena os ultimos estados visitados
      mut as list of int64: tabu_list = [current_x]
      mut as int64: tabu_tenure = 3
      mut as int64: iter = 1
      mut as int64: max_iter = 15

      infinite (iter <= max_iter) {
            #L Avalia vizinhos: x - 1 e x + 1
            mut as int64: best_neighbor = 0
            mut as int64: best_neighbor_cost = 999999

            mut as int64: step_dir = -1
            infinite (step_dir <= 1) {
                  route {
                        step_dir != 0 ==> {
                              mut as int64: cand = current_x + step_dir
                              mut as int64: cand_cost = (cand - 7) * (cand - 7) + 3

                              #L Verifica se cand esta na lista tabu
                              mut as bool: is_tabu = false
                              mut as int64: t_idx = 1
                              infinite (t_idx <= listLength(tabu_list)) {
                                    route {
                                          tabu_list[t_idx] == cand ==> {
                                                is_tabu = true
                                          }
                                    }
                                    t_idx = t_idx + 1
                              }

                              #L Criterio de aspiracao: se cand melhora o melhor global, ignora tabu
                              route {
                                    (not is_tabu) or (cand_cost < best_cost) ==> {
                                          route {
                                                cand_cost < best_neighbor_cost ==> {
                                                      best_neighbor = cand
                                                      best_neighbor_cost = cand_cost
                                                }
                                          }
                                    }
                              }
                        }
                  }
                  step_dir = step_dir + 2
            }

            route {
                  best_neighbor != 0 ==> {
                        current_x = best_neighbor
                        tabu_list = listPushBack(tabu_list, current_x)
                        route {
                              listLength(tabu_list) > tabu_tenure ==> {
                                    tabu_list = listSlice(tabu_list, 2, listLength(tabu_list))
                              }
                        }

                        route {
                              best_neighbor_cost < best_cost ==> {
                                    best_cost = best_neighbor_cost
                                    best_x = current_x
                              }
                        }
                  }
            }

            iter = iter + 1
      }

      println("2. Melhor Solucao Encontrada: x = " + best_x + " | Custo: " + best_cost)
      mut as bool: ok = (best_x == 7 and best_cost == 3)
      println("3. Validacao (Minimo otimo x=7, f(x)=3): " + ok)
      println("==================================================")
}
