#L ============================================================================
#L Algoritmo: Parallel Bitonic Sort (Rede de Ordenacao de Batcher)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(N log^2 N) comparadores | O(log^2 N) profundidade paralela
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteBitonicSort) {
      println("==================================================")
      println("  SciAlgo: Parallel Bitonic Sort Network          ")
      println("==================================================")

      #L Vetor de N = 8 elementos para ordenacao bitonica
      mut as int64: n = 8
      mut as list of int64: a = [10, 30, 11, 20, 4, 330, 21, 110]

      println("1. Vetor de Entrada (N = 8):")
      mut as string: in_str = ""
      mut as int64: idx = 1
      infinite (idx <= n) {
            in_str = in_str + a[idx] + " "
            idx = idx + 1
      }
      println("   A = [ " + in_str + "]")

      println("2. Executando Estagios da Rede Bitonica de Batcher:")

      #L Estagio k = 2, 4, 8...
      mut as int64: k = 2
      infinite (k <= n) {
            #L Passos j = k/2, k/4... 1
            mut as int64: j = k /i 2
            infinite (j >= 1) {
                  mut as int64: i = 0
                  infinite (i < n) {
                        #L Operacao bitwise XOR manual entre i e j (ambos < 8):
                        #L Calcula l = i XOR j
                        mut as int64: l = 0
                        mut as int64: bit = 1
                        infinite (bit <= 4) {
                              mut as int64: bit_i = (i /i bit) - ((i /i bit) /i 2) * 2
                              mut as int64: bit_j = (j /i bit) - ((j /i bit) /i 2) * 2
                              route {
                                    (bit_i != bit_j) ==> {
                                          l = l + bit
                                    }
                                    _ ==> {}
                              }
                              bit = bit * 2
                        }

                        #L Apenas para pares ordenados (i < l)
                        route {
                              l > i ==> {
                                    #L Direcao de ordenacao: ascendente se (i & k) == 0, descendente se != 0
                                    mut as int64: and_k = (i /i k) - ((i /i k) /i 2) * 2
                                    mut as bool: asc = and_k == 0

                                    mut as int64: pos_i = i + 1
                                    mut as int64: pos_l = l + 1

                                    route {
                                          asc and a[pos_i] > a[pos_l] ==> {
                                                mut as int64: tmp = a[pos_i]
                                                a[pos_i] = a[pos_l]
                                                a[pos_l] = tmp
                                          }
                                          (not asc) and a[pos_i] < a[pos_l] ==> {
                                                mut as int64: tmp = a[pos_i]
                                                a[pos_i] = a[pos_l]
                                                a[pos_l] = tmp
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }
                  j = j /i 2
            }
            k = k * 2
      }

      println("3. Vetor Final Ordenado:")
      mut as string: out_str = ""
      idx = 1
      infinite (idx <= n) {
            out_str = out_str + a[idx] + " "
            idx = idx + 1
      }
      println("   A = [ " + out_str + "]")

      #L Verificacao de ordenacao ascendente
      mut as bool: is_sorted = true
      idx = 1
      infinite (idx < n) {
            route {
                  a[idx] > a[idx + 1] ==> {
                        is_sorted = false
                  }
                  _ ==> {}
            }
            idx = idx + 1
      }
      println("4. Verificacao de Ordenacao Concorrente: " + is_sorted)

      println("Parallel Bitonic Sort concluido com sucesso.")
}
