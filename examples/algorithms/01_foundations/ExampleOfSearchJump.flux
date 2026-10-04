#L ============================================================================
#L Algoritmo: Jump Search (Busca por Saltos)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(sqrt(N)) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchJump) {
      println("==================================================")
      println("  SciAlgo: Jump Search")
      println("==================================================")

      mut as list of int64: arr = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610]
      mut as int64: n = listLength(arr)
      println("1. Vetor ordenado (N = 16): " + arr)

      mut as int64: target = 55

      #L Calcula tamanho de salto aproximado: sqrt(16) = 4
      mut as int64: step = 4
      mut as int64: prev = 1
      mut as int64: jumps = 0

      #L Salta em blocos de tamanho 'step'
      infinite (step <= n and arr[step] < target) {
            jumps = jumps + 1
            prev = step + 1
            step = step + 4
      }

      route {
            step > n ==> {
                  step = n
            }
      }

      #L Busca linear dentro do bloco delimitado [prev, step]
      mut as int64: found_pos = 0
      mut as int64: curr = prev
      infinite (curr <= step) {
            route {
                  arr[curr] == target ==> {
                        found_pos = curr
                        break
                  }
            }
            curr = curr + 1
      }

      println("2. Alvo: " + target)
      println("3. Posicao encontrada: " + found_pos)
      println("4. Saltos de bloco executados: " + jumps)
      println("5. Validacao: " + (found_pos == 11 and arr[found_pos] == target))
      println("==================================================")
}
