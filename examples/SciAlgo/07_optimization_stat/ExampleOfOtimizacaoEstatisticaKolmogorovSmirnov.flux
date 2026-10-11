#L ============================================================================
#L Algoritmo: Kolmogorov-Smirnov (Teste de Aderencia de Distribuicao)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(N log N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaKolmogorovSmirnov) {
      println("==================================================")
      println("  SciAlgo: Kolmogorov-Smirnov Test (D Statistic)")
      println("==================================================")

      #L Amostra ordenada normalizada em [0, 100]
      mut as list of int64: sample = [10, 25, 45, 60, 90]
      mut as int64: n = listLength(sample)

      #L CDF teorica uniforme: F0(x) = x / 100
      #L Estatistica D = max |F_empirica(x) - F0(x)|
      mut as int64: max_d = 0
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: f_emp = (i * 100) /i n
            mut as int64: f_teo = sample[i]

            mut as int64: diff = f_emp - f_teo
            route {
                  diff < 0 ==> { diff = 0 - diff }
                  _ ==> {}
            }
            route {
                  diff > max_d ==> {
                        max_d = diff
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Estatistica maxima D calculada: " + max_d + " / 100")
      route {
            max_d > 0 and max_d < 50 ==> {
                  println("   [PASS] Teste Kolmogorov-Smirnov executado com sucesso (amostra adere a hipotese)!")
            }
            _ ==> {
                  println("   [ERRO] Falha no teste K-S.")
            }
      }

      println("==================================================")
      println("Kolmogorov-Smirnov concluido com sucesso!")
}
