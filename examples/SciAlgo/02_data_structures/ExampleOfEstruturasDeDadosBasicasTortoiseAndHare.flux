#L ============================================================================
#L Algoritmo: Floyd's Tortoise and Hare (Deteccao de Ciclos em Estruturas Ligadas)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados basicas
#L Complexidade: O(N) tempo | O(1) espaco auxiliar de ponteiros
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBasicasTortoiseAndHare) {
      println("==================================================")
      println("  SciAlgo: Tortoise and Hare (Estruturas Ligadas)")
      println("==================================================")

      #L Estrutura encadeada com ciclo (1-based):
      #L 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8 -> 4 (ciclo de tamanho 5 com cauda 3)
      mut as list of int64: next_node = [2, 3, 4, 5, 6, 7, 8, 4]
      println("1. Estrutura encadeada com ciclo mapeada: 1->2->3->4->5->6->7->8->4")

      #L Fase 1: Encontro dos dois ponteiros (rapido e lento)
      mut as int64: slow = 1
      mut as int64: fast = 1
      mut as int64: steps_phase1 = 0

      infinite (true) {
            steps_phase1 = steps_phase1 + 1
            slow = next_node[slow]
            fast = next_node[next_node[fast]]
            route {
                  slow == fast ==> {
                        break
                  }
            }
      }
      println("2. Ponto de encontro dos ponteiros: no " + slow + " (passos: " + steps_phase1 + ")")

      #L Fase 2: Localizacao da cabeca/entrada do ciclo
      slow = 1
      mut as int64: tail_len = 0
      infinite (slow != fast) {
            tail_len = tail_len + 1
            slow = next_node[slow]
            fast = next_node[fast]
      }
      mut as int64: cycle_entry = slow
      println("3. Entrada do ciclo identificada: no " + cycle_entry + " (comprimento da cauda: " + tail_len + ")")

      #L Fase 3: Calculo da circunferencia do ciclo
      mut as int64: cycle_length = 1
      mut as int64: walker = next_node[cycle_entry]
      infinite (walker != cycle_entry) {
            cycle_length = cycle_length + 1
            walker = next_node[walker]
      }
      println("4. Circunferencia do ciclo (periodo): " + cycle_length)
      println("5. Validacao: " + (cycle_entry == 4 and cycle_length == 5 and tail_len == 3))
      println("==================================================")
}
