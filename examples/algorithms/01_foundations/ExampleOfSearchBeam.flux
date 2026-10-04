#L ============================================================================
#L Algoritmo: Beam Search (Busca em Feixe)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(B * W) por nivel | O(W) espaco de memoria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchBeam) {
      println("==================================================")
      println("  SciAlgo: Beam Search (Largura de Feixe W = 2)")
      println("==================================================")

      #L Grafo com 10 vertices
      mut as list of list of int64: adj = [
            [0, 1, 1, 1, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 1, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 1, 1, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      ]

      #L Heuristicas h(n) ate o objetivo (vertice 10)
      mut as list of int64: h = [20, 14, 9, 12, 6, 8, 5, 11, 2, 0]

      mut as int64: beam_width = 2
      mut as int64: start = 1
      mut as int64: goal = 10

      mut as list of int64: current_beam = [start]
      mut as bool: reached = false
      mut as int64: level = 0

      println("1. Origem: " + start + " | Destino: " + goal + " | Beam Width: " + beam_width)

      infinite (listLength(current_beam) > 0 and not reached) {
            level = level + 1
            #L Gera todos os sucessores dos nos no feixe atual
            mut as list of int64: candidates = []
            mut as int64: bi = 1
            infinite (bi <= listLength(current_beam)) {
                  mut as int64: u = current_beam[bi]
                  route {
                        u == goal ==> {
                              reached = true
                              break
                        }
                  }

                  mut as int64: v = 1
                  infinite (v <= 10) {
                        route {
                              adj[u][v] == 1 ==> {
                                    candidates = listPushBack(candidates, v)
                              }
                        }
                        v = v + 1
                  }
                  bi = bi + 1
            }

            route {
                  reached ==> {
                        break
                  }
            }

            route {
                  listLength(candidates) == 0 ==> {
                        #L Nenhum candidato adicional
                        break
                  }
            }

            #L Filtra os W melhores candidatos com menor heuristica h(n)
            mut as list of int64: next_beam = []
            mut as list of int64: cand_pool = candidates

            mut as int64: sel = 1
            infinite (sel <= beam_width and listLength(cand_pool) > 0) {
                  #L Encontra o melhor no no pool
                  mut as int64: best_idx = 1
                  mut as int64: best_cand = cand_pool[1]
                  mut as int64: min_val = h[best_cand]

                  mut as int64: ci = 2
                  infinite (ci <= listLength(cand_pool)) {
                        mut as int64: nd = cand_pool[ci]
                        route {
                              h[nd] < min_val ==> {
                                    min_val = h[nd]
                                    best_cand = nd
                                    best_idx = ci
                              }
                        }
                        ci = ci + 1
                  }

                  next_beam = listPushBack(next_beam, best_cand)

                  #L Remove de cand_pool
                  mut as list of int64: n_pool = []
                  mut as int64: rem_k = 1
                  infinite (rem_k <= listLength(cand_pool)) {
                        route {
                              rem_k != best_idx ==> {
                                    n_pool = listPushBack(n_pool, cand_pool[rem_k])
                              }
                        }
                        rem_k = rem_k + 1
                  }
                  cand_pool = n_pool
                  sel = sel + 1
            }

            current_beam = next_beam
            println("  Nivel " + level + " | Feixe selecionado: " + current_beam)
            
            #L Checa se algum no selecionado e o objetivo
            mut as int64: chk = 1
            infinite (chk <= listLength(current_beam)) {
                  route {
                        current_beam[chk] == goal ==> {
                              reached = true
                              break
                        }
                  }
                  chk = chk + 1
            }
      }

      println("2. Objetivo alcancado pelo feixe: " + reached)
      println("3. Nivel de profundidade atingido: " + level)
      println("4. Validacao: " + (reached and level == 3))
      println("==================================================")
}
