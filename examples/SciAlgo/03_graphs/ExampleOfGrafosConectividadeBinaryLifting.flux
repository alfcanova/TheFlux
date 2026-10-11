#L ============================================================================
#L Algoritmo: Binary Lifting (Elevacao Binaria para LCA e K-esimo Ancestral)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V log V) preprocessamento | O(log V) por consulta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeBinaryLifting) {
      println("==================================================")
      println("  SciAlgo: Binary Lifting (Ancestors in O(log V)) ")
      println("==================================================")

      mut as int64: num_v = 7
      mut as list of int64: parent = [0, 1, 1, 2, 2, 3, 3]
      mut as list of int64: depth = [0, 1, 1, 2, 2, 2, 2]

      #L Tabela up[num_v * 3] onde colunas sao 2^0, 2^1, 2^2
      mut as list of int64: up = [
            0, 0, 0,
            1, 0, 0,
            1, 0, 0,
            2, 1, 0,
            2, 1, 0,
            3, 1, 0,
            3, 1, 0
      ]

      mut as list of int64: pow2 = [1, 2, 4]

      println("1. Consulta de K-esimo Ancestral:")
      #L 2o ancestral do no 4 (4 -> 2 -> 1)
      mut as int64: cur_node = 4
      mut as int64: k_steps = 2
      mut as int64: k = 2
      infinite (k >= 0) {
            route {
                  k_steps >= pow2[k + 1] ==> {
                        cur_node = up[(cur_node - 1) * 3 + (k + 1)]
                        k_steps = k_steps - pow2[k + 1]
                  }
                  _ ==> {}
            }
            k = k - 1
      }
      println("   2o ancestral do vertice 4: " + cur_node)

      println("2. Consultas de LCA via Binary Lifting:")
      mut as list of int64: q_u = [4, 4, 6, 5]
      mut as list of int64: q_v = [5, 7, 7, 2]
      mut as int64: qi = 1

      infinite (qi <= 4) {
            mut as int64: u = q_u[qi]
            mut as int64: v = q_v[qi]

            route {
                  depth[u] < depth[v] ==> {
                        mut as int64: tmp = u
                        u = v
                        v = tmp
                  }
                  _ ==> {}
            }

            mut as int64: diff = depth[u] - depth[v]
            k = 2
            infinite (k >= 0) {
                  route {
                        diff >= pow2[k + 1] ==> {
                              u = up[(u - 1) * 3 + (k + 1)]
                              diff = diff - pow2[k + 1]
                        }
                        _ ==> {}
                  }
                  k = k - 1
            }

            mut as int64: lca_res = 0
            route {
                  u == v ==> {
                        lca_res = u
                  }
                  _ ==> {
                        k = 2
                        infinite (k >= 0) {
                              mut as int64: anc_u = up[(u - 1) * 3 + (k + 1)]
                              mut as int64: anc_v = up[(v - 1) * 3 + (k + 1)]
                              route {
                                    anc_u != anc_v ==> {
                                          u = anc_u
                                          v = anc_v
                                    }
                                    _ ==> {}
                              }
                              k = k - 1
                        }
                        lca_res = up[(u - 1) * 3 + 1]
                  }
            }

            println("   LCA(" + q_u[qi] + ", " + q_v[qi] + ") = " + lca_res)
            qi = qi + 1
      }
}
