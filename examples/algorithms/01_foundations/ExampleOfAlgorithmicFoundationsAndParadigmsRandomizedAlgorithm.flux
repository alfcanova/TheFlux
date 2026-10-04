#L ============================================================================
#L Algoritmo: Randomized Algorithm (Algoritmo Aleatorizado)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N) tempo esperado | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsRandomizedAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Randomized Algorithm (Quickselect)")
      println("==================================================")

      mut as list of int64: arr = [38, 27, 43, 3, 9, 82, 10, 19, 50, 61, 15]
      mut as int64: n = listLength(arr)
      mut as int64: k_target = 5
      println("1. Vetor de entrada: " + arr)
      println("2. Ordem estatistica K desejada: " + k_target)

      #L PRNG LCG deterministico
      mut as int64: seed = 987654321
      mut as int64: lcg_m = 2147483647
      mut as int64: lcg_a = 48271

      mut as int64: low = 1
      mut as int64: high = n
      mut as int64: result = 0
      mut as bool: finished = false
      mut as int64: iterations = 0

      infinite (low <= high and not finished) {
            iterations = iterations + 1
            route {
                  low == high ==> {
                        result = arr[low]
                        finished = true
                  }
                  _ ==> {
                        #L Seleciona indice aleatorio no intervalo [low, high]
                        seed = ((seed * lcg_a) + 1) /r lcg_m
                        route {
                              seed < 0 ==> {
                                    seed = 0 - seed
                              }
                              _ ==> {
                              }
                        }
                        mut as int64: span = (high - low) + 1
                        mut as int64: rand_idx = low + (seed /r span)

                        #L Troca elemento sorteado com arr[high] para ser o pivo
                        mut as int64: tmp_p = arr[rand_idx]
                        arr[rand_idx] = arr[high]
                        arr[high] = tmp_p

                        mut as int64: pivot_val = arr[high]
                        mut as int64: store_idx = low
                        mut as int64: j = low

                        infinite (j < high) {
                              route {
                                    arr[j] <= pivot_val ==> {
                                          mut as int64: tmp_s = arr[store_idx]
                                          arr[store_idx] = arr[j]
                                          arr[j] = tmp_s
                                          store_idx = store_idx + 1
                                    }
                                    _ ==> {
                                    }
                              }
                              j = j + 1
                        }

                        #L Posiciona pivo no store_idx
                        mut as int64: tmp_fin = arr[store_idx]
                        arr[store_idx] = arr[high]
                        arr[high] = tmp_fin

                        route {
                              store_idx == k_target ==> {
                                    result = arr[store_idx]
                                    finished = true
                              }
                              store_idx > k_target ==> {
                                    high = store_idx - 1
                              }
                              _ ==> {
                                    low = store_idx + 1
                              }
                        }
                  }
            }
      }

      println("3. Iteracoes com pivos aleatorizados: " + iterations)
      println("4. " + k_target + "-esimo menor elemento: " + result)
      println("Concluido com Sucesso")
}
