#L ============================================================================
#L Algoritmo: Edmonds-Karp (Fluxo Maximo com BFS)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V * E^2) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteEdmondsKarp) {
      println("==================================================")
      println("  SciAlgo: Edmonds-Karp (Fluxo Maximo com BFS)    ")
      println("==================================================")

      #L Grafo com V = 4 vertices (1: fonte, 4: sumidouro)
      mut as int64: num_v = 4
      mut as int64: src = 1
      mut as int64: sink = 4

      #L Matriz de capacidade residual (4x4 linearizada 1-based, tamanho 16)
      mut as list of int64: capacity = [
            0, 20, 10, 0,
            0, 0, 30, 10,
            0, 0, 0, 20,
            0, 0, 0, 0
      ]

      println("1. Grafo de Entrada:")
      println("   Fonte: " + src + ", Sumidouro: " + sink)
      println("   Capacidades: 1->2: 20, 1->3: 10, 2->3: 30, 2->4: 10, 3->4: 20")

      mut as int64: max_flow = 0
      mut as int64: iter = 0

      #L Edmonds-Karp: BFS encontra o caminho mais curto em numero de arestas
      infinite (true) {
            iter = iter + 1

            mut as list of bool: visited = [false, false, false, false]
            mut as list of int64: parent = [0, 0, 0, 0]

            #L Fila para BFS
            mut as list of int64: queue = [src, 0, 0, 0]
            mut as int64: head = 1
            mut as int64: tail = 1
            visited[src] = true

            mut as bool: path_found = false

            infinite (head <= tail) {
                  mut as int64: curr = queue[head]
                  head = head + 1

                  route {
                        curr == sink ==> {
                              path_found = true
                              break
                        }
                        _ ==> {}
                  }

                  mut as int64: nxt = 1
                  infinite (nxt <= num_v) {
                        mut as int64: idx = (curr - 1) * num_v + nxt
                        mut as int64: cap_res = capacity[idx]

                        route {
                              (not visited[nxt]) and (cap_res > 0) ==> {
                                    visited[nxt] = true
                                    parent[nxt] = curr
                                    tail = tail + 1
                                    queue[tail] = nxt
                              }
                              _ ==> {}
                        }
                        nxt = nxt + 1
                  }
            }

            route {
                  not path_found ==> {
                        break
                  }
                  _ ==> {}
            }

            #L Determina o gargalo
            mut as int64: bottleneck = 999999
            mut as int64: v = sink
            infinite (v != src) {
                  mut as int64: u = parent[v]
                  mut as int64: idx = (u - 1) * num_v + v
                  mut as int64: cap = capacity[idx]
                  route {
                        cap < bottleneck ==> {
                              bottleneck = cap
                        }
                        _ ==> {}
                  }
                  v = u
            }

            #L Atualiza capacidades residuais
            v = sink
            infinite (v != src) {
                  mut as int64: u = parent[v]
                  mut as int64: fwd_idx = (u - 1) * num_v + v
                  mut as int64: rev_idx = (v - 1) * num_v + u

                  capacity[fwd_idx] = capacity[fwd_idx] - bottleneck
                  capacity[rev_idx] = capacity[rev_idx] + bottleneck

                  v = u
            }

            max_flow = max_flow + bottleneck
            println("   Iteracao " + iter + ": Caminho BFS aumentante com gargalo = " + bottleneck)
      }

      println("2. Resultado Final:")
      println("   Fluxo Maximo Calculado: " + max_flow)

      route {
            max_flow == 30 ==> {
                  println("   Validacao: SUCESSO (Fluxo Maximo = 30)")
            }
            _ ==> {
                  println("   Validacao: FALHA")
            }
      }

      println("Edmonds-Karp concluido com sucesso.")
}
