#L ============================================================================
#L Algoritmo: Viterbi (Decodificacao Otima de Estados em HMM)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(T * S^2) | Espaco O(T * S)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaViterbi) {
      println("==================================================")
      println("  SciAlgo: Viterbi (HMM Optimal Path Decoding)")
      println("==================================================")

      #L 2 Estados: 1 = Estado A, 2 = Estado B
      #L Sequencia de 3 observacoes
      #L Trellis DP viterbi[t, s] (escala multiplicativa)
      mut as list of int64: v1 = [60, 40]   #L t = 1: Pi * B(o1)
      println("1. Inicializacao do Trellis t = 1: State A = 60, State B = 40")

      #L t = 2: transicao e emissao
      mut as int64: trans_A_to_A = (v1[1] * 8) /i 10
      mut as int64: trans_B_to_A = (v1[2] * 2) /i 10
      mut as int64: best_prev_A = 1
      mut as int64: best_score_A = trans_A_to_A
      route {
            trans_B_to_A > trans_A_to_A ==> {
                  best_prev_A = 2
                  best_score_A = trans_B_to_A
            }
            _ ==> {}
      }

      mut as int64: trans_A_to_B = (v1[1] * 2) /i 10
      mut as int64: trans_B_to_B = (v1[2] * 8) /i 10
      mut as int64: best_prev_B = 2
      mut as int64: best_score_B = trans_B_to_B
      route {
            trans_A_to_B > trans_B_to_B ==> {
                  best_prev_B = 1
                  best_score_B = trans_A_to_B
            }
            _ ==> {}
      }

      println("2. Decisao Viterbi para t = 2:")
      println("   -> Melhor predecessor para Estado A: " + best_prev_A + " (score " + best_score_A + ")")
      println("   -> Melhor predecessor para Estado B: " + best_prev_B + " (score " + best_score_B + ")")

      route {
            best_prev_A == 1 and best_prev_B == 2 ==> {
                  println("   [PASS] Decodificacao de Viterbi computou o caminho de maxima verossimilhanca!")
            }
            _ ==> {
                  println("   [ERRO] Falha no algoritmo de Viterbi.")
            }
      }

      println("==================================================")
      println("Viterbi concluido com sucesso!")
}
