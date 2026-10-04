#L ============================================================================
#L Algoritmo: Boyer-Moore Majority Vote (Voto Majoritario)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysBoyerMooreMajorityVote) {
      println("==================================================")
      println("  SciAlgo: Boyer-Moore Majority Vote")
      println("==================================================")

      #L Teste 1: Possui majoritario claro (2 aparece 4 vezes em 7)
      mut as list of int64: arr1 = [2, 2, 1, 1, 1, 2, 2]
      mut as int64: n1 = listLength(arr1)
      println("1. Array 1: " + arr1)

      mut as int64: cand1 = arr1[1]
      mut as int64: count1 = 0
      mut as int64: i1 = 1
      infinite (i1 <= n1) {
            route {
                  count1 == 0 ==> {
                        cand1 = arr1[i1]
                        count1 = 1
                  }
                  arr1[i1] == cand1 ==> {
                        count1 = count1 + 1
                  }
                  _ ==> {
                        count1 = count1 - 1
                  }
            }
            i1 = i1 + 1
      }

      #L Validacao da frequencia
      mut as int64: actual_cnt1 = 0
      i1 = 1
      infinite (i1 <= n1) {
            route {
                  arr1[i1] == cand1 ==> {
                        actual_cnt1 = actual_cnt1 + 1
                  }
                  _ ==> {
                  }
            }
            i1 = i1 + 1
      }

      route {
            actual_cnt1 > (n1 /i 2) ==> {
                  println("2. Majoritario encontrado: " + cand1 + " (frequencia: " + actual_cnt1 + " de " + n1 + ")")
            }
            _ ==> {
                  println("2. Nenhum majoritario")
            }
      }

      #L Teste 2: Array sem majoritario
      mut as list of int64: arr2 = [1, 2, 3, 4, 5]
      mut as int64: n2 = listLength(arr2)
      println("3. Array 2: " + arr2)

      mut as int64: cand2 = arr2[1]
      mut as int64: count2 = 0
      mut as int64: i2 = 1
      infinite (i2 <= n2) {
            route {
                  count2 == 0 ==> {
                        cand2 = arr2[i2]
                        count2 = 1
                  }
                  arr2[i2] == cand2 ==> {
                        count2 = count2 + 1
                  }
                  _ ==> {
                        count2 = count2 - 1
                  }
            }
            i2 = i2 + 1
      }

      mut as int64: actual_cnt2 = 0
      i2 = 1
      infinite (i2 <= n2) {
            route {
                  arr2[i2] == cand2 ==> {
                        actual_cnt2 = actual_cnt2 + 1
                  }
                  _ ==> {
                  }
            }
            i2 = i2 + 1
      }

      route {
            actual_cnt2 > (n2 /i 2) ==> {
                  println("4. Majoritario encontrado: " + cand2)
            }
            _ ==> {
                  println("4. Nenhum elemento majoritario encontrado (correto)")
            }
      }
}
