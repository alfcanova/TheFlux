#L ============================================================================
#L Algoritmo: Dial's Algorithm (Dijkstra com Baldes / Bucket Implementation)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V * C + E) tempo | O(V * C) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosDial) {
      println("==================================================")
      println("  SciAlgo: Dial's Algorithm (Bucket Dijkstra)     ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: src = 1
      mut as int64: max_c = 5
      mut as int64: max_dist = 25 #L Limite superior de distancia (V * max_c)

      #L Matriz de pesos inteiros pequenos (1..5). -1 indica sem aresta
      mut as list of int64: weight = [
            -1,  4,  2, -1, -1,
            -1, -1,  1,  5, -1,
            -1, -1, -1,  3,  4,
            -1, -1, -1, -1,  2,
            -1, -1, -1, -1, -1
      ]

      println("1. Grafo com Pesos Inteiros Pequenos (C <= 5):")
      println("   Fonte: " + src)

      mut as list of int64: dist = [999999, 999999, 999999, 999999, 999999]
      dist[src] = 0

      #L Matriz de baldes: buckets[d, k] onde d varia de 0 a max_dist (26 baldes de capacidade 5)
      #L Representado linearmente: indice = d * num_v + slot (1..num_v)
      mut as list of int64: bucket_count = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0
      ]
      mut as list of int64: buckets = [
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0
      ]

      #L Insere fonte no balde 0
      bucket_count[1] = 1
      buckets[1] = src

      mut as list of bool: visited = [false, false, false, false, false]
      mut as int64: cur_b = 0

      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: w = 0
      mut as int64: slot = 0
      mut as int64: i = 1

      infinite (cur_b <= max_dist) {
            #L Enquanto houver vertices no balde cur_b
            infinite (bucket_count[cur_b + 1] > 0) {
                  slot = bucket_count[cur_b + 1]
                  bucket_count[cur_b + 1] = slot - 1
                  u = buckets[cur_b * num_v + slot]

                  route {
                        not visited[u] ==> {
                              visited[u] = true

                              #L Relaxa arestas saindo de u
                              v = 1
                              infinite (v <= num_v) {
                                    w = weight[(u - 1) * num_v + v]
                                    route {
                                          w >= 0 ==> {
                                                mut as int64: new_d = dist[u] + w
                                                route {
                                                      new_d < dist[v] ==> {
                                                            dist[v] = new_d
                                                            #L Insere v no balde new_d
                                                            mut as int64: cnt = bucket_count[new_d + 1] + 1
                                                            bucket_count[new_d + 1] = cnt
                                                            buckets[new_d * num_v + cnt] = v
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    v = v + 1
                              }
                        }
                        _ ==> {}
                  }
            }

            cur_b = cur_b + 1
      }

      println("2. Distancias Minimas Finais (Dial's Algorithm):")
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + ": distancia = " + dist[i])
            i = i + 1
      }

      println("Dial's Algorithm concluido com sucesso.")
}
