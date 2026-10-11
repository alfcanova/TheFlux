#L ============================================================================
#L Algoritmo: Prune and Search (Paradigma de Poda e Busca)
#L Dominio: 01_foundations / Fundamentos e Paradigmas
#L Complexidade: O(n) tempo | O(n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasPruneAndSearch) {
      println("==================================================")
      println("  SciAlgo: Prune and Search (Poda e Busca)        ")
      println("==================================================")

      mut as list of int64: arr = [12, 3, 5, 7, 4, 19, 26]
      mut as int64: k = 4
      println("1. Vetor Original: " + arr + " | Alvo k = " + k)

      mut as list of int64: current_set = arr
      mut as int64: current_k = k
      mut as int64: result = 0
      mut as bool: searching = true
      mut as int64: round = 1

      infinite (searching and round <= 10) {
            mut as int64: sz = listLength(current_set)
            route {
                  sz == 1 ==> {
                        result = current_set[1]
                        searching = false
                  }
                  _ ==> {
                        mut as int64: pivot = current_set[1]
                        mut as list of int64: left = []
                        mut as list of int64: equal = []
                        mut as list of int64: right = []

                        mut as int64: i = 1
                        infinite (i <= sz) {
                              mut as int64: val = current_set[i]
                              route {
                                    val < pivot ==> {
                                          left = listPushBack(left, val)
                                    }
                                    val == pivot ==> {
                                          equal = listPushBack(equal, val)
                                    }
                                    _ ==> {
                                          right = listPushBack(right, val)
                                    }
                              }
                              i = i + 1
                        }

                        mut as int64: len_left = listLength(left)
                        mut as int64: len_eq = listLength(equal)

                        #L Poda o espaco de busca
                        route {
                              current_k <= len_left ==> {
                                    current_set = left
                              }
                              current_k <= len_left + len_eq ==> {
                                    result = pivot
                                    searching = false
                              }
                              _ ==> {
                                    current_set = right
                                    current_k = current_k - len_left - len_eq
                              }
                        }
                  }
            }
            round = round + 1
      }

      println("2. Elemento na Posicao k=" + k + ": " + result)
      mut as bool: ok = (result == 7)
      println("3. Validacao (4o menor elemento == 7): " + ok)
      println("==================================================")
}
