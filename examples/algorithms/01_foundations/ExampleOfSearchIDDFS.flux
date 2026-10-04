#L ============================================================================
#L Algoritmo: Iterative Deepening DFS (IDDFS)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^d) tempo | O(d) espaco linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchIDDFS) {
      println("==================================================")
      println("  SciAlgo: Iterative Deepening DFS (IDDFS)")
      println("==================================================")

      #L Grafo em arvore (7 vertices):
      #L 1 -> [2, 3], 2 -> [4, 5], 3 -> [6, 7]
      mut as list of list of int64: adj = [
            [0, 1, 1, 0, 0, 0, 0],
            [0, 0, 0, 1, 1, 0, 0],
            [0, 0, 0, 0, 0, 1, 1],
            [0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0]
      ]

      mut as int64: start = 1
      mut as int64: target = 7
      mut as int64: max_depth = 3

      println("1. Origem: " + start + " | Alvo buscado: " + target)

      mut as int64: found_at_depth = -1
      mut as int64: current_limit = 0
      mut as int64: total_nodes_evaluated = 0

      infinite (current_limit <= max_depth and found_at_depth < 0) {
            #L Executa DLS (Depth-Limited Search) iterativo com pilha
            mut as list of int64: stack_node = [start]
            mut as list of int64: stack_depth = [0]
            mut as int64: found_in_iteration = 0

            infinite (listLength(stack_node) > 0) {
                  mut as int64: top = listLength(stack_node)
                  mut as int64: u = stack_node[top]
                  mut as int64: d = stack_depth[top]

                  #L Desempilha
                  mut as list of int64: n_stack_node = []
                  mut as list of int64: n_stack_depth = []
                  mut as int64: idx = 1
                  infinite (idx < top) {
                        n_stack_node = listPushBack(n_stack_node, stack_node[idx])
                        n_stack_depth = listPushBack(n_stack_depth, stack_depth[idx])
                        idx = idx + 1
                  }
                  stack_node = n_stack_node
                  stack_depth = n_stack_depth

                  total_nodes_evaluated = total_nodes_evaluated + 1

                  route {
                        u == target ==> {
                              found_in_iteration = 1
                              found_at_depth = current_limit
                              break
                        }
                  }

                  route {
                        d < current_limit ==> {
                              #L Empilha vizinhos em ordem reversa
                              mut as int64: v = 7
                              infinite (v >= 1) {
                                    route {
                                          adj[u][v] == 1 ==> {
                                                stack_node = listPushBack(stack_node, v)
                                                stack_depth = listPushBack(stack_depth, d + 1)
                                          }
                                    }
                                    v = v - 1
                              }
                        }
                  }
            }

            println("  - Limite de profundidade " + current_limit + " concluido.")
            current_limit = current_limit + 1
      }

      println("2. Alvo encontrado na profundidade: " + found_at_depth)
      println("3. Total de nos expandidos/revisitados: " + total_nodes_evaluated)
      println("4. Validacao: " + (found_at_depth == 2))
      println("==================================================")
}
