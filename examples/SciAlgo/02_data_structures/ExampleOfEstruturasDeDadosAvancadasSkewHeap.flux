#L ============================================================================
#L Algoritmo: Skew Heap (Heap Auto-Ajustavel de Sleator & Tarjan 1986)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) amortizado para fusao, insercao e remocao | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasSkewHeap) {
      println("==================================================")
      println("  SciAlgo: Skew Heap (Sleator & Tarjan)")
      println("==================================================")

      #L Representacao em vetores paralelos (1-based, 0 = NULL)
      mut as list of int64: key = [0]
      mut as list of int64: left_ch = [0]
      mut as list of int64: right_ch = [0]
      mut as int64: root = 0

      #L Chaves a inserir: 18, 9, 35, 12, 4, 27, 16
      mut as list of int64: in_keys = [18, 9, 35, 12, 4, 27, 16]
      mut as int64: n = listLength(in_keys)

      println("1. Inserindo " + n + " chaves no Skew Heap com swap incondicional:")

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: k = in_keys[i]

            key = listPushBack(key, k)
            left_ch = listPushBack(left_ch, 0)
            right_ch = listPushBack(right_ch, 0)
            mut as int64: node = listLength(key) - 1

            #L Fusao Skew iterativa de root e node
            route {
                  root == 0 ==> {
                        root = node
                  }
                  _ ==> {
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

                        mut as int64: remainder = h1
                        route { h1 == 0 ==> { remainder = h2 } }

                        #L Sobe pelo caminho e inverte INCONDICIONALMENTE os filhos esquerdo e direito
                        mut as int64: p_idx = listLength(path)
                        infinite (p_idx >= 1) {
                              mut as int64: curr = path[p_idx]
                              mut as int64: old_left = left_ch[curr]

                              #L Novo filho esquerdo vira a fusao da subarvore direita anterior (remainder)
                              #L Novo filho direito vira o antigo filho esquerdo
                              left_ch[curr] = remainder
                              right_ch[curr] = old_left

                              remainder = curr
                              p_idx = p_idx - 1
                        }
                        root = remainder
                  }
            }
            println("   Inserido " + k + " (raiz atual: " + key[root] + ")")
            i = i + 1
      }

      println("2. Raiz minima apos insercoes: chave " + key[root])

      #L Extrair Minimo (Extract-Min)
      mut as int64: min_extracted = key[root]
      println("3. Extraindo chave minima: " + min_extracted)

      mut as int64: left_sub = left_ch[root]
      mut as int64: right_sub = right_ch[root]

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
                        mut as int64: old_left = left_ch[curr]
                        left_ch[curr] = remainder
                        right_ch[curr] = old_left
                        remainder = curr
                        p_idx = p_idx - 1
                  }
                  root = remainder
            }
      }

      println("4. Novo minimo resultante: chave " + key[root])
      println("5. Validacao: " + (min_extracted == 4 and key[root] == 9 and n == 7))
      println("==================================================")
}
