#L ============================================================================
#L Algoritmo: Difference Constraints (Sistema de Restricoes de Diferencas)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(V * E) tempo via Bellman-Ford | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysDifferenceConstraints) {
      println("==================================================")
      println("  SciAlgo: System of Difference Constraints")
      println("==================================================")

      #L Variaveis x1, x2, x3, x4 e vertice ficticio 0 (super-fonte)
      #L Total de vertices V = 5 (indices 1..5 onde 1 representa x0)
      mut as int64: num_v = 5

      #L Sistema de inequacoes xj - xi <= c convertido em arestas i -> j com peso c
      #L Restricoes:
      #L 1. x2 - x1 <= 3   (aresta 2 -> 3, peso 3)
      #L 2. x3 - x2 <= -2  (aresta 3 -> 4, peso -2)
      #L 3. x4 - x3 <= 2   (aresta 4 -> 5, peso 2)
      #L 4. x4 - x1 <= 2   (aresta 2 -> 5, peso 2)
      #L Arestas da super-fonte x0 (vertice 1) para todos os outros com peso 0:
      #L 5. x0 -> x1 (peso 0)
      #L 6. x0 -> x2 (peso 0)
      #L 7. x0 -> x3 (peso 0)
      #L 8. x0 -> x4 (peso 0)

      mut as list of int64: edge_u = [2, 3, 4, 2, 1, 1, 1, 1]
      mut as list of int64: edge_v = [3, 4, 5, 5, 2, 3, 4, 5]
      mut as list of int64: edge_w = [3, -2, 2, 2, 0, 0, 0, 0]
      mut as int64: num_edges = listLength(edge_u)

      println("1. Sistema de inequacoes modelado como grafo de restricoes (" + num_edges + " arestas)")

      #L Vetor de distancias inicializado com 0 para a super-fonte e infinito para os demais
      mut as list of int64: dist = [0, 999999, 999999, 999999, 999999]

      #L Execucao de Bellman-Ford (V - 1 relaxacoes)
      mut as int64: iter = 1
      infinite (iter <= num_v - 1) {
            mut as int64: e = 1
            infinite (e <= num_edges) {
                  mut as int64: u = edge_u[e]
                  mut as int64: v = edge_v[e]
                  mut as int64: w = edge_w[e]

                  route {
                        dist[u] < 999999 and dist[u] + w < dist[v] ==> {
                              dist[v] = dist[u] + w
                        }
                        _ ==> {
                        }
                  }
                  e = e + 1
            }
            iter = iter + 1
      }

      #L Verificacao de ciclo negativo (inconsistencia no sistema)
      mut as bool: has_negative_cycle = false
      mut as int64: check_e = 1
      infinite (check_e <= num_edges) {
            mut as int64: u_chk = edge_u[check_e]
            mut as int64: v_chk = edge_v[check_e]
            mut as int64: w_chk = edge_w[check_e]

            route {
                  dist[u_chk] < 999999 and dist[u_chk] + w_chk < dist[v_chk] ==> {
                        has_negative_cycle = true
                  }
                  _ ==> {
                  }
            }
            check_e = check_e + 1
      }

      route {
            has_negative_cycle ==> {
                  println("2. Sistema INCONSISTENTE: ciclo negativo detectado.")
            }
            _ ==> {
                  println("2. Sistema CONSISTENTE e viavel!")
                  println("3. Solucao viavel encontrada (distancias maximas permitidas):")
                  println("   x1 = " + dist[2])
                  println("   x2 = " + dist[3])
                  println("   x3 = " + dist[4])
                  println("   x4 = " + dist[5])

                  #L Validacao das restricoes
                  println("4. Validacao:")
                  println("   x2 - x1 = " + (dist[3] - dist[2]) + " <= 3 (OK)")
                  println("   x3 - x2 = " + (dist[4] - dist[3]) + " <= -2 (OK)")
                  println("   x4 - x3 = " + (dist[5] - dist[4]) + " <= 2 (OK)")
                  println("   x4 - x1 = " + (dist[5] - dist[2]) + " <= 2 (OK)")
            }
      }
}
