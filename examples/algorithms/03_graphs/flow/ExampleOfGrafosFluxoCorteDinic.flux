#L ============================================================================
#L Algoritmo: Dinic (Fluxo em Niveis e Fluxo Bloqueante)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V^2 * E) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteDinic) {
      println("==================================================")
      println("  SciAlgo: Dinic (Fluxo Bloqueante em Niveis)     ")
      println("==================================================")

      mut as int64: num_v = 4
      mut as int64: src = 1
      mut as int64: sink = 4

      #L Matriz residual linearizada 4x4
      mut as list of int64: capacity = [
            0, 10, 10, 0,
            0, 0, 2, 4,
            0, 0, 0, 9,
            0, 0, 0, 0
      ]

      println("1. Grafo de Entrada:")
      println("   Fonte: " + src + ", Sumidouro: " + sink)
      println("   Capacidades: 1->2: 10, 1->3: 10, 2->3: 2, 2->4: 4, 3->4: 9")

      mut as int64: max_flow = 0
      mut as int64: phase = 0

      #L Laco externo: enquanto houver caminho no grafo em niveis (BFS)
      infinite (true) {
            phase = phase + 1

            #L BFS para calcular niveis
            mut as list of int64: level = [-1, -1, -1, -1]
            mut as list of int64: queue = [src, 0, 0, 0]
            mut as int64: head = 1
            mut as int64: tail = 1
            level[src] = 0

            infinite (head <= tail) {
                  mut as int64: u = queue[head]
                  head = head + 1

                  mut as int64: v = 1
                  infinite (v <= num_v) {
                        mut as int64: idx = (u - 1) * num_v + v
                        mut as int64: cap = capacity[idx]

                        route {
                              (level[v] == -1) and (cap > 0) ==> {
                                    level[v] = level[u] + 1
                                    tail = tail + 1
                                    queue[tail] = v
                              }
                              _ ==> {}
                        }
                        v = v + 1
                  }
            }

            #L Se o sumidouro nao for alcancavel, o fluxo maximo foi atingido
            route {
                  level[sink] == -1 ==> {
                        break
                  }
                  _ ==> {}
            }

            #L Laco interno: envia fluxo bloqueante no grafo de niveis usando caminhos aumentantes
            mut as int64: flow_pushed_in_phase = 0
            infinite (true) {
                  #L Busca caminho aumentante respeitando level[v] == level[u] + 1
                  mut as list of bool: visited = [false, false, false, false]
                  mut as list of int64: parent = [0, 0, 0, 0]
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

                        mut as int64: nxt = 1
                        infinite (nxt <= num_v) {
                              mut as int64: idx = (curr - 1) * num_v + nxt
                              mut as int64: cap = capacity[idx]

                              route {
                                    (not visited[nxt]) and (cap > 0) and (level[nxt] == level[curr] + 1) ==> {
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

                  route {
                        not path_found ==> {
                              break
                        }
                        _ ==> {}
                  }

                  #L Gargalo
                  mut as int64: bottleneck = 999999
                  mut as int64: cur_v = sink
                  infinite (cur_v != src) {
                        mut as int64: p = parent[cur_v]
                        mut as int64: idx = (p - 1) * num_v + cur_v
                        mut as int64: cap = capacity[idx]
                        route {
                              cap < bottleneck ==> {
                                    bottleneck = cap
                              }
                              _ ==> {}
                        }
                        cur_v = p
                  }

                  #L Atualiza capacidades residuais
                  cur_v = sink
                  infinite (cur_v != src) {
                        mut as int64: p = parent[cur_v]
                        mut as int64: fwd = (p - 1) * num_v + cur_v
                        mut as int64: rev = (cur_v - 1) * num_v + p

                        capacity[fwd] = capacity[fwd] - bottleneck
                        capacity[rev] = capacity[rev] + bottleneck
                        cur_v = p
                  }

                  flow_pushed_in_phase = flow_pushed_in_phase + bottleneck
                  max_flow = max_flow + bottleneck
            }

            println("   Fase Dinic " + phase + ": Fluxo acumulado ate aqui = " + max_flow)
      }

      println("2. Resultado Final:")
      println("   Fluxo Maximo Dinic: " + max_flow)

      route {
            max_flow == 13 ==> {
                  println("   Validacao: SUCESSO (Fluxo Maximo = 13)")
            }
            _ ==> {
                  println("   Validacao: FALHA")
            }
      }

      println("Dinic concluido com sucesso.")
}
