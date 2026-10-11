#L ============================================================================
#L Algoritmo: Branch and Bound (Ramificacao e Limite)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(2^N) pior caso | Sub-exponencial na pratica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasBranchAndBound) {
      println("==================================================")
      println("  SciAlgo: Branch and Bound (Mochila 0/1)")
      println("==================================================")

      #L Itens ordenados por razao valor/peso decrescente:
      #L Item 1: peso 2, valor 10 (ratio 5.0)
      #L Item 2: peso 3, valor 12 (ratio 4.0)
      #L Item 3: peso 5, valor 15 (ratio 3.0)
      #L Item 4: peso 7, valor 20 (ratio ~2.85)
      mut as list of int64: weights = [2, 3, 5, 7]
      mut as list of int64: values = [10, 12, 15, 20]
      mut as int64: n = listLength(weights)
      mut as int64: capacity = 10

      println("1. Pesos: " + weights)
      println("2. Valores: " + values)
      println("3. Capacidade: " + capacity)

      #L Pilhas para BFS/DFS de nos: (level, curr_weight, curr_val)
      mut as list of int64: q_lvl = [0]
      mut as list of int64: q_wt = [0]
      mut as list of int64: q_val = [0]

      mut as int64: max_profit = 0
      mut as int64: nodes_explored = 0
      mut as int64: branches_pruned = 0

      infinite (listLength(q_lvl) > 0) {
            mut as int64: top = listLength(q_lvl)
            mut as int64: lvl = q_lvl[top]
            mut as int64: wt = q_wt[top]
            mut as int64: val = q_val[top]

            #L Remove topo da pilha
            mut as list of int64: n_lvl = []
            mut as list of int64: n_wt = []
            mut as list of int64: n_val = []
            mut as int64: idx = 1
            infinite (idx < top) {
                  n_lvl = listPushBack(n_lvl, q_lvl[idx])
                  n_wt = listPushBack(n_wt, q_wt[idx])
                  n_val = listPushBack(n_val, q_val[idx])
                  idx = idx + 1
            }
            q_lvl = n_lvl
            q_wt = n_wt
            q_val = n_val

            nodes_explored = nodes_explored + 1

            route {
                  val > max_profit ==> {
                        max_profit = val
                  }
                  _ ==> {
                  }
            }

            route {
                  lvl < n ==> {
                        mut as int64: next_lvl = lvl + 1

                        #L Ramo 1: Nao incluir o item next_lvl
                        #L Calcula limite superior (upper bound) guloso fracionario
                        mut as int64: bound_excl = val
                        mut as int64: w_left_excl = capacity - wt
                        mut as int64: k1 = next_lvl + 1
                        infinite (k1 <= n and w_left_excl > 0) {
                              route {
                                    weights[k1] <= w_left_excl ==> {
                                          bound_excl = bound_excl + values[k1]
                                          w_left_excl = w_left_excl - weights[k1]
                                    }
                                    _ ==> {
                                          #L Fracao inteira aproximada (bound superior)
                                          bound_excl = bound_excl + ((values[k1] * w_left_excl) /i weights[k1])
                                          w_left_excl = 0
                                    }
                              }
                              k1 = k1 + 1
                        }

                        route {
                              bound_excl > max_profit ==> {
                                    q_lvl = listPushBack(q_lvl, next_lvl)
                                    q_wt = listPushBack(q_wt, wt)
                                    q_val = listPushBack(q_val, val)
                              }
                              _ ==> {
                                    branches_pruned = branches_pruned + 1
                              }
                        }

                        #L Ramo 2: Incluir o item next_lvl (se couber)
                        mut as int64: next_wt = wt + weights[next_lvl]
                        mut as int64: next_val = val + values[next_lvl]

                        route {
                              next_wt <= capacity ==> {
                                    #L Calcula bound incluindo
                                    mut as int64: bound_incl = next_val
                                    mut as int64: w_left_incl = capacity - next_wt
                                    mut as int64: k2 = next_lvl + 1
                                    infinite (k2 <= n and w_left_incl > 0) {
                                          route {
                                                weights[k2] <= w_left_incl ==> {
                                                      bound_incl = bound_incl + values[k2]
                                                      w_left_incl = w_left_incl - weights[k2]
                                                }
                                                _ ==> {
                                                      bound_incl = bound_incl + ((values[k2] * w_left_incl) /i weights[k2])
                                                      w_left_incl = 0
                                                }
                                          }
                                          k2 = k2 + 1
                                    }

                                    route {
                                          bound_incl > max_profit ==> {
                                                q_lvl = listPushBack(q_lvl, next_lvl)
                                                q_wt = listPushBack(q_wt, next_wt)
                                                q_val = listPushBack(q_val, next_val)
                                          }
                                          _ ==> {
                                                branches_pruned = branches_pruned + 1
                                          }
                                    }
                              }
                              _ ==> {
                                    #L Poda por excesso de peso
                                    branches_pruned = branches_pruned + 1
                              }
                        }
                  }
                  _ ==> {
                  }
            }
      }

      println("4. Lucro maximo encontrado: " + max_profit)
      println("5. Nos explorados: " + nodes_explored)
      println("6. Ramos podados pelo limite superior: " + branches_pruned)
      println("Concluido com Sucesso")
}
