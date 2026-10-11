#L ============================================================================
#L Algoritmo: Trie (Arvore de Prefixos / Prefix Tree)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Insercao O(L) | Busca O(L) | Prefixo O(L), onde L = tamanho da string
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib
use StringStdLib

function (charToId) (as string: ch) as int64 {
      mut as int64: id = 0
      route {
            ch == "a" ==> { id = 1 }
            ch == "b" ==> { id = 2 }
            ch == "c" ==> { id = 3 }
            ch == "d" ==> { id = 4 }
            ch == "e" ==> { id = 5 }
            ch == "f" ==> { id = 6 }
            ch == "g" ==> { id = 7 }
            ch == "h" ==> { id = 8 }
            ch == "i" ==> { id = 9 }
            ch == "j" ==> { id = 10 }
            ch == "k" ==> { id = 11 }
            ch == "l" ==> { id = 12 }
            ch == "m" ==> { id = 13 }
            ch == "n" ==> { id = 14 }
            ch == "o" ==> { id = 15 }
            ch == "p" ==> { id = 16 }
            ch == "q" ==> { id = 17 }
            ch == "r" ==> { id = 18 }
            ch == "s" ==> { id = 19 }
            ch == "t" ==> { id = 20 }
            ch == "u" ==> { id = 21 }
            ch == "v" ==> { id = 22 }
            ch == "w" ==> { id = 23 }
            ch == "x" ==> { id = 24 }
            ch == "y" ==> { id = 25 }
            ch == "z" ==> { id = 26 }
            _ ==> { id = 0 }
      }
      emit(nice, id, "ok")
}

program (ExampleOfEstruturasDeDadosAvancadasTrie) {
      println("==================================================")
      println("  SciAlgo: Trie (Arvore de Prefixos)")
      println("==================================================")

      #L Representacao tabular da Trie:
      #L Tabela de transicoes: next_node[(node - 1) * 26 + char_id]
      #L is_end[node]: booleano indicando fim de palavra
      mut as list of bool: is_end = [false] #L No 1 = raiz
      mut as list of int64: next_node = []
      
      #L Inicializa 26 transicoes para a raiz (no 1)
      mut as int64: zi = 1
      infinite (zi <= 26) {
            next_node = listPushBack(next_node, 0)
            zi = zi + 1
      }
      mut as int64: num_nodes = 1

      mut as list of string: palavras = ["flux", "flow", "float", "the", "there", "their"]
      mut as int64: n_palavras = listLength(palavras)
      println("1. Inserindo " + n_palavras + " palavras na Trie: " + palavras)

      #L Insercao de palavras
      mut as int64: pi = 1
      infinite (pi <= n_palavras) {
            mut as string: w = palavras[pi]
            mut as int64: len_w = stringLength(w)
            mut as int64: curr = 1

            mut as int64: ci = 1
            infinite (ci <= len_w) {
                  mut as string: ch = w[ci]
                  mut as int64: cid = charToId(ch)

                  mut as int64: edge_idx = ((curr - 1) * 26) + cid
                  mut as int64: nxt = next_node[edge_idx]

                  route {
                        nxt == 0 ==> {
                              #L Cria novo no
                              num_nodes = num_nodes + 1
                              nxt = num_nodes
                              next_node[edge_idx] = nxt
                              is_end = listPushBack(is_end, false)

                              #L Aloca 26 arestas para o novo no
                              mut as int64: k = 1
                              infinite (k <= 26) {
                                    next_node = listPushBack(next_node, 0)
                                    k = k + 1
                              }
                        }
                        _ ==> {
                        }
                  }
                  curr = nxt
                  ci = ci + 1
            }
            is_end[curr] = true
            println("   Palavra inserida: '" + w + "' (no terminal " + curr + ")")
            pi = pi + 1
      }
      println("2. Total de nos na Trie: " + num_nodes)

      #L Consultas de busca exata (Search)
      println("3. Testes de busca exata (Search):")
      mut as list of string: buscas = ["flux", "flow", "flu", "there", "th", "apple"]
      mut as list of bool: res_busca = []

      mut as int64: bi = 1
      infinite (bi <= listLength(buscas)) {
            mut as string: query_w = buscas[bi]
            mut as int64: len_q = stringLength(query_w)
            mut as int64: curr = 1
            mut as bool: found = true

            mut as int64: ci = 1
            infinite (ci <= len_q) {
                  mut as string: ch = query_w[ci]
                  mut as int64: cid = charToId(ch)
                  route {
                        cid == 0 ==> {
                              found = false
                              break
                        }
                        _ ==> {
                              mut as int64: edge_idx = ((curr - 1) * 26) + cid
                              mut as int64: nxt = next_node[edge_idx]
                              route {
                                    nxt == 0 ==> {
                                          found = false
                                          break
                                    }
                                    _ ==> {
                                          curr = nxt
                                    }
                              }
                        }
                  }
                  ci = ci + 1
            }

            mut as bool: match_exato = found and is_end[curr]
            res_busca = listPushBack(res_busca, match_exato)
            println("   Busca exata '" + query_w + "': " + match_exato)
            bi = bi + 1
      }

      #L Consultas de prefixo (StartsWith)
      println("4. Testes de correspondencia de prefixo (StartsWith):")
      mut as list of string: prefixos = ["fl", "the", "thei", "xyz"]
      mut as list of bool: res_prefix = []

      mut as int64: pfi = 1
      infinite (pfi <= listLength(prefixos)) {
            mut as string: pref = prefixos[pfi]
            mut as int64: len_p = stringLength(pref)
            mut as int64: curr = 1
            mut as bool: pref_ok = true

            mut as int64: ci = 1
            infinite (ci <= len_p) {
                  mut as string: ch = pref[ci]
                  mut as int64: cid = charToId(ch)
                  route {
                        cid == 0 ==> {
                              pref_ok = false
                              break
                        }
                        _ ==> {
                              mut as int64: edge_idx = ((curr - 1) * 26) + cid
                              mut as int64: nxt = next_node[edge_idx]
                              route {
                                    nxt == 0 ==> {
                                          pref_ok = false
                                          break
                                    }
                                    _ ==> {
                                          curr = nxt
                                    }
                              }
                        }
                  }
                  ci = ci + 1
            }

            res_prefix = listPushBack(res_prefix, pref_ok)
            println("   Prefixo '" + pref + "': " + pref_ok)
            pfi = pfi + 1
      }

      mut as bool: ok_busca = res_busca[1] and res_busca[2] and (not res_busca[3]) and res_busca[4] and (not res_busca[5]) and (not res_busca[6])
      mut as bool: ok_pref = res_prefix[1] and res_prefix[2] and res_prefix[3] and (not res_prefix[4])
      mut as bool: ok = ok_busca and ok_pref

      println("5. Verificacao geral da Trie: " + ok)
      println("Concluido com Sucesso")
}
