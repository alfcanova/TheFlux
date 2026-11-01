#L ============================================================================
#L Algoritmo: DFS (Busca em Profundidade / Depth-First Search)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeDFS) {
      println("==================================================")
      println("  SciAlgo: Depth-First Search (DFS)               ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: start_node = 1

      #L Matriz de adjacencia (6x6)
      #L Arestas: (1-2), (1-3), (2-4), (2-5), (3-6)
      mut as list of int64: adj = [
            0, 1, 1, 0, 0, 0,
            1, 0, 0, 1, 1, 0,
            1, 0, 0, 0, 0, 1,
            0, 1, 0, 0, 0, 0,
            0, 1, 0, 0, 0, 0,
            0, 0, 1, 0, 0, 0
      ]

      println("1. Grafo com 6 Vertices. Origem DFS: " + start_node)

      mut as list of bool: visited = [false, false, false, false, false, false]
      mut as list of int64: order = [0, 0, 0, 0, 0, 0]
      mut as int64: order_count = 0

      #L Pilha explicita para execucao deterministica
      mut as list of int64: stack = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: top = 1
      stack[top] = start_node

      mut as int64: curr = 0
      mut as int64: v = 1
      mut as int64: i = 1

      infinite (top > 0) {
            curr = stack[top]
            top = top - 1

            route {
                  not visited[curr] ==> {
                        visited[curr] = true
                        order_count = order_count + 1
                        order[order_count] = curr

                        #L Empilha vizinhos em ordem reversa para explorar em ordem crescente
                        v = num_v
                        infinite (v >= 1) {
                              route {
                                    (adj[(curr - 1) * num_v + v] == 1) and (not visited[v]) ==> {
                                          top = top + 1
                                          stack[top] = v
                                    }
                                    _ ==> {}
                              }
                              v = v - 1
                        }
                  }
                  _ ==> {}
            }
      }

      println("2. Ordem de Visitacao DFS:")
      i = 1
      infinite (i <= order_count) {
            println("   Passo " + i + ": Vertice " + order[i])
            i = i + 1
      }

      println("DFS concluido com sucesso.")
}
