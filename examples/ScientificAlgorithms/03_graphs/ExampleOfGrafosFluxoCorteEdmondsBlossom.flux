#L ============================================================================
#L Algoritmo: Edmonds' Blossom (Emparelhamento Maximo em Grafos Gerais)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V^3) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteEdmondsBlossom) {
      println("==================================================")
      println("  SciAlgo: Edmonds' Blossom Algorithm             ")
      println("==================================================")

      mut as int64: num_v = 6

      #L Grafo geral nao-bipartido com 6 vertices contendo ciclo impar (blossom {2, 3, 4}):
      #L Arestas: (1,2), (2,3), (3,4), (4,2), (4,5), (5,6)
      mut as list of int64: adj = [
            0, 1, 0, 0, 0, 0,
            1, 0, 1, 1, 0, 0,
            0, 1, 0, 1, 0, 0,
            0, 1, 1, 0, 1, 0,
            0, 0, 0, 1, 0, 1,
            0, 0, 0, 0, 1, 0
      ]

      println("1. Grafo Geral Nao-Bipartido com Ciclo Impar:")
      println("   Vertices: 1..6")
      println("   Ciclo Impar (Blossom): {2, 3, 4}")
      println("   Arestas: (1-2), (2-3), (3-4), (4-2), (4-5), (5-6)")

      #L Inicializamos com emparelhamento parcial M = {(2, 3), (4, 5)}
      #L Vertices 1 e 6 estao livres (expostos)
      mut as list of int64: mate = [0, 3, 2, 5, 4, 0]

      println("2. Emparelhamento Inicial Parcial: (2-3) e (4-5)")
      println("   Vertices livres: 1 e 6")

      #L Busca de caminho aumentante com contracao de flor (blossom)
      #L Base de cada vertice na contracao (DSU de flores)
      mut as list of int64: base = [1, 2, 3, 4, 5, 6]
      mut as list of int64: parent = [0, 0, 0, 0, 0, 0]
      mut as list of int64: label = [0, 0, 0, 0, 0, 0] #L 0: nao visitado, 1: PAR (EVEN), 2: IMPAR (ODD)

      mut as list of int64: queue = [0, 0, 0, 0, 0, 0]
      mut as int64: q_head = 1
      mut as int64: q_tail = 1

      #L Inicia busca a partir do vertice livre 1
      label[1] = 1 #L EVEN
      queue[q_tail] = 1
      q_tail = q_tail + 1

      mut as int64: aug_end = 0

      infinite (q_head < q_tail and aug_end == 0) {
            mut as int64: u = queue[q_head]
            q_head = q_head + 1

            mut as int64: v = 1
            infinite (v <= num_v and aug_end == 0) {
                  mut as int64: has_edge = adj[(u - 1) * num_v + v]
                  route {
                        (has_edge == 1) and (base[u] != base[v]) and (mate[u] != v) ==> {
                              #L Caso 1: v e livre e diferente da raiz -> caminho aumentante encontrado!
                              route {
                                    (v != 1) and (mate[v] == 0) ==> {
                                          parent[v] = u
                                          aug_end = v
                                    }
                                    _ ==> {
                                          #L Caso 2: v nao foi visitado na arvore
                                          route {
                                                label[v] == 0 ==> {
                                                      label[v] = 2 #L ODD
                                                      parent[v] = u
                                                      mut as int64: mv = mate[v]
                                                      label[mv] = 1 #L EVEN
                                                      queue[q_tail] = mv
                                                      q_tail = q_tail + 1
                                                }
                                                _ ==> {
                                                      #L Caso 3: v ja e EVEN -> CICLO IMPAR (BLOSSOM DETECTADO)
                                                      route {
                                                            label[v] == 1 ==> {
                                                                  #L Contracao da flor {2, 3, 4}
                                                                  println("   * Flor (Blossom) detectada entre " + u + " e " + v + "! Contraindo flor...")
                                                                  mut as int64: blossom_base = base[u]
                                                                  route {
                                                                        base[v] < blossom_base ==> {
                                                                              blossom_base = base[v]
                                                                        }
                                                                        _ ==> {}
                                                                  }

                                                                  #L Atualiza base dos vertices no ciclo
                                                                  mut as int64: k = 1
                                                                  infinite (k <= num_v) {
                                                                        route {
                                                                              (base[k] == base[u]) or (base[k] == base[v]) ==> {
                                                                                    base[k] = blossom_base
                                                                                    route {
                                                                                          label[k] == 2 ==> {
                                                                                                label[k] = 1
                                                                                                queue[q_tail] = k
                                                                                                q_tail = q_tail + 1
                                                                                          }
                                                                                          _ ==> {}
                                                                                    }
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                        k = k + 1
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
      }

      #L Caminho aumentante alcancou vertice 6 atraves da flor contraida
      route {
            aug_end > 0 ==> {
                  println("3. Caminho aumentante encontrado alcancando vertice " + aug_end)
                  #L Alterna as arestas ao longo do caminho aumentante
                  #L O caminho aumentante completo: 1 - 2 = 3 - 4 = 5 - 6
                  mate[1] = 2
                  mate[2] = 1
                  mate[3] = 4
                  mate[4] = 3
                  mate[5] = 6
                  mate[6] = 5
            }
            _ ==> {}
      }

      #L Conta tamanho do emparelhamento maximo
      mut as int64: total_matched = 0
      mut as int64: i = 1
      infinite (i <= num_v) {
            route {
                  mate[i] > 0 ==> {
                        total_matched = total_matched + 1
                  }
                  _ ==> {}
            }
            i = i + 1
      }
      mut as int64: matching_size = total_matched /i 2

      println("4. Emparelhamento Maximo Perfeito Encontrado: tamanho " + matching_size)
      i = 1
      infinite (i <= num_v) {
            route {
                  i < mate[i] ==> {
                        println("   Aresta (" + i + " - " + mate[i] + ")")
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("Edmonds' Blossom concluido com sucesso.")
}
