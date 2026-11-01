#L ============================================================================
#L Algoritmo: PTAS para Knapsack (Polynomial-Time Approximation Scheme)
#L Dominio: 03_graphs / Categoria: Teoria da computacao e complexidade
#L Complexidade: O(n^(1/epsilon + 1)) tempo | O(n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosComplexidadePTASKnapsack) {
      println("==================================================")
      println("  SciAlgo: PTAS para Knapsack 0/1 (Sahni 1975)    ")
      println("==================================================")

      #L Instancia do problema:
      #L n = 5 itens com (peso, valor). Capacidade da mochila W = 15.
      mut as int64: n = 5
      mut as int64: capacity = 15
      mut as list of int64: weights = [4, 5, 8, 10, 2]
      mut as list of int64: values = [10, 12, 18, 20, 3]

      #L Itens pre-ordenados por densidade de valor (v_i / w_i decrescente):
      #L Item 1: 10/4 = 2.50
      #L Item 2: 12/5 = 2.40
      #L Item 3: 18/8 = 2.25
      #L Item 4: 20/10 = 2.00
      #L Item 5: 3/2 = 1.50
      #L Ordem de indices por razao: [1, 2, 3, 4, 5]
      mut as list of int64: sorted_indices = [1, 2, 3, 4, 5]

      println("1. Parametros da Instancia:")
      println("   Numero de itens: " + n + ", Capacidade W: " + capacity)
      println("   Pesos: " + weights)
      println("   Valores: " + values)

      #L Parametro de aproximacao epsilon = 0.5
      #L Tamanho do subconjunto enumerado m = 1/epsilon = 2.
      #L O esquema de Sahni enumera todos os subconjuntos S com |S| <= m
      #L e completa avidamente a capacidade residual com os itens restantes.
      mut as int64: m_bound = 2
      println("2. Esquema PTAS: enumeracao de subconjuntos de tamanho <= " + m_bound)

      mut as int64: best_val = 0
      mut as int64: best_weight = 0
      mut as list of int64: best_items = []
      mut as int64: subsets_evaluated = 0

      #L Caso 0: Subconjunto vazio S = {} (Gulosa pura)
      subsets_evaluated = subsets_evaluated + 1
      mut as int64: cur_weight0 = 0
      mut as int64: cur_val0 = 0
      mut as list of int64: cur_items0 = []
      mut as int64: idx0 = 1
      infinite (idx0 <= n) {
            mut as int64: it0 = sorted_indices[idx0]
            mut as int64: w0 = weights[it0]
            route {
                  cur_weight0 + w0 <= capacity ==> {
                        cur_weight0 = cur_weight0 + w0
                        cur_val0 = cur_val0 + values[it0]
                        cur_items0 = listPushBack(cur_items0, it0)
                  }
                  _ ==> {}
            }
            idx0 = idx0 + 1
      }
      route {
            cur_val0 > best_val ==> {
                  best_val = cur_val0
                  best_weight = cur_weight0
                  best_items = cur_items0
            }
            _ ==> {}
      }

      #L Caso 1: Subconjuntos de tamanho |S| = 1
      mut as int64: i = 1
      infinite (i <= n) {
            subsets_evaluated = subsets_evaluated + 1
            mut as int64: w_i = weights[i]
            route {
                  w_i <= capacity ==> {
                        mut as int64: cur_w = w_i
                        mut as int64: cur_v = values[i]
                        mut as list of int64: cur_sol = [i]

                        #L Completa com itens gulosos restantes
                        mut as int64: k = 1
                        infinite (k <= n) {
                              mut as int64: it_k = sorted_indices[k]
                              route {
                                    it_k != i and (cur_w + weights[it_k] <= capacity) ==> {
                                          cur_w = cur_w + weights[it_k]
                                          cur_v = cur_v + values[it_k]
                                          cur_sol = listPushBack(cur_sol, it_k)
                                    }
                                    _ ==> {}
                              }
                              k = k + 1
                        }

                        route {
                              cur_v > best_val ==> {
                                    best_val = cur_v
                                    best_weight = cur_w
                                    best_items = cur_sol
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      #L Caso 2: Subconjuntos de tamanho |S| = 2
      mut as int64: p1 = 1
      infinite (p1 <= n) {
            mut as int64: p2 = p1 + 1
            infinite (p2 <= n) {
                  subsets_evaluated = subsets_evaluated + 1
                  mut as int64: w_pair = weights[p1] + weights[p2]
                  route {
                        w_pair <= capacity ==> {
                              mut as int64: cur_w2 = w_pair
                              mut as int64: cur_v2 = values[p1] + values[p2]
                              mut as list of int64: cur_sol2 = [p1, p2]

                              #L Completa com itens gulosos restantes
                              mut as int64: k2 = 1
                              infinite (k2 <= n) {
                                    mut as int64: it2 = sorted_indices[k2]
                                    route {
                                          it2 != p1 and it2 != p2 and (cur_w2 + weights[it2] <= capacity) ==> {
                                                cur_w2 = cur_w2 + weights[it2]
                                                cur_v2 = cur_v2 + values[it2]
                                                cur_sol2 = listPushBack(cur_sol2, it2)
                                          }
                                          _ ==> {}
                                    }
                                    k2 = k2 + 1
                              }

                              route {
                                    cur_v2 > best_val ==> {
                                          best_val = cur_v2
                                          best_weight = cur_w2
                                          best_items = cur_sol2
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  p2 = p2 + 1
            }
            p1 = p1 + 1
      }

      println("3. Resultados da Execucao do PTAS:")
      println("   Subconjuntos base avaliados: " + subsets_evaluated)
      println("   Melhor valor alcancado: " + best_val)
      println("   Peso total utilizado: " + best_weight + " / " + capacity)
      println("   Itens selecionados na solucao: " + best_items)

      #L Verificacao da cota teorica de aproximacao (1 - epsilon) * OPT:
      #L Valor otimo conhecido = 33 (itens 2, 3 e 5: peso 5+8+2=15, valor 12+18+3=33)
      mut as int64: opt_val = 33
      mut as bool: guarantee_met = best_val >= (opt_val /i 2)
      mut as bool: is_optimal = best_val == opt_val
      println("4. Garantia Teorica PTAS (>= (1-eps)*OPT = 16): " + guarantee_met)
      println("   Solucao Otima Alcancada: " + is_optimal)

      mut as bool: final_ok = guarantee_met and is_optimal
      println("5. Verificacao de Conformidade PTAS: " + final_ok)

      println("Concluido com Sucesso")
}
