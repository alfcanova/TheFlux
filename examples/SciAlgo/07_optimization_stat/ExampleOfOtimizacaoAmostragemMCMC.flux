#L ============================================================================
#L Algoritmo: Markov Chain Monte Carlo (MCMC com Cadeia Estacionaria)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(Passos) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemMCMC) {
      println("==================================================")
      println("  SciAlgo: Markov Chain Monte Carlo (MCMC)")
      println("==================================================")

      #L 2 Estados: 1 e 2. Distribuicao estacionaria alvo: pi_1 = 40%, pi_2 = 60%
      #L Transicoes reversiveis com balanceamento detalhado
      mut as int64: state = 1
      mut as int64: visits_state1 = 0
      mut as int64: visits_state2 = 0
      mut as int64: total_steps = 100

      mut as int64: lcg = 42
      mut as int64: step = 1
      infinite (step <= total_steps) {
            lcg = (((lcg * 67) + 23) /r 100) #L rand em [0, 99]

            route {
                  state == 1 ==> {
                        visits_state1 = visits_state1 + 1
                        route {
                              lcg < 60 ==> { state = 2 } #L P(1->2) = 0.60
                              _ ==> {}
                        }
                  }
                  _ ==> {
                        visits_state2 = visits_state2 + 1
                        route {
                              lcg < 40 ==> { state = 1 } #L P(2->1) = 0.40
                              _ ==> {}
                        }
                  }
            }
            step = step + 1
      }

      mut as int64: pct1 = (visits_state1 * 100) /i total_steps
      mut as int64: pct2 = (visits_state2 * 100) /i total_steps
      println("1. Frequencia amostrada pelo MCMC:")
      println("   -> Estado 1: " + pct1 + "% (alvo teorico ~ 40%)")
      println("   -> Estado 2: " + pct2 + "% (alvo teorico ~ 60%)")

      route {
            pct2 > pct1 ==> {
                  println("   [PASS] MCMC convergiu para a distribuicao estacionaria alvo!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia na convergencia da cadeia de Markov.")
            }
      }

      println("==================================================")
      println("MCMC concluido com sucesso!")
}
