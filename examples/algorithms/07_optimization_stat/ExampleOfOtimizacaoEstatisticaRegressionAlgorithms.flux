#L ============================================================================
#L Algoritmo: Regression Algorithms (OLS e Ridge Regularization)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(N * D) | Espaco O(D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaRegressionAlgorithms) {
      println("==================================================")
      println("  SciAlgo: Regression Algorithms (OLS & Ridge)")
      println("==================================================")

      #L Pontos (x, y): y = 2x
      mut as list of int64: x = [1, 2, 3, 4]
      mut as list of int64: y = [2, 4, 6, 8]
      mut as int64: n = listLength(x)

      #L OLS: w = sum(x*y) / sum(x^2)
      mut as int64: sum_xy = 0
      mut as int64: sum_xx = 0
      mut as int64: i = 1
      infinite (i <= n) {
            sum_xy = sum_xy + (x[i] * y[i])
            sum_xx = sum_xx + (x[i] * x[i])
            i = i + 1
      }
      mut as int64: w_ols = sum_xy /i sum_xx   #L 60 / 30 = 2

      #L Ridge L2: w = sum(x*y) / (sum(x^2) + lambda) com lambda = 10
      mut as int64: lambda = 10
      mut as int64: w_ridge = (sum_xy * 10) /i (sum_xx + lambda) #L 600 / 40 = 15 (1.5)

      println("1. Coeficiente OLS estimado: " + w_ols + " (esperado 2)")
      println("2. Coeficiente Ridge L2 encolhido: " + w_ridge + " (escala x10, esperado 15)")

      route {
            w_ols == 2 and w_ridge == 15 ==> {
                  println("   [PASS] Regressoes OLS e Ridge computadas com exatidao analitica!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia nos coeficientes de regressao.")
            }
      }

      println("==================================================")
      println("Regression Algorithms concluido com sucesso!")
}
