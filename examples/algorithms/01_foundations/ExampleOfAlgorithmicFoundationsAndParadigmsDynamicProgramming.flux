#L ============================================================================
#L Algoritmo: Dynamic Programming (Programacao Dinamica)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N * W) tempo | O(N * W) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsDynamicProgramming) {
      println("==================================================")
      println("  SciAlgo: Dynamic Programming (Mochila 0/1)")
      println("==================================================")

      mut as list of int64: weights = [2, 3, 4, 5]
      mut as list of int64: values = [3, 4, 5, 8]
      mut as int64: n = listLength(weights)
      mut as int64: capacity = 8

      println("1. Pesos dos itens: " + weights)
      println("2. Valores dos itens: " + values)
      println("3. Capacidade da mochila: " + capacity)

      #L Tabela DP linearizada (N+1) linhas x (W+1) colunas
      #L Indice no vetor 1-based: idx = (i * (capacity + 1)) + w + 1
      mut as int64: num_cols = capacity + 1
      mut as int64: total_cells = (n + 1) * num_cols
      mut as list of int64: dp = []
      mut as int64: z = 1
      infinite (z <= total_cells) {
            dp = listPushBack(dp, 0)
            z = z + 1
      }

      #L Preenchimento da tabela DP (Tabulacao Bottom-Up)
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: wt = weights[i]
            mut as int64: val = values[i]
            mut as int64: w = 0
            infinite (w <= capacity) {
                  mut as int64: prev_idx = ((i - 1) * num_cols) + w + 1
                  mut as int64: without_item = dp[prev_idx]
                  mut as int64: best = without_item

                  route {
                        w >= wt ==> {
                              mut as int64: rem_idx = ((i - 1) * num_cols) + (w - wt) + 1
                              mut as int64: with_item = dp[rem_idx] + val
                              route {
                                    with_item > best ==> {
                                          best = with_item
                                    }
                                    _ ==> {
                                    }
                              }
                        }
                        _ ==> {
                        }
                  }

                  mut as int64: cur_idx = (i * num_cols) + w + 1
                  dp[cur_idx] = best
                  w = w + 1
            }
            i = i + 1
      }

      mut as int64: max_profit_idx = (n * num_cols) + capacity + 1
      mut as int64: max_profit = dp[max_profit_idx]
      println("4. Valor maximo acumulado pela DP: " + max_profit)

      #L Reconstrucao dos itens selecionados (Backtracking na tabela DP)
      mut as list of int64: chosen_items = []
      mut as int64: rem_w = capacity
      mut as int64: k = n
      infinite (k >= 1) {
            mut as int64: curr_idx = (k * num_cols) + rem_w + 1
            mut as int64: prior_idx = ((k - 1) * num_cols) + rem_w + 1
            route {
                  dp[curr_idx] != dp[prior_idx] ==> {
                        chosen_items = listPushBack(chosen_items, k)
                        rem_w = rem_w - weights[k]
                  }
                  _ ==> {
                  }
            }
            k = k - 1
      }
      println("5. Itens selecionados na solucao otima: " + chosen_items)
      println("Concluido com Sucesso")
}
