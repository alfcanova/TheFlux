#L ============================================================================
#L Algoritmo: Simple Monte Carlo Integration (Estimacao Uniforme de Pi)
#L Capitulo: 07_random_numbers
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integracao de Monte Carlo para calcular a area do quarto de circulo.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SimpleMonteCarloIntegration) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SimpleMonteCarloIntegration")
      println("==================================================")

      #L Gerador pseudoaleatorio deterministico:
      mut as int64: a = 1664525
      mut as int64: c = 1013904223
      mut as int64: m = 2147483647
      mut as int64: u = 12345

      mut as int64: n_amostras = 50
      mut as int64: acertos = 0
      mut as int64: r_sq = 1000 * 1000

      println("1. Amostrando 50 pontos aleatorios no quadrado [0, 1000] x [0, 1000]:")
      mut as int64: k = 1
      infinite (k <= n_amostras) {
            u = (u * a + c) /r m
            route {
                  u < 0 ==> {
                        u = 0 - u
                  }
                  u >= 0 ==> {}
            }
            mut as int64: x = u /r 1000

            u = (u * a + c) /r m
            route {
                  u < 0 ==> {
                        u = 0 - u
                  }
                  u >= 0 ==> {}
            }
            mut as int64: y = u /r 1000

            route {
                  (x * x + y * y) <= r_sq ==> {
                        acertos = acertos + 1
                  }
                  (x * x + y * y) > r_sq ==> {}
            }
            k = k + 1
      }

      #L Estimativa de pi: pi ~= 4 * acertos / n_amostras
      mut as int64: pi_est = (4 * acertos * 1000) /i n_amostras
      println("   -> Acertos dentro do circulo: " + acertos + " / " + n_amostras)
      println("   -> Pi estimado = " + pi_est + " / 1000 (esperado ~= 3141)")

      #L Verificacao de que a estimativa esta no intervalo razoavel [2500, 3800]:
      mut as int64: valido = 0
      route {
            pi_est >= 2500 and pi_est <= 3800 ==> {
                  valido = 1
            }
            pi_est < 2500 or pi_est > 3800 ==> {
                  valido = 0
            }
      }
      mut as int64: res = 1 - valido
      println("2. Residuo do teste de integracao = " + res + " (esperado: 0)")
      println("3. Integracao simples de Monte Carlo concluida com sucesso.")
}
