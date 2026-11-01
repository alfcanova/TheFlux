#L ============================================================================
#L Algoritmo: Ford-Fulkerson (Fluxo Maximo com Busca de Caminho Aumentante)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(E * max_flow) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteFordFulkerson) {
      println("==================================================")
      println("  SciAlgo: Ford-Fulkerson (Fluxo Maximo)          ")
      println("==================================================")

      #L Grafo com V = 4 vertices (1: fonte, 4: sumidouro)
      mut as int64: num_v = 4
      mut as int64: src = 1
      mut as int64: sink = 4

      #L Matriz de capacidade residual (4x4 linearizada 1-based, tamanho 16)
      #L Indice (u - 1) * 4 + v
      mut as list of int64: capacity = [
            0, 10, 5, 0,
            0, 0, 15, 10,
            0, 0, 0, 10,
            0, 0, 0, 0
      ]

      println("1. Grafo de Capacidades de Entrada:")
      println("   Fonte: " + src + ", Sumidouro: " + sink)
      println("   Capacidades: 1->2: 10, 1->3: 5, 2->3: 15, 2->4: 10, 3->4: 10")

      mut as int64: max_flow = 0
      mut as int64: iter = 0

      #L Laco principal de Ford-Fulkerson: busca caminhos aumentantes via DFS
      infinite (true) {
            iter = iter + 1

            #L Vetor de visitados e pais para reconstrucao do caminho
            mut as list of bool: visited = [false, false, false, false]
            mut as list of int64: parent = [0, 0, 0, 0]

            #L Pilha para DFS simples
            mut as list of int64: stack = [src, 0, 0, 0]
            mut as int64: top = 1
            visited[src] = true

            mut as bool: path_found = false

            infinite (top > 0) {
                  mut as int64: curr = stack[top]
                  top = top - 1

                  route {
                        curr == sink ==> {
                              path_found = true
                              break
                        }
                        _ ==> {}
                  }

                  #L Explora vizinhos
                  mut as int64: nxt = 1
                  infinite (nxt <= num_v) {
                        mut as int64: idx = (curr - 1) * num_v + nxt
                        mut as int64: cap_res = capacity[idx]

                        route {
                              (not visited[nxt]) and (cap_res > 0) ==> {
                                    visited[nxt] = true
                                    parent[nxt] = curr
                                    top = top + 1
                                    stack[top] = nxt
                              }
                              _ ==> {}
                        }
                        nxt = nxt + 1
                  }
            }

            #L Se nao encontrou caminho aumentante, terminamos
            route {
                  not path_found ==> {
                        break
                  }
                  _ ==> {}
            }

            #L Determina o gargalo (capacidade residual minima) ao longo do caminho
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

            #L Atualiza capacidades residuais ao longo do caminho
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
            println("   Iteracao " + iter + ": Caminho aumentante com gargalo = " + bottleneck)
      }

      println("2. Resultado Final:")
      println("   Fluxo Maximo Calculado: " + max_flow)

      #L Validacao deterministica do resultado
      route {
            max_flow == 15 ==> {
                  println("   Validacao: SUCESSO (Fluxo Maximo = 15)")
            }
            _ ==> {
                  println("   Validacao: FALHA")
            }
      }

      println("Ford-Fulkerson concluido com sucesso.")
}
