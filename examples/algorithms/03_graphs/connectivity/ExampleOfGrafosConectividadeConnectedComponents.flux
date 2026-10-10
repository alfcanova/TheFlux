#L ============================================================================
#L Algoritmo: Connected Components (Componentes Conexos em Grafos Nao-Direcionados)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeConnectedComponents) {
      println("==================================================")
      println("  SciAlgo: Connected Components                   ")
      println("==================================================")

      mut as int64: num_v = 6

      #L Grafo com 6 vertices e 2 componentes conexos desconectados entre si:
      #L Componente 1: {1, 2, 3} com (1-2), (2-3), (3-1)
      #L Componente 2: {4, 5, 6} com (4-5), (5-6)
      mut as list of int64: adj = [
            0, 1, 1, 0, 0, 0,
            1, 0, 1, 0, 0, 0,
            1, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 1, 0,
            0, 0, 0, 1, 0, 1,
            0, 0, 0, 0, 1, 0
      ]

      println("1. Grafo com 6 Vertices e 2 Componentes:")

      mut as list of int64: comp_id = [0, 0, 0, 0, 0, 0]
      mut as int64: num_components = 0

      #L Fila para busca BFS em cada componente
      mut as list of int64: queue = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: head = 1
      mut as int64: tail = 1

      mut as int64: i = 1
      mut as int64: curr = 0
      mut as int64: v = 1

      infinite (i <= num_v) {
            route {
                  comp_id[i] == 0 ==> {
                        num_components = num_components + 1
                        comp_id[i] = num_components

                        head = 1
                        tail = 1
                        queue[tail] = i
                        tail = tail + 1

                        infinite (head < tail) {
                              curr = queue[head]
                              head = head + 1

                              v = 1
                              infinite (v <= num_v) {
                                    route {
                                          (adj[(curr - 1) * num_v + v] == 1) and (comp_id[v] == 0) ==> {
                                                comp_id[v] = num_components
                                                queue[tail] = v
                                                tail = tail + 1
                                          }
                                          _ ==> {}
                                    }
                                    v = v + 1
                              }
                        }
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("2. Total de Componentes Conexos Encontrados: " + num_components)
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + " pertence ao Componente #" + comp_id[i])
            i = i + 1
      }

      println("Connected Components concluido com sucesso.")
}
