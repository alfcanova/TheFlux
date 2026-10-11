#L ============================================================================
#L Algoritmo: Metropolis-Hastings (Amostrador com Taxa de Aceitacao)
#L Dominio: 07_optimization_stat / Categoria: Probabilidade e amostragem
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAmostragemMetropolisHastings) {
      println("==================================================")
      println("  SciAlgo: Metropolis-Hastings (Target Sampling)")
      println("==================================================")

      #L Alvo p(x) proporcional a exp(-x^2 / 200) com x em discretizacao
      #L Densidade proporcional a 1000 - (x^2 / 2) para |x| < 40
      mut as int64: curr_x = 0
      mut as int64: accepted_moves = 0
      mut as int64: total_moves = 50

      mut as int64: lcg = 29
      mut as int64: m = 1
      infinite (m <= total_moves) {
            #L Proposta candidata x_prop = curr_x + delta (delta in {-2, +2})
            lcg = (((lcg * 79) + 17) /r 100)
            mut as int64: delta = 2
            route {
                  lcg < 50 ==> { delta = -2 }
                  _ ==> {}
            }
            mut as int64: cand_x = curr_x + delta

            #L Avalia verossimilhanca relativa
            mut as int64: p_curr = 1000 - ((curr_x * curr_x) /i 2)
            mut as int64: p_cand = 1000 - ((cand_x * cand_x) /i 2)

            #L Aceita se p_cand >= p_curr ou com probabilidade p_cand / p_curr
            route {
                  p_cand >= p_curr ==> {
                        curr_x = cand_x
                        accepted_moves = accepted_moves + 1
                  }
                  _ ==> {
                        mut as int64: ratio = (p_cand * 100) /i p_curr
                        route {
                              lcg < ratio ==> {
                                    curr_x = cand_x
                                    accepted_moves = accepted_moves + 1
                              }
                              _ ==> {}
                        }
                  }
            }
            m = m + 1
      }

      println("1. Movimentos aceitos pelo criterio Metropolis: " + accepted_moves + " / " + total_moves)
      println("2. Posicao final da cadeia: " + curr_x)

      route {
            accepted_moves >= 20 ==> {
                  println("   [PASS] Metropolis-Hastings amostrou a distribuicao com taxa de aceitacao valida!")
            }
            _ ==> {
                  println("   [ERRO] Baixa taxa de aceitacao.")
            }
      }

      println("==================================================")
      println("Metropolis-Hastings concluido com sucesso!")
}
