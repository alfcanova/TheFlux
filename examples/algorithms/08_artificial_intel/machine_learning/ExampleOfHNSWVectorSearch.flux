#L ============================================================================
#L Algoritmo: HNSW (Hierarchical Navigable Small World) Vector Search
#L Domínio: 08_artificial_intel / Categoria: Busca Vetorial e Nearest Neighbors
#L Complexidade: O(log N) por consulta K-NN em grafos de proximidade multicamadas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (distSq) (as int64: x1, as int64: y1, as int64: z1, as int64: x2, as int64: y2, as int64: z2) as int64 {
      mut as int64: dx = x1 - x2
      mut as int64: dy = y1 - y2
      mut as int64: dz = z1 - z2
      mut as int64: res = (dx * dx) + (dy * dy) + (dz * dz)
      emit(nice, res, "ok")
}

program (ExampleOfHNSWVectorSearch) {
      println("==================================================")
      println("  SciAlgo: HNSW Hierarchical Vector Search")
      println("==================================================")

      #L Base vetorial em 3 dimensoes (8 vetores)
      mut as int64: n = 8
      mut as list of int64: vx = [10, 12, 50, 52, 90, 88, 15, 55]
      mut as list of int64: vy = [10, 11, 50, 49, 90, 92, 12, 52]
      mut as list of int64: vz = [10, 10, 50, 51, 90, 91, 14, 48]

      #L Vetor de consulta Q
      mut as int64: qx = 11
      mut as int64: qy = 10
      mut as int64: qz = 9

      #L Inicializa grafos de adjacencia das 3 camadas (8x8 = 64 posicoes cada)
      mut as list of int64: adj2 = []
      mut as list of int64: adj1 = []
      mut as list of int64: adj0 = []
      mut as int64: cell_idx = 1
      infinite (cell_idx <= 64) {
            adj2 = listPushBack(adj2, 0)
            adj1 = listPushBack(adj1, 0)
            adj0 = listPushBack(adj0, 0)
            cell_idx = cell_idx + 1
      }

      #L Camada 2 (topo, esparsa para saltos longos): aresta 1 <-> 5
      adj2[(1 - 1) * n + 5] = 1
      adj2[(5 - 1) * n + 1] = 1

      #L Camada 1 (intermediaria): arestas 1 <-> 3, 3 <-> 5
      adj1[(1 - 1) * n + 3] = 1
      adj1[(3 - 1) * n + 1] = 1
      adj1[(3 - 1) * n + 5] = 1
      adj1[(5 - 1) * n + 3] = 1

      #L Camada 0 (base densa, todos os vizinhos locais):
      #L Cluster 1: 1-2, 1-7, 2-7
      adj0[(1 - 1) * n + 2] = 1
      adj0[(2 - 1) * n + 1] = 1
      adj0[(1 - 1) * n + 7] = 1
      adj0[(7 - 1) * n + 1] = 1
      adj0[(2 - 1) * n + 7] = 1
      adj0[(7 - 1) * n + 2] = 1

      #L Cluster 2: 3-4, 3-8, 4-8
      adj0[(3 - 1) * n + 4] = 1
      adj0[(4 - 1) * n + 3] = 1
      adj0[(3 - 1) * n + 8] = 1
      adj0[(8 - 1) * n + 3] = 1
      adj0[(4 - 1) * n + 8] = 1
      adj0[(8 - 1) * n + 4] = 1

      #L Cluster 3: 5-6
      adj0[(5 - 1) * n + 6] = 1
      adj0[(6 - 1) * n + 5] = 1

      #L Pontes entre clusters: 1-3, 3-5
      adj0[(1 - 1) * n + 3] = 1
      adj0[(3 - 1) * n + 1] = 1
      adj0[(3 - 1) * n + 5] = 1
      adj0[(5 - 1) * n + 3] = 1

      #L ----------------------------------------------------
      #L Busca Gulosa no HNSW: Ponto de entrada ep = 5 no Layer 2
      #L ----------------------------------------------------
      mut as int64: curr = 5
      mut as int64: curr_d = distSq(vx[curr], vy[curr], vz[curr], qx, qy, qz)

      #L 1. Roteamento guloso na Camada 2
      mut as bool: mudou = true
      infinite (mudou) {
            mudou = false
            mut as int64: cand = 1
            infinite (cand <= n) {
                  route {
                        adj2[(curr - 1) * n + cand] == 1 ==> {
                              mut as int64: d_cand = distSq(vx[cand], vy[cand], vz[cand], qx, qy, qz)
                              route {
                                    d_cand < curr_d ==> {
                                          curr = cand
                                          curr_d = d_cand
                                          mudou = true
                                    }
                              }
                        }
                  }
                  cand = cand + 1
            }
      }
      println("1. Roteamento Camada 2 convergiu no no: " + curr)

      #L 2. Roteamento guloso na Camada 1 descendo de curr
      mudou = true
      infinite (mudou) {
            mudou = false
            mut as int64: cand = 1
            infinite (cand <= n) {
                  route {
                        adj1[(curr - 1) * n + cand] == 1 ==> {
                              mut as int64: d_cand = distSq(vx[cand], vy[cand], vz[cand], qx, qy, qz)
                              route {
                                    d_cand < curr_d ==> {
                                          curr = cand
                                          curr_d = d_cand
                                          mudou = true
                                    }
                              }
                        }
                  }
                  cand = cand + 1
            }
      }
      println("2. Roteamento Camada 1 convergiu no no: " + curr)

      #L 3. Busca em Feixe (Beam Search) na Camada 0
      mut as list of int64: visited = [0, 0, 0, 0, 0, 0, 0, 0]
      visited[curr] = 1

      mut as list of int64: cand_nodes = [curr]
      mut as list of int64: cand_dists = [curr_d]

      #L Lista de resultados (nos visitados e suas distancias)
      mut as list of int64: res_nodes = [curr]
      mut as list of int64: res_dists = [curr_d]

      infinite (listLength(cand_nodes) > 0) {
            #L Encontra candidato mais proximo da consulta
            mut as int64: best_idx = 1
            mut as int64: min_cd = cand_dists[1]
            mut as int64: ci = 2
            mut as int64: num_cand = listLength(cand_nodes)
            infinite (ci <= num_cand) {
                  route {
                        cand_dists[ci] < min_cd ==> {
                              min_cd = cand_dists[ci]
                              best_idx = ci
                        }
                  }
                  ci = ci + 1
            }

            mut as int64: c_node = cand_nodes[best_idx]

            #L Remove candidato selecionado
            mut as list of int64: new_cn = []
            mut as list of int64: new_cd = []
            mut as int64: ri = 1
            infinite (ri <= num_cand) {
                  route {
                        ri != best_idx ==> {
                              new_cn = listPushBack(new_cn, cand_nodes[ri])
                              new_cd = listPushBack(new_cd, cand_dists[ri])
                        }
                  }
                  ri = ri + 1
            }
            cand_nodes = new_cn
            cand_dists = new_cd

            #L Explora vizinhos no Layer 0
            mut as int64: nxt = 1
            infinite (nxt <= n) {
                  route {
                        adj0[(c_node - 1) * n + nxt] == 1 ==> {
                              route {
                                    visited[nxt] == 0 ==> {
                                          visited[nxt] = 1
                                          mut as int64: d_nxt = distSq(vx[nxt], vy[nxt], vz[nxt], qx, qy, qz)
                                          cand_nodes = listPushBack(cand_nodes, nxt)
                                          cand_dists = listPushBack(cand_dists, d_nxt)
                                          res_nodes = listPushBack(res_nodes, nxt)
                                          res_dists = listPushBack(res_dists, d_nxt)
                                    }
                              }
                        }
                  }
                  nxt = nxt + 1
            }
      }

      #L Ordena resultados por distancia (Bubble Sort simples)
      mut as int64: total_res = listLength(res_nodes)
      mut as int64: a = 1
      infinite (a <= total_res) {
            mut as int64: b = 1
            infinite (b < total_res) {
                  route {
                        res_dists[b] > res_dists[b + 1] ==> {
                              mut as int64: td = res_dists[b]
                              res_dists[b] = res_dists[b + 1]
                              res_dists[b + 1] = td

                              mut as int64: tn = res_nodes[b]
                              res_nodes[b] = res_nodes[b + 1]
                              res_nodes[b + 1] = tn
                        }
                  }
                  b = b + 1
            }
            a = a + 1
      }

      mut as int64: top1 = res_nodes[1]
      mut as int64: top2 = res_nodes[2]
      println("3. Vizinhos Mais Proximos (K-NN com K=2): [" + top1 + ", " + top2 + "]")
      println("4. Distancias ao quadrado correspondentes: [" + res_dists[1] + ", " + res_dists[2] + "]")

      #L 4. Validacao com Forca Bruta (Varredura Linear Exata)
      mut as int64: exact_best = 1
      mut as int64: exact_min_d = distSq(vx[1], vy[1], vz[1], qx, qy, qz)
      mut as int64: vi = 2
      infinite (vi <= n) {
            mut as int64: d_i = distSq(vx[vi], vy[vi], vz[vi], qx, qy, qz)
            route {
                  d_i < exact_min_d ==> {
                        exact_min_d = d_i
                        exact_best = vi
                  }
            }
            vi = vi + 1
      }

      mut as bool: match_exact = (top1 == exact_best) and (res_dists[1] == exact_min_d)
      println("5. Verificacao de exatidao contra Forca Bruta: " + match_exact)
      println("==================================================")
}
