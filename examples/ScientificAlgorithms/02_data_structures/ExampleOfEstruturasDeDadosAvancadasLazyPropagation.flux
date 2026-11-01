#L ============================================================================
#L Algoritmo: Segment Tree com Lazy Propagation (Atualizacao por Faixa O(log N))
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Construcao O(N) | Atualizacao em Faixa O(log N) | Consulta O(log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasLazyPropagation) {
      println("==================================================")
      println("  SciAlgo: Segment Tree com Lazy Propagation")
      println("==================================================")

      mut as list of int64: arr = [1, 2, 3, 4, 5, 6, 7, 8]
      mut as int64: n = listLength(arr)
      println("1. Vetor inicial de " + n + " posicoes: " + arr)

      mut as int64: tree_sz = 4 * n
      mut as list of int64: tree = []
      mut as list of int64: lazy = []
      mut as int64: zi = 1
      infinite (zi <= tree_sz) {
            tree = listPushBack(tree, 0)
            lazy = listPushBack(lazy, 0)
            zi = zi + 1
      }

      #L Construcao da arvore (Build)
      mut as list of int64: st_n = [1]
      mut as list of int64: st_l = [1]
      mut as list of int64: st_r = [n]
      mut as list of int64: st_st = [0]

      infinite (listLength(st_n) > 0) {
            mut as int64: top = listLength(st_n)
            mut as int64: cn = st_n[top]
            mut as int64: cl = st_l[top]
            mut as int64: cr = st_r[top]
            mut as int64: cst = st_st[top]

            route {
                  cl == cr ==> {
                        tree[cn] = arr[cl]
                        st_n = listTake(st_n, top - 1)
                        st_l = listTake(st_l, top - 1)
                        st_r = listTake(st_r, top - 1)
                        st_st = listTake(st_st, top - 1)
                  }
                  cst == 0 ==> {
                        st_st[top] = 1
                        mut as int64: mid = (cl + cr) /i 2
                        st_n = listPushBack(st_n, (2 * cn) + 1)
                        st_l = listPushBack(st_l, mid + 1)
                        st_r = listPushBack(st_r, cr)
                        st_st = listPushBack(st_st, 0)

                        st_n = listPushBack(st_n, 2 * cn)
                        st_l = listPushBack(st_l, cl)
                        st_r = listPushBack(st_r, mid)
                        st_st = listPushBack(st_st, 0)
                  }
                  _ ==> {
                        tree[cn] = tree[2 * cn] + tree[(2 * cn) + 1]
                        st_n = listTake(st_n, top - 1)
                        st_l = listTake(st_l, top - 1)
                        st_r = listTake(st_r, top - 1)
                        st_st = listTake(st_st, top - 1)
                  }
            }
      }
      println("2. Arvore construida (Soma total inicial 1..8): " + tree[1])

      #L Funcao/bloco para consulta de soma com Pushdown de Lazy
      #L Consulta inicial em [1..8] -> 36, em [3..6] -> 3+4+5+6 = 18
      println("3. Consultas antes de atualizacao:")
      
      #L Pilha de consulta: [node, l, r]
      mut as list of int64: q_node = [1]
      mut as list of int64: q_l = [1]
      mut as list of int64: q_r = [n]
      mut as int64: ans_3_6 = 0
      mut as int64: ql_target = 3
      mut as int64: qr_target = 6

      infinite (listLength(q_node) > 0) {
            mut as int64: qsz = listLength(q_node)
            mut as int64: cn = q_node[qsz]
            mut as int64: cl = q_l[qsz]
            mut as int64: cr = q_r[qsz]
            q_node = listTake(q_node, qsz - 1)
            q_l = listTake(q_l, qsz - 1)
            q_r = listTake(q_r, qsz - 1)

            #L Pushdown se houver lazy pendente
            route {
                  lazy[cn] != 0 ==> {
                        tree[cn] = tree[cn] + ((cr - cl + 1) * lazy[cn])
                        route {
                              cl != cr ==> {
                                    lazy[2 * cn] = lazy[2 * cn] + lazy[cn]
                                    lazy[(2 * cn) + 1] = lazy[(2 * cn) + 1] + lazy[cn]
                              }
                              _ ==> {
                              }
                        }
                        lazy[cn] = 0
                  }
                  _ ==> {
                  }
            }

            route {
                  ql_target <= cl and cr <= qr_target ==> {
                        ans_3_6 = ans_3_6 + tree[cn]
                  }
                  cl > qr_target or cr < ql_target ==> {
                  }
                  _ ==> {
                        mut as int64: mid = (cl + cr) /i 2
                        q_node = listPushBack(q_node, 2 * cn)
                        q_l = listPushBack(q_l, cl)
                        q_r = listPushBack(q_r, mid)

                        q_node = listPushBack(q_node, (2 * cn) + 1)
                        q_l = listPushBack(q_l, mid + 1)
                        q_r = listPushBack(q_r, cr)
                  }
            }
      }
      println("   Soma da subfaixa [3..6] (esperado 18): " + ans_3_6)

      #L Range Update: Somar +10 na subfaixa [2..5]
      println("4. Aplicando Range Update: Somar +10 em cada elemento de [2..5]...")
      mut as int64: upd_l = 2
      mut as int64: upd_r = 5
      mut as int64: upd_val = 10

      #L Pilha de atualizacao por faixa: [node, l, r, state]
      #L state 0: expande e aplica lazy, state 1: recalcula soma do pai
      mut as list of int64: u_n = [1]
      mut as list of int64: u_l = [1]
      mut as list of int64: u_r = [n]
      mut as list of int64: u_st = [0]

      infinite (listLength(u_n) > 0) {
            mut as int64: usz = listLength(u_n)
            mut as int64: cn = u_n[usz]
            mut as int64: cl = u_l[usz]
            mut as int64: cr = u_r[usz]
            mut as int64: cst = u_st[usz]

            route {
                  cst == 1 ==> {
                        #L Pos-visita: atualiza pai a partir dos filhos
                        tree[cn] = tree[2 * cn] + tree[(2 * cn) + 1]
                        u_n = listTake(u_n, usz - 1)
                        u_l = listTake(u_l, usz - 1)
                        u_r = listTake(u_r, usz - 1)
                        u_st = listTake(u_st, usz - 1)
                  }
                  _ ==> {
                        #L Pushdown do lazy atual
                        route {
                              lazy[cn] != 0 ==> {
                                    tree[cn] = tree[cn] + ((cr - cl + 1) * lazy[cn])
                                    route {
                                          cl != cr ==> {
                                                lazy[2 * cn] = lazy[2 * cn] + lazy[cn]
                                                lazy[(2 * cn) + 1] = lazy[(2 * cn) + 1] + lazy[cn]
                                          }
                                          _ ==> {
                                          }
                                    }
                                    lazy[cn] = 0
                              }
                              _ ==> {
                              }
                        }

                        route {
                              cl > upd_r or cr < upd_l ==> {
                                    u_n = listTake(u_n, usz - 1)
                                    u_l = listTake(u_l, usz - 1)
                                    u_r = listTake(u_r, usz - 1)
                                    u_st = listTake(u_st, usz - 1)
                              }
                              upd_l <= cl and cr <= upd_r ==> {
                                    #L Totalmente contido: aplica lazy diretamente neste no
                                    tree[cn] = tree[cn] + ((cr - cl + 1) * upd_val)
                                    route {
                                          cl != cr ==> {
                                                lazy[2 * cn] = lazy[2 * cn] + upd_val
                                                lazy[(2 * cn) + 1] = lazy[(2 * cn) + 1] + upd_val
                                          }
                                          _ ==> {
                                          }
                                    }
                                    u_n = listTake(u_n, usz - 1)
                                    u_l = listTake(u_l, usz - 1)
                                    u_r = listTake(u_r, usz - 1)
                                    u_st = listTake(u_st, usz - 1)
                              }
                              _ ==> {
                                    #L Parcialmente contido: empilha pos-visita e divide filhos
                                    u_st[usz] = 1
                                    mut as int64: mid = (cl + cr) /i 2
                                    u_n = listPushBack(u_n, (2 * cn) + 1)
                                    u_l = listPushBack(u_l, mid + 1)
                                    u_r = listPushBack(u_r, cr)
                                    u_st = listPushBack(u_st, 0)

                                    u_n = listPushBack(u_n, 2 * cn)
                                    u_l = listPushBack(u_l, cl)
                                    u_r = listPushBack(u_r, mid)
                                    u_st = listPushBack(u_st, 0)
                              }
                        }
                  }
            }
      }

      println("5. Consultando apos Lazy Propagation:")
      #L Subfaixa [3..6]: elementos em 3,4,5 receberam +10 cada (total +30).
      #L Antigo: 18 -> Novo: 18 + 30 = 48!
      q_node = [1]
      q_l = [1]
      q_r = [n]
      mut as int64: new_ans_3_6 = 0

      infinite (listLength(q_node) > 0) {
            mut as int64: qsz = listLength(q_node)
            mut as int64: cn = q_node[qsz]
            mut as int64: cl = q_l[qsz]
            mut as int64: cr = q_r[qsz]
            q_node = listTake(q_node, qsz - 1)
            q_l = listTake(q_l, qsz - 1)
            q_r = listTake(q_r, qsz - 1)

            route {
                  lazy[cn] != 0 ==> {
                        tree[cn] = tree[cn] + ((cr - cl + 1) * lazy[cn])
                        route {
                              cl != cr ==> {
                                    lazy[2 * cn] = lazy[2 * cn] + lazy[cn]
                                    lazy[(2 * cn) + 1] = lazy[(2 * cn) + 1] + lazy[cn]
                              }
                              _ ==> {
                              }
                        }
                        lazy[cn] = 0
                  }
                  _ ==> {
                  }
            }

            route {
                  ql_target <= cl and cr <= qr_target ==> {
                        new_ans_3_6 = new_ans_3_6 + tree[cn]
                  }
                  cl > qr_target or cr < ql_target ==> {
                  }
                  _ ==> {
                        mut as int64: mid = (cl + cr) /i 2
                        q_node = listPushBack(q_node, 2 * cn)
                        q_l = listPushBack(q_l, cl)
                        q_r = listPushBack(q_r, mid)

                        q_node = listPushBack(q_node, (2 * cn) + 1)
                        q_l = listPushBack(q_l, mid + 1)
                        q_r = listPushBack(q_r, cr)
                  }
            }
      }
      println("   Nova soma subfaixa [3..6] (esperado 48): " + new_ans_3_6)

      #L Consulta total [1..8]: 4 elementos aumentaram +10 cada (+40). 36 + 40 = 76!
      q_node = [1]
      q_l = [1]
      q_r = [n]
      mut as int64: tot_ans = 0
      mut as int64: t_ql = 1
      mut as int64: t_qr = 8

      infinite (listLength(q_node) > 0) {
            mut as int64: qsz = listLength(q_node)
            mut as int64: cn = q_node[qsz]
            mut as int64: cl = q_l[qsz]
            mut as int64: cr = q_r[qsz]
            q_node = listTake(q_node, qsz - 1)
            q_l = listTake(q_l, qsz - 1)
            q_r = listTake(q_r, qsz - 1)

            route {
                  lazy[cn] != 0 ==> {
                        tree[cn] = tree[cn] + ((cr - cl + 1) * lazy[cn])
                        route {
                              cl != cr ==> {
                                    lazy[2 * cn] = lazy[2 * cn] + lazy[cn]
                                    lazy[(2 * cn) + 1] = lazy[(2 * cn) + 1] + lazy[cn]
                              }
                              _ ==> {
                              }
                        }
                        lazy[cn] = 0
                  }
                  _ ==> {
                  }
            }

            route {
                  t_ql <= cl and cr <= t_qr ==> {
                        tot_ans = tot_ans + tree[cn]
                  }
                  cl > t_qr or cr < t_ql ==> {
                  }
                  _ ==> {
                        mut as int64: mid = (cl + cr) /i 2
                        q_node = listPushBack(q_node, 2 * cn)
                        q_l = listPushBack(q_l, cl)
                        q_r = listPushBack(q_r, mid)

                        q_node = listPushBack(q_node, (2 * cn) + 1)
                        q_l = listPushBack(q_l, mid + 1)
                        q_r = listPushBack(q_r, cr)
                  }
            }
      }
      println("   Nova soma total [1..8] (esperado 76): " + tot_ans)

      mut as bool: ok = (ans_3_6 == 18) and (new_ans_3_6 == 48) and (tot_ans == 76)
      println("6. Verificacao de Lazy Propagation: " + ok)
      println("Concluido com Sucesso")
}
