#L ============================================================================
#L Algoritmo: Hill Climbing (Subida de Encosta / Steepest Ascent)
#L Dominio: 01_foundations / Busca
#L Complexidade: O(passos * vizinhos) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaHillClimbing) {
      println("==================================================")
      println("  SciAlgo: Hill Climbing (Subida de Encosta)      ")
      println("==================================================")

      #L Maximizacao da funcao concava f(x) = -(x - 5)^2 + 25
      #L O pico ocorre em x = 5, f(5) = 25
      mut as int64: current_x = 0
      mut as int64: current_score = 0 - (current_x - 5) * (current_x - 5) + 25

      println("1. Posicao Inicial: x = " + current_x + " | Score: " + current_score)

      mut as bool: climbing = true
      mut as int64: steps = 0

      infinite (climbing and steps < 20) {
            steps = steps + 1
            mut as int64: best_neighbor = current_x
            mut as int64: best_neighbor_score = current_score

            #L Avalia vizinho a esquerda: x - 1
            mut as int64: left_x = current_x - 1
            mut as int64: left_score = 0 - (left_x - 5) * (left_x - 5) + 25
            route {
                  left_score > best_neighbor_score ==> {
                        best_neighbor = left_x
                        best_neighbor_score = left_score
                  }
            }

            #L Avalia vizinho a direita: x + 1
            mut as int64: right_x = current_x + 1
            mut as int64: right_score = 0 - (right_x - 5) * (right_x - 5) + 25
            route {
                  right_score > best_neighbor_score ==> {
                        best_neighbor = right_x
                        best_neighbor_score = right_score
                  }
            }

            #L Se nenhum vizinho for estritamente melhor, atingiu o pico
            route {
                  best_neighbor_score > current_score ==> {
                        current_x = best_neighbor
                        current_score = best_neighbor_score
                  }
                  _ ==> {
                        climbing = false
                  }
            }
      }

      println("2. Pico Atingido: x = " + current_x + " | Score Maximo: " + current_score)
      println("3. Total de Passos de Subida: " + steps)
      mut as bool: ok = (current_x == 5 and current_score == 25)
      println("4. Validacao (Maximo x=5, f(x)=25): " + ok)
      println("==================================================")
}
