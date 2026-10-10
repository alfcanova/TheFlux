#L ============================================================================
#L Algoritmo: Parallel Shortest Paths (Parallel Edge Relaxation / Bellman-Ford)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(V * E) trabalho | O(V) rodadas sincronizadas com barreira
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteParallelShortestPaths) {
      println("==================================================")
      println("  SciAlgo: Parallel Shortest Paths (Edge Stepping)")
      println("==================================================")

      #L Grafo dirigido com V = 6 vertices e E = 8 arestas com pesos
      mut as int64: v = 6
      mut as int64: e = 8
      mut as int64: inf_dist = 9999

      mut as list of int64: edge_src = [1, 1, 3, 2, 3, 3, 4, 5]
      mut as list of int64: edge_dst = [2, 3, 2, 4, 4, 5, 6, 6]
      mut as list of int64: edge_wt  = [4, 2, 1, 5, 10, 8, 2, 3]

      println("1. Grafo Definido com 6 Vertices e 8 Arestas:")
      println("   Vertice Origem: 1")

      #L Distancias atuais e buffer concorrente para proxima rodada
      mut as list of int64: dist = [0, 9999, 9999, 9999, 9999, 9999]
      mut as list of int64: next_dist = [0, 9999, 9999, 9999, 9999, 9999]

      println("2. Executando Relaxamento Concorrente de Arestas:")

      #L Executa ate V - 1 rodadas síncronas
      mut as int64: round = 1
      mut as bool: changed = true

      infinite (round < v and changed) {
            changed = false

            #L Todas as arestas sao avaliadas concorrentemente em paralelo
            mut as int64: i = 1
            infinite (i <= e) {
                  mut as int64: u = edge_src[i]
                  mut as int64: w = edge_dst[i]
                  mut as int64: weight = edge_wt[i]

                  route {
                        dist[u] < inf_dist ==> {
                              mut as int64: cand = dist[u] + weight
                              route {
                                    cand < next_dist[w] ==> {
                                          next_dist[w] = cand
                                          changed = true
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            println("   Rodada " + round + ": Arestas relaxadas concorrentemente. Mudancas: " + changed)

            #L Barreira de Sincronizacao Global
            dist = next_dist
            round = round + 1
      }

      println("3. Distancias Minimas Finais a Partir da Origem 1:")
      mut as int64: node = 1
      infinite (node <= v) {
            println("   Vertice " + node + ": Distancia Minima = " + dist[node])
            node = node + 1
      }

      #L Caminhos minimos esperados a partir de 1:
      #L 1 -> 1: 0
      #L 1 -> 3: 2
      #L 1 -> 2: 1 -> 3 -> 2 = 2 + 1 = 3 (menor que aresta direta 4)
      #L 1 -> 4: 1 -> 3 -> 2 -> 4 = 3 + 5 = 8
      #L 1 -> 5: 1 -> 3 -> 5 = 2 + 8 = 10
      #L 1 -> 6: 1 -> 4 -> 6 = 8 + 2 = 10 (menor que via 5: 10 + 3 = 13)
      mut as bool: correct = (dist[1] == 0) and (dist[2] == 3) and (dist[3] == 2) and (dist[4] == 8) and (dist[5] == 10) and (dist[6] == 10)
      println("4. Verificacao de Caminhos Minimos Paralelos: " + correct)

      println("Parallel Shortest Paths concluido com sucesso.")
}
