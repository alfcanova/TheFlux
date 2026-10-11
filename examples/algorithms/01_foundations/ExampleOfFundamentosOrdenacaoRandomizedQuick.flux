#L ============================================================================
#L Algoritmo: Randomized QuickSort (Pivoteamento Pseudo-Aleatório)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) tempo esperado | O(log N) espaço auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoRandomizedQuick) {
      println("==================================================")
      println("  SciAlgo: Randomized QuickSort (Pivô Aleatório)")
      println("==================================================")

      mut as list of int64: arr = [42, 17, 89, 3, 25, 64, 11, 78, 55, 9, 31, 2]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Pilhas explícitas para partição iterativa (elimina risco de estouro de pilha)
      mut as list of int64: st_low = [1]
      mut as list of int64: st_high = [n]

      #L Gerador Congruencial Linear (LCG) determinístico
      mut as int64: seed = 123456789
      mut as int64: lcg_m = 2147483647
      mut as int64: lcg_a = 48271

      infinite (listLength(st_low) > 0) {
            mut as int64: top_idx = listLength(st_low)
            mut as int64: low = st_low[top_idx]
            mut as int64: high = st_high[top_idx]

            #L Remove topo das pilhas
            mut as list of int64: new_sl = []
            mut as list of int64: new_sh = []
            mut as int64: si = 1
            infinite (si < top_idx) {
                  new_sl = listPushBack(new_sl, st_low[si])
                  new_sh = listPushBack(new_sh, st_high[si])
                  si = si + 1
            }
            st_low = new_sl
            st_high = new_sh

            route {
                  low < high ==> {
                        #L Passo LCG para escolher pivô estocástico no intervalo [low, high]
                        seed = ((seed * lcg_a) + 1) /r lcg_m
                        route {
                              seed < 0 ==> {
                                    seed = 0 - seed
                              }
                        }
                        mut as int64: span = (high - low) + 1
                        mut as int64: p_offset = seed /r span
                        mut as int64: p_idx = low + p_offset

                        #L Troca arr[p_idx] com arr[high]
                        mut as int64: tmp_p = arr[p_idx]
                        arr[p_idx] = arr[high]
                        arr[high] = tmp_p

                        #L Particionamento Lomuto
                        mut as int64: pivot = arr[high]
                        mut as int64: i = low
                        mut as int64: j = low
                        infinite (j < high) {
                              route {
                                    arr[j] <= pivot ==> {
                                          mut as int64: tmp_j = arr[i]
                                          arr[i] = arr[j]
                                          arr[j] = tmp_j
                                          i = i + 1
                                    }
                              }
                              j = j + 1
                        }

                        #L Posiciona pivô no ponto de partição
                        mut as int64: tmp_end = arr[i]
                        arr[i] = arr[high]
                        arr[high] = tmp_end
                        mut as int64: p = i

                        #L Empilha partições esquerda e direita
                        route {
                              low < (p - 1) ==> {
                                    st_low = listPushBack(st_low, low)
                                    st_high = listPushBack(st_high, p - 1)
                              }
                        }
                        route {
                              (p + 1) < high ==> {
                                    st_low = listPushBack(st_low, p + 1)
                                    st_high = listPushBack(st_high, high)
                              }
                        }
                  }
            }
      }

      println("2. Vetor ordenado: " + arr)

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

      println("3. Verificacao de corretude do Randomized QuickSort: " + ordenado)
      println("==================================================")
}
