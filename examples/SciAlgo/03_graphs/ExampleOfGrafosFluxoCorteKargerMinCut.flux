#L ============================================================================
#L Algoritmo: Karger's Min-Cut (Corte Minimo por Contracao Aleatoria)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V^2) por tentativa / O(V^2 * log V) repeticoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteKargerMinCut) {
      println("==================================================")
      println("  SciAlgo: Karger's Min-Cut                       ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: num_e = 8

      mut as list of int64: edge_u = [1, 2, 3, 4, 5, 6, 1, 2]
      mut as list of int64: edge_v = [2, 3, 1, 5, 6, 4, 4, 5]

      println("1. Grafo com " + num_v + " vertices e " + num_e + " arestas:")
      println("   Triangulo A: {1, 2, 3}, Triangulo B: {4, 5, 6}")
      println("   Arestas de corte entre A e B: (1-4) e (2-5)")

      mut as int64: seed = 1234567
      mut as int64: num_trials = 10
      mut as int64: min_cut = 999999

      mut as int64: trial = 1
      infinite (trial <= num_trials) {
            #L Inicializa DSU
            mut as list of int64: parent = [1, 2, 3, 4, 5, 6]
            mut as int64: active_v = num_v

            #L Contrai arestas aleatoriamente ate restarem 2 componentes
            infinite (active_v > 2) {
                  #L Gerador LCG deterministico
                  seed = (seed * 1103515245 + 12345) /r 2147483647
                  route {
                        seed < 0 ==> {
                              seed = 0 - seed
                        }
                        _ ==> {}
                  }

                  mut as int64: picked_edge = 1 + (seed /r num_e)
                  mut as int64: u = edge_u[picked_edge]
                  mut as int64: v = edge_v[picked_edge]

                  #L Find(u)
                  mut as int64: ru = u
                  infinite (parent[ru] != ru) {
                        ru = parent[ru]
                  }

                  #L Find(v)
                  mut as int64: rv = v
                  infinite (parent[rv] != rv) {
                        rv = parent[rv]
                  }

                  route {
                        ru != rv ==> {
                              parent[ru] = rv
                              active_v = active_v - 1
                        }
                        _ ==> {}
                  }
            }

            #L Conta arestas que cruzam os 2 super-vertices restantes
            mut as int64: cut_edges = 0
            mut as int64: e = 1
            infinite (e <= num_e) {
                  mut as int64: u = edge_u[e]
                  mut as int64: v = edge_v[e]

                  mut as int64: ru = u
                  infinite (parent[ru] != ru) {
                        ru = parent[ru]
                  }

                  mut as int64: rv = v
                  infinite (parent[rv] != rv) {
                        rv = parent[rv]
                  }

                  route {
                        ru != rv ==> {
                              cut_edges = cut_edges + 1
                        }
                        _ ==> {}
                  }
                  e = e + 1
            }

            route {
                  cut_edges < min_cut ==> {
                        min_cut = cut_edges
                  }
                  _ ==> {}
            }

            trial = trial + 1
      }

      println("2. Min-Cut encontrado apos " + num_trials + " tentativas: " + min_cut)
      println("Karger's Min-Cut concluido com sucesso.")
}
