#L ============================================================================
#L Algoritmo: Fibonacci Search (Busca de Fibonacci)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(log N) tempo | O(1) espaco (somente somas e subtracoes)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaFibonacci) {
      println("==================================================")
      println("  SciAlgo: Fibonacci Search")
      println("==================================================")

      mut as list of int64: arr = [10, 22, 35, 40, 45, 50, 80, 82, 85, 90, 100, 235]
      mut as int64: n = listLength(arr)
      println("1. Vetor ordenado (N = 12): " + arr)

      mut as int64: target = 85

      #L Inicializa numeros de Fibonacci: fibM2 = F(k-2), fibM1 = F(k-1), fibM = F(k)
      mut as int64: fibM2 = 0
      mut as int64: fibM1 = 1
      mut as int64: fibM = fibM2 + fibM1

      infinite (fibM < n) {
            fibM2 = fibM1
            fibM1 = fibM
            fibM = fibM2 + fibM1
      }

      mut as int64: offset = 0
      mut as int64: found_pos = 0
      mut as int64: steps = 0

      infinite (fibM > 1) {
            steps = steps + 1
            mut as int64: i = offset + fibM2
            route {
                  i > n ==> {
                        i = n
                  }
            }

            route {
                  arr[i] < target ==> {
                        fibM = fibM1
                        fibM1 = fibM2
                        fibM2 = fibM - fibM1
                        offset = i
                  }
                  arr[i] > target ==> {
                        fibM = fibM2
                        fibM1 = fibM1 - fibM2
                        fibM2 = fibM - fibM1
                  }
                  _ ==> {
                        found_pos = i
                        break
                  }
            }
      }

      route {
            found_pos == 0 and fibM1 == 1 and (offset + 1) <= n ==> {
                  route {
                        arr[offset + 1] == target ==> {
                              found_pos = offset + 1
                        }
                  }
            }
      }

      println("2. Alvo: " + target)
      println("3. Posicao encontrada: " + found_pos)
      println("4. Passos executados: " + steps)
      println("5. Validacao: " + (found_pos == 9 and arr[found_pos] == target))
      println("==================================================")
}
