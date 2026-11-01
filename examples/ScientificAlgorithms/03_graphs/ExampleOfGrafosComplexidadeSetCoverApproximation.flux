#L ============================================================================
#L Algoritmo: Set Cover Approximation (Algoritmo Guloso com Fator H_n = O(log n))
#L Dominio: 03_graphs / Categoria: Teoria da computacao e complexidade
#L Complexidade: O(|U| * |S|) tempo | Fator de Aproximacao: <= H(|U|) * OPT
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosComplexidadeSetCoverApproximation) {
      println("==================================================")
      println("  SciAlgo: Set Cover Guloso (Aproximacao O(log n))")
      println("==================================================")

      #L Universo U = {1..8} (n = 8 elementos)
      mut as int64: n_universe = 8

      #L Familia de m = 5 subconjuntos:
      #L S1 = {1, 2, 3, 4, 5}
      #L S2 = {4, 5, 6, 7}
      #L S3 = {6, 7, 8}
      #L S4 = {1, 8}
      #L S5 = {2, 3, 6}
      mut as int64: m_subsets = 5
      mut as list of int64: set_sz = [5, 4, 3, 2, 3]
      mut as list of int64: set_off = [1, 6, 10, 13, 15]
      mut as list of int64: set_pool = [
            1, 2, 3, 4, 5,       #L S1
            4, 5, 6, 7,          #L S2
            6, 7, 8,             #L S3
            1, 8,                #L S4
            2, 3, 6              #L S5
      ]

      println("1. Universo |U| = 8 e 5 subconjuntos candidatos carregados.")

      #L Rastreamento de elementos cobertos
      mut as list of bool: covered = [false, false, false, false, false, false, false, false]
      mut as int64: num_covered = 0

      #L Subconjuntos ja selecionados
      mut as list of bool: set_selected = [false, false, false, false, false]
      mut as list of int64: chosen_sets = []

      #L Algoritmo Guloso de Johnson-Lovasz-Chvatal (1975):
      #L Em cada rodada, escolhe o subconjunto que cobre o maior numero de elementos ainda nao cobertos.
      println("2. Executando selecao gulosa...")

      mut as bool: running = true
      infinite (running) {
            mut as int64: best_set = 0
            mut as int64: best_gain = 0

            mut as int64: si = 1
            infinite (si <= m_subsets) {
                  mut as bool: already = set_selected[si]
                  route {
                        not already ==> {
                              mut as int64: sz = set_sz[si]
                              mut as int64: off = set_off[si]
                              mut as int64: gain = 0

                              mut as int64: ei = 0
                              infinite (ei < sz) {
                                    mut as int64: elem = set_pool[off + ei]
                                    mut as bool: is_cov = covered[elem]
                                    route {
                                          not is_cov ==> { gain = gain + 1 }
                                    }
                                    ei = ei + 1
                              }

                              route {
                                    gain > best_gain ==> {
                                          best_gain = gain
                                          best_set = si
                                    }
                              }
                        }
                  }
                  si = si + 1
            }

            route {
                  best_set == 0 ==> {
                        #L Todos os elementos foram cobertos ou nenhum ganho adicional
                        running = false
                  }
                  _ ==> {
                        #L Seleciona best_set
                        set_selected[best_set] = true
                        chosen_sets = listPushBack(chosen_sets, best_set)
                        println("   Subconjunto escolhido: S" + best_set + " (ganho = " + best_gain + " novos elementos)")

                        #L Marca elementos como cobertos
                        mut as int64: b_sz = set_sz[best_set]
                        mut as int64: b_off = set_off[best_set]
                        mut as int64: bi = 0
                        infinite (bi < b_sz) {
                              mut as int64: elem = set_pool[b_off + bi]
                              route {
                                    not covered[elem] ==> {
                                          covered[elem] = true
                                          num_covered = num_covered + 1
                                    }
                              }
                              bi = bi + 1
                        }

                        route {
                              num_covered >= n_universe ==> {
                                    running = false
                              }
                        }
                  }
            }
      }

      println("3. Subconjuntos selecionados pela cobertura gulosa: " + chosen_sets)
      mut as int64: num_chosen = listLength(chosen_sets)
      println("   Total de subconjuntos selecionados: " + num_chosen)

      #L Verificacao de corretude
      mut as bool: all_elements_covered = (num_covered == n_universe)
      println("4. Todos os 8 elementos do universo cobertos: " + all_elements_covered)

      #L Subconjuntos otimos esperados: {S1, S3} de tamanho 2
      #L O algoritmo escolhe S1 (cobre 1..5) e depois S3 (cobre 6..8)
      mut as bool: is_optimal = (num_chosen == 2)
      println("5. Cobertura coincide com a solucao otima (OPT = 2): " + is_optimal)

      mut as bool: final_ok = all_elements_covered and is_optimal
      println("6. Verificacao geral do Set Cover Aproximado: " + final_ok)
      println("Concluido com Sucesso")
}
