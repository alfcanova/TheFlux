#L ============================================================================
#L Algoritmo: Kruskal (Arvore Geradora Minima com DSU)
#L Dominio: 03_graphs / Categoria: 8. Arvores geradoras minimas
#L Complexidade: O(E log E) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosMSTKruskal) {
      println("==================================================")
      println("  SciAlgo: Kruskal (Arvore Geradora Minima - MST) ")
      println("==================================================")

      #L Grafo com V = 6 vertices (1..6) e E = 9 arestas
      mut as int64: num_v = 6
      mut as int64: num_e = 9

      #L Arestas originais (u, v, peso):
      mut as list of int64: edge_u = [1, 1, 2, 2, 3, 3, 4, 4, 5]
      mut as list of int64: edge_v = [2, 3, 3, 4, 4, 5, 5, 6, 6]
      mut as list of int64: edge_w = [4, 2, 1, 5, 8, 10, 2, 6, 3]

      println("1. Grafo de Entrada:")
      println("   Vertices: " + num_v + ", Arestas: " + num_e)
      println("   Arestas e pesos: [(1,2,4), (1,3,2), (2,3,1), (2,4,5), (3,4,8), (3,5,10), (4,5,2), (4,6,6), (5,6,3)]")

      #L Ordenacao das arestas por peso crescente (Bubble Sort nos vetores paralelos)
      mut as int64: i = 1
      infinite (i <= num_e) {
            mut as int64: j = 1
            infinite (j <= num_e - i) {
                  route {
                        edge_w[j] > edge_w[j + 1] ==> {
                              #L Troca pesos
                              mut as int64: tw = edge_w[j]
                              edge_w[j] = edge_w[j + 1]
                              edge_w[j + 1] = tw

                              #L Troca extremos u
                              mut as int64: tu = edge_u[j]
                              edge_u[j] = edge_u[j + 1]
                              edge_u[j + 1] = tu

                              #L Troca extremos v
                              mut as int64: tv = edge_v[j]
                              edge_v[j] = edge_v[j + 1]
                              edge_v[j + 1] = tv
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("2. Arestas ordenadas por peso:")
      println("   Pesos: " + edge_w)

      #L Inicializacao do Disjoint Set Union (DSU) com compressao de caminho
      mut as list of int64: parent = [0, 0, 0, 0, 0, 0]
      mut as list of int64: rank = [0, 0, 0, 0, 0, 0]
      mut as int64: vi = 1
      infinite (vi <= num_v) {
            parent[vi] = vi
            rank[vi] = 0
            vi = vi + 1
      }

      #L Execucao de Kruskal: adiciona arestas que nao formam ciclos
      mut as int64: mst_weight = 0
      mut as int64: mst_edges_count = 0
      mut as list of int64: mst_selected_u = []
      mut as list of int64: mst_selected_v = []
      mut as list of int64: mst_selected_w = []

      mut as int64: ei = 1
      infinite (ei <= num_e and mst_edges_count < (num_v - 1)) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            mut as int64: w = edge_w[ei]

            #L DSU Find(u) com compressao
            mut as int64: root_u = u
            infinite (parent[root_u] != root_u) {
                  root_u = parent[root_u]
            }
            #L Compressao de caminho para u
            mut as int64: curr_u = u
            infinite (curr_u != root_u) {
                  mut as int64: nxt_u = parent[curr_u]
                  parent[curr_u] = root_u
                  curr_u = nxt_u
            }

            #L DSU Find(v) com compressao
            mut as int64: root_v = v
            infinite (parent[root_v] != root_v) {
                  root_v = parent[root_v]
            }
            #L Compressao de caminho para v
            mut as int64: curr_v = v
            infinite (curr_v != root_v) {
                  mut as int64: nxt_v = parent[curr_v]
                  parent[curr_v] = root_v
                  curr_v = nxt_v
            }

            #L Se u e v pertencem a componentes distintas, unifica (Union)
            route {
                  root_u != root_v ==> {
                        #L Union by Rank
                        route {
                              rank[root_u] < rank[root_v] ==> {
                                    parent[root_u] = root_v
                              }
                              rank[root_u] > rank[root_v] ==> {
                                    parent[root_v] = root_u
                              }
                              _ ==> {
                                    parent[root_v] = root_u
                                    rank[root_u] = rank[root_u] + 1
                              }
                        }

                        mst_weight = mst_weight + w
                        mst_edges_count = mst_edges_count + 1
                        mst_selected_u = listPushBack(mst_selected_u, u)
                        mst_selected_v = listPushBack(mst_selected_v, v)
                        mst_selected_w = listPushBack(mst_selected_w, w)
                  }
                  _ ==> {}
            }

            ei = ei + 1
      }

      println("3. Resultado da MST de Kruskal:")
      println("   Arestas selecionadas (u): " + mst_selected_u)
      println("   Arestas selecionadas (v): " + mst_selected_v)
      println("   Pesos selecionados (w): " + mst_selected_w)
      println("   Numero de arestas na MST: " + mst_edges_count + " / " + (num_v - 1))
      println("   Peso Total da MST: " + mst_weight)

      #L Verificacao:
      #L A MST deve ter exatamente V - 1 = 5 arestas e peso total = 13
      mut as bool: valid_edges = mst_edges_count == (num_v - 1)
      mut as bool: valid_cost = mst_weight == 13
      mut as bool: kruskal_ok = valid_edges and valid_cost
      println("4. Verificacao da MST de Kruskal: " + kruskal_ok)

      println("Concluido com Sucesso")
}
