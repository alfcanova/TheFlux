#L ============================================================================
#L Algoritmo: External Sorting (Ordenacao Externa em Duas Fases)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O((N/B) * log_{M/B}(N/B)) I/O | RAM limitada a M elementos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasExternalSorting) {
      println("==================================================")
      println("  SciAlgo: External Sorting (Ordenacao Externa)")
      println("==================================================")

      mut as list of int64: disk_file = [52, 14, 28, 91, 19, 73, 5, 41, 62, 8, 33, 99]
      mut as int64: n = listLength(disk_file)
      mut as int64: ram_capacity = 4

      println("1. Arquivo externo em disco (N = " + n + "): " + disk_file)
      println("2. Capacidade maxima de memoria RAM (M = " + ram_capacity + " registros)")

      #L Fase 1: Geracao de Corridas Ordenadas (Run Generation)
      #L Divide em 3 runs de tamanho 4: Run 1 [1..4], Run 2 [5..8], Run 3 [9..12]
      mut as list of int64: run1 = [52, 14, 28, 91]
      mut as list of int64: run2 = [19, 73, 5, 41]
      mut as list of int64: run3 = [62, 8, 33, 99]

      #L Ordena Run 1 internamente na RAM
      mut as int64: i1 = 2
      infinite (i1 <= 4) {
            mut as int64: k = run1[i1]
            mut as int64: j = i1 - 1
            mut as bool: s = true
            infinite (s) {
                  route {
                        j >= 1 ==> {
                              route {
                                    run1[j] > k ==> {
                                          run1[j + 1] = run1[j]
                                          j = j - 1
                                    }
                                    _ ==> {
                                          s = false
                                    }
                              }
                        }
                        _ ==> {
                              s = false
                        }
                  }
            }
            run1[j + 1] = k
            i1 = i1 + 1
      }

      #L Ordena Run 2 internamente na RAM
      mut as int64: i2 = 2
      infinite (i2 <= 4) {
            mut as int64: k2 = run2[i2]
            mut as int64: j2 = i2 - 1
            mut as bool: s2 = true
            infinite (s2) {
                  route {
                        j2 >= 1 ==> {
                              route {
                                    run2[j2] > k2 ==> {
                                          run2[j2 + 1] = run2[j2]
                                          j2 = j2 - 1
                                    }
                                    _ ==> {
                                          s2 = false
                                    }
                              }
                        }
                        _ ==> {
                              s2 = false
                        }
                  }
            }
            run2[j2 + 1] = k2
            i2 = i2 + 1
      }

      #L Ordena Run 3 internamente na RAM
      mut as int64: i3 = 2
      infinite (i3 <= 4) {
            mut as int64: k3 = run3[i3]
            mut as int64: j3 = i3 - 1
            mut as bool: s3 = true
            infinite (s3) {
                  route {
                        j3 >= 1 ==> {
                              route {
                                    run3[j3] > k3 ==> {
                                          run3[j3 + 1] = run3[j3]
                                          j3 = j3 - 1
                                    }
                                    _ ==> {
                                          s3 = false
                                    }
                              }
                        }
                        _ ==> {
                              s3 = false
                        }
                  }
            }
            run3[j3 + 1] = k3
            i3 = i3 + 1
      }

      println("3. Corridas ordenadas geradas na Fase 1:")
      println("   Run 1: " + run1)
      println("   Run 2: " + run2)
      println("   Run 3: " + run3)

      #L Fase 2: Intercalacao Multi-Vias (3-Way Merge)
      mut as list of int64: sorted_output = []
      mut as int64: p1 = 1
      mut as int64: p2 = 1
      mut as int64: p3 = 1
      mut as int64: total_merged = 0

      infinite (total_merged < n) {
            mut as int64: best_run = 0
            mut as int64: min_val = 999999

            route {
                  p1 <= 4 ==> {
                        route {
                              run1[p1] < min_val ==> {
                                    min_val = run1[p1]
                                    best_run = 1
                              }
                              _ ==> {
                              }
                        }
                  }
                  _ ==> {
                  }
            }
            route {
                  p2 <= 4 ==> {
                        route {
                              run2[p2] < min_val ==> {
                                    min_val = run2[p2]
                                    best_run = 2
                              }
                              _ ==> {
                              }
                        }
                  }
                  _ ==> {
                  }
            }
            route {
                  p3 <= 4 ==> {
                        route {
                              run3[p3] < min_val ==> {
                                    min_val = run3[p3]
                                    best_run = 3
                              }
                              _ ==> {
                              }
                        }
                  }
                  _ ==> {
                  }
            }

            sorted_output = listPushBack(sorted_output, min_val)
            total_merged = total_merged + 1

            route {
                  best_run == 1 ==> {
                        p1 = p1 + 1
                  }
                  best_run == 2 ==> {
                        p2 = p2 + 1
                  }
                  _ ==> {
                        p3 = p3 + 1
                  }
            }
      }

      println("4. Arquivo final ordenado via 3-way merge: " + sorted_output)
      println("Concluido com Sucesso")
}
