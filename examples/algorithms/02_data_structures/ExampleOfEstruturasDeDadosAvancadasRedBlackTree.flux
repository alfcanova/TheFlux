#L ============================================================================
#L Algoritmo: Red-Black Tree (Arvore Rubro-Negra Auto-Balanceada)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Insercao O(log N) | Busca O(log N) | Altura Garantida <= 2 log2(N+1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasRedBlackTree) {
      println("==================================================")
      println("  SciAlgo: Red-Black Tree (Arvore Rubro-Negra)")
      println("==================================================")

      #L Representacao em vetores paralelos (1-based, 0 = NULL / NIL preto)
      #L Cor: 0 = PRETO, 1 = VERMELHO
      mut as list of int64: key = [0]
      mut as list of int64: color = [0]
      mut as list of int64: parent = [0]
      mut as list of int64: left_ch = [0]
      mut as list of int64: right_ch = [0]
      mut as int64: root = 0

      #L Sequencia de insercao deterministica
      mut as list of int64: entradas = [7, 3, 18, 10, 22, 8, 11, 26, 2, 6, 13]
      mut as int64: n = listLength(entradas)

      println("1. Inserindo " + n + " elementos na Arvore Rubro-Negra: " + entradas)

      mut as int64: ins_i = 1
      infinite (ins_i <= n) {
            mut as int64: val = entradas[ins_i]

            #L Novo no eh inserido inicialmente como VERMELHO (cor = 1)
            key = listPushBack(key, val)
            color = listPushBack(color, 1)
            parent = listPushBack(parent, 0)
            left_ch = listPushBack(left_ch, 0)
            right_ch = listPushBack(right_ch, 0)
            mut as int64: z = listLength(key) - 1

            #L Insercao BST padrao
            mut as int64: y = 0
            mut as int64: x = root
            infinite (x != 0) {
                  y = x
                  route {
                        val < key[x] ==> {
                              x = left_ch[x]
                        }
                        _ ==> {
                              x = right_ch[x]
                        }
                  }
            }

            parent[z] = y
            route {
                  y == 0 ==> {
                        root = z
                  }
                  val < key[y] ==> {
                        left_ch[y] = z
                  }
                  _ ==> {
                        right_ch[y] = z
                  }
            }

            #L Reparo de propriedades Rubro-Negras (Fixup)
            infinite (z != root) {
                  mut as int64: p = parent[z]
                  mut as bool: p_is_red = false
                  route {
                        p != 0 ==> {
                              route {
                                    color[p] == 1 ==> {
                                          p_is_red = true
                                    }
                                    _ ==> {
                                    }
                              }
                        }
                        _ ==> {
                        }
                  }
                  route {
                        not p_is_red ==> {
                              break
                        }
                        _ ==> {
                        }
                  }
                  mut as int64: gp = parent[p]

                  route {
                        p == left_ch[gp] ==> {
                              mut as int64: uncle = right_ch[gp]
                              #L Caso 1: Tio eh Vermelho -> recoloracao
                              mut as int64: u_col = 0
                              route { uncle != 0 ==> { u_col = color[uncle] } _ ==> {} }

                              route {
                                    u_col == 1 ==> {
                                          color[p] = 0
                                          color[uncle] = 0
                                          color[gp] = 1
                                          z = gp
                                    }
                                    _ ==> {
                                          #L Caso 2: z eh filho direito -> rotacao a esquerda em p
                                          route {
                                                z == right_ch[p] ==> {
                                                      z = p
                                                      #L Rotacao a esquerda em z
                                                      mut as int64: y_rot = right_ch[z]
                                                      right_ch[z] = left_ch[y_rot]
                                                      route { left_ch[y_rot] != 0 ==> { parent[left_ch[y_rot]] = z } _ ==> {} }
                                                      parent[y_rot] = parent[z]
                                                      route {
                                                            parent[z] == 0 ==> { root = y_rot }
                                                            z == left_ch[parent[z]] ==> { left_ch[parent[z]] = y_rot }
                                                            _ ==> { right_ch[parent[z]] = y_rot }
                                                      }
                                                      left_ch[y_rot] = z
                                                      parent[z] = y_rot
                                                      p = parent[z]
                                                      gp = parent[p]
                                                }
                                                _ ==> {
                                                }
                                          }

                                          #L Caso 3: z eh filho esquerdo -> recolore e rotacao a direita em gp
                                          color[p] = 0
                                          color[gp] = 1
                                          #L Rotacao a direita em gp
                                          mut as int64: y_rd = left_ch[gp]
                                          left_ch[gp] = right_ch[y_rd]
                                          route { right_ch[y_rd] != 0 ==> { parent[right_ch[y_rd]] = gp } _ ==> {} }
                                          parent[y_rd] = parent[gp]
                                          route {
                                                parent[gp] == 0 ==> { root = y_rd }
                                                gp == left_ch[parent[gp]] ==> { left_ch[parent[gp]] = y_rd }
                                                _ ==> { right_ch[parent[gp]] = y_rd }
                                          }
                                          right_ch[y_rd] = gp
                                          parent[gp] = y_rd
                                    }
                              }
                        }
                        _ ==> {
                              #L Lado espelhado: p eh filho direito de gp
                              mut as int64: uncle = left_ch[gp]
                              mut as int64: u_col = 0
                              route { uncle != 0 ==> { u_col = color[uncle] } _ ==> {} }

                              route {
                                    u_col == 1 ==> {
                                          color[p] = 0
                                          color[uncle] = 0
                                          color[gp] = 1
                                          z = gp
                                    }
                                    _ ==> {
                                          #L Caso 2 espelhado: z eh filho esquerdo -> rotacao a direita em p
                                          route {
                                                z == left_ch[p] ==> {
                                                      z = p
                                                      #L Rotacao a direita em z
                                                      mut as int64: y_rot = left_ch[z]
                                                      left_ch[z] = right_ch[y_rot]
                                                      route { right_ch[y_rot] != 0 ==> { parent[right_ch[y_rot]] = z } _ ==> {} }
                                                      parent[y_rot] = parent[z]
                                                      route {
                                                            parent[z] == 0 ==> { root = y_rot }
                                                            z == left_ch[parent[z]] ==> { left_ch[parent[z]] = y_rot }
                                                            _ ==> { right_ch[parent[z]] = y_rot }
                                                      }
                                                      right_ch[y_rot] = z
                                                      parent[z] = y_rot
                                                      p = parent[z]
                                                      gp = parent[p]
                                                }
                                                _ ==> {
                                                }
                                          }

                                          #L Caso 3 espelhado: recolore e rotacao a esquerda em gp
                                          color[p] = 0
                                          color[gp] = 1
                                          #L Rotacao a esquerda em gp
                                          mut as int64: y_re = right_ch[gp]
                                          right_ch[gp] = left_ch[y_re]
                                          route { left_ch[y_re] != 0 ==> { parent[left_ch[y_re]] = gp } _ ==> {} }
                                          parent[y_re] = parent[gp]
                                          route {
                                                parent[gp] == 0 ==> { root = y_re }
                                                gp == left_ch[parent[gp]] ==> { left_ch[parent[gp]] = y_re }
                                                _ ==> { right_ch[parent[gp]] = y_re }
                                          }
                                          left_ch[y_re] = gp
                                          parent[gp] = y_re
                                    }
                              }
                        }
                  }
            }

            #L A raiz sempre deve ser PRETA
            color[root] = 0
            ins_i = ins_i + 1
      }

      println("2. Arvore Rubro-Negra construida (Raiz: chave " + key[root] + ", cor PRETA: " + (color[root] == 0) + ")")

      #L Percurso In-Order para checar ordenacao
      mut as list of int64: in_order = []
      mut as list of int64: st_trav = []
      mut as int64: cur_tr = root

      infinite (cur_tr != 0 or listLength(st_trav) > 0) {
            infinite (cur_tr != 0) {
                  st_trav = listPushBack(st_trav, cur_tr)
                  cur_tr = left_ch[cur_tr]
            }
            mut as int64: t_sz = listLength(st_trav)
            cur_tr = st_trav[t_sz]
            st_trav = listTake(st_trav, t_sz - 1)

            in_order = listPushBack(in_order, key[cur_tr])
            cur_tr = right_ch[cur_tr]
      }
      println("3. Percurso In-Order (Ordenado): " + in_order)

      mut as bool: ordenado = true
      mut as int64: oi = 1
      mut as int64: n_ord = listLength(in_order)
      infinite (oi < n_ord) {
            route {
                  in_order[oi] > in_order[oi + 1] ==> {
                        ordenado = false
                  }
                  _ ==> {
                  }
            }
            oi = oi + 1
      }

      #L Verificacao de Propriedades Rubro-Negras:
      #L 1. Raiz eh preta
      mut as bool: raiz_preta = (color[root] == 0)

      #L 2. Nenhum no vermelho tem filho vermelho
      mut as bool: sem_vermelhos_consecutivos = true
      mut as int64: ci = 1
      infinite (ci < listLength(key)) {
            route {
                  color[ci] == 1 ==> {
                        mut as int64: lc = left_ch[ci]
                        mut as int64: rc = right_ch[ci]
                        route {
                              lc != 0 ==> {
                                    route { color[lc] == 1 ==> { sem_vermelhos_consecutivos = false } _ ==> {} }
                              }
                              _ ==> {}
                        }
                        route {
                              rc != 0 ==> {
                                    route { color[rc] == 1 ==> { sem_vermelhos_consecutivos = false } _ ==> {} }
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {
                  }
            }
            ci = ci + 1
      }
      println("4. Verificacao de cores: Raiz Preta: " + raiz_preta + " | Sem Vermelhos Consecutivos: " + sem_vermelhos_consecutivos)

      #L 3. Teste de Busca (Search O(log N))
      mut as list of int64: test_keys = [18, 6, 99]
      mut as list of bool: founds = []
      mut as int64: bi = 1
      infinite (bi <= listLength(test_keys)) {
            mut as int64: tk = test_keys[bi]
            mut as int64: cur = root
            mut as bool: f = false
            infinite (cur != 0) {
                  route {
                        tk == key[cur] ==> {
                              f = true
                              break
                        }
                        tk < key[cur] ==> {
                              cur = left_ch[cur]
                        }
                        _ ==> {
                              cur = right_ch[cur]
                        }
                  }
            }
            founds = listPushBack(founds, f)
            println("   Busca chave " + tk + ": " + f)
            bi = bi + 1
      }

      mut as bool: ok = ordenado and raiz_preta and sem_vermelhos_consecutivos and founds[1] and founds[2] and (not founds[3])
      println("5. Verificacao geral da Red-Black Tree: " + ok)
      println("Concluido com Sucesso")
}
