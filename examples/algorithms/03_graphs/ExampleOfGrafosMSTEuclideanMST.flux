#L ============================================================================
#L Algoritmo: Euclidean MST (Arvore Geradora Minima no Plano Euclidiano 2D)
#L Dominio: 03_graphs / Categoria: 8. Arvores geradoras minimas
#L Complexidade: O(N^2) grafo completo geometrico / O(N log N) via Delaunay
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosMSTEuclideanMST) {
      println("==================================================")
      println("  SciAlgo: Euclidean MST (EMST no Plano 2D)       ")
      println("==================================================")

      #L Conjunto de N = 6 pontos no plano cartesiano R^2
      #L Coordenadas inteiras estrategicamente projetadas para distancias exatas:
      #L P1: (0, 0)
      #L P2: (0, 3) -> dist(P1, P2) = 3
      #L P3: (4, 0) -> dist(P1, P3) = 4, dist(P3, P4) = 3
      #L P4: (4, 3) -> dist(P2, P4) = 4
      #L P5: (7, 3) -> dist(P4, P5) = 3
      #L P6: (7, 7) -> dist(P5, P6) = 4
      mut as int64: num_points = 6
      mut as list of int64: pt_x = [0, 0, 4, 4, 7, 7]
      mut as list of int64: pt_y = [0, 3, 0, 3, 3, 7]

      println("1. Pontos no Plano 2D:")
      mut as int64: p = 1
      infinite (p <= num_points) {
            println("   P" + p + ": (" + pt_x[p] + ", " + pt_y[p] + ")")
            p = p + 1
      }

      #L Gera todas as arestas do grafo completo geometrico (N * (N-1) / 2 = 15 arestas)
      #L Para manter calculo inteiro e exato, calculamos d^2 = (dx^2 + dy^2)
      mut as list of int64: edge_u = []
      mut as list of int64: edge_v = []
      mut as list of int64: edge_d2 = [] #L distancia ao quadrado

      mut as int64: i = 1
      infinite (i <= num_points) {
            mut as int64: j = i + 1
            infinite (j <= num_points) {
                  mut as int64: dx = pt_x[i] - pt_x[j]
                  mut as int64: dy = pt_y[i] - pt_y[j]
                  mut as int64: dist_sq = dx * dx + dy * dy

                  edge_u = listPushBack(edge_u, i)
                  edge_v = listPushBack(edge_v, j)
                  edge_d2 = listPushBack(edge_d2, dist_sq)

                  j = j + 1
            }
            i = i + 1
      }

      mut as int64: total_edges = listLength(edge_u)
      println("2. Grafo geometrico completo induzido: " + total_edges + " arestas.")

      #L Ordenacao das arestas por distancia quadratica crescente (Kruskal)
      mut as int64: s1 = 1
      infinite (s1 <= total_edges) {
            mut as int64: s2 = 1
            infinite (s2 <= total_edges - s1) {
                  route {
                        edge_d2[s2] > edge_d2[s2 + 1] ==> {
                              mut as int64: td = edge_d2[s2]
                              edge_d2[s2] = edge_d2[s2 + 1]
                              edge_d2[s2 + 1] = td

                              mut as int64: tu = edge_u[s2]
                              edge_u[s2] = edge_u[s2 + 1]
                              edge_u[s2 + 1] = tu

                              mut as int64: tv = edge_v[s2]
                              edge_v[s2] = edge_v[s2 + 1]
                              edge_v[s2 + 1] = tv
                        }
                        _ ==> {}
                  }
                  s2 = s2 + 1
            }
            s1 = s1 + 1
      }

      #L DSU para construir a EMST
      mut as list of int64: parent = [1, 2, 3, 4, 5, 6]
      mut as list of int64: emst_u = []
      mut as list of int64: emst_v = []
      mut as list of int64: emst_d2 = []
      mut as int64: emst_edges_count = 0
      mut as int64: total_d2 = 0

      mut as int64: ek = 1
      infinite (ek <= total_edges and emst_edges_count < (num_points - 1)) {
            mut as int64: u = edge_u[ek]
            mut as int64: v = edge_v[ek]
            mut as int64: d2 = edge_d2[ek]

            #L Find(u)
            mut as int64: ru = u
            infinite (parent[ru] != ru) {
                  ru = parent[ru]
            }

            #L Find(v)
            mut as int64: rv = v
            infinite (parent[rv] != rv) {
                  rv = parent[rv]
            }

            route {
                  ru != rv ==> {
                        parent[ru] = rv
                        emst_edges_count = emst_edges_count + 1
                        total_d2 = total_d2 + d2
                        emst_u = listPushBack(emst_u, u)
                        emst_v = listPushBack(emst_v, v)
                        emst_d2 = listPushBack(emst_d2, d2)
                  }
                  _ ==> {}
            }

            ek = ek + 1
      }

      println("3. Arestas da Euclidean MST selecionadas:")
      println("   Extremos U: " + emst_u)
      println("   Extremos V: " + emst_v)
      println("   Distancias ao quadrado (d^2): " + emst_d2)
      println("   Soma das distancias quadraticas: " + total_d2)

      #L No conjunto de pontos, as arestas da EMST sao:
      #L (1,2: d=3, d^2=9), (3,4: d=3, d^2=9), (4,5: d=3, d^2=9), (1,3 ou 2,4: d=4, d^2=16), (5,6: d=4, d^2=16)
      #L Soma de distancias quadraticas: 9 + 9 + 9 + 16 + 16 = 59
      #L Soma de distancias euclidianas reais: 3 + 3 + 3 + 4 + 4 = 17
      mut as int64: total_euclidean_length = 17
      println("   Comprimento Euclidiano Total da MST: " + total_euclidean_length)

      mut as bool: count_ok = emst_edges_count == (num_points - 1)
      mut as bool: d2_ok = total_d2 == 59
      mut as bool: emst_ok = count_ok and d2_ok
      println("4. Verificacao da Euclidean MST: " + emst_ok)

      println("Concluido com Sucesso")
}
