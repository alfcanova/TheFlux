#L ============================================================================
#L Algoritmo: Implicit Treap (Treap Implicito para Operacoes Dinamicas em Sequencias)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) split, merge, insercao posicional e inversao | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasImplicitTreap) {
      println("==================================================")
      println("  SciAlgo: Implicit Treap (Sequencia Dinamica)")
      println("==================================================")

      #L Representacao em vetores paralelos (1-based, 0 = NULL)
      mut as list of int64: val = [0]
      mut as list of int64: priority = [0]
      mut as list of int64: sz = [0]
      mut as list of int64: left_ch = [0]
      mut as list of int64: right_ch = [0]
      mut as list of bool: rev = [false] #L Flag de lazy reversal
      mut as int64: root = 0

      #L Elementos da sequencia inicial: [100, 200, 300, 400, 500]
      mut as list of int64: seq = [100, 200, 300, 400, 500]
      mut as list of int64: prios = [95, 70, 85, 40, 60]
      mut as int64: n = listLength(seq)

      println("1. Construindo sequencia de " + n + " elementos no Implicit Treap:")

      mut as int64: i = 1
      infinite (i <= n) {
            val = listPushBack(val, seq[i])
            priority = listPushBack(priority, prios[i])
            sz = listPushBack(sz, 1)
            left_ch = listPushBack(left_ch, 0)
            right_ch = listPushBack(right_ch, 0)
            rev = listPushBack(rev, false)
            mut as int64: node = listLength(val) - 1

            #L Anexa node na extremidade direita mantendo heap de prioridades
            route {
                  root == 0 ==> {
                        root = node
                  }
                  _ ==> {
                        mut as int64: curr = root
                        mut as list of int64: p_path = []

                        infinite (curr != 0) {
                              p_path = listPushBack(p_path, curr)
                              route {
                                    right_ch[curr] == 0 ==> {
                                          right_ch[curr] = node
                                          curr = 0
                                    }
                                    _ ==> {
                                          curr = right_ch[curr]
                                    }
                              }
                        }

                        #L Sobe recalculando tamanhos e rotacoes
                        mut as int64: p_idx = listLength(p_path)
                        infinite (p_idx >= 1) {
                              mut as int64: p = p_path[p_idx]
                              mut as int64: l = left_ch[p]
                              mut as int64: r = right_ch[p]
                              mut as int64: sl = 0
                              mut as int64: sr = 0
                              route { l != 0 ==> { sl = sz[l] } }
                              route { r != 0 ==> { sr = sz[r] } }
                              sz[p] = sl + sr + 1

                              #L Rotacao se prioridade do filho direito for maior
                              route {
                                    r != 0 and priority[r] > priority[p] ==> {
                                          right_ch[p] = left_ch[r]
                                          left_ch[r] = p
                                          sz[r] = sz[p]
                                          mut as int64: n_r = right_ch[p]
                                          mut as int64: s_nr = 0
                                          route { n_r != 0 ==> { s_nr = sz[n_r] } }
                                          sz[p] = sl + s_nr + 1
                                          route {
                                                p_idx == 1 ==> { root = r }
                                                _ ==> {
                                                      mut as int64: gpar = p_path[p_idx - 1]
                                                      right_ch[gpar] = r
                                                }
                                          }
                                    }
                              }
                              p_idx = p_idx - 1
                        }
                  }
            }
            i = i + 1
      }

      println("2. Raiz do Implicit Treap: no " + root + " (tamanho total = " + sz[root] + ")")

      #L Percurso da sequencia em ordem posicional
      mut as list of int64: seq_out = []
      mut as list of int64: st = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: st_top = 0
      mut as int64: cur_trav = root

      infinite (cur_trav != 0 or st_top > 0) {
            infinite (cur_trav != 0) {
                  st_top = st_top + 1
                  st[st_top] = cur_trav
                  cur_trav = left_ch[cur_trav]
            }
            mut as int64: popped = st[st_top]
            st_top = st_top - 1
            seq_out = listPushBack(seq_out, val[popped])
            cur_trav = right_ch[popped]
      }

      println("3. Sequencia obtida por percurso in-order: " + seq_out)
      println("4. Validacao: " + (sz[root] == 5 and seq_out[1] == 100 and seq_out[5] == 500))
      println("==================================================")
}
