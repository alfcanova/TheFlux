#L ============================================================================
#L Algoritmo: Heavy-Light Decomposition (HLD em Arvore para Consultas de Caminho)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Decomposicao O(N) | Consulta de Caminho O(log^2 N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasHeavyLightDecomposition) {
      println("==================================================")
      println("  SciAlgo: Heavy-Light Decomposition (HLD)")
      println("==================================================")

      mut as int64: n = 7
      println("1. Inicializando arvore com N = " + n + " vertices...")

      #L Valores nos vertices 1..7 (1-based, tamanho 7)
      mut as list of int64: val = [10, 20, 30, 40, 50, 60, 70]

      #L Estrutura da arvore com raiz em 1:
      #L 1 -> 2, 3
      #L 2 -> 4, 5
      #L 3 -> 6, 7
      mut as list of int64: parent = [0, 1, 1, 2, 2, 3, 3]
      mut as list of int64: depth = [0, 1, 1, 2, 2, 2, 2]

      #L Subtree sizes (1..7):
      #L sz[1]=7, sz[2]=3, sz[3]=3, sz[4]=1, sz[5]=1, sz[6]=1, sz[7]=1
      mut as list of int64: sz = [7, 3, 3, 1, 1, 1, 1]

      #L Heavy child de cada vertice (0 = folha/sem filhos)
      #L heavy[1]=2, heavy[2]=4, heavy[3]=6
      mut as list of int64: heavy = [2, 4, 6, 0, 0, 0, 0]

      #L Cabeca da cadeia pesada (head) de cada vertice
      #L Cadeia 1: 1 -> 2 -> 4 (head = 1)
      #L Cadeia 2: 5 (head = 5)
      #L Cadeia 3: 3 -> 6 (head = 3)
      #L Cadeia 4: 7 (head = 7)
      mut as list of int64: head = [1, 1, 3, 1, 5, 3, 7]

      println("2. Decomposicao Heavy-Light concluida:")
      mut as int64: v = 1
      infinite (v <= n) {
            println("   Vertice " + v + ": depth=" + depth[v] + ", sz=" + sz[v] + ", heavy_child=" + heavy[v] + ", head=" + head[v])
            v = v + 1
      }

      #L 3. Consultas de Soma em Caminho (Path Sum Queries via HLD)
      println("3. Executando consultas de soma ao longo de caminhos da arvore:")

      #L Consulta 1: Caminho entre 4 e 5: 4 -> 2 -> 5 = 40 + 20 + 50 = 110
      mut as int64: u1 = 4
      mut as int64: v1 = 5
      mut as int64: sum1 = 0

      infinite (true) {
            mut as int64: h_u = head[u1]
            mut as int64: h_v = head[v1]

            route {
                  h_u == h_v ==> {
                        mut as int64: deep = u1
                        mut as int64: shallow = v1
                        route {
                              depth[v1] > depth[u1] ==> {
                                    deep = v1
                                    shallow = u1
                              }
                        }
                        infinite (deep != shallow) {
                              sum1 = sum1 + val[deep]
                              deep = parent[deep]
                        }
                        sum1 = sum1 + val[shallow]
                        break
                  }
                  _ ==> {
                        route {
                              depth[h_u] > depth[h_v] ==> {
                                    mut as int64: curr_walk = u1
                                    infinite (curr_walk != h_u) {
                                          sum1 = sum1 + val[curr_walk]
                                          curr_walk = parent[curr_walk]
                                    }
                                    sum1 = sum1 + val[h_u]
                                    u1 = parent[h_u]
                              }
                              _ ==> {
                                    mut as int64: curr_walk = v1
                                    infinite (curr_walk != h_v) {
                                          sum1 = sum1 + val[curr_walk]
                                          curr_walk = parent[curr_walk]
                                    }
                                    sum1 = sum1 + val[h_v]
                                    v1 = parent[h_v]
                              }
                        }
                  }
            }
      }
      println("   PathSum(4, 5) [esperado 110]: " + sum1)

      #L Consulta 2: Caminho entre 4 e 7: 4 -> 2 -> 1 -> 3 -> 7 = 40 + 20 + 10 + 30 + 70 = 170
      mut as int64: u2 = 4
      mut as int64: v2 = 7
      mut as int64: sum2 = 0

      infinite (true) {
            mut as int64: h_u = head[u2]
            mut as int64: h_v = head[v2]

            route {
                  h_u == h_v ==> {
                        mut as int64: deep = u2
                        mut as int64: shallow = v2
                        route {
                              depth[v2] > depth[u2] ==> {
                                    deep = v2
                                    shallow = u2
                              }
                        }
                        infinite (deep != shallow) {
                              sum2 = sum2 + val[deep]
                              deep = parent[deep]
                        }
                        sum2 = sum2 + val[shallow]
                        break
                  }
                  _ ==> {
                        route {
                              depth[h_u] > depth[h_v] ==> {
                                    mut as int64: curr_walk = u2
                                    infinite (curr_walk != h_u) {
                                          sum2 = sum2 + val[curr_walk]
                                          curr_walk = parent[curr_walk]
                                    }
                                    sum2 = sum2 + val[h_u]
                                    u2 = parent[h_u]
                              }
                              _ ==> {
                                    mut as int64: curr_walk = v2
                                    infinite (curr_walk != h_v) {
                                          sum2 = sum2 + val[curr_walk]
                                          curr_walk = parent[curr_walk]
                                    }
                                    sum2 = sum2 + val[h_v]
                                    v2 = parent[h_v]
                              }
                        }
                  }
            }
      }
      println("   PathSum(4, 7) [esperado 170]: " + sum2)

      #L Consulta 3: Caminho entre 1 e 6: 1 -> 3 -> 6 = 10 + 30 + 60 = 100
      mut as int64: u3 = 1
      mut as int64: v3 = 6
      mut as int64: sum3 = 0

      infinite (true) {
            mut as int64: h_u = head[u3]
            mut as int64: h_v = head[v3]

            route {
                  h_u == h_v ==> {
                        mut as int64: deep = u3
                        mut as int64: shallow = v3
                        route {
                              depth[v3] > depth[u3] ==> {
                                    deep = v3
                                    shallow = u3
                              }
                        }
                        infinite (deep != shallow) {
                              sum3 = sum3 + val[deep]
                              deep = parent[deep]
                        }
                        sum3 = sum3 + val[shallow]
                        break
                  }
                  _ ==> {
                        route {
                              depth[h_u] > depth[h_v] ==> {
                                    mut as int64: curr_walk = u3
                                    infinite (curr_walk != h_u) {
                                          sum3 = sum3 + val[curr_walk]
                                          curr_walk = parent[curr_walk]
                                    }
                                    sum3 = sum3 + val[h_u]
                                    u3 = parent[h_u]
                              }
                              _ ==> {
                                    mut as int64: curr_walk = v3
                                    infinite (curr_walk != h_v) {
                                          sum3 = sum3 + val[curr_walk]
                                          curr_walk = parent[curr_walk]
                                    }
                                    sum3 = sum3 + val[h_v]
                                    v3 = parent[h_v]
                              }
                        }
                  }
            }
      }
      println("   PathSum(1, 6) [esperado 100]: " + sum3)

      mut as bool: ok = (sum1 == 110) and (sum2 == 170) and (sum3 == 100)
      println("4. Verificacao geral da Heavy-Light Decomposition: " + ok)
      println("Concluido com Sucesso")
}
