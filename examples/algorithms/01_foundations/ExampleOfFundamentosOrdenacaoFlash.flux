#L ============================================================================
#L Algoritmo: Flashsort (Classificação Probabilística e Permutação Ciclo)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N) tempo esperado | O(M) memória auxiliar | Quase In-Place
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoFlash) {
      println("==================================================")
      println("  SciAlgo: Flashsort (Distribuicao e Permutacao)")
      println("==================================================")

      mut as list of int64: arr = [25, 4, 13, 89, 42, 67, 10, 55, 31, 78, 19, 47, 95, 2, 60, 36]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Localiza mínimo e índice do máximo
      mut as int64: min_val = arr[1]
      mut as int64: max_val = arr[1]
      mut as int64: i = 2
      infinite (i <= n) {
            mut as int64: val = arr[i]
            route {
                  val < min_val ==> {
                        min_val = val
                  }
                  val > max_val ==> {
                        max_val = val
                  }
            }
            i = i + 1
      }

      mut as int64: range_val = max_val - min_val
      println("2. Minimo: " + min_val + ", Maximo: " + max_val + ", Amplitude: " + range_val)

      route {
            min_val == max_val ==> {
                  println("Vetor ja homogêneo e ordenado.")
            }
            _ ==> {
                  mut as int64: m = 5
                  #L Inicializa vetor de classes L com zeros
                  mut as list of int64: L = []
                  i = 1
                  infinite (i <= m) {
                        L = listPushBack(L, 0)
                        i = i + 1
                  }

                  #L Passo 1: Classificação e contagem
                  i = 1
                  infinite (i <= n) {
                        mut as int64: c = 1 + ((m - 1) * (arr[i] - min_val)) /i range_val
                        route {
                              c > m ==> { c = m }
                              c < 1 ==> { c = 1 }
                        }
                        L[c] = L[c] + 1
                        i = i + 1
                  }
                  println("3. Contagem por classe: " + L)

                  #L Passo 2: Somas cumulativas
                  i = 2
                  infinite (i <= m) {
                        L[i] = L[i] + L[i - 1]
                        i = i + 1
                  }
                  println("4. Limites cumulativos de classe: " + L)

                  #L Passo 3: Permutação de ciclo-líder
                  mut as int64: nmove = 0
                  mut as int64: j = 1
                  mut as int64: k = m

                  infinite (nmove < (n - 1)) {
                        infinite (j > L[k]) {
                              j = j + 1
                              k = 1 + ((m - 1) * (arr[j] - min_val)) /i range_val
                              route {
                                    k > m ==> { k = m }
                                    k < 1 ==> { k = 1 }
                              }
                        }

                        mut as int64: flash = arr[j]
                        infinite (j != (L[k] + 1)) {
                              k = 1 + ((m - 1) * (flash - min_val)) /i range_val
                              route {
                                    k > m ==> { k = m }
                                    k < 1 ==> { k = 1 }
                              }
                              mut as int64: dest = L[k]
                              mut as int64: hold = arr[dest]
                              arr[dest] = flash
                              flash = hold
                              L[k] = L[k] - 1
                              nmove = nmove + 1
                        }
                  }

                  #L Passo 4: Ordenação por Inserção local
                  i = 2
                  infinite (i <= n) {
                        mut as int64: key = arr[i]
                        mut as int64: p = i - 1
                        infinite (p >= 1) {
                              route {
                                    arr[p] > key ==> {
                                          arr[p + 1] = arr[p]
                                          p = p - 1
                                    }
                                    _ ==> {
                                          break
                                    }
                              }
                        }
                        arr[p + 1] = key
                        i = i + 1
                  }
            }
      }

      println("5. Vetor ordenado pelo Flashsort: " + arr)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      i = 1
      infinite (i < n) {
            route {
                  arr[i] > arr[i + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            i = i + 1
      }
      println("6. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
