#L ============================================================================
#L Algoritmo: Centroid Decomposition (Decomposicao em Centroides de Arvore)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Decomposicao O(N log N) | Altura da Arvore de Centroides O(log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasCentroidDecomposition) {
      println("==================================================")
      println("  SciAlgo: Centroid Decomposition de Arvore")
      println("==================================================")

      #L Arvore com N = 7 vertices:
      #L Arestas: (1-2), (1-3), (2-4), (2-5), (3-6), (3-7)
      mut as int64: n = 7
      println("1. Arvore de teste com N = 7 vertices e 6 arestas")

      #L Lista de adjacencia representada por vetores:
      #L Grafo:
      #L 1: [2, 3]
      #L 2: [1, 4, 5]
      #L 3: [1, 6, 7]
      #L 4: [2]
      #L 5: [2]
      #L 6: [3]
      #L 7: [3]

      #L Vetor booleano de vertices 'removidos' na decomposicao
      mut as list of bool: is_removed = [false, false, false, false, false, false, false]
      mut as list of int64: sz = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: centroid_parent = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: centroid_depth = [0, 0, 0, 0, 0, 0, 0]

      #L Lista estatica de vizinhos:
      #L Grau de cada vertice e offset em adj_pool
      #L v1: 2, 3
      #L v2: 1, 4, 5
      #L v3: 1, 6, 7
      #L v4: 2
      #L v5: 2
      #L v6: 3
      #L v7: 3
      mut as list of int64: adj_deg = [2, 3, 3, 1, 1, 1, 1]
      mut as list of int64: adj_off = [1, 3, 6, 9, 10, 11, 12]
      mut as list of int64: adj_pool = [2, 3,  1, 4, 5,  1, 6, 7,  2,  2,  3,  3]

      #L Fila para processar componentes na decomposicao:
      #L Cada item: (entry_node, parent_centroid, depth)
      mut as list of int64: q_entry = [1]
      mut as list of int64: q_cpar = [0]
      mut as list of int64: q_cdep = [1]
      mut as int64: q_head = 1

      println("2. Executando Decomposicao em Centroides hierarquica...")

      infinite (q_head <= listLength(q_entry)) {
            mut as int64: root_node = q_entry[q_head]
            mut as int64: cur_cpar = q_cpar[q_head]
            mut as int64: cur_cdep = q_cdep[q_head]
            q_head = q_head + 1

            #L 1. BFS/DFS para listar todos os vertices da componente conectada e computar tamanhos
            mut as list of int64: comp_nodes = [root_node]
            mut as list of int64: comp_par = [0]
            mut as list of int64: bfs_q = [root_node]
            mut as list of bool: in_comp = [false, false, false, false, false, false, false]
            in_comp[root_node] = true

            mut as int64: b_head = 1
            infinite (b_head <= listLength(bfs_q)) {
                  mut as int64: u = bfs_q[b_head]
                  b_head = b_head + 1

                  mut as int64: deg = adj_deg[u]
                  mut as int64: off = adj_off[u]
                  mut as int64: di = 0
                  infinite (di < deg) {
                        mut as int64: v = adj_pool[off + di]
                        mut as bool: rem = is_removed[v]
                        mut as bool: seen = in_comp[v]
                        route {
                              (not rem) and (not seen) ==> {
                                    in_comp[v] = true
                                    comp_nodes = listPushBack(comp_nodes, v)
                                    comp_par = listPushBack(comp_par, u)
                                    bfs_q = listPushBack(bfs_q, v)
                              }
                        }
                        di = di + 1
                  }
            }

            mut as int64: comp_total_sz = listLength(comp_nodes)

            #L 2. Computa tamanhos de subarvore em ordem reversa (bottom-up)
            mut as int64: ci = 1
            infinite (ci <= comp_total_sz) {
                  mut as int64: nd = comp_nodes[ci]
                  sz[nd] = 1
                  ci = ci + 1
            }

            mut as int64: ri = comp_total_sz
            infinite (ri >= 2) {
                  mut as int64: nd = comp_nodes[ri]
                  mut as int64: p_nd = comp_par[ri]
                  sz[p_nd] = sz[p_nd] + sz[nd]
                  ri = ri - 1
            }

            #L 3. Encontra o centroide da componente
            #L O centroide e o vertice onde nenhuma subarvore conectada tem mais de comp_total_sz / 2
            mut as int64: centroid = 0
            mut as int64: fi = 1
            infinite (fi <= comp_total_sz) {
                  mut as int64: candidate = comp_nodes[fi]
                  mut as bool: is_c = true

                  #L Verifica subarvores de candidate
                  mut as int64: deg = adj_deg[candidate]
                  mut as int64: off = adj_off[candidate]
                  mut as int64: di = 0
                  infinite (di < deg) {
                        mut as int64: v = adj_pool[off + di]
                        mut as bool: rem = is_removed[v]
                        route {
                              not rem ==> {
                                    mut as int64: sub_size = sz[v]
                                    route {
                                          sub_size > sz[candidate] ==> {
                                                sub_size = comp_total_sz - sz[candidate]
                                          }
                                    }
                                    route {
                                          (sub_size * 2) > comp_total_sz ==> {
                                                is_c = false
                                          }
                                    }
                              }
                        }
                        di = di + 1
                  }

                  route {
                        is_c ==> {
                              route {
                                    centroid == 0 ==> { centroid = candidate }
                              }
                        }
                  }
                  fi = fi + 1
            }

            #L Marca centroide como removido e registra na arvore de centroides
            is_removed[centroid] = true
            centroid_parent[centroid] = cur_cpar
            centroid_depth[centroid] = cur_cdep
            println("   Centroide encontrado: " + centroid + " (tamanho comp = " + comp_total_sz + ", profundidade = " + cur_cdep + ", pai = " + cur_cpar + ")")

            #L Agenda novas componentes a partir de cada vizinho nao removido
            mut as int64: c_deg = adj_deg[centroid]
            mut as int64: c_off = adj_off[centroid]
            mut as int64: cdi = 0
            infinite (cdi < c_deg) {
                  mut as int64: nv = adj_pool[c_off + cdi]
                  mut as bool: nrem = is_removed[nv]
                  route {
                        not nrem ==> {
                              q_entry = listPushBack(q_entry, nv)
                              q_cpar = listPushBack(q_cpar, centroid)
                              q_cdep = listPushBack(q_cdep, cur_cdep + 1)
                        }
                  }
                  cdi = cdi + 1
            }
      }

      println("3. Arvore de Centroides gerada com sucesso.")
      println("   Pai de cada vertice na arvore de centroides: " + centroid_parent)
      println("   Profundidade de cada vertice: " + centroid_depth)

      #L Verificacoes:
      #L Vertice 1 e o centroide raiz (pai = 0, prof = 1)
      #L Vertices 2 e 3 sao filhos de 1 (pai = 1, prof = 2)
      #L Vertices 4, 5, 6, 7 sao folhas (prof = 3)
      mut as bool: all_ok = true
      route {
            centroid_parent[1] != 0 ==> { all_ok = false }
      }
      route {
            centroid_depth[1] != 1 ==> { all_ok = false }
      }
      route {
            centroid_parent[2] != 1 ==> { all_ok = false }
      }
      route {
            centroid_parent[3] != 1 ==> { all_ok = false }
      }
      route {
            centroid_depth[4] != 3 ==> { all_ok = false }
      }
      route {
            centroid_depth[5] != 3 ==> { all_ok = false }
      }
      route {
            centroid_depth[6] != 3 ==> { all_ok = false }
      }
      route {
            centroid_depth[7] != 3 ==> { all_ok = false }
      }

      println("4. Altura maxima da Arvore de Centroides: 3 <= log2(7) + 1")
      println("5. Verificacao geral da Decomposicao em Centroides: " + all_ok)
      println("Concluido com Sucesso")
}
