#L ============================================================================
#L Algoritmo: Strongly Connected Components (Componentes Fortemente Conexos / SCC)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeStronglyConnectedComponents) {
      println("==================================================")
      println("  SciAlgo: Strongly Connected Components (SCC)    ")
      println("==================================================")

      mut as int64: num_v = 5

      #L Grafo direcionado com 5 vertices:
      #L Ciclo 1: 1->2, 2->3, 3->1 (SCC #1: {1, 2, 3})
      #L Aresta de ponte: 3->4
      #L Ciclo 2: 4->5, 5->4 (SCC #2: {4, 5})
      mut as list of int64: adj = [
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            1, 0, 0, 1, 0,
            0, 0, 0, 0, 1,
            0, 0, 0, 1, 0
      ]

      println("1. Grafo Direcionado com 5 Vertices:")
      println("   Ciclos: {1->2->3->1} e {4<->5}, ligacao 3->4")

      #L Fecho transitivo de alcancabilidade 5x5
      mut as list of bool: reach = [
            true,  false, false, false, false,
            false, true,  false, false, false,
            false, false, true,  false, false,
            false, false, false, true,  false,
            false, false, false, false, true
      ]

      mut as int64: i = 1
      mut as int64: j = 1
      mut as int64: k = 1

      #L Arestas diretas
      i = 1
      infinite (i <= num_v) {
            j = 1
            infinite (j <= num_v) {
                  route {
                        adj[(i - 1) * num_v + j] == 1 ==> {
                              reach[(i - 1) * num_v + j] = true
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      #L Warshall para alcancabilidade
      k = 1
      infinite (k <= num_v) {
            i = 1
            infinite (i <= num_v) {
                  j = 1
                  infinite (j <= num_v) {
                        route {
                              reach[(i - 1) * num_v + k] and reach[(k - 1) * num_v + j] ==> {
                                    reach[(i - 1) * num_v + j] = true
                              }
                              _ ==> {}
                        }
                        j = j + 1
                  }
                  i = i + 1
            }
            k = k + 1
      }

      #L Identifica SCCs: u e v estao na mesma SCC se reach(u, v) e reach(v, u)
      mut as list of int64: scc_id = [0, 0, 0, 0, 0]
      mut as int64: total_scc = 0

      i = 1
      infinite (i <= num_v) {
            route {
                  scc_id[i] == 0 ==> {
                        total_scc = total_scc + 1
                        scc_id[i] = total_scc

                        j = i + 1
                        infinite (j <= num_v) {
                              route {
                                    reach[(i - 1) * num_v + j] and reach[(j - 1) * num_v + i] ==> {
                                          scc_id[j] = total_scc
                                    }
                                    _ ==> {}
                              }
                              j = j + 1
                        }
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("2. Total de SCCs Detectadas: " + total_scc)
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + " -> SCC #" + scc_id[i])
            i = i + 1
      }

      println("Strongly Connected Components concluido com sucesso.")
}
