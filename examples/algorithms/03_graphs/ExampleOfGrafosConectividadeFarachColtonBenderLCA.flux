#L ============================================================================
#L Algoritmo: Farach-Colton and Bender LCA (Reducao de LCA para +-1 RMQ em Tour de Euler)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V) tempo | O(1) por consulta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeFarachColtonBenderLCA) {
      println("==================================================")
      println("  SciAlgo: Farach-Colton and Bender LCA (+-1 RMQ) ")
      println("==================================================")

      mut as int64: num_v = 5
      #L Tour de Euler (visita cada no ao percorrer cada aresta de ida e volta)
      #L Arvore: 1->2 (2->4, 2->5), 1->3
      mut as list of int64: euler_nodes = [1, 2, 4, 2, 5, 2, 1, 3, 1]
      mut as list of int64: euler_depth = [0, 1, 2, 1, 2, 1, 0, 1, 0]
      mut as int64: tour_len = 9

      #L Primeira ocorrencia de cada vertice no tour de Euler
      mut as list of int64: first_occ = [1, 2, 8, 3, 5]

      mut as list of int64: q_u = [4, 4, 2]
      mut as list of int64: q_v = [5, 3, 5]

      println("1. Tamanho do Tour de Euler: " + tour_len)
      println("2. Consultas de LCA via RMQ no Tour de Euler:")

      mut as int64: qi = 1
      infinite (qi <= 3) {
            mut as int64: idx_l = first_occ[q_u[qi]]
            mut as int64: idx_r = first_occ[q_v[qi]]

            route {
                  idx_l > idx_r ==> {
                        mut as int64: tmp = idx_l
                        idx_l = idx_r
                        idx_r = tmp
                  }
                  _ ==> {}
            }

            mut as int64: min_d = euler_depth[idx_l]
            mut as int64: min_node = euler_nodes[idx_l]
            mut as int64: k = idx_l + 1

            infinite (k <= idx_r) {
                  route {
                        euler_depth[k] < min_d ==> {
                              min_d = euler_depth[k]
                              min_node = euler_nodes[k]
                        }
                        _ ==> {}
                  }
                  k = k + 1
            }

            println("   LCA(" + q_u[qi] + ", " + q_v[qi] + ") = " + min_node)
            qi = qi + 1
      }
}
