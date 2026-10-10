#L ============================================================================
#L Algoritmo: Fisher-Yates Shuffle (Embaralhamento de Fisher-Yates / Knuth)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysFisherYates) {
      println("==================================================")
      println("  SciAlgo: Fisher-Yates Shuffle")
      println("==================================================")

      mut as list of int64: arr = [10, 20, 30, 40, 50, 60, 70, 80]
      mut as int64: n = listLength(arr)
      println("1. Array original (tamanho " + n + "): " + arr)

      #L PRNG deterministico LCG (Linear Congruential Generator):
      #L state = (state * 1103515245 + 12345) & 0x7FFFFFFF
      mut as int64: rng_state = 123456789

      #L Fisher-Yates: iterar de n ate 2 e trocar arr[i] com arr[j] onde j in [1..i]
      mut as int64: i = n
      infinite (i >= 2) {
            rng_state = (rng_state * 1103515245 + 12345) /r 2147483647
            route {
                  rng_state < 0 ==> {
                        rng_state = rng_state + 2147483647
                  }
                  _ ==> {
                  }
            }

            mut as int64: j = (rng_state /r i) + 1
            mut as int64: tmp = arr[i]
            arr[i] = arr[j]
            arr[j] = tmp

            i = i - 1
      }

      println("2. Array embaralhado deterministico: " + arr)

      #L Validacao de conservacao dos elementos (soma invariante)
      mut as int64: sum_original = 10 + 20 + 30 + 40 + 50 + 60 + 70 + 80
      mut as int64: sum_shuffled = 0
      mut as int64: idx = 1
      infinite (idx <= n) {
            sum_shuffled = sum_shuffled + arr[idx]
            idx = idx + 1
      }
      println("3. Soma esperada: " + sum_original + " | Soma obtida: " + sum_shuffled)
      route {
            sum_shuffled == sum_original ==> {
                  println("4. Invariante de conservacao: VALIDO")
            }
            _ ==> {
                  println("4. Invariante de conservacao: FALHA")
            }
      }
}
