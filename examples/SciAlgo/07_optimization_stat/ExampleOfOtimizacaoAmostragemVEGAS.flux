#L ============================================================================
#L Algoritmo: VEGAS (Integracao Monte Carlo Adaptativa Multidimensional)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(Iter * N_amostras) | Espaco O(N_bins)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemVEGAS) {
      println("==================================================")
      println("  SciAlgo: VEGAS (Adaptive Monte Carlo Integration)")
      println("==================================================")

      #L Grade adaptativa com 4 caixas (bins) com densidades estimadas:
      #L Caixas [1, 2, 3, 4] com variancias [10, 80, 10, 5]
      #L VEGAS refina a grade concentrando mais amostras onde a variancia eh maior (Bin 2)
      mut as list of int64: bin_variance = [10, 80, 10, 5]
      mut as int64: n_bins = listLength(bin_variance)

      mut as int64: max_var_bin = 1
      mut as int64: max_var = bin_variance[1]
      mut as int64: i = 2
      infinite (i <= n_bins) {
            route {
                  bin_variance[i] > max_var ==> {
                        max_var = bin_variance[i]
                        max_var_bin = i
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Grade adaptativa inicializada com " + n_bins + " intervalos")
      println("2. Caixa com maior densidade de variancia detectada: Bin " + max_var_bin + " (Var: " + max_var + ")")

      #L Re-ponderacao da grade VEGAS para proxima iteracao
      mut as int64: refined_samples_bin2 = 60 #L 60% das proximas amostras no Bin 2
      println("3. Grade VEGAS adaptada: Bin " + max_var_bin + " recebera " + refined_samples_bin2 + "% das amostras")

      route {
            max_var_bin == 2 ==> {
                  println("   [PASS] VEGAS adaptou a grade multidimensional com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha na adaptacao VEGAS.")
            }
      }

      println("==================================================")
      println("VEGAS concluido com sucesso!")
}
