#L ============================================================================
#L Algoritmo: Kosaraju (Componentes Fortemente Conexos em Duas Passagens)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeKosaraju) {
      println("==================================================")
      println("  SciAlgo: Kosaraju's SCC Algorithm               ")
      println("==================================================")

      mut as int64: num_v = 5

      #L Grafo direcionado:
      #L 1->2, 2->3, 3->1 (SCC {1, 2, 3})
      #L 3->4
      #L 4->5, 5->4 (SCC {4, 5})
      mut as list of int64: adj = [
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            1, 0, 0, 1, 0,
            0, 0, 0, 0, 1,
            0, 0, 0, 1, 0
      ]

      #L Grafo transposto (adj_t) com arestas invertidas
      mut as list of int64: adj_t = [
            0, 0, 1, 0, 0,
            1, 0, 0, 0, 0,
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 1,
            0, 0, 0, 1, 0
      ]

      println("1. Grafo Direcionado com 5 Vertices (Kosaraju)")

      #L PASSAGEM 1: Ordenacao pelo tempo de finalizacao no grafo original
      mut as list of bool: vis1 = [false, false, false, false, false]
      mut as list of int64: finish_stack = [0, 0, 0, 0, 0]
      mut as int64: f_top = 0

      #L Executa busca para preencher finish_stack
      #L Ordem de finalizacao: para cada no nao visitado, simula DFS
      mut as list of int64: dfs_stk = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: st_top = 0

      mut as int64: start_v = 1
      mut as int64: curr = 0
      mut as int64: v = 1
      mut as int64: i = 1

      infinite (start_v <= num_v) {
            route {
                  not vis1[start_v] ==> {
                        st_top = st_top + 1
                        dfs_stk[st_top] = start_v
                        vis1[start_v] = true

                        infinite (st_top > 0) {
                              curr = dfs_stk[st_top]
                              #L Procura proximo vizinho nao visitado
                              mut as int64: nxt = 0
                              v = 1
                              infinite (v <= num_v and nxt == 0) {
                                    route {
                                          (adj[(curr - 1) * num_v + v] == 1) and (not vis1[v]) ==> {
                                                nxt = v
                                          }
                                          _ ==> {}
                                    }
                                    v = v + 1
                              }

                              route {
                                    nxt > 0 ==> {
                                          vis1[nxt] = true
                                          st_top = st_top + 1
                                          dfs_stk[st_top] = nxt
                                    }
                                    _ ==> {
                                          #L Todos os vizinhos visitados: desempilha e adiciona ao finish_stack
                                          st_top = st_top - 1
                                          f_top = f_top + 1
                                          finish_stack[f_top] = curr
                                    }
                              }
                        }
                  }
                  _ ==> {}
            }
            start_v = start_v + 1
      }

      println("2. Passagem 1: Ordem de Finalizacao = [" + finish_stack[1] + ", " + finish_stack[2] + ", " + finish_stack[3] + ", " + finish_stack[4] + ", " + finish_stack[5] + "]")

      #L PASSAGEM 2: DFS no grafo transposto pela ordem decrescente de finalizacao
      mut as list of bool: vis2 = [false, false, false, false, false]
      mut as list of int64: scc_label = [0, 0, 0, 0, 0]
      mut as int64: scc_count = 0

      mut as int64: pos = num_v
      infinite (pos >= 1) {
            mut as int64: root = finish_stack[pos]
            route {
                  not vis2[root] ==> {
                        scc_count = scc_count + 1
                        #L BFS/DFS no grafo transposto a partir de root
                        st_top = 1
                        dfs_stk[st_top] = root
                        vis2[root] = true
                        scc_label[root] = scc_count

                        infinite (st_top > 0) {
                              curr = dfs_stk[st_top]
                              st_top = st_top - 1

                              v = 1
                              infinite (v <= num_v) {
                                    route {
                                          (adj_t[(curr - 1) * num_v + v] == 1) and (not vis2[v]) ==> {
                                                vis2[v] = true
                                                scc_label[v] = scc_count
                                                st_top = st_top + 1
                                                dfs_stk[st_top] = v
                                          }
                                          _ ==> {}
                                    }
                                    v = v + 1
                              }
                        }
                  }
                  _ ==> {}
            }
            pos = pos - 1
      }

      println("3. Total de SCCs via Kosaraju: " + scc_count)
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + " -> SCC #" + scc_label[i])
            i = i + 1
      }

      println("Kosaraju concluido com sucesso.")
}
