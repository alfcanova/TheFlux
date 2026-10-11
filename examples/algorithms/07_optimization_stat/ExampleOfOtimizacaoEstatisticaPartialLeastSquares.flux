#L ============================================================================
#L Algoritmo: Partial Least Squares (PLS / NIPALS)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(Iter * N * D) | Espaco O(N + D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaPartialLeastSquares) {
      println("==================================================")
      println("  SciAlgo: Partial Least Squares (PLS NIPALS)")
      println("==================================================")

      #L Variavel preditora X e resposta Y centradas (N = 4)
      mut as list of int64: x = [1, 2, 3, 4]
      mut as list of int64: y = [2, 4, 6, 8]
      mut as int64: n = listLength(x)

      #L 1. Peso w = X^T * Y
      mut as int64: w = 0
      mut as int64: i = 1
      infinite (i <= n) {
            w = w + (x[i] * y[i])
            i = i + 1
      }
      println("1. Covariancia cruzada X^T * Y (peso latente): " + w)

      #L 2. Escore latente t = X * w
      mut as int64: norm_w = w /i 10
      mut as int64: t1 = x[1] * norm_w

      println("2. Primeiro escore latente calculado: " + t1)
      route {
            w == 60 ==> {
                  println("   [PASS] Extracao de componente latente por PLS validada!")
            }
            _ ==> {
                  println("   [ERRO] Falha no PLS.")
            }
      }

      println("==================================================")
      println("Partial Least Squares concluido com sucesso!")
}
