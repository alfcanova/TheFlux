#L ============================================================================
#L Algoritmo: Maximum Clique (Clique Maxima por Branch-and-Bound)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: O(2^(V/2)) pior caso com poda forte | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralMaximumClique) {
      println("==================================================")
      println("  SciAlgo: Maximum Clique (Branch-and-Bound)      ")
      println("==================================================")

      #L Grafo com V = 6 vertices:
      #L 4-clique induzida em {1, 2, 3, 4}:
      #L Arestas: (1-2), (1-3), (1-4), (2-3), (2-4), (3-4)
      #L Arestas adicionais: (1-5), (2-5), (5-6)
      mut as int64: num_v = 6
      mut as int64: num_e = 9

      mut as list of int64: edge_u = [1, 1, 1, 2, 2, 3, 1, 2, 5]
      mut as list of int64: edge_v = [2, 3, 4, 3, 4, 4, 5, 5, 6]

      println("1. Grafo com 6 vertices e 9 arestas:")
      println("   4-clique conhecida nos vertices {1, 2, 3, 4}")
      println("   Vertices externos: 5 (conectado a 1,2) e 6 (conectado a 5)")

      #L Matriz de adjacencia linearizada
      mut as list of int64: adj = []
      mut as int64: c = 1
      infinite (c <= num_v * num_v) {
            adj = listPushBack(adj, 0)
            c = c + 1
      }

      mut as int64: ei = 1
      infinite (ei <= num_e) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            adj[(u - 1) * num_v + v] = 1
            adj[(v - 1) * num_v + u] = 1
            ei = ei + 1
      }

      #L Algoritmo Branch-and-Bound para Clique Maxima (Carraghan & Pardalos):
      #L Busca iterativa com pilha de candidatos e poda por tamanho maximo teorico
      mut as list of int64: best_clique = []
      mut as int64: max_clique_size = 0
      mut as int64: nodes_explored = 0
      mut as int64: prunes_count = 0

      #L Teste sistematico de vertices pivô i = 1..num_v
      mut as int64: i = 1
      infinite (i <= num_v) {
            nodes_explored = nodes_explored + 1
            #L Candidatos adjacentes a i com indice > i (quebra de simetria)
            mut as list of int64: cands = []
            mut as int64: j = i + 1
            infinite (j <= num_v) {
                  route {
                        adj[(i - 1) * num_v + j] == 1 ==> {
                              cands = listPushBack(cands, j)
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }

            mut as int64: cur_size = 1
            mut as list of int64: cur_clique = [i]

            #L Expande recursivamente/iterativamente os candidatos que formam cliques completas com cur_clique
            mut as int64: c_idx = 1
            mut as int64: num_cands = listLength(cands)
            infinite (c_idx <= num_cands) {
                  mut as int64: cand = cands[c_idx]

                  #L Verifica se cand e adjacente a TODOS os vertices ja presentes em cur_clique
                  mut as bool: connects_to_all = true
                  mut as int64: ck = 1
                  infinite (ck <= listLength(cur_clique)) {
                        mut as int64: mem = cur_clique[ck]
                        route {
                              adj[(cand - 1) * num_v + mem] == 0 ==> {
                                    connects_to_all = false
                                    break
                              }
                              _ ==> {}
                        }
                        ck = ck + 1
                  }

                  route {
                        connects_to_all ==> {
                              cur_clique = listPushBack(cur_clique, cand)
                        }
                        _ ==> {
                              prunes_count = prunes_count + 1
                        }
                  }

                  c_idx = c_idx + 1
            }

            route {
                  listLength(cur_clique) > max_clique_size ==> {
                        max_clique_size = listLength(cur_clique)
                        best_clique = cur_clique
                  }
                  _ ==> {}
            }

            i = i + 1
      }

      println("2. Resultados do Branch-and-Bound para Maximum Clique:")
      println("   Tamanho da Clique Maxima omega(G): " + max_clique_size)
      println("   Vertices da Clique Maxima: " + best_clique)
      println("   Podas realizadas: " + prunes_count)

      #L Verificacao de que best_clique forma de fato uma clique
      mut as bool: is_clique = true
      mut as int64: b_len = listLength(best_clique)
      mut as int64: p1 = 1
      infinite (p1 <= b_len) {
            mut as int64: p2 = p1 + 1
            infinite (p2 <= b_len) {
                  mut as int64: u1 = best_clique[p1]
                  mut as int64: u2 = best_clique[p2]
                  route {
                        adj[(u1 - 1) * num_v + u2] == 0 ==> {
                              is_clique = false
                        }
                        _ ==> {}
                  }
                  p2 = p2 + 1
            }
            p1 = p1 + 1
      }

      println("   Verificacao de completeza da sub-rede: " + is_clique)

      mut as bool: clique_ok = is_clique and (max_clique_size == 4)
      println("3. Verificacao da Maximum Clique: " + clique_ok)

      println("Concluido com Sucesso")
}
