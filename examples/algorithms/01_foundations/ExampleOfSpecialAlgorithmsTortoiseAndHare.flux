#L ============================================================================
#L Algoritmo: Tortoise and Hare (Deteccao de Ciclos de Floyd)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSpecialAlgorithmsTortoiseAndHare) {
      println("==================================================")
      println("  SciAlgo: Floyd's Tortoise and Hare Cycle Finding")
      println("==================================================")

      #L Grafo em forma de Rho (cauda + ciclo):
      #L 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8 -> (volta para 4)
      #L Inicio do ciclo: no 4 | Comprimento do ciclo: 5 (nos 4,5,6,7,8)
      mut as list of int64: next_node = [2, 3, 4, 5, 6, 7, 8, 4]
      println("1. Estrutura mapeada: 1->2->3->4->5->6->7->8->4")

      #L Fase 1: Encontro da tartaruga e da lebre no ciclo
      mut as int64: tortoise = 1
      mut as int64: hare = 1
      mut as int64: steps_phase1 = 0

      infinite (true) {
            steps_phase1 = steps_phase1 + 1
            tortoise = next_node[tortoise]
            hare = next_node[next_node[hare]]
            route {
                  tortoise == hare ==> {
                        break
                  }
            }
      }
      println("2. Ponto de colisao da lebre e tartaruga: no " + tortoise + " (passos: " + steps_phase1 + ")")

      #L Fase 2: Localizacao da entrada do ciclo
      #L Mantem a lebre no ponto de colisao e move a tartaruga de volta para o inicio (1)
      tortoise = 1
      mut as int64: cycle_start = 0
      mut as int64: steps_phase2 = 0

      infinite (tortoise != hare) {
            steps_phase2 = steps_phase2 + 1
            tortoise = next_node[tortoise]
            hare = next_node[hare]
      }
      cycle_start = tortoise
      println("3. No de entrada do ciclo identificado: " + cycle_start + " (passos da cauda: " + steps_phase2 + ")")

      #L Fase 3: Calculo do comprimento do ciclo
      mut as int64: cycle_length = 1
      mut as int64: runner = next_node[cycle_start]
      infinite (runner != cycle_start) {
            cycle_length = cycle_length + 1
            runner = next_node[runner]
      }
      println("4. Comprimento do ciclo (periodo): " + cycle_length)
      println("5. Validacao: " + (cycle_start == 4 and cycle_length == 5 and steps_phase2 == 3))
      println("==================================================")
}
