#L ============================================================================
#L Algoritmo: Tree Center (Centro de Arvore via Poda de Folhas)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeTreeCenter) {
      println("==================================================")
      println("  SciAlgo: Tree Center (Leaf Trimming)            ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as list of int64: deg = [1, 2, 2, 2, 1] #L Caminho: 1-2-3-4-5
      mut as list of int64: adj = [
            0, 1, 0, 0, 0,
            1, 0, 1, 0, 0,
            0, 1, 0, 1, 0,
            0, 0, 1, 0, 1,
            0, 0, 0, 1, 0
      ]

      mut as list of int64: q = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: q_h = 1
      mut as int64: q_t = 0

      mut as int64: i = 1
      infinite (i <= num_v) {
            route {
                  deg[i] <= 1 ==> {
                        q_t = q_t + 1
                        q[q_t] = i
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      mut as int64: rem_nodes = num_v
      infinite (rem_nodes > 2) {
            mut as int64: sz = q_t - q_h + 1
            rem_nodes = rem_nodes - sz

            infinite (sz > 0) {
                  mut as int64: u = q[q_h]
                  q_h = q_h + 1
                  sz = sz - 1

                  mut as int64: v = 1
                  infinite (v <= num_v) {
                        mut as int64: has_e = adj[(u - 1) * num_v + v]
                        route {
                              has_e == 1 ==> {
                                    adj[(u - 1) * num_v + v] = 0
                                    adj[(v - 1) * num_v + u] = 0
                                    deg[v] = deg[v] - 1
                                    route {
                                          deg[v] == 1 ==> {
                                                q_t = q_t + 1
                                                q[q_t] = v
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        v = v + 1
                  }
            }
      }

      println("Vertices Centrais da Arvore:")
      infinite (q_h <= q_t) {
            mut as int64: center_node = q[q_h]
            q_h = q_h + 1
            println("   Centro: Vertice " + center_node)
      }
}
