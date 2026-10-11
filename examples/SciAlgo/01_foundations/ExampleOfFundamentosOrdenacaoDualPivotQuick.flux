#L ============================================================================
#L Algoritmo: Dual-Pivot Quicksort (Yaroslavskiy)
#L Dominio: 01_foundations / Ordenacao
#L Complexidade: O(n log n) tempo | O(log n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoDualPivotQuick) {
      println("==================================================")
      println("  SciAlgo: Dual-Pivot Quicksort (Yaroslavskiy)    ")
      println("==================================================")

      mut as list of int64: arr = [24, 8, 42, 75, 2, 17, 33, 50]
      mut as int64: n = listLength(arr)
      println("1. Vetor Original: " + arr)

      #L Particionamento de dois pivos (Dual-Pivot)
      route {
            arr[1] > arr[n] ==> {
                  mut as int64: tmp = arr[1]
                  arr[1] = arr[n]
                  arr[n] = tmp
            }
      }

      mut as int64: p = arr[1]
      mut as int64: q = arr[n]

      mut as int64: lt = 2
      mut as int64: gt = n - 1
      mut as int64: k = 2

      infinite (k <= gt) {
            route {
                  arr[k] < p ==> {
                        mut as int64: tmp1 = arr[k]
                        arr[k] = arr[lt]
                        arr[lt] = tmp1
                        lt = lt + 1
                        k = k + 1
                  }
                  arr[k] > q ==> {
                        mut as bool: scanning = true
                        infinite (scanning) {
                              route {
                                    gt > k ==> {
                                          route {
                                                arr[gt] > q ==> {
                                                      gt = gt - 1
                                                }
                                                _ ==> {
                                                      scanning = false
                                                }
                                          }
                                    }
                                    _ ==> {
                                          scanning = false
                                    }
                              }
                        }
                        mut as int64: tmp2 = arr[k]
                        arr[k] = arr[gt]
                        arr[gt] = tmp2
                        gt = gt - 1
                        route {
                              arr[k] < p ==> {
                                    mut as int64: tmp3 = arr[k]
                                    arr[k] = arr[lt]
                                    arr[lt] = tmp3
                                    lt = lt + 1
                              }
                        }
                        k = k + 1
                  }
                  _ ==> {
                        k = k + 1
                  }
            }
      }

      lt = lt - 1
      gt = gt + 1

      mut as int64: tmp_p = arr[1]
      arr[1] = arr[lt]
      arr[lt] = tmp_p

      mut as int64: tmp_q = arr[n]
      arr[n] = arr[gt]
      arr[gt] = tmp_q

      #L Ordenacao dos segmentos finais via insertion seguro
      mut as int64: i = 2
      infinite (i <= n) {
            mut as int64: key = arr[i]
            mut as int64: j = i - 1
            infinite (j >= 1) {
                  route {
                        arr[j] > key ==> {
                              arr[j + 1] = arr[j]
                              j = j - 1
                        }
                        _ ==> {
                              break
                        }
                  }
            }
            arr[j + 1] = key
            i = i + 1
      }

      println("2. Vetor Ordenado: " + arr)
      #L Esperado: [2, 8, 17, 24, 33, 42, 50, 75]
      mut as bool: ok = (arr[1] == 2 and arr[2] == 8 and arr[3] == 17 and arr[4] == 24 and arr[5] == 33 and arr[6] == 42 and arr[7] == 50 and arr[8] == 75)
      println("3. Validacao (Ordenacao correta): " + ok)
      println("==================================================")
}
