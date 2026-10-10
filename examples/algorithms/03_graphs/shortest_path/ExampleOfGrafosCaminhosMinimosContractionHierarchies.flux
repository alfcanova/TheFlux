#L ============================================================================
#L Algoritmo: Contraction Hierarchies (Hierarquias de Contracao / CH)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: Preprocessamento O(V log V + E) | Consulta O(log V)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosContractionHierarchies) {
      println("==================================================")
      println("  SciAlgo: Contraction Hierarchies (CH)           ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: src = 1
      mut as int64: target = 5

      #L Grafo original em cadeia: 1 - 2 (1), 2 - 3 (1), 3 - 4 (1), 4 - 5 (1)
      #L e aresta direta 1 - 5 com custo subotimo 10.
      println("1. Grafo Original com 5 Vertices:")
      println("   Cadeia: 1-2 (1), 2-3 (1), 3-4 (1), 4-5 (1), direta: 1-5 (10)")

      #L ETAPA 1: Ordem de Contracao e Insercao de Atalhos (Shortcuts)
      #L Ordem de importancia (ranks): nos 2, 3, 4 sao contraidos primeiro.
      #L Ranks: rank[2]=1, rank[3]=2, rank[4]=3, rank[1]=4, rank[5]=5
      mut as list of int64: rank = [4, 1, 2, 3, 5]

      #L Grafo aumentado com atalhos (upward graph):
      #L Cada aresta so e percorrida na direcao de MENOR rank para MAIOR rank!
      #L Arestas ascendentes (u -> v com rank[u] < rank[v]):
      #L (2 -> 1: peso 1), (2 -> 3: peso 1)
      #L (3 -> 1: atalho peso 2), (3 -> 4: peso 1)
      #L (4 -> 1: atalho peso 3), (4 -> 5: peso 1)
      #L (1 -> 5: atalho peso 4)
      mut as list of int64: ch_weight = [
            0, 0, 0, 0, 4,
            1, 0, 1, 0, 0,
            2, 0, 0, 1, 0,
            3, 0, 0, 0, 1,
            0, 0, 0, 0, 0
      ]

      println("2. Pre-processamento CH Concluido: Atalhos ascendentes inseridos.")

      #L ETAPA 2: Consulta Bidirecional Ascendente (Upward Search)
      #L Busca para frente a partir de src=1 (so para nos com rank maior)
      #L Busca para tras a partir de target=5 (so para nos com rank maior)
      mut as list of int64: dist_f = [999999, 999999, 999999, 999999, 999999]
      mut as list of int64: dist_b = [999999, 999999, 999999, 999999, 999999]

      dist_f[src] = 0
      dist_b[target] = 0

      #L Relaxamento ascendente de src (rank[1] = 4, so pode ir para rank 5)
      mut as int64: v = 1
      infinite (v <= num_v) {
            mut as int64: w = ch_weight[(src - 1) * num_v + v]
            route {
                  (w > 0) and (rank[v] > rank[src]) ==> {
                        route {
                              dist_f[src] + w < dist_f[v] ==> {
                                    dist_f[v] = dist_f[src] + w
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            v = v + 1
      }

      #L Relaxamento ascendente reverso de target (rank[5] = 5 e o topo)
      #L Arestas ascendentes que chegam em target vindo de nos com menor rank
      mut as int64: u = 1
      infinite (u <= num_v) {
            mut as int64: w = ch_weight[(u - 1) * num_v + target]
            route {
                  (w > 0) and (rank[u] < rank[target]) ==> {
                        route {
                              dist_b[target] + w < dist_b[u] ==> {
                                    dist_b[u] = dist_b[target] + w
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            u = u + 1
      }

      #L Ponto de encontro: menor dist_f[p] + dist_b[p]
      mut as int64: best_dist = 999999
      mut as int64: peak_node = 0
      mut as int64: p = 1
      infinite (p <= num_v) {
            route {
                  dist_f[p] + dist_b[p] < best_dist ==> {
                        best_dist = dist_f[p] + dist_b[p]
                        peak_node = p
                  }
                  _ ==> {}
            }
            p = p + 1
      }

      println("3. Consulta CH:")
      println("   No de pico (maior hierarquia): " + peak_node)
      println("   Distancia Minima Calculada: " + best_dist)
      println("Contraction Hierarchies concluido com sucesso.")
}
