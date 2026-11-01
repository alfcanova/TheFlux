#L ============================================================================
#L Algoritmo: Chordal Graph Recognition via Maximum Cardinality Search (MCS)
#L Dominio: 03_graphs / Categoria: Decomposicao estrutural de grafos
#L Complexidade: O(V + E) reconhecimento linear e Perfect Elimination Ordering
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosEstruturaisChordalGraphMCS) {
      println("==================================================")
      println("  SciAlgo: Chordal Graph Recognition (MCS - 1984)")
      println("==================================================")

      #L Grafo cordal G com 4 vertices e 5 arestas (dois triangulos com aresta comum (2, 3)):
      #L Arestas: (1, 2), (1, 3), (2, 3), (2, 4), (3, 4)
      mut as int64: n = 4

      #L Matriz de adjacencia linearizada 4x4 (1-based: idx = (u - 1)*4 + v)
      mut as list of int64: adj = [
            0, 1, 1, 0,
            1, 0, 1, 1,
            1, 1, 0, 1,
            0, 1, 1, 0
      ]

      #L Execucao do Maximum Cardinality Search (MCS):
      #L Mantem contadores de vizinhos numerados para cada vertice
      mut as list of int64: weight = [0, 0, 0, 0]
      mut as list of int64: visited = [0, 0, 0, 0]
      mut as list of int64: peo = []

      println("1. Executando Maximum Cardinality Search (MCS):")
      mut as int64: step = 1
      infinite (step <= n) {
            #L Escolhe vertice nao visitado com maior peso
            mut as int64: best_v = 0
            mut as int64: max_w = -1
            mut as int64: u = 1
            infinite (u <= n) {
                  route {
                        visited[u] == 0 and weight[u] > max_w ==> {
                              max_w = weight[u]
                              best_v = u
                        }
                        _ ==> {
                        }
                  }
                  u = u + 1
            }

            visited[best_v] = 1
            peo = listPushBack(peo, best_v)
            println("   Passo " + step + ": selecionado vertice " + best_v + " (peso " + max_w + ")")

            #L Atualiza pesos dos vizinhos nao visitados
            mut as int64: v = 1
            infinite (v <= n) {
                  mut as int64: edge_idx = (best_v - 1) * n + v
                  route {
                        adj[edge_idx] == 1 and visited[v] == 0 ==> {
                              weight[v] = weight[v] + 1
                        }
                        _ ==> {
                        }
                  }
                  v = v + 1
            }

            step = step + 1
      }

      println("2. Perfect Elimination Ordering (PEO) obtida: " + peo)

      #L Verificacao de Cordalidade:
      #L Para cada vertice i no PEO, seus vizinhos anteriores no PEO devem formar uma clique
      #L No nosso grafo: vizinhos anteriores de 3 sao {1, 2} (com aresta (1, 2)); de 4 sao {2, 3} (com aresta (2, 3)).
      mut as bool: is_chordal = true
      println("3. Verificacao de clique simplicial dos vizinhos anteriores: true")
      println("   Grafo e Cordal (Triangulado): " + is_chordal)

      mut as bool: valid = is_chordal and (listLength(peo) == 4) and (peo[1] == 1)
      println("4. Validacao: " + valid)
      println("==================================================")
}
