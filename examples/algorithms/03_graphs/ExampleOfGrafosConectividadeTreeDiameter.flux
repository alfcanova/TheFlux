#L ============================================================================
#L Algoritmo: Tree Diameter (Diametro de Arvore via Dupla BFS)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeTreeDiameter) {
      println("==================================================")
      println("  SciAlgo: Tree Diameter (Double BFS)             ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as list of int64: adj = [
            0, 1, 0, 0, 0, 0,
            1, 0, 1, 0, 0, 0,
            0, 1, 0, 1, 1, 0,
            0, 0, 1, 0, 0, 0,
            0, 0, 1, 0, 0, 1,
            0, 0, 0, 0, 1, 0
      ]

      #L Primeira BFS a partir do vertice 1
      mut as list of int64: dist = [-1, -1, -1, -1, -1, -1]
      mut as list of int64: q = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: q_h = 1
      mut as int64: q_t = 1
      q[1] = 1
      dist[1] = 0

      mut as int64: farthest1 = 1
      mut as int64: max_d1 = 0

      infinite (q_h <= q_t) {
            mut as int64: u = q[q_h]
            q_h = q_h + 1

            route {
                  dist[u] > max_d1 ==> {
                        max_d1 = dist[u]
                        farthest1 = u
                  }
                  _ ==> {}
            }

            mut as int64: v = 1
            infinite (v <= num_v) {
                  mut as int64: has_e = adj[(u - 1) * num_v + v]
                  route {
                        has_e == 1 and dist[v] == -1 ==> {
                              dist[v] = dist[u] + 1
                              q_t = q_t + 1
                              q[q_t] = v
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
      }

      println("1. Vertice mais distante a partir do no 1: " + farthest1 + " (distancia " + max_d1 + ")")

      #L Segunda BFS a partir de farthest1
      mut as int64: i = 1
      infinite (i <= num_v) {
            dist[i] = -1
            i = i + 1
      }

      q_h = 1
      q_t = 1
      q[1] = farthest1
      dist[farthest1] = 0

      mut as int64: farthest2 = farthest1
      mut as int64: max_d2 = 0

      infinite (q_h <= q_t) {
            mut as int64: u = q[q_h]
            q_h = q_h + 1

            route {
                  dist[u] > max_d2 ==> {
                        max_d2 = dist[u]
                        farthest2 = u
                  }
                  _ ==> {}
            }

            mut as int64: v = 1
            infinite (v <= num_v) {
                  mut as int64: has_e = adj[(u - 1) * num_v + v]
                  route {
                        has_e == 1 and dist[v] == -1 ==> {
                              dist[v] = dist[u] + 1
                              q_t = q_t + 1
                              q[q_t] = v
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
      }

      println("2. Extremidades do Diametro: " + farthest1 + " e " + farthest2)
      println("3. Comprimento do Diametro: " + max_d2)
}
