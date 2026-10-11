#L ============================================================================
#L Algoritmo: Powerset Construction (NFA para DFA via Subconjuntos)
#L Dominio: 09_systems_infra / Categoria: Automatos e linguagens formais
#L Complexidade: O(2^|Q| * |Sigma|) tempo e espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasAutomatosPowersetConstruction) {
      println("==================================================")
      println("  SciAlgo: Powerset Construction (NFA -> DFA)     ")
      println("==================================================")

      #L NFA de teste: reconhece cadeias sobre {a, b} terminando em 'ab'
      #L Estados NFA: 1 (inicial), 2, 3 (final)
      #L Simbolos: 1 = 'a', 2 = 'b'
      mut as int64: num_nfa_states = 3
      mut as int64: num_symbols = 2

      #L Representacao de transicoes do NFA como bitmasks:
      #L nfa_trans[(s - 1) * num_symbols + sym] = mascara de estados destino
      #L Estado 1: com 'a' -> {1, 2} (mask 1|2 = 3); com 'b' -> {1} (mask 1)
      #L Estado 2: com 'a' -> {} (mask 0); com 'b' -> {3} (mask 4)
      #L Estado 3: com 'a' -> {} (mask 0); com 'b' -> {} (mask 0)
      mut as list of int64: nfa_trans = [
            3, 1, #L Estado 1 (bit 1): trans('a')=3, trans('b')=1
            0, 4, #L Estado 2 (bit 2): trans('a')=0, trans('b')=4
            0, 0  #L Estado 3 (bit 4): trans('a')=0, trans('b')=0
      ]

      println("1. Estrutura do NFA Original:")
      println("   Estados: {1 (inicial), 2, 3 (final)}")
      println("   Alfabeto: {'a', 'b'}")
      println("   Transicoes: d(1, a)={1, 2}, d(1, b)={1}, d(2, b)={3}")

      #L Determinacao via Powerset Construction:
      #L Espaco maximo de estados DFA: 2^3 = 8 (indices de mascara 0 a 7, ajustados para 1..8)
      mut as list of bool: dfa_state_discovered = [
            false, false, false, false, false, false, false, false
      ]
      mut as list of int64: dfa_queue = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: queue_head = 1
      mut as int64: queue_tail = 1

      #L Tabela de transicao do DFA: dfa_trans[(mask) * 2 + sym]
      mut as list of int64: dfa_trans = [
            0, 0, #L mask 0
            0, 0, #L mask 1
            0, 0, #L mask 2
            0, 0, #L mask 3
            0, 0, #L mask 4
            0, 0, #L mask 5
            0, 0, #L mask 6
            0, 0  #L mask 7
      ]

      #L Estado inicial do DFA = {1} (bitmask 1)
      mut as int64: initial_mask = 1
      dfa_state_discovered[initial_mask + 1] = true
      dfa_queue[queue_tail] = initial_mask
      queue_tail = queue_tail + 1

      mut as int64: total_dfa_states = 0

      println("2. Executando Powerset Construction...")

      infinite (queue_head < queue_tail) {
            mut as int64: curr_mask = dfa_queue[queue_head]
            queue_head = queue_head + 1
            total_dfa_states = total_dfa_states + 1

            mut as int64: sym = 1
            infinite (sym <= num_symbols) {
                  mut as int64: next_mask = 0

                  #L Verifica se estado 1 esta ativo (bit 1)
                  route {
                        curr_mask == 1 or curr_mask == 3 or curr_mask == 5 or curr_mask == 7 ==> {
                              mut as int64: dest1 = nfa_trans[(1 - 1) * num_symbols + sym]
                              #L Union com dest1
                              route {
                                    dest1 == 1 or dest1 == 3 or dest1 == 5 or dest1 == 7 ==> {
                                          route { next_mask == 0 or next_mask == 2 or next_mask == 4 or next_mask == 6 ==> { next_mask = next_mask + 1 } _ ==> {} }
                                    }
                                    _ ==> {}
                              }
                              route {
                                    dest1 == 2 or dest1 == 3 or dest1 == 6 or dest1 == 7 ==> {
                                          route { next_mask < 2 or next_mask == 4 or next_mask == 5 ==> { next_mask = next_mask + 2 } _ ==> {} }
                                    }
                                    _ ==> {}
                              }
                              route {
                                    dest1 >= 4 ==> {
                                          route { next_mask < 4 ==> { next_mask = next_mask + 4 } _ ==> {} }
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }

                  #L Verifica se estado 2 esta ativo (bit 2)
                  route {
                        curr_mask == 2 or curr_mask == 3 or curr_mask == 6 or curr_mask == 7 ==> {
                              mut as int64: dest2 = nfa_trans[(2 - 1) * num_symbols + sym]
                              route {
                                    dest2 == 1 or dest2 == 3 or dest2 == 5 or dest2 == 7 ==> {
                                          route { next_mask == 0 or next_mask == 2 or next_mask == 4 or next_mask == 6 ==> { next_mask = next_mask + 1 } _ ==> {} }
                                    }
                                    _ ==> {}
                              }
                              route {
                                    dest2 == 2 or dest2 == 3 or dest2 == 6 or dest2 == 7 ==> {
                                          route { next_mask < 2 or next_mask == 4 or next_mask == 5 ==> { next_mask = next_mask + 2 } _ ==> {} }
                                    }
                                    _ ==> {}
                              }
                              route {
                                    dest2 >= 4 ==> {
                                          route { next_mask < 4 ==> { next_mask = next_mask + 4 } _ ==> {} }
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }

                  #L Verifica se estado 3 esta ativo (bit 4)
                  route {
                        curr_mask >= 4 ==> {
                              mut as int64: dest3 = nfa_trans[(3 - 1) * num_symbols + sym]
                              route {
                                    dest3 == 1 or dest3 == 3 or dest3 == 5 or dest3 == 7 ==> {
                                          route { next_mask == 0 or next_mask == 2 or next_mask == 4 or next_mask == 6 ==> { next_mask = next_mask + 1 } _ ==> {} }
                                    }
                                    _ ==> {}
                              }
                              route {
                                    dest3 == 2 or dest3 == 3 or dest3 == 6 or dest3 == 7 ==> {
                                          route { next_mask < 2 or next_mask == 4 or next_mask == 5 ==> { next_mask = next_mask + 2 } _ ==> {} }
                                    }
                                    _ ==> {}
                              }
                              route {
                                    dest3 >= 4 ==> {
                                          route { next_mask < 4 ==> { next_mask = next_mask + 4 } _ ==> {} }
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }

                  dfa_trans[curr_mask * 2 + sym] = next_mask

                  route {
                        next_mask > 0 and (not dfa_state_discovered[next_mask + 1]) ==> {
                              dfa_state_discovered[next_mask + 1] = true
                              dfa_queue[queue_tail] = next_mask
                              queue_tail = queue_tail + 1
                        }
                        _ ==> {}
                  }

                  sym = sym + 1
            }
      }

      println("3. DFA Construido:")
      println("   Total de Estados Alcancaveis: " + total_dfa_states)

      mut as int64: idx = 1
      infinite (idx < queue_tail) {
            mut as int64: m = dfa_queue[idx]
            mut as bool: is_final = m >= 4
            mut as int64: t_a = dfa_trans[m * 2 + 1]
            mut as int64: t_b = dfa_trans[m * 2 + 2]
            println("   Estado DFA Mask " + m + " (Final: " + is_final + ") -- 'a' -> Mask " + t_a + ", 'b' -> Mask " + t_b)
            idx = idx + 1
      }

      println("4. Simulando DFA em Cadeias de Teste:")

      #L Teste 1: "ab" (deve aceitar) -> [1, 2]
      mut as int64: state = initial_mask
      state = dfa_trans[state * 2 + 1] #L 'a'
      state = dfa_trans[state * 2 + 2] #L 'b'
      mut as bool: acc1 = state >= 4
      println("   Cadeia 'ab': Aceita = " + acc1)

      #L Teste 2: "aab" (deve aceitar) -> [1, 1, 2]
      state = initial_mask
      state = dfa_trans[state * 2 + 1] #L 'a'
      state = dfa_trans[state * 2 + 1] #L 'a'
      state = dfa_trans[state * 2 + 2] #L 'b'
      mut as bool: acc2 = state >= 4
      println("   Cadeia 'aab': Aceita = " + acc2)

      #L Teste 3: "ba" (deve rejeitar) -> [2, 1]
      state = initial_mask
      state = dfa_trans[state * 2 + 2] #L 'b'
      state = dfa_trans[state * 2 + 1] #L 'a'
      mut as bool: acc3 = state >= 4
      println("   Cadeia 'ba': Aceita = " + acc3)

      println("Powerset Construction concluido com sucesso.")
}
