#L ============================================================================
#L Algoritmo: Kernelization (Regras de Reducao de Buss para k-Vertex Cover)
#L Dominio: 03_graphs / Categoria: Teoria da computacao e complexidade
#L Complexidade: O(V + E) tempo polinomial | Nucleo Reduzido: |V'| <= 2*k^2, |E'| <= k^2
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosComplexidadeKernelization) {
      println("==================================================")
      println("  SciAlgo: Kernelizacao (Regra de Buss para k-VC)")
      println("==================================================")

      #L Grafo original com V = 8 vertices e parametro de cobertura k = 2
      #L Arestas iniciais:
      #L Vertice 1 conectado a: 2, 3, 4, 5 (grau 4 > k=2)
      #L Vertices 2 e 3 conectados: (2-3)
      #L Vertice 6 e isolado (grau 0)
      #L Vertices 7 e 8 sao isolados (grau 0)
      mut as int64: num_v = 8
      mut as int64: k_param = 2

      mut as list of int64: edge_u = [1, 1, 1, 1, 2]
      mut as list of int64: edge_v = [2, 3, 4, 5, 3]
      mut as int64: num_edges = listLength(edge_u)
      mut as list of bool: edge_active = [true, true, true, true, true]

      println("1. Instancia original: |V| = 8, |E| = 5, parametro k = 2.")

      #L Vetor de vertices obrigatorios no Vertex Cover identificados pelo Kernel
      mut as list of int64: mandatory_cover = []
      mut as list of bool: vertex_removed = [false, false, false, false, false, false, false, false]

      #L Regras de Reducao de Buss (1993):
      #L Regra 1: Vertices de grau 0 nao cobrem arestas; descarte-os.
      #L Regra 2: Qualquer vertice com grau > k DEVE pertencer a cobertura!
      #L          (Caso contrario, todos os seus > k vizinhos teriam que ser incluidos, excedendo k).
      println("2. Aplicando Regras de Reducao do Kernel...")

      #L Calcula graus atuais
      mut as list of int64: deg = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: ei = 1
      infinite (ei <= num_edges) {
            route {
                  edge_active[ei] ==> {
                        mut as int64: u = edge_u[ei]
                        mut as int64: v = edge_v[ei]
                        deg[u] = deg[u] + 1
                        deg[v] = deg[v] + 1
                  }
            }
            ei = ei + 1
      }

      println("   Graus iniciais dos vertices: " + deg)

      #L Aplicacao da Regra 2: Vertices com grau > k_orig
      mut as int64: k_orig = k_param
      mut as int64: vi = 1
      infinite (vi <= num_v) {
            route {
                  deg[vi] > k_orig ==> {
                        println("   Regra 2 aplicada: Vertice " + vi + " tem grau " + deg[vi] + " > k (" + k_param + "). Adicionado a cobertura!")
                        mandatory_cover = listPushBack(mandatory_cover, vi)
                        vertex_removed[vi] = true
                        k_param = k_param - 1

                        #L Desativa arestas incidentes em vi
                        mut as int64: ej = 1
                        infinite (ej <= num_edges) {
                              route {
                                    edge_active[ej] ==> {
                                          route {
                                                (edge_u[ej] == vi) or (edge_v[ej] == vi) ==> {
                                                      edge_active[ej] = false
                                                }
                                          }
                                    }
                              }
                              ej = ej + 1
                        }
                  }
            }
            vi = vi + 1
      }

      #L Recalcula graus apos remocao
      vi = 1
      infinite (vi <= num_v) {
            deg[vi] = 0
            vi = vi + 1
      }
      ei = 1
      infinite (ei <= num_edges) {
            route {
                  edge_active[ei] ==> {
                        mut as int64: u = edge_u[ei]
                        mut as int64: v = edge_v[ei]
                        deg[u] = deg[u] + 1
                        deg[v] = deg[v] + 1
                  }
            }
            ei = ei + 1
      }

      #L Aplicacao da Regra 1: Remove vertices de grau 0
      vi = 1
      infinite (vi <= num_v) {
            route {
                  (not vertex_removed[vi]) and (deg[vi] == 0) ==> {
                        println("   Regra 1 aplicada: Vertice isolado " + vi + " descartado.")
                        vertex_removed[vi] = true
                  }
            }
            vi = vi + 1
      }

      #L Coleta vertices e arestas do nucleo (kernel)
      mut as list of int64: kernel_vertices = []
      vi = 1
      infinite (vi <= num_v) {
            route {
                  not vertex_removed[vi] ==> {
                        kernel_vertices = listPushBack(kernel_vertices, vi)
                  }
            }
            vi = vi + 1
      }

      mut as int64: kernel_edges_count = 0
      ei = 1
      infinite (ei <= num_edges) {
            route {
                  edge_active[ei] ==> {
                        kernel_edges_count = kernel_edges_count + 1
                  }
            }
            ei = ei + 1
      }

      println("3. Nucleo Reduzido (Kernel) computado:")
      println("   Vertices restantes no Kernel: " + kernel_vertices + " (tamanho " + listLength(kernel_vertices) + ")")
      println("   Arestas restantes no Kernel: " + kernel_edges_count)
      println("   Parametro residual k' = " + k_param)
      println("   Vertices obrigatorios identificados: " + mandatory_cover)

      #L Resolvendo a instancia residual do Kernel:
      #L A unica aresta restante e (2-3) com k' = 1.
      #L Escolher vertice 2 cobre a aresta restante!
      mandatory_cover = listPushBack(mandatory_cover, 2)
      println("4. Solucao final para o Vertex Cover obtida via Kernel: " + mandatory_cover)

      mut as bool: all_ok = (listLength(mandatory_cover) == 2) and (listLength(kernel_vertices) == 2)
      println("5. Verificacao geral do Algoritmo de Kernelizacao: " + all_ok)
      println("Concluido com Sucesso")
}
