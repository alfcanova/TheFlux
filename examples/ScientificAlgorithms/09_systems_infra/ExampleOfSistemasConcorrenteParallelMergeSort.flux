#L ============================================================================
#L Algoritmo: Parallel Merge Sort (Particionamento e Merge Tree Paralelo)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(N log N) trabalho | O(log^2 N) profundidade paralela
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteParallelMergeSort) {
      println("==================================================")
      println("  SciAlgo: Parallel Merge Sort (Tree Concurrency) ")
      println("==================================================")

      #L Vetor de N = 8 elementos dividido em 2 metades paralelas de tamanho 4
      mut as int64: n = 8
      mut as list of int64: a = [54, 26, 93, 17, 77, 31, 44, 55]

      println("1. Vetor de Entrada (N = 8):")
      mut as string: in_str = ""
      mut as int64: idx = 1
      infinite (idx <= n) {
            in_str = in_str + a[idx] + " "
            idx = idx + 1
      }
      println("   A = [ " + in_str + "]")

      println("2. Fase Paralela 1: Ordenacao Concorrente dos Sub-blocos:")
      #L Thread 1 ordena a[1..4]: [54, 26, 93, 17] -> [17, 26, 54, 93]
      mut as int64: i = 1
      infinite (i <= 4) {
            mut as int64: j = i + 1
            infinite (j <= 4) {
                  route {
                        a[i] > a[j] ==> {
                              mut as int64: sw = a[i]
                              a[i] = a[j]
                              a[j] = sw
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      #L Thread 2 ordena a[5..8]: [77, 31, 44, 55] -> [31, 44, 55, 77]
      i = 5
      infinite (i <= 8) {
            mut as int64: j = i + 1
            infinite (j <= 8) {
                  route {
                        a[i] > a[j] ==> {
                              mut as int64: sw = a[i]
                              a[i] = a[j]
                              a[j] = sw
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("   Sub-bloco 1 (Thread 1): [ 17 26 54 93 ]")
      println("   Sub-bloco 2 (Thread 2): [ 31 44 55 77 ]")

      println("3. Fase Paralela 2: Merge Tree (Intercalacao Paralela):")
      #L Intercalacao dos dois sub-blocos ordenados em buffer temporario
      mut as list of int64: merged = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: p1 = 1
      mut as int64: p2 = 5
      mut as int64: dest = 1

      infinite (p1 <= 4 and p2 <= 8) {
            route {
                  a[p1] <= a[p2] ==> {
                        merged[dest] = a[p1]
                        p1 = p1 + 1
                  }
                  _ ==> {
                        merged[dest] = a[p2]
                        p2 = p2 + 1
                  }
            }
            dest = dest + 1
      }

      infinite (p1 <= 4) {
            merged[dest] = a[p1]
            p1 = p1 + 1
            dest = dest + 1
      }

      infinite (p2 <= 8) {
            merged[dest] = a[p2]
            p2 = p2 + 1
            dest = dest + 1
      }

      a = merged

      println("4. Vetor Final Totalmente Ordenado:")
      mut as string: out_str = ""
      idx = 1
      infinite (idx <= n) {
            out_str = out_str + a[idx] + " "
            idx = idx + 1
      }
      println("   A = [ " + out_str + "]")

      #L Verificacao de corretude
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
      println("5. Verificacao de Ordenacao: " + is_sorted)

      println("Parallel Merge Sort concluido com sucesso.")
}
