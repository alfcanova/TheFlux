#L ============================================================================
#L Algoritmo: Rejection Sampling (Amostragem por Rejeicao de Envelope)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(M * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemRejectionSampling) {
      println("==================================================")
      println("  SciAlgo: Rejection Sampling (Target Envelope)")
      println("==================================================")

      #L Alvo p(x) = triangular em [0, 10]: p(x) = 2x para x<=5, 2(10-x) para x>5
      #L Envelope majorante M * q(x) = 10 (uniforme em [0, 10])
      mut as int64: accepted = 0
      mut as int64: trials = 20

      mut as int64: lcg = 13
      mut as int64: t = 1
      infinite (t <= trials) {
            #L Gera proposta x em [1, 10]
            lcg = (((lcg * 47) + 29) /r 100)
            mut as int64: prop_x = (lcg /i 10) + 1

            #L Altura do alvo
            mut as int64: target_p = prop_x * 2
            route {
                  prop_x > 5 ==> {
                        target_p = (10 - prop_x) * 2
                  }
                  _ ==> {}
            }

            #L Amostra uniforme u em [0, 10]
            mut as int64: u = (lcg /r 10) + 1
            route {
                  u <= target_p ==> {
                        accepted = accepted + 1
                  }
                  _ ==> {}
            }
            t = t + 1
      }

      println("1. Amostras aceitas: " + accepted + " / " + trials)
      route {
            accepted >= 5 ==> {
                  println("   [PASS] Rejection Sampling gerou amostras sob o envelope com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Rejection Sampling.")
            }
      }

      println("==================================================")
      println("Rejection Sampling concluido com sucesso!")
}
