#L ============================================================================
#L Algoritmo: Median of Medians (Algoritmo BFPRT - Mediana das Medianas)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) estrito no pior caso | O(N) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysMedianOfMedians) {
      println("==================================================")
      println("  SciAlgo: Median of Medians (BFPRT)")
      println("==================================================")

      mut as list of int64: arr = [12, 3, 5, 7, 4, 19, 26, 1, 15, 22, 10, 8, 14, 2, 6]
      mut as int64: n = listLength(arr)
      println("1. Array original (N = " + n + "): " + arr)

      #L Divisao em blocos de 5 elementos e extracao da mediana de cada bloco
      mut as list of int64: medians = []
      mut as int64: b_start = 1
      infinite (b_start <= n) {
            mut as int64: b_end = b_start + 4
            route {
                  b_end > n ==> {
                        b_end = n
                  }
                  _ ==> {
                  }
            }

            #L Extrai e ordena o bloco de ate 5 elementos
            mut as list of int64: block = []
            mut as int64: idx = b_start
            infinite (idx <= b_end) {
                  block = listPushBack(block, arr[idx])
                  idx = idx + 1
            }

            #L Ordena o bloco pequeno
            mut as int64: b_len = listLength(block)
            mut as int64: u = 1
            infinite (u <= b_len) {
                  mut as int64: v = u + 1
                  infinite (v <= b_len) {
                        route {
                              block[v] < block[u] ==> {
                                    mut as int64: sw = block[u]
                                    block[u] = block[v]
                                    block[v] = sw
                              }
                              _ ==> {
                              }
                        }
                        v = v + 1
                  }
                  u = u + 1
            }

            #L Mediana do bloco
            mut as int64: med_idx = (b_len + 1) /i 2
            medians = listPushBack(medians, block[med_idx])

            b_start = b_start + 5
      }

      println("2. Medianas dos blocos de 5: " + medians)

      #L Mediana das medianas (pivo ideal para particao garantida)
      mut as int64: m_len = listLength(medians)
      mut as int64: mu = 1
      infinite (mu <= m_len) {
            mut as int64: mv = mu + 1
            infinite (mv <= m_len) {
                  route {
                        medians[mv] < medians[mu] ==> {
                              mut as int64: msw = medians[mu]
                              medians[mu] = medians[mv]
                              medians[mv] = msw
                        }
                        _ ==> {
                        }
                  }
                  mv = mv + 1
            }
            mu = mu + 1
      }
      mut as int64: mom = medians[(m_len + 1) /i 2]
      println("3. Mediana das medianas (Pivo BFPRT): " + mom)

      #L Particao usando o pivo BFPRT
      mut as list of int64: less = []
      mut as list of int64: equal = []
      mut as list of int64: greater = []

      mut as int64: i = 1
      infinite (i <= n) {
            route {
                  arr[i] < mom ==> {
                        less = listPushBack(less, arr[i])
                  }
                  arr[i] == mom ==> {
                        equal = listPushBack(equal, arr[i])
                  }
                  _ ==> {
                        greater = listPushBack(greater, arr[i])
                  }
            }
            i = i + 1
      }

      println("4. Particao em torno do pivo " + mom + ":")
      println("   Menores (" + listLength(less) + "): " + less)
      println("   Iguais  (" + listLength(equal) + "): " + equal)
      println("   Maiores (" + listLength(greater) + "): " + greater)

      #L Verificacao de balanceamento da particao BFPRT (garantia 30%-70%)
      mut as int64: rank_mom = listLength(less) + 1
      println("5. Posto (1-based) da mediana das medianas no array: " + rank_mom + " de " + n)
}
