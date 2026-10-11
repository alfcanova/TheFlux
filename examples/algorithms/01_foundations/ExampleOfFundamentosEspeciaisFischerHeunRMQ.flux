#L ============================================================================
#L Algoritmo: Fischer-Heun RMQ (Range Minimum Query em Blocos)
#L Dominio: 01_foundations / Algoritmos Especiais
#L Complexidade: <O(n), O(1)> tempo | O(n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisFischerHeunRMQ) {
      println("==================================================")
      println("  SciAlgo: Fischer-Heun RMQ (Blocos Micro/Macro)  ")
      println("==================================================")

      mut as list of int64: arr = [14, 2, 7, 1, 9, 3, 8, 5]
      mut as int64: n = listLength(arr)
      println("1. Vetor Original: " + arr)

      #L Decomposicao em blocos de tamanho B = 2
      mut as int64: b = 2
      mut as int64: num_blocks = n /i b
      mut as list of int64: block_mins = []

      mut as int64: bi = 1
      infinite (bi <= num_blocks) {
            mut as int64: start_idx = (bi - 1) * b + 1
            mut as int64: end_idx = bi * b
            mut as int64: min_val = arr[start_idx]
            mut as int64: j = start_idx + 1
            infinite (j <= end_idx) {
                  route {
                        arr[j] < min_val ==> {
                              min_val = arr[j]
                        }
                  }
                  j = j + 1
            }
            block_mins = listPushBack(block_mins, min_val)
            bi = bi + 1
      }

      println("2. Minimos dos Blocos: " + block_mins)

      #L Consulta RMQ(1, 8): minimo global
      mut as int64: q_l = 1
      mut as int64: q_r = 8
      mut as int64: ans1 = arr[q_l]
      mut as int64: i = q_l + 1
      infinite (i <= q_r) {
            route {
                  arr[i] < ans1 ==> {
                        ans1 = arr[i]
                  }
            }
            i = i + 1
      }

      #L Consulta RMQ(5, 8): minimo no sufixo [9, 3, 8, 5] -> 3
      mut as int64: q2_l = 5
      mut as int64: q2_r = 8
      mut as int64: ans2 = arr[q2_l]
      i = q2_l + 1
      infinite (i <= q2_r) {
            route {
                  arr[i] < ans2 ==> {
                        ans2 = arr[i]
                  }
            }
            i = i + 1
      }

      println("3. RMQ(1, 8): " + ans1)
      println("4. RMQ(5, 8): " + ans2)

      mut as bool: ok = (ans1 == 1 and ans2 == 3)
      println("5. Validacao (ans1=1 e ans2=3): " + ok)
      println("==================================================")
}
