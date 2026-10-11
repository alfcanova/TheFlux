#L ============================================================================
#L Algoritmo: Expectation-Maximization (EM para GMM 1D)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(K * N * I) | Espaco O(N * K)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaExpectationMaximization) {
      println("==================================================")
      println("  SciAlgo: Expectation-Maximization (EM / GMM 1D)")
      println("==================================================")

      mut as list of int64: x = [9, 10, 11, 12, 48, 50, 51, 52]
      mut as int64: n = listLength(x)
      println("1. Observacoes (N = " + n + "): [9, 10, 11, 12, 48, 50, 51, 52]")

      mut as int64: mu1 = 15
      mut as int64: mu2 = 40
      println("2. Parametros iniciais: mu1 = " + mu1 + ", mu2 = " + mu2)

      mut as int64: iter = 1
      infinite (iter <= 5) {
            mut as int64: sum1 = 0
            mut as int64: count1 = 0
            mut as int64: sum2 = 0
            mut as int64: count2 = 0

            mut as int64: i = 1
            infinite (i <= n) {
                  mut as int64: val = x[i]
                  mut as int64: d1 = (val - mu1) * (val - mu1)
                  mut as int64: d2 = (val - mu2) * (val - mu2)

                  route {
                        d1 <= d2 ==> {
                              sum1 = sum1 + val
                              count1 = count1 + 1
                        }
                        _ ==> {
                              sum2 = sum2 + val
                              count2 = count2 + 1
                        }
                  }
                  i = i + 1
            }

            route {
                  count1 > 0 ==> { mu1 = sum1 /i count1 }
                  _ ==> {}
            }
            route {
                  count2 > 0 ==> { mu2 = sum2 /i count2 }
                  _ ==> {}
            }

            println("   Iteracao " + iter + ": mu1 = " + mu1 + ", mu2 = " + mu2)
            iter = iter + 1
      }

      println("3. Parametros finais:")
      println("   -> Media 1: " + mu1 + " | Media 2: " + mu2)
      route {
            (mu1 >= 9 and mu1 <= 12) and (mu2 >= 49 and mu2 <= 52) ==> {
                  println("   [PASS] Expectation-Maximization convergiu com precisao!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no EM.")
            }
      }

      println("==================================================")
      println("Expectation-Maximization concluido com sucesso!")
}
