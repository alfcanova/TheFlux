#L ============================================================================
#L Algoritmo: Union-Find (Weighted Quick-Union com Path Halving e Componentes)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(alpha(N)) por operacao quase linear | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasUnionFind) {
      println("==================================================")
      println("  SciAlgo: Union-Find (Weighted Quick-Union)")
      println("==================================================")

      mut as int64: n = 8
      println("1. Inicializando Union-Find com " + n + " elementos:")

      #L Vetores paralelos: parent[i] = i, size[i] = 1 (1-based)
      mut as list of int64: parent = []
      mut as list of int64: sz = []
      mut as int64: init_idx = 1
      infinite (init_idx <= n) {
            parent = listPushBack(parent, init_idx)
            sz = listPushBack(sz, 1)
            init_idx = init_idx + 1
      }
      mut as int64: num_components = n

      #L Operacoes de uniao: (1, 2), (2, 3), (4, 5), (6, 7), (5, 6)
      mut as list of int64: edge_u = [1, 2, 4, 6, 5]
      mut as list of int64: edge_v = [2, 3, 5, 7, 6]
      mut as int64: m = listLength(edge_u)

      println("2. Processando " + m + " conexoes de arestas:")
      mut as int64: e = 1
      infinite (e <= m) {
            mut as int64: u = edge_u[e]
            mut as int64: v = edge_v[e]

            #L Find com Path Halving em u
            mut as int64: root_u = u
            infinite (root_u != parent[root_u]) {
                  parent[root_u] = parent[parent[root_u]]
                  root_u = parent[root_u]
            }

            #L Find com Path Halving em v
            mut as int64: root_v = v
            infinite (root_v != parent[root_v]) {
                  parent[root_v] = parent[parent[root_v]]
                  root_v = parent[root_v]
            }

            route {
                  root_u != root_v ==> {
                        #L Union ponderado por tamanho (Weighted Union)
                        route {
                              sz[root_u] < sz[root_v] ==> {
                                    parent[root_u] = root_v
                                    sz[root_v] = sz[root_v] + sz[root_u]
                              }
                              _ ==> {
                                    parent[root_v] = root_u
                                    sz[root_u] = sz[root_u] + sz[root_v]
                              }
                        }
                        num_components = num_components - 1
                        println("   Unido (" + u + ", " + v + "): componentes restantes = " + num_components)
                  }
                  _ ==> {
                        println("   Aresta redundante (" + u + ", " + v + ") ignorada")
                  }
            }
            e = e + 1
      }

      println("3. Total final de componentes conexos: " + num_components)

      #L Consultas de conectividade (connected query)
      #L Teste 1: 1 e 3 devem estar conectados (mesmo grupo {1, 2, 3})
      #L Teste 2: 4 e 7 devem estar conectados (mesmo grupo {4, 5, 6, 7})
      #L Teste 3: 1 e 4 nao estao conectados
      #L Teste 4: 8 e isolado
      mut as int64: r1 = 1
      infinite (r1 != parent[r1]) { r1 = parent[r1] }
      mut as int64: r3 = 3
      infinite (r3 != parent[r3]) { r3 = parent[r3] }

      mut as int64: r4 = 4
      infinite (r4 != parent[r4]) { r4 = parent[r4] }
      mut as int64: r7 = 7
      infinite (r7 != parent[r7]) { r7 = parent[r7] }

      mut as int64: r8 = 8
      infinite (r8 != parent[r8]) { r8 = parent[r8] }

      mut as bool: c1_3 = (r1 == r3)
      mut as bool: c4_7 = (r4 == r7)
      mut as bool: c1_4 = (r1 == r4)
      mut as bool: c8_iso = (sz[r8] == 1)

      println("4. Conectividade (1, 3): " + c1_3)
      println("5. Conectividade (4, 7): " + c4_7)
      println("6. Conectividade (1, 4): " + c1_4)
      println("7. Validacao: " + (c1_3 and c4_7 and not c1_4 and c8_iso and num_components == 3))
      println("==================================================")
}
