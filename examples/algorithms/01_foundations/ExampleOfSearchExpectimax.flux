#L ============================================================================
#L Algoritmo: Expectimax (Jogos com Incerteza e Nos de Chance)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^d) tempo ponderado por probabilidade
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchExpectimax) {
      println("==================================================")
      println("  SciAlgo: Expectimax Algorithm (Probabilistic Games)")
      println("==================================================")

      #L Acao 1 leva ao No de Chance 1:
      #L   Desfecho 1A: Recompensa 10 (probabilidade 50%)
      #L   Desfecho 1B: Recompensa 2  (probabilidade 50%)
      #L Esperanca ponderada (multiplicada por 100 para precisao inteira):
      #L E(Acao 1) = (50 * 10) + (50 * 2) = 500 + 100 = 600 centesimos (6.0)
      mut as int64: prob_1a = 50
      mut as int64: val_1a = 10
      mut as int64: prob_1b = 50
      mut as int64: val_1b = 2
      mut as int64: exp_action1 = (prob_1a * val_1a) + (prob_1b * val_1b)

      #L Acao 2 leva ao No de Chance 2:
      #L   Desfecho 2A: Recompensa 20 (probabilidade 20%)
      #L   Desfecho 2B: Recompensa 4  (probabilidade 80%)
      #L E(Acao 2) = (20 * 20) + (80 * 4) = 400 + 320 = 720 centesimos (7.2)
      mut as int64: prob_2a = 20
      mut as int64: val_2a = 20
      mut as int64: prob_2b = 80
      mut as int64: val_2b = 4
      mut as int64: exp_action2 = (prob_2a * val_2a) + (prob_2b * val_2b)

      println("1. Esperanca calculada para Acao 1: " + (exp_action1 /i 100) + "." + (exp_action1 /r 100))
      println("2. Esperanca calculada para Acao 2: " + (exp_action2 /i 100) + "." + (exp_action2 /r 100))

      #L Decisao do No MAX na raiz: escolhe a acao com maior esperanca
      mut as int64: best_action = 1
      mut as int64: max_expected = exp_action1

      route {
            exp_action2 > exp_action1 ==> {
                  best_action = 2
                  max_expected = exp_action2
            }
      }

      println("3. Melhor acao escolhida pelo Expectimax: " + best_action)
      println("4. Esperanca maxima alcancada: " + max_expected)
      println("5. Validacao: " + (best_action == 2 and max_expected == 720))
      println("==================================================")
}
