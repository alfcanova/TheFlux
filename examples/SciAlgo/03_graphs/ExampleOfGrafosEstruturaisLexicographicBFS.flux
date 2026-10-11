#L ============================================================================
#L Algoritmo: Lexicographic BFS (Rose, Tarjan & Lueker 1976)
#L Dominio: 03_graphs / Categoria: Decomposicao estrutural de grafos
#L Complexidade: O(V + E) busca em largura lexicografica linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosEstruturaisLexicographicBFS) {
      println("==================================================")
      println("  SciAlgo: Lexicographic BFS (LexBFS - 1976)")
      println("==================================================")

      #L Grafo com 5 vertices:
      #L (1,2), (1,3), (2,3), (2,4), (3,4), (4,5)
      mut as int64: n = 5
      mut as list of int64: adj = [
            0, 1, 1, 0, 0,
            1, 0, 1, 1, 0,
            1, 1, 0, 1, 0,
            0, 1, 1, 0, 1,
            0, 0, 0, 1, 0
      ]

      #L Rotulo lexicografico ponderado por potencia de 2: label[u] = sum(2^k)
      mut as list of int64: label = [0, 0, 0, 0, 0]
      mut as list of int64: visited = [0, 0, 0, 0, 0]
      mut as list of int64: lex_order = []

      #L Potencias de 2 para simulacao do rotulo lexicografico:
      #L k = 5 -> 32, k = 4 -> 16, k = 3 -> 8, k = 2 -> 4, k = 1 -> 2
      mut as list of int64: pow2 = [2, 4, 8, 16, 32]

      println("1. Executando Lexicographic BFS (LexBFS):")
      mut as int64: step = n
      infinite (step >= 1) {
            #L Encontra vertice nao visitado com maior rotulo lexicografico
            mut as int64: best_u = 0
            mut as int64: max_lbl = -1
            mut as int64: u = 1
            infinite (u <= n) {
                  route {
                        visited[u] == 0 and label[u] > max_lbl ==> {
                              max_lbl = label[u]
                              best_u = u
                        }
                        _ ==> {
                        }
                  }
                  u = u + 1
            }

            visited[best_u] = 1
            lex_order = listPushBack(lex_order, best_u)
            println("   Posicao " + step + ": vertice " + best_u + " (rotulo lex = " + max_lbl + ")")

            #L Atualiza rotulo dos vizinhos nao visitados acrescentando peso 2^step
            mut as int64: add_weight = pow2[step]
            mut as int64: v = 1
            infinite (v <= n) {
                  mut as int64: edge_idx = (best_u - 1) * n + v
                  route {
                        adj[edge_idx] == 1 and visited[v] == 0 ==> {
                              label[v] = label[v] + add_weight
                        }
                        _ ==> {
                        }
                  }
                  v = v + 1
            }

            step = step - 1
      }

      println("2. Sequencia final da ordenacao LexBFS: " + lex_order)

      mut as bool: valid = (listLength(lex_order) == 5) and (lex_order[1] == 1)
      println("3. Validacao: " + valid)
      println("==================================================")
}
