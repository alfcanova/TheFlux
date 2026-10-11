#L ============================================================================
#L Algoritmo: FPTAS para Knapsack (Fully Polynomial-Time Approximation Scheme)
#L Dominio: 03_graphs / Categoria: Teoria da computacao e complexidade
#L Complexidade: O(n^3 / epsilon) tempo | O(n^2 / epsilon) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosComplexidadeFPTASKnapsack) {
      println("==================================================")
      println("  SciAlgo: FPTAS para Knapsack (Ibarra & Kim 1975)")
      println("==================================================")

      #L Instancia do problema:
      mut as int64: n = 5
      mut as int64: capacity = 32
      mut as list of int64: weights = [9, 12, 15, 8, 10]
      mut as list of int64: values = [200, 300, 420, 180, 250]

      println("1. Instancia Knapsack 0/1:")
      println("   Numero de itens: " + n + ", Capacidade W: " + capacity)
      println("   Pesos: " + weights)
      println("   Valores Originais: " + values)

      #L Encontra V_max
      mut as int64: v_max = 0
      mut as int64: i = 1
      infinite (i <= n) {
            route {
                  values[i] > v_max ==> {
                        v_max = values[i]
                  }
                  _ ==> {}
            }
            i = i + 1
      }
      println("   V_max encontrado: " + v_max)

      #L Parametro de aproximacao epsilon = 0.20 (20% de tolerancia)
      #L Fator de escala K = floor(epsilon * V_max / n) = floor(0.20 * 420 / 5) = 16
      #L Como trabalhamos com inteiros: K = (20 * v_max) /i (100 * n)
      mut as int64: k_scale = (20 * v_max) /i (100 * n)
      route {
            k_scale < 1 ==> {
                  k_scale = 1
            }
            _ ==> {}
      }
      println("2. Parametros do FPTAS:")
      println("   Epsilon: 0.20 (20% erro maximo)")
      println("   Fator de Escala K: " + k_scale)

      #L Calcula valores escalados v'_i = floor(v_i / K)
      mut as list of int64: scaled_values = []
      mut as int64: max_scaled_sum = 0
      mut as int64: j = 1
      infinite (j <= n) {
            mut as int64: sv = values[j] /i k_scale
            scaled_values = listPushBack(scaled_values, sv)
            max_scaled_sum = max_scaled_sum + sv
            j = j + 1
      }
      println("   Valores Escalados v': " + scaled_values)
      println("   Soma maxima de valores escalados: " + max_scaled_sum)

      #L Programacao Dinamica sobre os valores escalados:
      #L dp[i, v] = menor peso necessario usando subconjunto dos primeiros i itens para atingir valor v
      #L Inicializa tabela com infinito (999999)
      mut as int64: inf_weight = 999999
      mut as int64: cols = max_scaled_sum + 1
      mut as int64: total_cells = (n + 1) * cols
      mut as list of int64: dp_table = []
      mut as int64: cell = 1
      infinite (cell <= total_cells) {
            dp_table = listPushBack(dp_table, inf_weight)
            cell = cell + 1
      }

      #L Caso base: dp[0, 0] = 0 (1-based: indice para (i=0, v=0) -> 0 * cols + 0 + 1 = 1)
      dp_table[1] = 0

      #L Preenche a tabela DP
      mut as int64: it = 1
      infinite (it <= n) {
            mut as int64: wi = weights[it]
            mut as int64: vi = scaled_values[it]

            mut as int64: v_cur = 0
            infinite (v_cur <= max_scaled_sum) {
                  #L Opcao 1: Nao incluir o item it
                  mut as int64: prev_idx = (it - 1) * cols + v_cur + 1
                  mut as int64: cur_idx = it * cols + v_cur + 1
                  mut as int64: best_w = dp_table[prev_idx]

                  #L Opcao 2: Incluir o item it (se v_cur >= vi)
                  route {
                        v_cur >= vi ==> {
                              mut as int64: sub_idx = (it - 1) * cols + (v_cur - vi) + 1
                              mut as int64: cand_w = dp_table[sub_idx] + wi
                              route {
                                    cand_w < best_w ==> {
                                          best_w = cand_w
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }

                  dp_table[cur_idx] = best_w
                  v_cur = v_cur + 1
            }
            it = it + 1
      }

      #L Encontra o maior valor escalado alcancavel com peso <= capacidade
      mut as int64: best_scaled_v = 0
      mut as int64: best_weight_used = 0
      mut as int64: v_search = max_scaled_sum
      infinite (v_search >= 0) {
            mut as int64: search_idx = n * cols + v_search + 1
            mut as int64: w_req = dp_table[search_idx]
            route {
                  w_req <= capacity ==> {
                        best_scaled_v = v_search
                        best_weight_used = w_req
                        break
                  }
                  _ ==> {}
            }
            v_search = v_search - 1
      }

      #L Reconstroi os itens selecionados
      mut as list of int64: selected_items = []
      mut as int64: rem_v = best_scaled_v
      mut as int64: rec_i = n
      infinite (rec_i >= 1 and rem_v >= 0) {
            mut as int64: w_item = weights[rec_i]
            mut as int64: v_item = scaled_values[rec_i]
            mut as int64: prev_cell = (rec_i - 1) * cols + rem_v + 1
            mut as int64: cur_cell = rec_i * cols + rem_v + 1

            route {
                  dp_table[cur_cell] != dp_table[prev_cell] ==> {
                        #L O item rec_i foi incluido!
                        selected_items = listPushBack(selected_items, rec_i)
                        rem_v = rem_v - v_item
                  }
                  _ ==> {}
            }
            rec_i = rec_i - 1
      }

      #L Calcula o valor real da solucao com os valores originais
      mut as int64: real_val = 0
      mut as int64: sel_idx = 1
      mut as int64: sel_len = listLength(selected_items)
      infinite (sel_idx <= sel_len) {
            mut as int64: it_id = selected_items[sel_idx]
            real_val = real_val + values[it_id]
            sel_idx = sel_idx + 1
      }

      println("3. Resultados do FPTAS:")
      println("   Maior valor escalado alcancavel: " + best_scaled_v)
      println("   Peso total da solucao: " + best_weight_used + " / " + capacity)
      println("   Itens selecionados: " + selected_items)
      println("   Valor Real da Solucao: " + real_val)

      #L Cota de aproximacao teorica: Real >= (1 - epsilon) * OPT
      #L OPT conhecido = 800 (itens 1, 3 e 4: peso 9+15+8=32, valor 200+420+180=800)
      mut as int64: opt_val = 800
      mut as int64: min_guaranteed = (opt_val * 80) /i 100 #L (1 - 0.20) * 800 = 640
      mut as bool: bound_satisfied = real_val >= min_guaranteed
      mut as bool: achieved_optimal = real_val == opt_val

      println("4. Verificacao Teorica:")
      println("   OPT exato: " + opt_val)
      println("   Cota minima garantida ((1 - eps)*OPT = " + min_guaranteed + "): " + bound_satisfied)
      println("   Solucao Otima Alcancada: " + achieved_optimal)

      mut as bool: final_valid = bound_satisfied and (best_weight_used <= capacity)
      println("5. Verificacao Geral do FPTAS: " + final_valid)

      println("Concluido com Sucesso")
}
