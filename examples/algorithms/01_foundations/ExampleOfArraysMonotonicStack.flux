#L ============================================================================
#L Algoritmo: Monotonic Stack (Pilha Monotonica - NGE e PGE)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo | O(N) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysMonotonicStack) {
      println("==================================================")
      println("  SciAlgo: Monotonic Stack (Next Greater Element)")
      println("==================================================")

      mut as list of int64: arr = [4, 5, 2, 10, 8]
      mut as int64: n = listLength(arr)
      println("1. Array original (N = " + n + "): " + arr)

      #L Next Greater Element (NGE): primeiro elemento maior a direita
      mut as list of int64: nge = [-1, -1, -1, -1, -1]
      mut as list of int64: stack = [] #L armazena indices

      mut as int64: i = 1
      infinite (i <= n) {
            #L Desempilha enquanto o topo for menor que o elemento atual
            mut as bool: popping = true
            infinite (listLength(stack) > 0 and popping) {
                  mut as int64: top_idx = listLength(stack)
                  mut as int64: top_elem_idx = stack[top_idx]

                  route {
                        arr[top_elem_idx] < arr[i] ==> {
                              nge[top_elem_idx] = arr[i]
                              #L Remove do topo
                              mut as list of int64: new_stack = []
                              mut as int64: s = 1
                              infinite (s < top_idx) {
                                    new_stack = listPushBack(new_stack, stack[s])
                                    s = s + 1
                              }
                              stack = new_stack
                        }
                        _ ==> {
                              popping = false
                        }
                  }
            }

            stack = listPushBack(stack, i)
            i = i + 1
      }

      println("2. Next Greater Element para cada posicao:")
      mut as int64: k = 1
      infinite (k <= n) {
            println("   arr[" + k + "] = " + arr[k] + " -> NGE = " + nge[k])
            k = k + 1
      }
      println("3. Vetor NGE completo: " + nge)
}
