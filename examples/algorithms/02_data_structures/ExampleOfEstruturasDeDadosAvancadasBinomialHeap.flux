#L ============================================================================
#L Algoritmo: Binomial Heap (Floresta de Arvores Binomiais de Vuillemin 1978)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) uniao, insercao e extract-min no pior caso | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasBinomialHeap) {
      println("==================================================")
      println("  SciAlgo: Binomial Heap (Vuillemin)")
      println("==================================================")

      #L Representacao em vetores paralelos (1-based, 0 = NULL)
      mut as list of int64: key = [0]
      mut as list of int64: deg = [0]
      mut as list of int64: parent = [0]
      mut as list of int64: child = [0]
      mut as list of int64: sibling = [0]

      #L Raizes das arvores binomiais ordenadas por grau crescente
      mut as list of int64: roots = []

      #L Elementos para construir o Heap Binomial: 12, 7, 25, 18, 14, 8, 30
      mut as list of int64: elements = [12, 7, 25, 18, 14, 8, 30]
      mut as int64: n = listLength(elements)

      println("1. Inserindo " + n + " elementos no Binomial Heap:")
      mut as int64: idx = 1
      infinite (idx <= n) {
            mut as int64: val = elements[idx]
            key = listPushBack(key, val)
            deg = listPushBack(deg, 0)
            parent = listPushBack(parent, 0)
            child = listPushBack(child, 0)
            sibling = listPushBack(sibling, 0)
            mut as int64: u = listLength(key) - 1

            #L Realiza uniao de arvore B0 de u com a floresta atual
            mut as int64: carry = u
            mut as list of int64: new_roots = []
            mut as int64: r_i = 1
            mut as int64: num_r = listLength(roots)

            infinite (r_i <= num_r or carry != 0) {
                  route {
                        r_i <= num_r ==> {
                              mut as int64: curr_tree = roots[r_i]
                              route {
                                    carry == 0 ==> {
                                          new_roots = listPushBack(new_roots, curr_tree)
                                          r_i = r_i + 1
                                    }
                                    deg[carry] < deg[curr_tree] ==> {
                                          new_roots = listPushBack(new_roots, carry)
                                          carry = 0
                                    }
                                    deg[carry] == deg[curr_tree] ==> {
                                          #L Funde duas arvores de mesmo grau (a menor vira pai da maior)
                                          route {
                                                key[carry] <= key[curr_tree] ==> {
                                                      sibling[curr_tree] = child[carry]
                                                      child[carry] = curr_tree
                                                      parent[curr_tree] = carry
                                                      deg[carry] = deg[carry] + 1
                                                }
                                                _ ==> {
                                                      sibling[carry] = child[curr_tree]
                                                      child[curr_tree] = carry
                                                      parent[carry] = curr_tree
                                                      deg[curr_tree] = deg[curr_tree] + 1
                                                      carry = curr_tree
                                                }
                                          }
                                          r_i = r_i + 1
                                    }
                                    _ ==> {
                                          new_roots = listPushBack(new_roots, curr_tree)
                                          r_i = r_i + 1
                                    }
                              }
                        }
                        _ ==> {
                              new_roots = listPushBack(new_roots, carry)
                              carry = 0
                        }
                  }
            }
            roots = new_roots
            idx = idx + 1
      }

      println("2. Arvores binomiais na floresta raiz: " + listLength(roots) + " arvores")
      mut as int64: min_val = 999999
      mut as int64: min_root = 0
      mut as int64: ri = 1
      infinite (ri <= listLength(roots)) {
            mut as int64: rt = roots[ri]
            println("   Arvore raiz com grau " + deg[rt] + ": chave = " + key[rt])
            route {
                  key[rt] < min_val ==> {
                        min_val = key[rt]
                        min_root = rt
                  }
            }
            ri = ri + 1
      }

      println("3. Chave minima global encontrada: " + min_val + " (raiz " + min_root + ")")
      println("4. Validacao: " + (min_val == 7 and listLength(roots) == 3 and n == 7))
      println("==================================================")
}
