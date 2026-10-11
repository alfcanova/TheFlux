#L ============================================================================
#L Algoritmo: Shear Sort (Rede de Ordenacao Bidimensional)
#L Dominio: 01_foundations / Ordenacao
#L Complexidade: O(R * log R) fases | O(R * C) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoShear) {
      println("==================================================")
      println("  SciAlgo: Shear Sort (Ordenacao em Malha 2D)     ")
      println("==================================================")

      #L Matriz 4x4 representada como lista de 16 elementos (row-major)
      mut as list of int64: arr = [
            15, 6, 2, 9,
            8, 1, 14, 4,
            12, 10, 3, 16,
            7, 5, 11, 13
      ]
      mut as int64: r = 4
      mut as int64: c = 4
      println("1. Vetor Original (16 elementos): " + arr)

      mut as int64: phase = 1
      #L Executa 3 fases (log2(4) + 1 = 3 iteracoes completas de linhas + colunas)
      infinite (phase <= 3) {
            #L Passo A: Ordenacao das Linhas
            #L Linhas impares (1, 3): crescente | Linhas pares (2, 4): decrescente (snake)
            mut as int64: row = 1
            infinite (row <= r) {
                  mut as int64: row_start = (row - 1) * c + 1
                  mut as int64: row_end = row * c

                  #L Insertion sort na linha com guarda segura
                  mut as int64: i = row_start + 1
                  infinite (i <= row_end) {
                        mut as int64: key = arr[i]
                        mut as int64: j = i - 1

                        route {
                              row /r 2 == 1 ==> {
                                    #L Linha impar: ordem crescente
                                    infinite (j >= row_start) {
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
                              }
                              _ ==> {
                                    #L Linha par: ordem decrescente
                                    infinite (j >= row_start) {
                                          route {
                                                arr[j] < key ==> {
                                                      arr[j + 1] = arr[j]
                                                      j = j - 1
                                                }
                                                _ ==> {
                                                      break
                                                }
                                          }
                                    }
                              }
                        }
                        arr[j + 1] = key
                        i = i + 1
                  }
                  row = row + 1
            }

            #L Passo B: Ordenacao das Colunas (todas em ordem crescente)
            mut as int64: col = 1
            infinite (col <= c) {
                  mut as int64: i = 2
                  infinite (i <= r) {
                        mut as int64: key = arr[(i - 1) * c + col]
                        mut as int64: j = i - 1
                        infinite (j >= 1) {
                              route {
                                    arr[(j - 1) * c + col] > key ==> {
                                          arr[j * c + col] = arr[(j - 1) * c + col]
                                          j = j - 1
                                    }
                                    _ ==> {
                                          break
                                    }
                              }
                        }
                        arr[j * c + col] = key
                        i = i + 1
                  }
                  col = col + 1
            }

            phase = phase + 1
      }

      #L Passo Final: Todas as linhas em ordem crescente
      mut as int64: final_row = 1
      infinite (final_row <= r) {
            mut as int64: row_start = (final_row - 1) * c + 1
            mut as int64: row_end = final_row * c
            mut as int64: i = row_start + 1
            infinite (i <= row_end) {
                  mut as int64: key = arr[i]
                  mut as int64: j = i - 1
                  infinite (j >= row_start) {
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
            final_row = final_row + 1
      }

      println("2. Vetor Ordenado via Shear Sort: " + arr)
      #L Verifica se arr eh 1..16 ordenado
      mut as bool: is_sorted = true
      mut as int64: idx = 1
      infinite (idx <= 15) {
            route {
                  arr[idx] > arr[idx + 1] ==> {
                        is_sorted = false
                  }
            }
            idx = idx + 1
      }
      println("3. Validacao (Sequencia 1..16 ordenada): " + is_sorted)
      println("==================================================")
}
