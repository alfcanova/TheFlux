#L ============================================================================
#L Algoritmo: Uniform Binary Search (Busca Binaria Uniforme de Knuth)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(log N) tempo | O(log N) espaco de tabela pre-computada
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaUniformBinary) {
      println("==================================================")
      println("  SciAlgo: Uniform Binary Search (Donald Knuth)")
      println("==================================================")

      mut as list of int64: arr = [4, 9, 15, 23, 38, 44, 51, 60, 67, 73, 81, 88, 92, 95, 99]
      mut as int64: n = listLength(arr)
      println("1. Vetor ordenado (N = 15): " + arr)

      mut as int64: target = 73

      #L Pre-computa tabela de deltas para N = 15 (potencias de 2 decrescentes)
      #L Inicio no elemento medio inicial: i = 8, com deltas 4, 2, 1
      mut as list of int64: deltas = [4, 2, 1, 0]
      mut as int64: delta_len = listLength(deltas)

      mut as int64: i = 8
      mut as int64: step = 1
      mut as int64: found_pos = 0

      infinite (step <= delta_len) {
            mut as int64: current_delta = deltas[step]
            route {
                  arr[i] == target ==> {
                        found_pos = i
                        break
                  }
                  target < arr[i] ==> {
                        route {
                              current_delta > 0 ==> {
                                    i = i - current_delta
                              }
                        }
                  }
                  _ ==> {
                        route {
                              current_delta > 0 ==> {
                                    i = i + current_delta
                              }
                        }
                  }
            }
            step = step + 1
      }

      println("2. Alvo: " + target)
      println("3. Posicao encontrada: " + found_pos)
      println("4. Passos na tabela uniforme: " + step)
      println("5. Validacao: " + (found_pos == 10 and arr[found_pos] == target))
      println("==================================================")
}
