#L ============================================================================
#L Algoritmo: Leftist Heap (Arvore Esquerdista / Fila de Crane 1972)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) fusao, insercao e remocao de minimo | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasLeftistHeap) {
      println("==================================================")
      println("  SciAlgo: Leftist Heap (Leftist Tree)")
      println("==================================================")

      #L Representacao em vetores paralelos (1-based, 0 = NULL)
      mut as list of int64: key = [0]
      mut as list of int64: npl = [0] #L Null Path Length (s-value)
      mut as list of int64: left_ch = [0]
      mut as list of int64: right_ch = [0]
      mut as int64: root = 0

      #L Chaves a inserir: 24, 15, 30, 8, 19, 5, 42
      mut as list of int64: in_keys = [24, 15, 30, 8, 19, 5, 42]
      mut as int64: n = listLength(in_keys)

      println("1. Inserindo " + n + " chaves via fusao iterativa no Leftist Heap:")

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: k = in_keys[i]

            #L Aloca novo no com npl = 1
            key = listPushBack(key, k)
            npl = listPushBack(npl, 1)
            left_ch = listPushBack(left_ch, 0)
            right_ch = listPushBack(right_ch, 0)
            mut as int64: node = listLength(key) - 1

            #L Fusao de root e node
            route {
                  root == 0 ==> {
                        root = node
                  }
                  _ ==> {
                        #L Desce pela espinha direita guardando caminho para restaurar npl e swap
                        mut as int64: h1 = root
                        mut as int64: h2 = node
                        mut as list of int64: path = []

                        infinite (h1 != 0 and h2 != 0) {
                              route {
                                    key[h1] <= key[h2] ==> {
                                          path = listPushBack(path, h1)
                                          h1 = right_ch[h1]
                                    }
                                    _ ==> {
                                          path = listPushBack(path, h2)
                                          h2 = right_ch[h2]
                                    }
                              }
                        }

                        #L O restante (nao nulo) e anexado
                        mut as int64: remainder = h1
                        route { h1 == 0 ==> { remainder = h2 } }

                        #L Sobe pelo caminho restaurando a espinha direita e a propriedade esquerdista
                        mut as int64: p_idx = listLength(path)
                        infinite (p_idx >= 1) {
                              mut as int64: curr = path[p_idx]
                              right_ch[curr] = remainder

                              #L Garante propriedade esquerdista: npl(left) >= npl(right)
                              mut as int64: l = left_ch[curr]
                              mut as int64: r = right_ch[curr]
                              mut as int64: npl_l = 0
                              mut as int64: npl_r = 0
                              route { l != 0 ==> { npl_l = npl[l] } }
                              route { r != 0 ==> { npl_r = npl[r] } }

                              route {
                                    npl_l < npl_r ==> {
                                          #L Inverte filhos (swap)
                                          left_ch[curr] = r
                                          right_ch[curr] = l
                                          mut as int64: tmp = npl_l
                                          npl_l = npl_r
                                          npl_r = tmp
                                    }
                              }
                              npl[curr] = npl_r + 1
                              remainder = curr
                              p_idx = p_idx - 1
                        }
                        root = remainder
                  }
            }
            println("   Inserido " + k + " (raiz atual: chave = " + key[root] + ", npl = " + npl[root] + ")")
            i = i + 1
      }

      println("2. Raiz minima apos todas as insercoes: chave " + key[root] + " (npl = " + npl[root] + ")")

      #L Extrair Minimo (Extract-Min): remove raiz e funde filho esquerdo e direito
      mut as int64: min_extracted = key[root]
      println("3. Extraindo minimo: " + min_extracted)

      mut as int64: left_sub = left_ch[root]
      mut as int64: right_sub = right_ch[root]

      #L Funde as duas subarvores restantes
      route {
            left_sub == 0 ==> {
                  root = right_sub
            }
            right_sub == 0 ==> {
                  root = left_sub
            }
            _ ==> {
                  mut as int64: h1 = left_sub
                  mut as int64: h2 = right_sub
                  mut as list of int64: path = []

                  infinite (h1 != 0 and h2 != 0) {
                        route {
                              key[h1] <= key[h2] ==> {
                                    path = listPushBack(path, h1)
                                    h1 = right_ch[h1]
                              }
                              _ ==> {
                                    path = listPushBack(path, h2)
                                    h2 = right_ch[h2]
                              }
                        }
                  }

                  mut as int64: remainder = h1
                  route { h1 == 0 ==> { remainder = h2 } }

                  mut as int64: p_idx = listLength(path)
                  infinite (p_idx >= 1) {
                        mut as int64: curr = path[p_idx]
                        right_ch[curr] = remainder

                        mut as int64: l = left_ch[curr]
                        mut as int64: r = right_ch[curr]
                        mut as int64: npl_l = 0
                        mut as int64: npl_r = 0
                        route { l != 0 ==> { npl_l = npl[l] } }
                        route { r != 0 ==> { npl_r = npl[r] } }

                        route {
                              npl_l < npl_r ==> {
                                    left_ch[curr] = r
                                    right_ch[curr] = l
                                    mut as int64: tmp = npl_l
                                    npl_l = npl_r
                                    npl_r = tmp
                              }
                        }
                        npl[curr] = npl_r + 1
                        remainder = curr
                        p_idx = p_idx - 1
                  }
                  root = remainder
            }
      }

      println("4. Novo minimo apos extracao: chave " + key[root])
      println("5. Validacao: " + (min_extracted == 5 and key[root] == 8 and npl[root] >= 1))
      println("==================================================")
}
