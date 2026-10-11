#L ============================================================================
#L Algoritmo: BFS/DFS Paralelo (Busca em Largura por Fronteiras Sincronizadas)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: O(V + E) trabalho | O(Diametro) passos paralelos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralParallelBFSDFS) {
      println("==================================================")
      println("  SciAlgo: BFS/DFS Paralelo (Frontier-Based BFS)  ")
      println("==================================================")

      #L Grafo em camadas com V = 7 vertices e E = 8 arestas
      #L Camada 0: {1}
      #L Camada 1: {2, 3}
      #L Camada 2: {4, 5, 6}
      #L Camada 3: {7}
      mut as int64: num_v = 7
      mut as int64: num_e = 8

      mut as list of int64: edge_u = [1, 1, 2, 2, 3, 3, 5, 6]
      mut as list of int64: edge_v = [2, 3, 4, 5, 5, 6, 7, 7]

      println("1. Grafo estratificado em niveis com " + num_v + " vertices e " + num_e + " arestas.")
      println("   Origem da travessia paralela: vertice 1")

      #L Matriz de adjacencia
      mut as list of int64: adj = []
      mut as int64: c = 1
      infinite (c <= num_v * num_v) {
            adj = listPushBack(adj, 0)
            c = c + 1
      }

      mut as int64: ei = 1
      infinite (ei <= num_e) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            adj[(u - 1) * num_v + v] = 1
            adj[(v - 1) * num_v + u] = 1
            ei = ei + 1
      }

      #L Vetor de distancias / niveis BFS
      mut as list of int64: level = [-1, -1, -1, -1, -1, -1, -1]
      mut as list of bool: visited = [false, false, false, false, false, false, false]

      #L Fronteira inicial no passo 0: F_0 = [1]
      mut as list of int64: current_frontier = [1]
      level[1] = 0
      visited[1] = true

      mut as int64: parallel_round = 0
      println("2. Executando Fases Paralelas de Expansao de Fronteira...")

      infinite (listLength(current_frontier) > 0) {
            mut as int64: frontier_size = listLength(current_frontier)
            println("   --- Rodada Paralela " + parallel_round + ": Fronteira atual = " + current_frontier + " (tamanho " + frontier_size + ") ---")

            #L Expansao paralela: todos os vertices da fronteira exploram vizinhos simultaneamente
            mut as list of int64: next_frontier = []
            mut as int64: fi = 1
            infinite (fi <= frontier_size) {
                  mut as int64: curr_node = current_frontier[fi]

                  mut as int64: nbr = 1
                  infinite (nbr <= num_v) {
                        route {
                              adj[(curr_node - 1) * num_v + nbr] == 1 ==> {
                                    route {
                                          not visited[nbr] ==> {
                                                visited[nbr] = true
                                                level[nbr] = parallel_round + 1
                                                next_frontier = listPushBack(next_frontier, nbr)
                                                println("     [Worker] No " + curr_node + " descobriu vertice " + nbr + " para nivel " + (parallel_round + 1))
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        nbr = nbr + 1
                  }

                  fi = fi + 1
            }

            current_frontier = next_frontier
            parallel_round = parallel_round + 1
      }

      println("3. Niveis BFS Finais Calculados:")
      mut as int64: vi = 1
      infinite (vi <= num_v) {
            println("   Vertice " + vi + " -> Nivel " + level[vi])
            vi = vi + 1
      }

      #L Verificacao de corretude da travessia estratificada
      #L Nivel 1: 0
      #L Niveis 2 e 3: 1
      #L Niveis 4, 5 e 6: 2
      #L Nivel 7: 3
      mut as bool: l0_ok = level[1] == 0
      mut as bool: l1_ok = (level[2] == 1) and (level[3] == 1)
      mut as bool: l2_ok = (level[4] == 2) and (level[5] == 2) and (level[6] == 2)
      mut as bool: l3_ok = level[7] == 3
      mut as bool: bfs_ok = l0_ok and l1_ok and l2_ok and l3_ok
      println("4. Verificacao da Estratificacao Paralela: " + bfs_ok)

      println("Concluido com Sucesso")
}
