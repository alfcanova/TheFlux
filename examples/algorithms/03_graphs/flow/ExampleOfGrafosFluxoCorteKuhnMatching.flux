#L ============================================================================
#L Algoritmo: Kuhn Matching (Emparelhamento Bipartido Maximo)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V * E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteKuhnMatching) {
      println("==================================================")
      println("  SciAlgo: Kuhn's Algorithm (Bipartite Matching)  ")
      println("==================================================")

      mut as int64: n_left = 4
      mut as int64: n_right = 4

      #L Matriz de adjacencia bipartida (n_left x n_right)
      #L L1 conecta em R1, R2
      #L L2 conecta em R1, R3
      #L L3 conecta em R2, R4
      #L L4 conecta em R3, R4
      mut as list of int64: adj = [
            1, 1, 0, 0,
            1, 0, 1, 0,
            0, 1, 0, 1,
            0, 0, 1, 1
      ]

      println("1. Grafo Bipartido de Entrada:")
      println("   L = {1, 2, 3, 4}, R = {1, 2, 3, 4}")
      println("   Arestas: L1->(R1, R2), L2->(R1, R3), L3->(R2, R4), L4->(R3, R4)")

      mut as list of int64: match_l = [0, 0, 0, 0]
      mut as list of int64: match_r = [0, 0, 0, 0]
      mut as int64: matching_size = 0

      #L Para cada vertice u em L, busca caminho aumentante alternante
      mut as int64: u0 = 1
      infinite (u0 <= n_left) {
            mut as list of bool: visited_r = [false, false, false, false]
            mut as list of int64: from_l = [0, 0, 0, 0]

            #L Fila para busca em largura/profundidade do caminho aumentante
            mut as list of int64: queue = [0, 0, 0, 0]
            mut as int64: q_head = 1
            mut as int64: q_tail = 1

            queue[q_tail] = u0
            q_tail = q_tail + 1

            mut as int64: free_v = 0

            infinite (q_head < q_tail and free_v == 0) {
                  mut as int64: curr_u = queue[q_head]
                  q_head = q_head + 1

                  mut as int64: v = 1
                  infinite (v <= n_right and free_v == 0) {
                        mut as int64: edge = adj[(curr_u - 1) * n_right + v]
                        route {
                              (edge == 1) and (not visited_r[v]) ==> {
                                    visited_r[v] = true
                                    from_l[v] = curr_u

                                    route {
                                          match_r[v] == 0 ==> {
                                                free_v = v
                                          }
                                          _ ==> {
                                                queue[q_tail] = match_r[v]
                                                q_tail = q_tail + 1
                                          }
                                    }
                              }
                              _ ==> {}
                        }
                        v = v + 1
                  }
            }

            #L Se encontrou vertice livre em R, aplica o caminho aumentante alternante
            route {
                  free_v > 0 ==> {
                        mut as int64: curr_v = free_v
                        infinite (curr_v != 0) {
                              mut as int64: u = from_l[curr_v]
                              mut as int64: prev_r = match_l[u]

                              match_r[curr_v] = u
                              match_l[u] = curr_v

                              curr_v = prev_r
                        }
                        matching_size = matching_size + 1
                  }
                  _ ==> {}
            }

            u0 = u0 + 1
      }

      println("2. Tamanho do Emparelhamento Maximo: " + matching_size)
      println("3. Pares correspondentes (L -> R):")
      mut as int64: i = 1
      infinite (i <= n_left) {
            println("   L" + i + " <-> R" + match_l[i])
            i = i + 1
      }
      println("Kuhn Matching concluido com sucesso.")
}
