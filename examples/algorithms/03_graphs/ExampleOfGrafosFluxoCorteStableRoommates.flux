#L ============================================================================
#L Algoritmo: Stable Roommates (Algoritmo de Irving para Colegas de Quarto)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(N^2) tempo | O(N^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteStableRoommates) {
      println("==================================================")
      println("  SciAlgo: Stable Roommates Problem (Irving)      ")
      println("==================================================")

      mut as int64: n = 4

      #L Matriz de preferencias de cada pessoa sobre as demais (n x (n-1))
      #L Pessoa 1 prefere: 2, 4, 3
      #L Pessoa 2 prefere: 1, 3, 4
      #L Pessoa 3 prefere: 4, 2, 1
      #L Pessoa 4 prefere: 3, 1, 2
      mut as list of int64: pref = [
            2, 4, 3,
            1, 3, 4,
            4, 2, 1,
            3, 1, 2
      ]

      #L Matriz de classificacao: rank[p, q] e a posicao que p da a q (menor e melhor)
      mut as list of int64: rank = [
            0, 1, 3, 2,
            1, 0, 2, 3,
            3, 2, 0, 1,
            2, 3, 1, 0
      ]

      println("1. Instancia com 4 Colegas de Quarto:")
      println("   P1 prefere: [2, 4, 3]")
      println("   P2 prefere: [1, 3, 4]")
      println("   P3 prefere: [4, 2, 1]")
      println("   P4 prefere: [3, 1, 2]")

      #L FASE 1 DE IRVING: Propostas e Reducao de Listas
      #L proposed_to[p]: destinatario que atualmente retem a proposta de p (0 se livre)
      #L holding[q]: proponente que q atualmente retem (0 se nenhum)
      mut as list of int64: proposed_to = [0, 0, 0, 0]
      mut as list of int64: holding = [0, 0, 0, 0]
      mut as list of int64: next_cand = [1, 1, 1, 1]

      mut as int64: i = 1
      mut as int64: p = 0
      mut as bool: has_free = true

      infinite (has_free) {
            #L Encontra pessoa p cuja proposta ainda nao foi aceita/retida
            p = 0
            i = 1
            infinite (i <= n and p == 0) {
                  route {
                        (proposed_to[i] == 0) and (next_cand[i] <= (n - 1)) ==> {
                              p = i
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  p == 0 ==> {
                        has_free = false
                  }
                  _ ==> {
                        mut as int64: c_idx = next_cand[p]
                        next_cand[p] = c_idx + 1

                        mut as int64: recipient = pref[(p - 1) * (n - 1) + c_idx]
                        mut as int64: cur_holder = holding[recipient]

                        route {
                              cur_holder == 0 ==> {
                                    holding[recipient] = p
                                    proposed_to[p] = recipient
                              }
                              _ ==> {
                                    mut as int64: r_new = rank[(recipient - 1) * n + p]
                                    mut as int64: r_cur = rank[(recipient - 1) * n + cur_holder]

                                    route {
                                          r_new < r_cur ==> {
                                                proposed_to[cur_holder] = 0
                                                holding[recipient] = p
                                                proposed_to[p] = recipient
                                          }
                                          _ ==> {}
                                    }
                              }
                        }
                  }
            }
      }

      println("2. Fase 1 de Irving Concluida.")
      println("   Pares Estaveis Formados:")
      mut as list of int64: roommate = [0, 0, 0, 0]
      i = 1
      infinite (i <= n) {
            roommate[i] = proposed_to[i]
            i = i + 1
      }

      i = 1
      infinite (i <= n) {
            route {
                  i < roommate[i] ==> {
                        println("   Colega " + i + " <-> Colega " + roommate[i])
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      #L Verificacao de estabilidade: nenhum par {a, b} prefere um ao outro em relacao aos seus colegas atuais
      mut as int64: blocking_pairs = 0
      mut as int64: a = 1
      infinite (a <= n) {
            mut as int64: b = 1
            infinite (b <= n) {
                  route {
                        (a != b) and (b != roommate[a]) ==> {
                              mut as int64: cur_mate_a = roommate[a]
                              mut as int64: cur_mate_b = roommate[b]

                              mut as int64: rank_a_b = rank[(a - 1) * n + b]
                              mut as int64: rank_a_mate = rank[(a - 1) * n + cur_mate_a]

                              mut as int64: rank_b_a = rank[(b - 1) * n + a]
                              mut as int64: rank_b_mate = rank[(b - 1) * n + cur_mate_b]

                              route {
                                    (rank_a_b < rank_a_mate) and (rank_b_a < rank_b_mate) ==> {
                                          blocking_pairs = blocking_pairs + 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  b = b + 1
            }
            a = a + 1
      }

      println("3. Pares bloqueadores detectados: " + blocking_pairs)
      route {
            blocking_pairs == 0 ==> {
                  println("4. O emparelhamento de colegas de quarto e totalmente ESTAVEL.")
            }
            _ ==> {
                  println("4. O emparelhamento nao e estavel.")
            }
      }

      println("Stable Roommates concluido com sucesso.")
}
