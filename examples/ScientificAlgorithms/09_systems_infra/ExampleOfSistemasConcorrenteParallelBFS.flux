#L ============================================================================
#L Algoritmo: Parallel BFS (Level-Synchronous Frontier Parallelism)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(V + E) trabalho | O(Diametro) etapas sincronizadas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteParallelBFS) {
      println("==================================================")
      println("  SciAlgo: Parallel BFS (Level-Synchronous Model) ")
      println("==================================================")

      #L Grafo nao-dirigido com V = 8 vertices e 8 arestas:
      #L 1 - 2, 1 - 3
      #L 2 - 4, 2 - 5
      #L 3 - 6, 3 - 7
      #L 5 - 8
      mut as int64: v = 8
      mut as list of int64: adj = [
            0, 1, 1, 0, 0, 0, 0, 0, #L 1: -> 2, 3
            1, 0, 0, 1, 1, 0, 0, 0, #L 2: -> 1, 4, 5
            1, 0, 0, 0, 0, 1, 1, 0, #L 3: -> 1, 6, 7
            0, 1, 0, 0, 0, 0, 0, 0, #L 4: -> 2
            0, 1, 0, 0, 0, 0, 0, 1, #L 5: -> 2, 8
            0, 0, 1, 0, 0, 0, 0, 0, #L 6: -> 3
            0, 0, 1, 0, 0, 0, 0, 0, #L 7: -> 3
            0, 0, 0, 0, 1, 0, 0, 0  #L 8: -> 5
      ]

      println("1. Grafo Definido com 8 Vertices.")
      println("   Vertice Fonte: 1")

      #L Vetor de distancias (-1 = nao visitado)
      mut as list of int64: dist = [-1, -1, -1, -1, -1, -1, -1, -1]
      dist[1] = 0

      #L Fronteiras paralelas por nivel
      #L current_frontier: conjunto booleano de vertices no nivel atual
      mut as list of bool: curr_frontier = [true, false, false, false, false, false, false, false]
      mut as int64: level = 0
      mut as bool: has_frontier = true

      println("2. Executando BFS Paralela Sincronizada por Niveis:")

      infinite (has_frontier) {
            mut as list of bool: next_frontier = [false, false, false, false, false, false, false, false]
            mut as int64: frontier_size = 0

            #L Cada thread paralela processa um vertice u da fronteira atual
            mut as int64: u = 1
            infinite (u <= v) {
                  route {
                        curr_frontier[u] ==> {
                              frontier_size = frontier_size + 1
                              #L Expande vizinhos w de u concorrentemente
                              mut as int64: w = 1
                              infinite (w <= v) {
                                    route {
                                          adj[(u - 1) * v + w] == 1 and dist[w] == -1 ==> {
                                                #L Atomic/Owner claim: registra distancia e adiciona na proxima fronteira
                                                dist[w] = level + 1
                                                next_frontier[w] = true
                                          }
                                          _ ==> {}
                                    }
                                    w = w + 1
                              }
                        }
                        _ ==> {}
                  }
                  u = u + 1
            }

            println("   Nivel " + level + ": " + frontier_size + " vertices processados na fronteira paralela")

            #L Barreira de sincronizacao: avanca para o proximo nivel
            route {
                  frontier_size == 0 ==> {
                        has_frontier = false
                  }
                  _ ==> {
                        curr_frontier = next_frontier
                        level = level + 1
                  }
            }
      }

      println("3. Distancias Finais a Partir da Fonte 1:")
      mut as int64: i = 1
      infinite (i <= v) {
            println("   Vertice " + i + ": Distancia = " + dist[i])
            i = i + 1
      }

      #L Validacao deterministica:
      #L dist[1] = 0
      #L dist[2] = 1, dist[3] = 1
      #L dist[4] = 2, dist[5] = 2, dist[6] = 2, dist[7] = 2
      #L dist[8] = 3
      mut as bool: correct = (dist[1] == 0) and (dist[4] == 2) and (dist[8] == 3)
      println("4. Verificacao de Distancias Corretas: " + correct)

      println("Parallel BFS concluido com sucesso.")
}
