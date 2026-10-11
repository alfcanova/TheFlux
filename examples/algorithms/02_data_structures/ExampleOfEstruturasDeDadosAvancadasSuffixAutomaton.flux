#L ============================================================================
#L Algoritmo: Suffix Automaton / SAM (Automato de Sufixos / Directed Acyclic Word Graph)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Construcao O(N) | Busca de Substring O(M) | Substrings Distintas O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasSuffixAutomaton) {
      println("==================================================")
      println("  SciAlgo: Suffix Automaton (SAM / DAWG)")
      println("==================================================")

      #L String texto base: "banana" (comprimento N = 6)
      #L Representada em codigos ASCII: 'b'=98, 'a'=97, 'n'=110, 'a'=97, 'n'=110, 'a'=97
      mut as list of int64: s = [98, 97, 110, 97, 110, 97]
      mut as int64: n = listLength(s)

      println("1. Construindo SAM para a string 'banana' (N = 6)...")

      #L Estrutura de Estados do SAM (max 2*N estados = 13 estados):
      #L len[u]: maior comprimento aceito pelo estado u
      #L link[u]: suffix link para o maior sufixo de outra classe de endpos
      #L next_trans[(u - 1) * 3 + c]: transicoes para 'a'=1, 'b'=2, 'n'=3
      mut as list of int64: state_len = [0]
      mut as list of int64: state_link = [0]
      mut as list of int64: next_trans = [0, 0, 0] #L estado 1 (raiz / estado inicial)
      mut as int64: num_states = 1
      mut as int64: last = 1

      #L Construcao linear O(N) caractere a caractere
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: ch = s[i]
            mut as int64: cid = 0
            route {
                  ch == 97 ==> { cid = 1 } #L 'a'
                  ch == 98 ==> { cid = 2 } #L 'b'
                  ch == 110 ==> { cid = 3 } #L 'n'
            }

            #L Cria novo estado cur
            num_states = num_states + 1
            mut as int64: cur = num_states
            state_len = listPushBack(state_len, state_len[last] + 1)
            state_link = listPushBack(state_link, 0)
            next_trans = listPushBack(next_trans, 0)
            next_trans = listPushBack(next_trans, 0)
            next_trans = listPushBack(next_trans, 0)

            mut as int64: p = last
            mut as bool: updating_p = true
            infinite (updating_p) {
                  route {
                        p == 0 ==> { updating_p = false }
                        _ ==> {
                              mut as int64: t_idx = ((p - 1) * 3) + cid
                              route {
                                    next_trans[t_idx] == 0 ==> {
                                          next_trans[t_idx] = cur
                                          p = state_link[p]
                                    }
                                    _ ==> {
                                          updating_p = false
                                    }
                              }
                        }
                  }
            }

            route {
                  p == 0 ==> {
                        state_link[cur] = 1
                  }
                  _ ==> {
                        mut as int64: q = next_trans[((p - 1) * 3) + cid]
                        route {
                              state_len[p] + 1 == state_len[q] ==> {
                                    state_link[cur] = q
                              }
                              _ ==> {
                                    #L Clonagem do estado q
                                    num_states = num_states + 1
                                    mut as int64: clone = num_states
                                    state_len = listPushBack(state_len, state_len[p] + 1)
                                    state_link = listPushBack(state_link, state_link[q])

                                    #L Copia as 3 transicoes de q para clone
                                    mut as int64: q_t1 = next_trans[((q - 1) * 3) + 1]
                                    mut as int64: q_t2 = next_trans[((q - 1) * 3) + 2]
                                    mut as int64: q_t3 = next_trans[((q - 1) * 3) + 3]
                                    next_trans = listPushBack(next_trans, q_t1)
                                    next_trans = listPushBack(next_trans, q_t2)
                                    next_trans = listPushBack(next_trans, q_t3)

                                    #L Redireciona transicoes que apontavam para q para clone
                                    mut as int64: red_p = p
                                    mut as bool: redirecting = true
                                    infinite (redirecting) {
                                          route {
                                                red_p == 0 ==> { redirecting = false }
                                                _ ==> {
                                                      mut as int64: r_idx = ((red_p - 1) * 3) + cid
                                                      route {
                                                            next_trans[r_idx] == q ==> {
                                                                  next_trans[r_idx] = clone
                                                                  red_p = state_link[red_p]
                                                            }
                                                            _ ==> {
                                                                  redirecting = false
                                                            }
                                                      }
                                                }
                                          }
                                    }

                                    state_link[q] = clone
                                    state_link[cur] = clone
                              }
                        }
                  }
            }

            last = cur
            i = i + 1
      }

      println("2. Suffix Automaton gerado com " + num_states + " estados.")

      #L 3. Contagem exata de substrings distintas usando formula: SUM (len[u] - len[link[u]])
      mut as int64: total_distinct_substrings = 0
      mut as int64: u = 2
      infinite (u <= num_states) {
            mut as int64: l_cur = state_len[u]
            mut as int64: l_lnk = state_len[state_link[u]]
            total_distinct_substrings = total_distinct_substrings + (l_cur - l_lnk)
            u = u + 1
      }

      println("3. Calculo de substrings distintas em 'banana': " + total_distinct_substrings + " (esperado 15)")
      mut as bool: all_ok = (total_distinct_substrings == 15)

      #L 4. Testes de aceitacao de substrings
      #L Substrings testadas: "ana" (sim), "ban" (sim), "nana" (sim), "apple" (nao), "anb" (nao)
      println("4. Testando reconhecimento de padroes:")

      #L Teste "ana" -> [1, 3, 1]
      mut as list of int64: p1 = [1, 3, 1]
      mut as int64: cur_st = 1
      mut as bool: p1_ok = true
      mut as int64: pi = 1
      infinite (pi <= listLength(p1)) {
            mut as int64: pc = p1[pi]
            mut as int64: nxt = next_trans[((cur_st - 1) * 3) + pc]
            route {
                  nxt == 0 ==> { p1_ok = false }
                  _ ==> { cur_st = nxt }
            }
            pi = pi + 1
      }
      println("   Substring 'ana': " + p1_ok + " (esperado true)")
      route {
            not p1_ok ==> { all_ok = false }
      }

      #L Teste "ban" -> [2, 1, 3]
      mut as list of int64: p2 = [2, 1, 3]
      cur_st = 1
      mut as bool: p2_ok = true
      pi = 1
      infinite (pi <= listLength(p2)) {
            mut as int64: pc = p2[pi]
            mut as int64: nxt = next_trans[((cur_st - 1) * 3) + pc]
            route {
                  nxt == 0 ==> { p2_ok = false }
                  _ ==> { cur_st = nxt }
            }
            pi = pi + 1
      }
      println("   Substring 'ban': " + p2_ok + " (esperado true)")
      route {
            not p2_ok ==> { all_ok = false }
      }

      #L Teste "anb" -> [1, 3, 2] (ausente)
      mut as list of int64: p3 = [1, 3, 2]
      cur_st = 1
      mut as bool: p3_ok = true
      pi = 1
      infinite (pi <= listLength(p3)) {
            mut as int64: pc = p3[pi]
            mut as int64: nxt = next_trans[((cur_st - 1) * 3) + pc]
            route {
                  nxt == 0 ==> { p3_ok = false }
                  _ ==> { cur_st = nxt }
            }
            pi = pi + 1
      }
      println("   Substring 'anb': " + p3_ok + " (esperado false)")
      route {
            p3_ok ==> { all_ok = false }
      }

      println("5. Verificacao geral do Suffix Automaton: " + all_ok)
      println("Concluido com Sucesso")
}
