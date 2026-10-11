#L ============================================================================
#L Algoritmo: Bipartite Graph Test (Teste de Biparticao / 2-Coloracao)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeBipartiteGraphTest) {
      println("==================================================")
      println("  SciAlgo: Bipartite Graph Test (2-Colorability)   ")
      println("==================================================")

      mut as int64: num_v = 4

      #L Grafo bipartido: ciclo par 1-2-3-4-1
      #L Arestas: (1-2), (2-3), (3-4), (4-1)
      mut as list of int64: adj = [
            0, 1, 0, 1,
            1, 0, 1, 0,
            0, 1, 0, 1,
            1, 0, 1, 0
      ]

      println("1. Grafo com 4 Vertices em Ciclo Par:")
      println("   Arestas: (1-2), (2-3), (3-4), (4-1)")

      #L Cores: 0: Sem cor, 1: Cor A, 2: Cor B
      mut as list of int64: color = [0, 0, 0, 0]
      mut as bool: is_bipartite = true

      #L Fila BFS para coloracao em 2 cores
      mut as list of int64: q = [0, 0, 0, 0, 0, 0]
      mut as int64: head = 1
      mut as int64: tail = 1

      mut as int64: start_v = 1
      mut as int64: curr = 0
      mut as int64: v = 1
      mut as int64: i = 1

      infinite (start_v <= num_v and is_bipartite) {
            route {
                  color[start_v] == 0 ==> {
                        color[start_v] = 1 #L Primeira cor
                        head = 1
                        tail = 1
                        q[tail] = start_v
                        tail = tail + 1

                        infinite (head < tail and is_bipartite) {
                              curr = q[head]
                              head = head + 1

                              v = 1
                              infinite (v <= num_v and is_bipartite) {
                                    route {
                                          adj[(curr - 1) * num_v + v] == 1 ==> {
                                                route {
                                                      color[v] == 0 ==> {
                                                            #L Atribui cor oposta (3 - cor_atual)
                                                            color[v] = 3 - color[curr]
                                                            q[tail] = v
                                                            tail = tail + 1
                                                      }
                                                      color[v] == color[curr] ==> {
                                                            #L Conflito de cores: contem ciclo impar!
                                                            is_bipartite = false
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    v = v + 1
                              }
                        }
                  }
                  _ ==> {}
            }
            start_v = start_v + 1
      }

      route {
            is_bipartite ==> {
                  println("2. Resultado: O grafo e BIPARTIDO (2-Colorivel)!")
                  println("   Particao A (Cor 1):")
                  i = 1
                  infinite (i <= num_v) {
                        route {
                              color[i] == 1 ==> {
                                    println("      Vertice " + i)
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }
                  println("   Particao B (Cor 2):")
                  i = 1
                  infinite (i <= num_v) {
                        route {
                              color[i] == 2 ==> {
                                    println("      Vertice " + i)
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }
            }
            _ ==> {
                  println("2. Resultado: O grafo NAO e bipartido (possui ciclo impar).")
            }
      }

      println("Bipartite Graph Test concluido com sucesso.")
}
