#L ============================================================================
#L Algoritmo: Incremental Algorithm (Algoritmo Incremental)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N) por insercao | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasIncrementalAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Incremental Algorithm (Construcao Passo a Passo)")
      println("==================================================")

      mut as list of int64: stream = [45, 12, 85, 32, 89, 39, 67, 10]
      mut as int64: n = listLength(stream)
      println("1. Elementos chegando incrementalmente: " + stream)

      #L Mantem conjunto ordenado incrementalmente sem reordenar do zero
      mut as list of int64: current_sorted = []
      mut as int64: running_min = stream[1]
      mut as int64: running_max = stream[1]

      mut as int64: step = 1
      infinite (step <= n) {
            mut as int64: item = stream[step]

            #L Atualiza envoltoria / limites extremos incrementalmente
            route {
                  item < running_min ==> {
                        running_min = item
                  }
                  _ ==> {
                  }
            }
            route {
                  item > running_max ==> {
                        running_max = item
                  }
                  _ ==> {
                  }
            }

            #L Insercao ordenada incremental O(k)
            mut as int64: cur_len = listLength(current_sorted)
            mut as list of int64: new_sorted = []
            mut as bool: inserted = false
            mut as int64: idx = 1

            infinite (idx <= cur_len) {
                  route {
                        not inserted and item < current_sorted[idx] ==> {
                              new_sorted = listPushBack(new_sorted, item)
                              inserted = true
                        }
                        _ ==> {
                        }
                  }
                  new_sorted = listPushBack(new_sorted, current_sorted[idx])
                  idx = idx + 1
            }

            route {
                  not inserted ==> {
                        new_sorted = listPushBack(new_sorted, item)
                  }
                  _ ==> {
                  }
            }

            current_sorted = new_sorted
            step = step + 1
      }

      println("2. Colecao resultante mantida ordenada: " + current_sorted)
      println("3. Menor elemento (limite inferior incremental): " + running_min)
      println("4. Maior elemento (limite superior incremental): " + running_max)
      println("Concluido com Sucesso")
}
