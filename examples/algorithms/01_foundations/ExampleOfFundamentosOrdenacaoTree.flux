#L ============================================================================
#L Algoritmo: Tree Sort (Ordenação por Árvore Binária de Busca)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) tempo médio | O(N) espaço auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoTree) {
      println("==================================================")
      println("  SciAlgo: Tree Sort (BST In-Order Traversal)")
      println("==================================================")

      mut as list of int64: arr = [64, 34, 25, 12, 22, 11, 90, 45, 72, 18]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Pool de nós para a BST (1-based: nós de 1 a n)
      mut as list of int64: tree_val = []
      mut as list of int64: tree_left = []
      mut as list of int64: tree_right = []
      mut as int64: init_i = 1
      infinite (init_i <= n) {
            tree_val = listPushBack(tree_val, 0)
            tree_left = listPushBack(tree_left, 0)
            tree_right = listPushBack(tree_right, 0)
            init_i = init_i + 1
      }

      #L Insere primeiro elemento como raiz no nó 1
      tree_val[1] = arr[1]

      #L Insere os elementos restantes na BST
      mut as int64: idx = 2
      infinite (idx <= n) {
            mut as int64: v = arr[idx]
            tree_val[idx] = v
            mut as int64: curr = 1

            infinite (true) {
                  route {
                        v <= tree_val[curr] ==> {
                              route {
                                    tree_left[curr] == 0 ==> {
                                          tree_left[curr] = idx
                                          break
                                    }
                                    _ ==> {
                                          curr = tree_left[curr]
                                    }
                              }
                        }
                        _ ==> {
                              route {
                                    tree_right[curr] == 0 ==> {
                                          tree_right[curr] = idx
                                          break
                                    }
                                    _ ==> {
                                          curr = tree_right[curr]
                                    }
                              }
                        }
                  }
            }
            idx = idx + 1
      }

      #L Percurso Em-Ordem (In-Order Traversal) iterativo com pilha explícita
      mut as list of int64: sorted_arr = []
      mut as list of int64: stack = []
      mut as int64: trav_curr = 1

      infinite ((trav_curr != 0) or (listLength(stack) > 0)) {
            #L Desce o máximo para a subárvore esquerda
            infinite (trav_curr != 0) {
                  stack = listPushBack(stack, trav_curr)
                  trav_curr = tree_left[trav_curr]
            }

            #L Desempilha nó visitado
            mut as int64: top_idx = listLength(stack)
            trav_curr = stack[top_idx]

            mut as list of int64: new_stack = []
            mut as int64: si = 1
            infinite (si < top_idx) {
                  new_stack = listPushBack(new_stack, stack[si])
                  si = si + 1
            }
            stack = new_stack

            #L Visita o nó atual adicionando à lista ordenada
            sorted_arr = listPushBack(sorted_arr, tree_val[trav_curr])

            #L Avança para a subárvore direita
            trav_curr = tree_right[trav_curr]
      }

      println("2. Vetor ordenado pela BST: " + sorted_arr)

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

      println("3. Verificacao de corretude do Tree Sort: " + ordenado)
      println("==================================================")
}
