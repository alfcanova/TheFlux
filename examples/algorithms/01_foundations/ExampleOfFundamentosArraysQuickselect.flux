#L ============================================================================
#L Algoritmo: Quickselect (Selecao Rapida de Hoare)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo medio, O(N^2) pior caso | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysQuickselect) {
      println("==================================================")
      println("  SciAlgo: Quickselect (K-esimo Menor Elemento)")
      println("==================================================")

      mut as list of int64: original = [64, 34, 25, 12, 22, 11, 90, 88]
      mut as int64: n = listLength(original)
      println("1. Array original (tamanho " + n + "): " + original)

      #L Busca para K = 1 (Minimo), K = 3, K = 4 (Mediana inferior), K = 8 (Maximo)
      mut as list of int64: ks = [1, 3, 4, 8]
      mut as int64: q = 1

      infinite (q <= listLength(ks)) {
            mut as int64: k = ks[q]

            #L Cria copia do array para busca independente
            mut as list of int64: a = []
            mut as int64: c = 1
            infinite (c <= n) {
                  a = listPushBack(a, original[c])
                  c = c + 1
            }

            mut as int64: left = 1
            mut as int64: right = n
            mut as int64: ans = 0
            mut as bool: done = false

            infinite (left <= right and not done) {
                  route {
                        left == right ==> {
                              ans = a[left]
                              done = true
                        }
                        _ ==> {
                              mut as int64: pivot = a[right]
                              mut as int64: p_idx = left
                              mut as int64: idx = left

                              infinite (idx < right) {
                                    route {
                                          a[idx] <= pivot ==> {
                                                mut as int64: tmp = a[p_idx]
                                                a[p_idx] = a[idx]
                                                a[idx] = tmp
                                                p_idx = p_idx + 1
                                          }
                                          _ ==> {
                                          }
                                    }
                                    idx = idx + 1
                              }

                              mut as int64: tmp2 = a[p_idx]
                              a[p_idx] = a[right]
                              a[right] = tmp2

                              route {
                                    p_idx == k ==> {
                                          ans = a[p_idx]
                                          done = true
                                    }
                                    p_idx < k ==> {
                                          left = p_idx + 1
                                    }
                                    _ ==> {
                                          right = p_idx - 1
                                    }
                              }
                        }
                  }
            }

            println("2. K = " + k + " -> Elemento na posicao " + k + " ordenada: " + ans)
            q = q + 1
      }
}
