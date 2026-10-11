#L ============================================================================
#L Algoritmo: Natural Merge Sort (Mesclagem de Corridas Naturais)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) pior caso | O(N) melhor caso (adaptativo)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoNaturalMerge) {
      println("==================================================")
      println("  SciAlgo: Natural Merge Sort (Corridas Naturais)")
      println("==================================================")

      mut as list of int64: arr = [5, 12, 18, 3, 9, 21, 2, 4, 15, 1, 7, 30]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      infinite (true) {
            #L Detecta corridas contínuas não-decrescentes
            mut as list of int64: run_start = []
            mut as list of int64: run_end = []
            mut as int64: i = 1

            infinite (i <= n) {
                  mut as int64: r_s = i
                  infinite (i < n) {
                        route {
                              arr[i] <= arr[i + 1] ==> {
                                    i = i + 1
                              }
                              _ ==> {
                                    break
                              }
                        }
                  }
                  run_start = listPushBack(run_start, r_s)
                  run_end = listPushBack(run_end, i)
                  i = i + 1
            }

            mut as int64: num_runs = listLength(run_start)
            #L Se houver apenas 1 corrida, o vetor já está totalmente ordenado
            route {
                  num_runs <= 1 ==> {
                        break
                  }
            }

            #L Vetor auxiliar para mesclagem
            mut as list of int64: temp = []
            mut as int64: cpy_i = 1
            infinite (cpy_i <= n) {
                  temp = listPushBack(temp, arr[cpy_i])
                  cpy_i = cpy_i + 1
            }

            #L Mescla pares adjacentes de corridas
            mut as int64: pair_idx = 1
            infinite (pair_idx <= num_runs) {
                  route {
                        (pair_idx + 1) <= num_runs ==> {
                              mut as int64: s1 = run_start[pair_idx]
                              mut as int64: e1 = run_end[pair_idx]
                              mut as int64: s2 = run_start[pair_idx + 1]
                              mut as int64: e2 = run_end[pair_idx + 1]

                              mut as int64: p1 = s1
                              mut as int64: p2 = s2
                              mut as int64: out_p = s1

                              infinite ((p1 <= e1) and (p2 <= e2)) {
                                    route {
                                          arr[p1] <= arr[p2] ==> {
                                                temp[out_p] = arr[p1]
                                                p1 = p1 + 1
                                          }
                                          _ ==> {
                                                temp[out_p] = arr[p2]
                                                p2 = p2 + 1
                                          }
                                    }
                                    out_p = out_p + 1
                              }

                              infinite (p1 <= e1) {
                                    temp[out_p] = arr[p1]
                                    p1 = p1 + 1
                                    out_p = out_p + 1
                              }

                              infinite (p2 <= e2) {
                                    temp[out_p] = arr[p2]
                                    p2 = p2 + 1
                                    out_p = out_p + 1
                              }

                              pair_idx = pair_idx + 2
                        }
                        _ ==> {
                              pair_idx = pair_idx + 1
                        }
                  }
            }
            arr = temp
      }

      println("2. Vetor ordenado pelo Natural Merge Sort: " + arr)

      #L Verificação de monotonicidade
      mut as bool: ordenado = true
      mut as int64: vi = 1
      infinite (vi < n) {
            route {
                  arr[vi] > arr[vi + 1] ==> {
                        ordenado = false
                  }
            }
            vi = vi + 1
      }

      println("3. Verificacao de corretude do Natural Merge Sort: " + ordenado)
      println("==================================================")
}
