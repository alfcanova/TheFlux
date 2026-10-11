#L ============================================================================
#L Algoritmo: Monte Carlo (Estimacao de Pi por Integracao Estocastica)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(N) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemMonteCarlo) {
      println("==================================================")
      println("  SciAlgo: Monte Carlo (Pi Estimation)")
      println("==================================================")

      #L Gera amostras pseudo-aleatorias deterministas no quadrado unitario [0, 100]x[0, 100]
      #L R = 100 -> circulo: x^2 + y^2 <= 10000
      mut as int64: n = 100
      mut as int64: inside_circle = 0

      #L LCG deterministico: seed = (seed * 1103515245 + 12345) % 101
      mut as int64: seed_x = 17
      mut as int64: seed_y = 53

      mut as int64: i = 1
      infinite (i <= n) {
            seed_x = (((seed_x * 37) + 11) /r 101)
            seed_y = (((seed_y * 73) + 19) /r 101)

            mut as int64: dist_sq = (seed_x * seed_x) + (seed_y * seed_y)
            route {
                  dist_sq <= 10000 ==> {
                        inside_circle = inside_circle + 1
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      #L Pi aprox = 4 * (inside / N) (com escala x100)
      mut as int64: pi_est = (4 * inside_circle * 100) /i n
      println("1. Total de amostras: " + n + " | No quadrante do circulo: " + inside_circle)
      println("2. Pi aproximado por Monte Carlo: " + pi_est + " / 100")

      route {
            pi_est >= 280 and pi_est <= 340 ==> {
                  println("   [PASS] Estimacao Monte Carlo convergiu dentro da margem esperada!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia na integracao Monte Carlo.")
            }
      }

      println("==================================================")
      println("Monte Carlo concluido com sucesso!")
}
