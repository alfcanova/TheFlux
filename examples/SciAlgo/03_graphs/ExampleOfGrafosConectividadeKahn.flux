#L ============================================================================
#L Algoritmo: Kahn's Algorithm (Ordenacao Topologica Baseada em Grau de Entrada)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeKahn) {
      println("==================================================")
      println("  SciAlgo: Kahn's Algorithm (In-Degree Topo Sort) ")
      println("==================================================")

      mut as int64: num_v = 6

      #L DAG: 1->2, 1->3, 2->4, 3->4, 4->5, 5->6
      mut as list of int64: adj = [
            0, 1, 1, 0, 0, 0,
            0, 0, 0, 1, 0, 0,
            0, 0, 0, 1, 0, 0,
            0, 0, 0, 0, 1, 0,
            0, 0, 0, 0, 0, 1,
            0, 0, 0, 0, 0, 0
      ]

      println("1. Grafo Direcionado com 6 Vertices")

      #L Calcula in-degree
      mut as list of int64: in_deg = [0, 0, 0, 0, 0, 0]
      mut as int64: u = 1
      mut as int64: v = 1

      infinite (u <= num_v) {
            v = 1
            infinite (v <= num_v) {
                  route {
                        adj[(u - 1) * num_v + v] == 1 ==> {
                              in_deg[v] = in_deg[v] + 1
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
            u = u + 1
      }

      #L Fila com vertices de in-degree 0
      mut as list of int64: q = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: head = 1
      mut as int64: tail = 1

      mut as int64: i = 1
      infinite (i <= num_v) {
            route {
                  in_deg[i] == 0 ==> {
                        q[tail] = i
                        tail = tail + 1
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      mut as list of int64: topo_res = [0, 0, 0, 0, 0, 0]
      mut as int64: processed = 0

      infinite (head < tail) {
            mut as int64: curr = q[head]
            head = head + 1

            processed = processed + 1
            topo_res[processed] = curr

            v = 1
            infinite (v <= num_v) {
                  route {
                        adj[(curr - 1) * num_v + v] == 1 ==> {
                              in_deg[v] = in_deg[v] - 1
                              route {
                                    in_deg[v] == 0 ==> {
                                          q[tail] = v
                                          tail = tail + 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
      }

      route {
            processed < num_v ==> {
                  println("2. Ciclo detectado: o grafo nao e um DAG!")
            }
            _ ==> {
                  println("2. Ordem Topologica Valida (Kahn):")
                  i = 1
                  infinite (i <= processed) {
                        println("   Passo " + i + ": Vertice " + topo_res[i])
                        i = i + 1
                  }
            }
      }

      println("Kahn's Algorithm concluido com sucesso.")
}
