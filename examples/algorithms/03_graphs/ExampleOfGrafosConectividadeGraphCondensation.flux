#L ============================================================================
#L Algoritmo: Graph Condensation (Condensacao de Componentes Fortemente Conexas em DAG)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeGraphCondensation) {
      println("==================================================")
      println("  SciAlgo: Graph Condensation (SCC DAG)           ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as list of int64: comp = [1, 1, 1, 2, 2] #L Vertices 1,2,3 no SCC 1; Vertices 4,5 no SCC 2
      mut as int64: num_scc = 2

      #L Grafo: 1->2, 2->3, 3->1 (SCC 1), 3->4 (SCC 1 -> SCC 2), 4->5, 5->4 (SCC 2)
      mut as list of int64: edges_u = [1, 2, 3, 3, 4, 5]
      mut as list of int64: edges_v = [2, 3, 1, 4, 5, 4]
      mut as int64: num_e = 6

      mut as list of int64: dag_adj = [
            0, 0,
            0, 0
      ]

      mut as int64: e = 1
      infinite (e <= num_e) {
            mut as int64: u = edges_u[e]
            mut as int64: v = edges_v[e]
            mut as int64: cu = comp[u]
            mut as int64: cv = comp[v]

            route {
                  cu != cv ==> {
                        dag_adj[(cu - 1) * num_scc + cv] = 1
                  }
                  _ ==> {}
            }
            e = e + 1
      }

      println("1. Vertices e componentes SCC:")
      mut as int64: i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + " -> SCC " + comp[i])
            i = i + 1
      }

      println("2. Arestas do Grafo Condensado (DAG):")
      mut as int64: c1 = 1
      infinite (c1 <= num_scc) {
            mut as int64: c2 = 1
            infinite (c2 <= num_scc) {
                  mut as int64: has_edge = dag_adj[(c1 - 1) * num_scc + c2]
                  route {
                        has_edge == 1 ==> {
                              println("   SCC " + c1 + " -> SCC " + c2)
                        }
                        _ ==> {}
                  }
                  c2 = c2 + 1
            }
            c1 = c1 + 1
      }
}
