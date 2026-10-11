#L ============================================================================
#L Algoritmo: Lifelong Planning A* (LPA*)
#L Dominio: 01_foundations / Busca
#L Complexidade: O(b^d) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaLPAStar) {
      println("==================================================")
      println("  SciAlgo: Lifelong Planning A* (LPA*)            ")
      println("==================================================")

      mut as int64: num_nodes = 4
      mut as int64: start = 1
      mut as int64: goal = 4

      #L Matriz de adjacencia (4x4)
      #L Inicial: 1->2 (2), 1->3 (5), 2->4 (3), 3->4 (1)
      mut as list of list of int64: cost = [
            [0, 2, 5, 0],
            [0, 0, 0, 3],
            [0, 0, 0, 1],
            [0, 0, 0, 0]
      ]

      mut as list of int64: g = [0, 9999, 9999, 9999, 9999]
      mut as list of int64: rhs = [0, 9999, 9999, 9999, 9999]
      rhs[start] = 0

      println("1. Fase Inicial: Planejamento Estatico")
      #L Computa caminho estatico
      mut as int64: step = 1
      infinite (step <= num_nodes) {
            mut as int64: u = 1
            infinite (u <= num_nodes) {
                  route {
                        g[u] != rhs[u] ==> {
                              g[u] = rhs[u]
                              mut as int64: v = 1
                              infinite (v <= num_nodes) {
                                    mut as int64: w = cost[u][v]
                                    route {
                                          w > 0 ==> {
                                                mut as int64: cand = g[u] + w
                                                route {
                                                      cand < rhs[v] ==> {
                                                            rhs[v] = cand
                                                      }
                                                }
                                          }
                                    }
                                    v = v + 1
                              }
                        }
                  }
                  u = u + 1
            }
            step = step + 1
      }

      println("   Custo inicial ate o destino: " + g[goal])

      println("2. Fase Dinamica: Reducao de custo na aresta (1 -> 3) de 5 para 1")
      cost[1][3] = 1
      #L Atualiza rhs[3]
      mut as int64: new_rhs3 = g[1] + cost[1][3]
      route {
            new_rhs3 < rhs[3] ==> {
                  rhs[3] = new_rhs3
            }
      }

      #L Replanejamento incremental
      step = 1
      infinite (step <= num_nodes) {
            mut as int64: u = 1
            infinite (u <= num_nodes) {
                  route {
                        g[u] != rhs[u] ==> {
                              g[u] = rhs[u]
                              mut as int64: v = 1
                              infinite (v <= num_nodes) {
                                    mut as int64: w = cost[u][v]
                                    route {
                                          w > 0 ==> {
                                                mut as int64: cand = g[u] + w
                                                route {
                                                      cand < rhs[v] ==> {
                                                            rhs[v] = cand
                                                      }
                                                }
                                          }
                                    }
                                    v = v + 1
                              }
                        }
                  }
                  u = u + 1
            }
            step = step + 1
      }

      println("3. Custo recalculado apos mudanca: " + g[goal])
      #L Caminho inicial: 1->2->4 (custo 5). Apos diminuir 1->3 para 1: 1->3->4 (custo 1+1=2)
      mut as bool: ok = (g[goal] == 2)
      println("4. Validacao (Custo replanejado == 2): " + ok)
      println("==================================================")
}
