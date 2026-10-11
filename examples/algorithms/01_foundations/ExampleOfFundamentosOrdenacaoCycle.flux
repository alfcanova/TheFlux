#L ============================================================================
#L Algoritmo: Cycle Sort (Minimização de Escritas na Memória)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N^2) tempo | O(N) escritas no pior caso (ótimo) | In-Place
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoCycle) {
      println("==================================================")
      println("  SciAlgo: Cycle Sort (Minimizacao de Escritas)")
      println("==================================================")

      mut as list of int64: arr = [10, 5, 2, 3, 7, 5, 8, 1, 9, 6]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      mut as int64: total_writes = 0
      mut as int64: cycle_start = 1

      infinite (cycle_start < n) {
            mut as int64: item = arr[cycle_start]
            mut as int64: pos = cycle_start

            #L Encontra a posição correta contando quantos elementos à frente são menores
            mut as int64: i = cycle_start + 1
            infinite (i <= n) {
                  route {
                        arr[i] < item ==> {
                              pos = pos + 1
                        }
                  }
                  i = i + 1
            }

            #L Se o item já estiver em sua posição definitiva, passa para o próximo ciclo
            route {
                  pos == cycle_start ==> {
                        cycle_start = cycle_start + 1
                  }
                  _ ==> {
                        #L Ignora elementos duplicados
                        infinite (item == arr[pos]) {
                              pos = pos + 1
                        }

                        #L Coloca o item na sua posição e resgata o elemento deslocado
                        mut as int64: tmp = arr[pos]
                        arr[pos] = item
                        item = tmp
                        total_writes = total_writes + 1

                        #L Rotaciona o restante do ciclo até fechar em cycle_start
                        infinite (pos != cycle_start) {
                              pos = cycle_start
                              i = cycle_start + 1
                              infinite (i <= n) {
                                    route {
                                          arr[i] < item ==> {
                                                pos = pos + 1
                                          }
                                    }
                                    i = i + 1
                              }

                              infinite (item == arr[pos]) {
                                    pos = pos + 1
                              }

                              tmp = arr[pos]
                              arr[pos] = item
                              item = tmp
                              total_writes = total_writes + 1
                        }

                        cycle_start = cycle_start + 1
                  }
            }
      }

      println("2. Vetor ordenado pelo Cycle Sort: " + arr)
      println("3. Total de escritas na memoria: " + total_writes)

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

      println("4. Verificacao de corretude do Cycle Sort: " + ordenado)
      println("==================================================")
}
