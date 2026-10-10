#L ============================================================================
#L Algoritmo: Splay Tree (Arvore Auto-Ajustavel de Sleator & Tarjan 1985)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Acesso/Insercao O(log N) amortizado | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasSplayTree) {
      println("==================================================")
      println("  SciAlgo: Splay Tree (Zig, Zig-Zig, Zig-Zag)")
      println("==================================================")

      #L Representacao dos nos (1-based, 0 = NULL)
      mut as list of int64: tree_key = [0]
      mut as list of int64: tree_val = [0]
      mut as list of int64: tree_left = [0]
      mut as list of int64: tree_right = [0]
      mut as list of int64: tree_parent = [0]
      mut as int64: root = 0

      #L Funcoes inline de rotacao:
      #L Rotação a direita em p (filho esquerdo x sobe)
      #L Rotação a esquerda em p (filho direito x sobe)

      #L Chaves a inserir: 10, 20, 30, 40, 50
      mut as list of int64: in_keys = [10, 20, 30, 40, 50]
      mut as int64: n_keys = listLength(in_keys)
      println("1. Inserindo 5 chaves com Splay apos cada insercao...")

      mut as int64: ki = 1
      infinite (ki <= n_keys) {
            mut as int64: k = in_keys[ki]

            #L Aloca novo no
            tree_key = listPushBack(tree_key, k)
            tree_val = listPushBack(tree_val, k * 10)
            tree_left = listPushBack(tree_left, 0)
            tree_right = listPushBack(tree_right, 0)
            tree_parent = listPushBack(tree_parent, 0)
            mut as int64: new_node = listLength(tree_key)

            route {
                  root == 0 ==> {
                        root = new_node
                  }
                  _ ==> {
                        #L Insercao BST padrao
                        mut as int64: curr = root
                        infinite (true) {
                              route {
                                    k < tree_key[curr] ==> {
                                          route {
                                                tree_left[curr] == 0 ==> {
                                                      tree_left[curr] = new_node
                                                      tree_parent[new_node] = curr
                                                      break
                                                }
                                                _ ==> { curr = tree_left[curr] }
                                          }
                                    }
                                    _ ==> {
                                          route {
                                                tree_right[curr] == 0 ==> {
                                                      tree_right[curr] = new_node
                                                      tree_parent[new_node] = curr
                                                      break
                                                }
                                                _ ==> { curr = tree_right[curr] }
                                          }
                                    }
                              }
                        }

                        #L Operacao SPLAY em new_node ate a raiz
                        mut as int64: x = new_node
                        infinite (tree_parent[x] != 0) {
                              mut as int64: p = tree_parent[x]
                              mut as int64: g = tree_parent[p]

                              route {
                                    g == 0 ==> {
                                          #L Caso ZIG (simples)
                                          route {
                                                tree_left[p] == x ==> {
                                                      #L Rotacao a direita em p
                                                      mut as int64: xr = tree_right[x]
                                                      tree_left[p] = xr
                                                      route { xr != 0 ==> { tree_parent[xr] = p } }
                                                      tree_right[x] = p
                                                      tree_parent[p] = x
                                                      tree_parent[x] = 0
                                                      root = x
                                                }
                                                _ ==> {
                                                      #L Rotacao a esquerda em p
                                                      mut as int64: xl = tree_left[x]
                                                      tree_right[p] = xl
                                                      route { xl != 0 ==> { tree_parent[xl] = p } }
                                                      tree_left[x] = p
                                                      tree_parent[p] = x
                                                      tree_parent[x] = 0
                                                      root = x
                                                }
                                          }
                                    }
                                    _ ==> {
                                          #L Casos duplos: ZIG-ZIG ou ZIG-ZAG
                                          mut as int64: gg = tree_parent[g]
                                          route {
                                                (tree_left[p] == x) and (tree_left[g] == p) ==> {
                                                      #L ZIG-ZIG Esquerda: rotaciona g a direita, depois p a direita
                                                      mut as int64: pr = tree_right[p]
                                                      tree_left[g] = pr
                                                      route { pr != 0 ==> { tree_parent[pr] = g } }
                                                      tree_right[p] = g
                                                      tree_parent[g] = p

                                                      mut as int64: xr = tree_right[x]
                                                      tree_left[p] = xr
                                                      route { xr != 0 ==> { tree_parent[xr] = p } }
                                                      tree_right[x] = p
                                                      tree_parent[p] = x

                                                      tree_parent[x] = gg
                                                      route {
                                                            gg == 0 ==> { root = x }
                                                            tree_left[gg] == g ==> { tree_left[gg] = x }
                                                            _ ==> { tree_right[gg] = x }
                                                      }
                                                }
                                                (tree_right[p] == x) and (tree_right[g] == p) ==> {
                                                      #L ZIG-ZIG Direita: rotaciona g a esquerda, depois p a esquerda
                                                      mut as int64: pl = tree_left[p]
                                                      tree_right[g] = pl
                                                      route { pl != 0 ==> { tree_parent[pl] = g } }
                                                      tree_left[p] = g
                                                      tree_parent[g] = p

                                                      mut as int64: xl = tree_left[x]
                                                      tree_right[p] = xl
                                                      route { xl != 0 ==> { tree_parent[xl] = p } }
                                                      tree_left[x] = p
                                                      tree_parent[p] = x

                                                      tree_parent[x] = gg
                                                      route {
                                                            gg == 0 ==> { root = x }
                                                            tree_left[gg] == g ==> { tree_left[gg] = x }
                                                            _ ==> { tree_right[gg] = x }
                                                      }
                                                }
                                                (tree_right[p] == x) and (tree_left[g] == p) ==> {
                                                      #L ZIG-ZAG: rotaciona p a esquerda, depois g a direita
                                                      mut as int64: xl = tree_left[x]
                                                      tree_right[p] = xl
                                                      route { xl != 0 ==> { tree_parent[xl] = p } }
                                                      tree_left[x] = p
                                                      tree_parent[p] = x

                                                      mut as int64: xr = tree_right[x]
                                                      tree_left[g] = xr
                                                      route { xr != 0 ==> { tree_parent[xr] = g } }
                                                      tree_right[x] = g
                                                      tree_parent[g] = x

                                                      tree_parent[x] = gg
                                                      route {
                                                            gg == 0 ==> { root = x }
                                                            tree_left[gg] == g ==> { tree_left[gg] = x }
                                                            _ ==> { tree_right[gg] = x }
                                                      }
                                                }
                                                _ ==> {
                                                      #L ZIG-ZAG inverso: rotaciona p a direita, depois g a esquerda
                                                      mut as int64: xr = tree_right[x]
                                                      tree_left[p] = xr
                                                      route { xr != 0 ==> { tree_parent[xr] = p } }
                                                      tree_right[x] = p
                                                      tree_parent[p] = x

                                                      mut as int64: xl = tree_left[x]
                                                      tree_right[g] = xl
                                                      route { xl != 0 ==> { tree_parent[xl] = g } }
                                                      tree_left[x] = g
                                                      tree_parent[g] = x

                                                      tree_parent[x] = gg
                                                      route {
                                                            gg == 0 ==> { root = x }
                                                            tree_left[gg] == g ==> { tree_left[gg] = x }
                                                            _ ==> { tree_right[gg] = x }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }

            println("   Chave " + k + " inserida -> nova raiz da Splay Tree: " + tree_key[root])
            ki = ki + 1
      }

      #L Apos inserir 50, a raiz deve ser 50
      mut as int64: root_after_50 = tree_key[root]
      println("2. Raiz apos insercao de 50 (esperado 50): " + root_after_50)

      #L 3. Busca por chave 20 -> splay(20) deve levar chave 20 ate a raiz!
      println("3. Buscando chave 20 e aplicando Splay...")
      mut as int64: found_node = 0
      mut as int64: curr = root
      infinite (curr != 0) {
            route {
                  tree_key[curr] == 20 ==> {
                        found_node = curr
                        break
                  }
                  20 < tree_key[curr] ==> { curr = tree_left[curr] }
                  _ ==> { curr = tree_right[curr] }
            }
      }

      route {
            found_node != 0 ==> {
                  mut as int64: x = found_node
                  infinite (tree_parent[x] != 0) {
                        mut as int64: p = tree_parent[x]
                        mut as int64: g = tree_parent[p]

                        route {
                              g == 0 ==> {
                                    route {
                                          tree_left[p] == x ==> {
                                                mut as int64: xr = tree_right[x]
                                                tree_left[p] = xr
                                                route { xr != 0 ==> { tree_parent[xr] = p } }
                                                tree_right[x] = p
                                                tree_parent[p] = x
                                                tree_parent[x] = 0
                                                root = x
                                          }
                                          _ ==> {
                                                mut as int64: xl = tree_left[x]
                                                tree_right[p] = xl
                                                route { xl != 0 ==> { tree_parent[xl] = p } }
                                                tree_left[x] = p
                                                tree_parent[p] = x
                                                tree_parent[x] = 0
                                                root = x
                                          }
                                    }
                              }
                              _ ==> {
                                    mut as int64: gg = tree_parent[g]
                                    route {
                                          (tree_left[p] == x) and (tree_left[g] == p) ==> {
                                                mut as int64: pr = tree_right[p]
                                                tree_left[g] = pr
                                                route { pr != 0 ==> { tree_parent[pr] = g } }
                                                tree_right[p] = g
                                                tree_parent[g] = p

                                                mut as int64: xr = tree_right[x]
                                                tree_left[p] = xr
                                                route { xr != 0 ==> { tree_parent[xr] = p } }
                                                tree_right[x] = p
                                                tree_parent[p] = x

                                                tree_parent[x] = gg
                                                route {
                                                      gg == 0 ==> { root = x }
                                                      tree_left[gg] == g ==> { tree_left[gg] = x }
                                                      _ ==> { tree_right[gg] = x }
                                                }
                                          }
                                          (tree_right[p] == x) and (tree_right[g] == p) ==> {
                                                mut as int64: pl = tree_left[p]
                                                tree_right[g] = pl
                                                route { pl != 0 ==> { tree_parent[pl] = g } }
                                                tree_left[p] = g
                                                tree_parent[g] = p

                                                mut as int64: xl = tree_left[x]
                                                tree_right[p] = xl
                                                route { xl != 0 ==> { tree_parent[xl] = p } }
                                                tree_left[x] = p
                                                tree_parent[p] = x

                                                tree_parent[x] = gg
                                                route {
                                                      gg == 0 ==> { root = x }
                                                      tree_left[gg] == g ==> { tree_left[gg] = x }
                                                      _ ==> { tree_right[gg] = x }
                                                }
                                          }
                                          (tree_right[p] == x) and (tree_left[g] == p) ==> {
                                                mut as int64: xl = tree_left[x]
                                                tree_right[p] = xl
                                                route { xl != 0 ==> { tree_parent[xl] = p } }
                                                tree_left[x] = p
                                                tree_parent[p] = x

                                                mut as int64: xr = tree_right[x]
                                                tree_left[g] = xr
                                                route { xr != 0 ==> { tree_parent[xr] = g } }
                                                tree_right[g] = g
                                                tree_parent[g] = x

                                                tree_parent[x] = gg
                                                route {
                                                      gg == 0 ==> { root = x }
                                                      tree_left[gg] == g ==> { tree_left[gg] = x }
                                                      _ ==> { tree_right[gg] = x }
                                                }
                                          }
                                          _ ==> {
                                                mut as int64: xr = tree_right[x]
                                                tree_left[p] = xr
                                                route { xr != 0 ==> { tree_parent[xr] = p } }
                                                tree_right[x] = p
                                                tree_parent[p] = x

                                                mut as int64: xl = tree_left[x]
                                                tree_right[g] = xl
                                                route { xl != 0 ==> { tree_parent[xl] = p } }
                                                tree_left[x] = g
                                                tree_parent[g] = x

                                                tree_parent[x] = gg
                                                route {
                                                      gg == 0 ==> { root = x }
                                                      tree_left[gg] == g ==> { tree_left[gg] = x }
                                                      _ ==> { tree_right[gg] = x }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }
      }

      mut as int64: root_after_find20 = tree_key[root]
      println("   Raiz apos busca e splay da chave 20 (esperado 20): " + root_after_find20)

      #L 4. Verificacao da Ordem BST via percurso In-Order iterativo
      mut as list of int64: inorder_keys = []
      mut as list of int64: s = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: s_top = 0
      curr = root

      infinite ((curr != 0) or (s_top > 0)) {
            infinite (curr != 0) {
                  s_top = s_top + 1
                  s[s_top] = curr
                  curr = tree_left[curr]
            }

            curr = s[s_top]
            s_top = s_top - 1

            inorder_keys = listPushBack(inorder_keys, tree_key[curr])
            curr = tree_right[curr]
      }

      mut as bool: bst_sorted = true
      mut as int64: i = 1
      infinite (i <= n_keys) {
            route {
                  inorder_keys[i] != in_keys[i] ==> {
                        bst_sorted = false
                  }
            }
            i = i + 1
      }
      println("4. Arvore mantem estrita ordenacao BST: " + bst_sorted)

      mut as bool: ok = (root_after_50 == 50) and (root_after_find20 == 20) and bst_sorted
      println("5. Verificacao geral da Splay Tree: " + ok)
      println("Concluido com Sucesso")
}
