#L ============================================================================
#L Algoritmo: Three-Way Quicksort (Bentley-McIlroy)
#L Dominio: 01_foundations / Ordenacao
#L Complexidade: O(n log n) tempo | O(log n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoThreeWayQuick) {
      println("==================================================")
      println("  SciAlgo: Three-Way Quicksort (Bentley-McIlroy)  ")
      println("==================================================")

      mut as list of int64: arr = [4, 2, 4, 1, 4, 3, 2, 4]
      mut as int64: n = listLength(arr)
      println("1. Vetor Original (Com Duplicatas): " + arr)

      #L Pilhas com capacidade pre-alocada
      mut as list of int64: stack_l = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: stack_r = [n, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top = 1

      infinite (top > 0) {
            mut as int64: l = stack_l[top]
            mut as int64: r = stack_r[top]
            top = top - 1

            route {
                  l < r ==> {
                        mut as int64: pivot = arr[l]
                        mut as int64: lt = l
                        mut as int64: gt = r
                        mut as int64: i = l + 1

                        infinite (i <= gt) {
                              route {
                                    arr[i] < pivot ==> {
                                          mut as int64: tmp = arr[lt]
                                          arr[lt] = arr[i]
                                          arr[i] = tmp
                                          lt = lt + 1
                                          i = i + 1
                                    }
                                    arr[i] > pivot ==> {
                                          mut as int64: tmp2 = arr[i]
                                          arr[i] = arr[gt]
                                          arr[gt] = tmp2
                                          gt = gt - 1
                                    }
                                    _ ==> {
                                          i = i + 1
                                    }
                              }
                        }

                        #L Empilha subproblemas [l, lt - 1] e [gt + 1, r]
                        route {
                              l < lt - 1 ==> {
                                    top = top + 1
                                    stack_l[top] = l
                                    stack_r[top] = lt - 1
                              }
                        }
                        route {
                              gt + 1 < r ==> {
                                    top = top + 1
                                    stack_l[top] = gt + 1
                                    stack_r[top] = r
                              }
                        }
                  }
            }
      }

      println("2. Vetor Ordenado: " + arr)
      #L Esperado: [1, 2, 2, 3, 4, 4, 4, 4]
      mut as bool: ok = (arr[1] == 1 and arr[2] == 2 and arr[3] == 2 and arr[4] == 3 and arr[5] == 4 and arr[6] == 4 and arr[7] == 4 and arr[8] == 4)
      println("3. Validacao (Duplicatas ordenadas): " + ok)
      println("==================================================")
}
