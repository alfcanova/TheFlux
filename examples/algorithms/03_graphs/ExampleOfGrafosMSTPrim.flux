#L ============================================================================
#L Algoritmo: Prim (Arvore Geradora Minima a partir de Vertice Raiz)
#L Dominio: 03_graphs / Categoria: 8. Arvores geradoras minimas
#L Complexidade: O(V^2) / O(E log V) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosMSTPrim) {
      println("==================================================")
      println("  SciAlgo: Prim (Arvore Geradora Minima - MST)    ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: inf_weight = 999999

      #L Matriz de adjacencia 6x6 (linearizada em tamanho 36)
      mut as list of int64: adj = []
      mut as int64: c = 1
      infinite (c <= num_v * num_v) {
            adj = listPushBack(adj, inf_weight)
            c = c + 1
      }

      #L Arestas bidirecionais:
      #L (1-2: 4), (1-3: 2), (2-3: 1), (2-4: 5), (3-4: 8), (3-5: 10), (4-5: 2), (4-6: 6), (5-6: 3)
      adj[(1 - 1) * num_v + 2] = 4
      adj[(2 - 1) * num_v + 1] = 4

      adj[(1 - 1) * num_v + 3] = 2
      adj[(3 - 1) * num_v + 1] = 2

      adj[(2 - 1) * num_v + 3] = 1
      adj[(3 - 1) * num_v + 2] = 1

      adj[(2 - 1) * num_v + 4] = 5
      adj[(4 - 1) * num_v + 2] = 5

      adj[(3 - 1) * num_v + 4] = 8
      adj[(4 - 1) * num_v + 3] = 8

      adj[(3 - 1) * num_v + 5] = 10
      adj[(5 - 1) * num_v + 3] = 10

      adj[(4 - 1) * num_v + 5] = 2
      adj[(5 - 1) * num_v + 4] = 2

      adj[(4 - 1) * num_v + 6] = 6
      adj[(6 - 1) * num_v + 4] = 6

      adj[(5 - 1) * num_v + 6] = 3
      adj[(6 - 1) * num_v + 5] = 3

      println("1. Grafo com " + num_v + " vertices inicializado na matriz de pesos.")

      #L Vetores do algoritmo de Prim:
      #L key[v]: menor custo de aresta conectando v a MST atual
      #L parent[v]: vertice da MST que alcanca v com esse menor custo
      #L in_mst[v]: se o vertice ja foi incluido na MST
      mut as list of int64: key = [inf_weight, inf_weight, inf_weight, inf_weight, inf_weight, inf_weight]
      mut as list of int64: parent = [0, 0, 0, 0, 0, 0]
      mut as list of bool: in_mst = [false, false, false, false, false, false]

      #L Vertice inicial: 1
      key[1] = 0

      println("2. Executando Algoritmo de Prim a partir do vertice raiz 1...")

      mut as int64: step = 1
      infinite (step <= num_v) {
            #L Seleciona o vertice com menor key que ainda nao esta na MST
            mut as int64: u = 0
            mut as int64: min_k = inf_weight
            mut as int64: vi = 1
            infinite (vi <= num_v) {
                  route {
                        (not in_mst[vi]) and (key[vi] < min_k) ==> {
                              min_k = key[vi]
                              u = vi
                        }
                        _ ==> {}
                  }
                  vi = vi + 1
            }

            route {
                  u == 0 ==> {
                        break #L Grafo desconexo
                  }
                  _ ==> {}
            }

            #L Adiciona u a MST
            in_mst[u] = true

            #L Relaxa arestas para todos os vizinhos de u
            mut as int64: v = 1
            infinite (v <= num_v) {
                  mut as int64: w_uv = adj[(u - 1) * num_v + v]
                  route {
                        (not in_mst[v]) and (w_uv < inf_weight) ==> {
                              route {
                                    w_uv < key[v] ==> {
                                          key[v] = w_uv
                                          parent[v] = u
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }

            step = step + 1
      }

      #L Coleta resultados e calcula o peso total da MST
      mut as int64: total_mst_weight = 0
      mut as list of int64: mst_edges_u = []
      mut as list of int64: mst_edges_v = []
      mut as list of int64: mst_weights = []

      mut as int64: node = 2
      infinite (node <= num_v) {
            mut as int64: p = parent[node]
            mut as int64: w = key[node]
            total_mst_weight = total_mst_weight + w
            mst_edges_u = listPushBack(mst_edges_u, p)
            mst_edges_v = listPushBack(mst_edges_v, node)
            mst_weights = listPushBack(mst_weights, w)
            node = node + 1
      }

      println("3. Resultado da MST de Prim:")
      println("   Extremos U: " + mst_edges_u)
      println("   Extremos V: " + mst_edges_v)
      println("   Pesos: " + mst_weights)
      println("   Numero de arestas na MST: " + listLength(mst_edges_u) + " / " + (num_v - 1))
      println("   Peso Total da MST: " + total_mst_weight)

      #L Verificacao de corretude
      mut as bool: valid_count = listLength(mst_edges_u) == (num_v - 1)
      mut as bool: valid_weight = total_mst_weight == 13
      mut as bool: prim_ok = valid_count and valid_weight
      println("4. Verificacao da MST de Prim: " + prim_ok)

      println("Concluido com Sucesso")
}
