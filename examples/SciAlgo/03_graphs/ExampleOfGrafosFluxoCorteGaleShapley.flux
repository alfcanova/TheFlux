#L ============================================================================
#L Algoritmo: Gale-Shapley (Algoritmo de Aceitacao Diferida / Casamento Estavel)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(N^2) tempo | O(N^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteGaleShapley) {
      println("==================================================")
      println("  SciAlgo: Gale-Shapley (Deferred Acceptance)     ")
      println("==================================================")

      mut as int64: n = 4

      #L Listas de preferencias dos homens (1 a 4) em ordem de prioridade
      #L M1: W1, W2, W3, W4
      #L M2: W2, W1, W4, W3
      #L M3: W1, W3, W2, W4
      #L M4: W3, W2, W1, W4
      mut as list of int64: men_pref = [
            1, 2, 3, 4,
            2, 1, 4, 3,
            1, 3, 2, 4,
            3, 2, 1, 4
      ]

      #L Matriz de classificacao das mulheres: w_rank[w, m] indica a posicao de m para w (menor e melhor)
      #L W1 prefere: M3 (1o), M2 (2o), M1 (3o), M4 (4o)
      #L W2 prefere: M1 (1o), M2 (2o), M3 (3o), M4 (4o)
      #L W3 prefere: M4 (1o), M1 (2o), M2 (3o), M3 (4o)
      #L W4 prefere: M2 (1o), M3 (2o), M4 (3o), M1 (4o)
      mut as list of int64: w_rank = [
            3, 2, 1, 4,
            1, 2, 3, 4,
            2, 3, 4, 1,
            4, 1, 2, 3
      ]

      println("1. Instancia com 4 proponentes (M) e 4 receptoras (W)")

      #L Estado do emparelhamento
      mut as list of int64: husband_of = [0, 0, 0, 0]
      mut as list of int64: wife_of = [0, 0, 0, 0]
      mut as list of int64: next_prop = [1, 1, 1, 1]

      mut as int64: i = 1
      mut as bool: has_free_man = true

      #L Laco principal de aceitacao diferida
      infinite (has_free_man) {
            #L Encontra primeiro homem livre que ainda nao propôs a todas as mulheres
            mut as int64: m = 0
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
                        has_free_man = false
                  }
                  _ ==> {
                        mut as int64: p_idx = next_prop[m]
                        next_prop[m] = p_idx + 1

                        mut as int64: w = men_pref[(m - 1) * n + p_idx]
                        mut as int64: current_h = husband_of[w]

                        route {
                              current_h == 0 ==> {
                                    #L Mulher esta livre: aceita a proposta
                                    husband_of[w] = m
                                    wife_of[m] = w
                              }
                              _ ==> {
                                    #L Mulher ja tem noivo: compara preferencias
                                    mut as int64: rank_new = w_rank[(w - 1) * n + m]
                                    mut as int64: rank_curr = w_rank[(w - 1) * n + current_h]

                                    route {
                                          rank_new < rank_curr ==> {
                                                #L Mulher prefere m ao atual noivo
                                                wife_of[current_h] = 0
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

      println("2. Casamento Estavel Otimo para Proponentes:")
      i = 1
      infinite (i <= n) {
            println("   Homem " + i + " <-> Mulher " + wife_of[i])
            i = i + 1
      }

      println("Gale-Shapley concluido com sucesso.")
}
