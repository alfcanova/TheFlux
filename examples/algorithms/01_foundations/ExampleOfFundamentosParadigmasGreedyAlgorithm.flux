#L ============================================================================
#L Algoritmo: Greedy Algorithm (Algoritmo Guloso)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N log N) tempo | O(N) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasGreedyAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Greedy Algorithm (Algoritmo Guloso)")
      println("==================================================")

      #L Caso 1: Selecao de Atividades (Interval Scheduling)
      #L Atividades com tempos de inicio (s) e fim (f) ja ordenadas por fim
      mut as list of int64: act_id = [1, 2, 3, 4, 5, 6]
      mut as list of int64: start_times = [1, 3, 0, 5, 8, 5]
      mut as list of int64: finish_times = [2, 4, 6, 7, 9, 9]
      mut as int64: n_act = listLength(act_id)

      println("1. Atividades disponiveis: " + act_id)
      println("   Inicios: " + start_times)
      println("   Terminos: " + finish_times)

      mut as list of int64: selected_acts = [act_id[1]]
      mut as int64: last_finish = finish_times[1]

      mut as int64: i = 2
      infinite (i <= n_act) {
            route {
                  start_times[i] >= last_finish ==> {
                        selected_acts = listPushBack(selected_acts, act_id[i])
                        last_finish = finish_times[i]
                  }
                  _ ==> {
                  }
            }
            i = i + 1
      }
      println("2. Atividades selecionadas gulosamente: " + selected_acts)

      #L Caso 2: Problema do Troco Guloso (Sistema Canonico)
      mut as list of int64: coins = [100, 50, 20, 10, 5, 2, 1]
      mut as int64: target_change = 87
      println("3. Troco alvo: " + target_change)

      mut as list of int64: coins_used = []
      mut as int64: remaining = target_change
      mut as int64: ci = 1
      mut as int64: n_coins = listLength(coins)

      infinite (ci <= n_coins and remaining > 0) {
            mut as int64: c_val = coins[ci]
            mut as int64: count = remaining /i c_val
            infinite (count > 0) {
                  coins_used = listPushBack(coins_used, c_val)
                  remaining = remaining - c_val
                  count = count - 1
            }
            ci = ci + 1
      }
      println("4. Moedas utilizadas pelo algoritmo guloso: " + coins_used)
      println("5. Total de moedas: " + listLength(coins_used))
      println("Concluido com Sucesso")
}
