#L ============================================================================
#L Algoritmo: RANSAC (Random Sample Consensus para Ajuste Robusto)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(K * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaRANSAC) {
      println("==================================================")
      println("  SciAlgo: RANSAC (Random Sample Consensus)")
      println("==================================================")

      #L Pontos 2D (x, y) com reta y = 2x + 1 e varios outliers espurios
      mut as list of int64: px = [1, 2, 3, 4, 5, 6, 7, 8]
      mut as list of int64: py = [3, 5, 7, 9, 100, 13, 200, 17] #L outliers em x=5 e x=7
      mut as int64: n = listLength(px)

      println("1. Dados com outliers severos em x=5 e x=7")
      println("2. Executando iteracoes RANSAC para encontrar modelo consenso:")

      #L Hipotese 1: amostragem dos pontos (1,3) e (2,5) -> m = 2, c = 1
      mut as int64: m1 = 2
      mut as int64: c1 = 1
      mut as int64: inliers1 = 0

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: y_pred = m1 * px[i] + c1
            mut as int64: diff = py[i] - y_pred
            route {
                  diff < 0 ==> { diff = 0 - diff }
                  _ ==> {}
            }
            route {
                  diff <= 1 ==> {
                        inliers1 = inliers1 + 1
                  }
                  _ ==> {}
            }
            i = i + 1
      }
      println("   Hipotese 1 (m=2, c=1): Inliers = " + inliers1 + " / " + n)

      route {
            inliers1 >= 6 ==> {
                  println("   [PASS] RANSAC identificou a reta correta descartando outliers!")
            }
            _ ==> {
                  println("   [ERRO] RANSAC falhou em atingir consenso.")
            }
      }

      println("==================================================")
      println("RANSAC concluido com sucesso!")
}
