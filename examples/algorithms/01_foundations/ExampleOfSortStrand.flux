#L ============================================================================
#L Algoritmo: Strand Sort (Extração Iterativa de Subsequências Ordenadas)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N) melhor caso | O(N^2) pior caso | Estável
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortStrand) {
      println("==================================================")
      println("  SciAlgo: Strand Sort (Extracao e Mesclagem)")
      println("==================================================")

      mut as list of int64: arr = [10, 5, 30, 40, 2, 4, 9, 20, 15, 25]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Vetor com os elementos restantes a serem processados
      mut as list of int64: rem = []
      mut as int64: i = 1
      infinite (i <= n) {
            rem = listPushBack(rem, arr[i])
            i = i + 1
      }

      mut as list of int64: sorted_acc = []
      mut as int64: pass_count = 0

      infinite (listLength(rem) > 0) {
            pass_count = pass_count + 1

            #L Extrai o primeiro elemento de rem para iniciar o novo strand
            mut as list of int64: strand = [rem[1]]
            mut as list of int64: new_rem = []

            mut as int64: r_idx = 2
            mut as int64: rem_len = listLength(rem)
            infinite (r_idx <= rem_len) {
                  mut as int64: item = rem[r_idx]
                  mut as int64: st_last = strand[listLength(strand)]
                  route {
                        item >= st_last ==> {
                              strand = listPushBack(strand, item)
                        }
                        _ ==> {
                              new_rem = listPushBack(new_rem, item)
                        }
                  }
                  r_idx = r_idx + 1
            }
            rem = new_rem

            #L Mesclagem estável entre sorted_acc e o strand recém-extraído
            mut as list of int64: merged = []
            mut as int64: mi = 1
            mut as int64: mj = 1
            mut as int64: acc_len = listLength(sorted_acc)
            mut as int64: strand_len = listLength(strand)

            infinite ((mi <= acc_len) and (mj <= strand_len)) {
                  route {
                        sorted_acc[mi] <= strand[mj] ==> {
                              merged = listPushBack(merged, sorted_acc[mi])
                              mi = mi + 1
                        }
                        _ ==> {
                              merged = listPushBack(merged, strand[mj])
                              mj = mj + 1
                        }
                  }
            }
            infinite (mi <= acc_len) {
                  merged = listPushBack(merged, sorted_acc[mi])
                  mi = mi + 1
            }
            infinite (mj <= strand_len) {
                  merged = listPushBack(merged, strand[mj])
                  mj = mj + 1
            }

            sorted_acc = merged
      }

      println("2. Total de passes de extracao de strands: " + pass_count)

      #L Copia resultado ordenado de volta para arr
      i = 1
      infinite (i <= n) {
            arr[i] = sorted_acc[i]
            i = i + 1
      }

      println("3. Vetor ordenado pelo Strand Sort: " + arr)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      mut as int64: vi = 1
      infinite (vi < n) {
            route {
                  arr[vi] > arr[vi + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            vi = vi + 1
      }
      println("4. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
