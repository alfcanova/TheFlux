#L ============================================================================
#L Algoritmo: Tournament Sort (Ordenação por Árvore de Torneio de Vencedores)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) tempo | O(N) espaço auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortTournament) {
      println("==================================================")
      println("  SciAlgo: Tournament Sort (Winner Tree)")
      println("==================================================")

      mut as list of int64: arr = [29, 10, 14, 37, 13, 25, 8, 44]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Árvore completa de 2*n nós (1-based: nós 1 .. 2*n)
      #L Nós 1 .. n-1 são nós internos; nós n .. 2*n-1 são folhas
      mut as list of int64: tree_val = []
      mut as list of int64: tree_pos = []
      mut as int64: total_nodes = 2 * n
      mut as int64: ti = 1
      infinite (ti <= total_nodes) {
            tree_val = listPushBack(tree_val, 0)
            tree_pos = listPushBack(tree_pos, 0)
            ti = ti + 1
      }

      #L Inicializa as folhas com os elementos do vetor
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: leaf_idx = (n - 1) + i
            tree_val[leaf_idx] = arr[i]
            tree_pos[leaf_idx] = leaf_idx
            i = i + 1
      }

      #L Constrói a árvore de vencedores (bottom-up)
      mut as int64: p = n - 1
      infinite (p >= 1) {
            mut as int64: left_c = 2 * p
            mut as int64: right_c = (2 * p) + 1
            route {
                  tree_val[left_c] <= tree_val[right_c] ==> {
                        tree_val[p] = tree_val[left_c]
                        tree_pos[p] = tree_pos[left_c]
                  }
                  _ ==> {
                        tree_val[p] = tree_val[right_c]
                        tree_pos[p] = tree_pos[right_c]
                  }
            }
            p = p - 1
      }

      #L Extração do campeão e repetição do torneio N vezes
      mut as list of int64: sorted_arr = []
      mut as int64: step = 1
      infinite (step <= n) {
            mut as int64: winner_val = tree_val[1]
            mut as int64: winner_leaf = tree_pos[1]
            sorted_arr = listPushBack(sorted_arr, winner_val)

            #L Substitui a folha vencedora por infinito (999999)
            tree_val[winner_leaf] = 999999

            #L Atualiza o caminho da folha até a raiz em O(log N)
            mut as int64: curr = winner_leaf /i 2
            infinite (curr >= 1) {
                  mut as int64: lc = 2 * curr
                  mut as int64: rc = (2 * curr) + 1
                  route {
                        tree_val[lc] <= tree_val[rc] ==> {
                              tree_val[curr] = tree_val[lc]
                              tree_pos[curr] = tree_pos[lc]
                        }
                        _ ==> {
                              tree_val[curr] = tree_val[rc]
                              tree_pos[curr] = tree_pos[rc]
                        }
                  }
                  curr = curr /i 2
            }
            step = step + 1
      }

      println("2. Vetor ordenado pelo Torneio: " + sorted_arr)

      #L Verificação de monotonicidade
      mut as bool: ordenado = (listLength(sorted_arr) == n)
      mut as int64: vi = 1
      infinite (vi < n) {
            route {
                  sorted_arr[vi] > sorted_arr[vi + 1] ==> {
                        ordenado = false
                  }
            }
            vi = vi + 1
      }

      println("3. Verificacao de corretude do Tournament Sort: " + ordenado)
      println("==================================================")
}
