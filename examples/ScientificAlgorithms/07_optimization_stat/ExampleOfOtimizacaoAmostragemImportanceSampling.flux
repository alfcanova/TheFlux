#L ============================================================================
#L Algoritmo: Importance Sampling (Ponderacao por Razao de Verossimilhanca)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(N) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemImportanceSampling) {
      println("==================================================")
      println("  SciAlgo: Importance Sampling (Likelihood Ratio)")
      println("==================================================")

      #L Estimando E_p[f(X)] com proposta q(x)
      #L Amostras geradas de q: [2, 4, 6, 8]
      #L Pesos w_i = p(x_i) / q(x_i) (em escala x10): [15, 12, 8, 5]
      #L Valores f(x_i): [10, 20, 30, 40]
      mut as list of int64: f_val = [10, 20, 30, 40]
      mut as list of int64: weights = [15, 12, 8, 5]
      mut as int64: n = listLength(f_val)

      mut as int64: weighted_sum = 0
      mut as int64: sum_weights = 0
      mut as int64: i = 1
      infinite (i <= n) {
            weighted_sum = weighted_sum + (f_val[i] * weights[i])
            sum_weights = sum_weights + weights[i]
            i = i + 1
      }

      mut as int64: expected_val = weighted_sum /i sum_weights
      println("1. Soma ponderada: " + weighted_sum + " | Soma dos pesos: " + sum_weights)
      println("2. Valor esperado estimado por Importance Sampling: " + expected_val)

      route {
            expected_val >= 20 and expected_val <= 25 ==> {
                  println("   [PASS] Importance Sampling corrigiu o vies da proposta com exatidao!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no Importance Sampling.")
            }
      }

      println("==================================================")
      println("Importance Sampling concluido com sucesso!")
}
