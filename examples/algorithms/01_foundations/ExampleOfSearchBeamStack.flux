#L ============================================================================
#L Algoritmo: Beam Stack Search (Busca em Feixe com Pilha de Backtracking)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b * d) espaco com garantia de completeza
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchBeamStack) {
      println("==================================================")
      println("  SciAlgo: Beam Stack Search (Zhou & Hansen 2005)")
      println("==================================================")

      #L Grafo onde um caminho enganoso tem heuristica menor, mas leva a um beco sem saida
      #L 1 -> [2 (h=3, beco sem saida), 3 (h=5, leva ao objetivo 6)]
      #L 2 -> [4 (h=2, beco), 5 (h=1, beco sem saida)]
      #L 3 -> [6 (h=0, objetivo!)]
      mut as list of list of int64: adj = [
            [0, 1, 1, 0, 0, 0],
            [0, 0, 0, 1, 1, 0],
            [0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0]
      ]

      mut as list of int64: h = [10, 3, 5, 2, 1, 0]
      mut as int64: start = 1
      mut as int64: goal = 6
      mut as int64: beam_width = 1

      println("1. Origem: " + start + " | Destino: " + goal + " | Largura do feixe W = " + beam_width)

      #L Pilha de nos podados para backtracking (Beam Stack)
      mut as list of int64: reserve_stack = []
      mut as int64: current_node = start
      mut as bool: reached = false
      mut as int64: backtracks = 0

      mut as int64: steps = 0
      infinite (steps < 10 and not reached) {
            steps = steps + 1
            route {
                  current_node == goal ==> {
                        reached = true
                        break
                  }
            }

            #L Obtem sucessores de current_node
            mut as list of int64: succ = []
            mut as int64: v = 1
            infinite (v <= 6) {
                  route {
                        adj[current_node][v] == 1 ==> {
                              succ = listPushBack(succ, v)
                        }
                  }
                  v = v + 1
            }

            route {
                  listLength(succ) == 0 ==> {
                        #L Beco sem saida: faz backtracking usando a pilha de reserva
                        route {
                              listLength(reserve_stack) > 0 ==> {
                                    backtracks = backtracks + 1
                                    mut as int64: top_idx = listLength(reserve_stack)
                                    current_node = reserve_stack[top_idx]
                                    
                                    #L Desempilha
                                    mut as list of int64: n_res = []
                                    mut as int64: ri = 1
                                    infinite (ri < top_idx) {
                                          n_res = listPushBack(n_res, reserve_stack[ri])
                                          ri = ri + 1
                                    }
                                    reserve_stack = n_res
                                    println("  [Backtracking] Recuperando no reservado: " + current_node)
                              }
                              _ ==> {
                                    break
                              }
                        }
                  }
                  listLength(succ) == 1 ==> {
                        current_node = succ[1]
                  }
                  _ ==> {
                        #L Mais de um sucessor: escolhe o melhor para o feixe e guarda os demais na pilha
                        mut as int64: best = succ[1]
                        mut as int64: other = succ[2]
                        route {
                              h[succ[2]] < h[succ[1]] ==> {
                                    best = succ[2]
                                    other = succ[1]
                              }
                        }
                        reserve_stack = listPushBack(reserve_stack, other)
                        println("  [Feixe W=1] Escolhido: " + best + " | Reservado na pilha: " + other)
                        current_node = best
                  }
            }
      }

      println("2. Objetivo alcancado com auxilio da pilha: " + reached)
      println("3. Backtracks executados: " + backtracks)
      println("4. Validacao: " + (reached and backtracks == 2))
      println("==================================================")
}
