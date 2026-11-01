#L ============================================================================
#L Algoritmo: Stable Marriage (Verificacao e Paridade de Casamento Estavel)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(N^2) tempo | O(N^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteStableMarriage) {
      println("==================================================")
      println("  SciAlgo: Stable Marriage Problem (SMP)          ")
      println("==================================================")

      mut as int64: n = 3

      #L Matriz de preferencias dos homens (1 a 3):
      #L M1: W1, W2, W3
      #L M2: W2, W1, W3
      #L M3: W1, W2, W3
      mut as list of int64: m_pref = [
            1, 2, 3,
            2, 1, 3,
            1, 2, 3
      ]

      #L Matriz de classificacao das mulheres (1 a 3):
      #L W1 prefere: M2 (1o), M1 (2o), M3 (3o)
      #L W2 prefere: M1 (1o), M2 (2o), M3 (3o)
      #L W3 prefere: M1 (1o), M2 (2o), M3 (3o)
      mut as list of int64: w_rank = [
            2, 1, 3,
            1, 2, 3,
            1, 2, 3
      ]

      #L Matriz de classificacao dos homens para verificacao rapida de pares bloqueadores
      #L m_rank[m, w]: menor valor indica maior preferencia de m por w
      mut as list of int64: m_rank = [
            1, 2, 3,
            2, 1, 3,
            1, 2, 3
      ]

      println("1. Instancia de SMP com 3 Homens e 3 Mulheres")

      #L Execucao de proposta pelos homens
      mut as list of int64: husband_of = [0, 0, 0]
      mut as list of int64: wife_of = [0, 0, 0]
      mut as list of int64: next_prop = [1, 1, 1]

      mut as int64: i = 1
      mut as int64: m = 0
      mut as bool: has_free = true

      infinite (has_free) {
            m = 0
            i = 1
            infinite (i <= n and m == 0) {
                  route {
                        (wife_of[i] == 0) and (next_prop[i] <= n) ==> {
                              m = i
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  m == 0 ==> {
                        has_free = false
                  }
                  _ ==> {
                        mut as int64: p_idx = next_prop[m]
                        next_prop[m] = p_idx + 1

                        mut as int64: w = m_pref[(m - 1) * n + p_idx]
                        mut as int64: curr_h = husband_of[w]

                        route {
                              curr_h == 0 ==> {
                                    husband_of[w] = m
                                    wife_of[m] = w
                              }
                              _ ==> {
                                    mut as int64: rank_new = w_rank[(w - 1) * n + m]
                                    mut as int64: rank_curr = w_rank[(w - 1) * n + curr_h]

                                    route {
                                          rank_new < rank_curr ==> {
                                                wife_of[curr_h] = 0
                                                husband_of[w] = m
                                                wife_of[m] = w
                                          }
                                          _ ==> {}
                                    }
                              }
                        }
                  }
            }
      }

      println("2. Emparelhamento Obtido:")
      i = 1
      infinite (i <= n) {
            println("   Homem " + i + " casado com Mulher " + wife_of[i])
            i = i + 1
      }

      #L Verificacao de estabilidade: busca por pares bloqueadores (m, w)
      #L Um par (m, w) bloqueia se m prefere w a sua esposa atual E w prefere m a seu marido atual
      mut as int64: blocking_pairs = 0
      mut as int64: man = 1
      infinite (man <= n) {
            mut as int64: woman = 1
            infinite (woman <= n) {
                  mut as int64: cur_wife = wife_of[man]
                  mut as int64: cur_h = husband_of[woman]

                  route {
                        woman != cur_wife ==> {
                              mut as int64: m_pref_for_w = m_rank[(man - 1) * n + woman]
                              mut as int64: m_pref_for_wife = m_rank[(man - 1) * n + cur_wife]

                              mut as int64: w_pref_for_m = w_rank[(woman - 1) * n + man]
                              mut as int64: w_pref_for_h = w_rank[(woman - 1) * n + cur_h]

                              route {
                                    (m_pref_for_w < m_pref_for_wife) and (w_pref_for_m < w_pref_for_h) ==> {
                                          blocking_pairs = blocking_pairs + 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  woman = woman + 1
            }
            man = man + 1
      }

      println("3. Pares bloqueadores encontrados: " + blocking_pairs)
      route {
            blocking_pairs == 0 ==> {
                  println("4. Status: O emparelhamento e comprovadamente ESTAVEL.")
            }
            _ ==> {
                  println("4. Status: O emparelhamento contem instabilidades.")
            }
      }

      println("Stable Marriage concluido com sucesso.")
}
