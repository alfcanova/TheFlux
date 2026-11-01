#L ============================================================================
#L Algoritmo: BFS (Busca em Largura / Breadth-First Search)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeBFS) {
      println("==================================================")
      println("  SciAlgo: Breadth-First Search (BFS)             ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: start_node = 1

      #L Matriz de adjacencia (6x6)
      mut as list of int64: adj = [
            0, 1, 1, 0, 0, 0,
            1, 0, 0, 1, 1, 0,
            1, 0, 0, 0, 0, 1,
            0, 1, 0, 0, 0, 0,
            0, 1, 0, 0, 0, 0,
            0, 0, 1, 0, 0, 0
      ]

      println("1. Grafo com 6 Vertices. Origem BFS: " + start_node)

      mut as list of bool: visited = [false, false, false, false, false, false]
      mut as list of int64: level = [-1, -1, -1, -1, -1, -1]
      mut as list of int64: order = [0, 0, 0, 0, 0, 0]
      mut as int64: order_count = 0

      #L Fila FIFO
      mut as list of int64: queue = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: head = 1
      mut as int64: tail = 1

      visited[start_node] = true
      level[start_node] = 0
      queue[tail] = start_node
      tail = tail + 1

      mut as int64: curr = 0
      mut as int64: v = 1
      mut as int64: i = 1

      infinite (head < tail) {
            curr = queue[head]
            head = head + 1

            order_count = order_count + 1
            order[order_count] = curr

            v = 1
            infinite (v <= num_v) {
                  route {
                        (adj[(curr - 1) * num_v + v] == 1) and (not visited[v]) ==> {
                              visited[v] = true
                              level[v] = level[curr] + 1
                              queue[tail] = v
                              tail = tail + 1
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
      }

      println("2. Ordem de Visita BFS:")
      i = 1
      infinite (i <= order_count) {
            println("   Passo " + i + ": Vertice " + order[i] + " (Nivel " + level[order[i]] + ")")
            i = i + 1
      }

      println("BFS concluido com sucesso.")
}
