#L ============================================================================
#L Algoritmo: Monotonic Queue (Fila Monotonica / Deque Decrescente)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(1) amortizado por operacao | O(K) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysMonotonicQueue) {
      println("==================================================")
      println("  SciAlgo: Monotonic Queue (Decreasing Deque)")
      println("==================================================")

      #L Fila duplamente terminada que mantem elementos em ordem decrescente
      mut as list of int64: deque = []

      #L Sequencia de operacoes:
      #L 1. Push(5)
      deque = listPushBack(deque, 5)
      println("1. Push(5)   -> Deque: " + deque + " | Max = " + deque[1])

      #L 2. Push(2)
      deque = listPushBack(deque, 2)
      println("2. Push(2)   -> Deque: " + deque + " | Max = " + deque[1])

      #L 3. Push(8): remove elementos menores que 8 do fundo (2 e 5 saem)
      mut as bool: popping1 = true
      infinite (listLength(deque) > 0 and popping1) {
            mut as int64: last_idx = listLength(deque)
            route {
                  deque[last_idx] < 8 ==> {
                        mut as list of int64: nd1 = []
                        mut as int64: s1 = 1
                        infinite (s1 < last_idx) {
                              nd1 = listPushBack(nd1, deque[s1])
                              s1 = s1 + 1
                        }
                        deque = nd1
                  }
                  _ ==> {
                        popping1 = false
                  }
            }
      }
      deque = listPushBack(deque, 8)
      println("3. Push(8)   -> Deque: " + deque + " | Max = " + deque[1])

      #L 4. Push(3)
      mut as bool: popping2 = true
      infinite (listLength(deque) > 0 and popping2) {
            mut as int64: last_idx2 = listLength(deque)
            route {
                  deque[last_idx2] < 3 ==> {
                        mut as list of int64: nd2 = []
                        mut as int64: s2 = 1
                        infinite (s2 < last_idx2) {
                              nd2 = listPushBack(nd2, deque[s2])
                              s2 = s2 + 1
                        }
                        deque = nd2
                  }
                  _ ==> {
                        popping2 = false
                  }
            }
      }
      deque = listPushBack(deque, 3)
      println("4. Push(3)   -> Deque: " + deque + " | Max = " + deque[1])

      #L 5. Pop(5): como a frente eh 8 (5 ja foi descartado), nada muda
      route {
            listLength(deque) > 0 and deque[1] == 5 ==> {
                  mut as list of int64: nd3 = []
                  mut as int64: s3 = 2
                  infinite (s3 <= listLength(deque)) {
                        nd3 = listPushBack(nd3, deque[s3])
                        s3 = s3 + 1
                  }
                  deque = nd3
            }
            _ ==> {
            }
      }
      println("5. Pop(5)    -> Deque: " + deque + " (5 ja descartado) | Max = " + deque[1])

      #L 6. Pop(8): a frente eh 8, entao o 8 eh removido
      route {
            listLength(deque) > 0 and deque[1] == 8 ==> {
                  mut as list of int64: nd4 = []
                  mut as int64: s4 = 2
                  infinite (s4 <= listLength(deque)) {
                        nd4 = listPushBack(nd4, deque[s4])
                        s4 = s4 + 1
                  }
                  deque = nd4
            }
            _ ==> {
            }
      }
      println("6. Pop(8)    -> Deque: " + deque + " (8 removido)     | Max = " + deque[1])
}
