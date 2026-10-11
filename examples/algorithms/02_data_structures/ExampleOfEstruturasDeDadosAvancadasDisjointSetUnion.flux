#L ============================================================================
#L Algoritmo: Disjoint Set Union (DSU / Union-Find com Path Compression & Rank)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: O(alpha(N)) por operacao quase linear | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasDisjointSetUnion) {
      println("==================================================")
      println("  SciAlgo: Disjoint Set Union (DSU / Union-Find)")
      println("==================================================")

      mut as int64: n = 10
      println("1. Inicializando DSU para " + n + " elementos (1 a 10)")

      #L Inicializacao: parent[i] = i, rank[i] = 0 (1-based)
      mut as list of int64: parent = []
      mut as list of int64: rank = []
      mut as int64: init_i = 1
      infinite (init_i <= n) {
            parent = listPushBack(parent, init_i)
            rank = listPushBack(rank, 0)
            init_i = init_i + 1
      }

      #L Unioes: (1, 2), (2, 3), (4, 5), (6, 7), (5, 6), (8, 9)
      mut as list of int64: u_u = [1, 2, 4, 6, 5, 8]
      mut as list of int64: u_v = [2, 3, 5, 7, 6, 9]
      mut as int64: num_ops = listLength(u_u)

      println("2. Realizando operacoes de uniao...")
      mut as int64: op_idx = 1
      infinite (op_idx <= num_ops) {
            mut as int64: a = u_u[op_idx]
            mut as int64: b = u_v[op_idx]

            #L Find root de a com path compression iterativo
            mut as int64: root_a = a
            infinite (parent[root_a] != root_a) {
                  root_a = parent[root_a]
            }
            mut as int64: curr_a = a
            infinite (curr_a != root_a) {
                  mut as int64: nxt = parent[curr_a]
                  parent[curr_a] = root_a
                  curr_a = nxt
            }

            #L Find root de b com path compression iterativo
            mut as int64: root_b = b
            infinite (parent[root_b] != root_b) {
                  root_b = parent[root_b]
            }
            mut as int64: curr_b = b
            infinite (curr_b != root_b) {
                  mut as int64: nxt = parent[curr_b]
                  parent[curr_b] = root_b
                  curr_b = nxt
            }

            #L Union by rank
            route {
                  root_a != root_b ==> {
                        route {
                              rank[root_a] < rank[root_b] ==> {
                                    parent[root_a] = root_b
                              }
                              rank[root_a] > rank[root_b] ==> {
                                    parent[root_b] = root_a
                              }
                              _ ==> {
                                    parent[root_b] = root_a
                                    rank[root_a] = rank[root_a] + 1
                              }
                        }
                  }
                  _ ==> {
                  }
            }

            println("   Uniao (" + a + ", " + b + ") concluida")
            op_idx = op_idx + 1
      }

      #L Consultas de conectividade (Connected Components)
      println("3. Testando conectividade entre elementos...")

      #L Teste 1: 1 e 3 devem estar conectados (conjunto {1, 2, 3})
      mut as int64: r1 = 1
      infinite (parent[r1] != r1) { r1 = parent[r1] }
      mut as int64: r3 = 3
      infinite (parent[r3] != r3) { r3 = parent[r3] }
      mut as bool: conn_1_3 = (r1 == r3)
      println("   1 e 3 conectados: " + conn_1_3)

      #L Teste 2: 4 e 7 devem estar conectados (conjunto {4, 5, 6, 7})
      mut as int64: r4 = 4
      infinite (parent[r4] != r4) { r4 = parent[r4] }
      mut as int64: r7 = 7
      infinite (parent[r7] != r7) { r7 = parent[r7] }
      mut as bool: conn_4_7 = (r4 == r7)
      println("   4 e 7 conectados: " + conn_4_7)

      #L Teste 3: 1 e 7 NAO devem estar conectados
      mut as bool: conn_1_7 = (r1 == r7)
      println("   1 e 7 conectados (esperado false): " + conn_1_7)

      #L Teste 4: 10 deve estar isolado
      mut as int64: r10 = 10
      infinite (parent[r10] != r10) { r10 = parent[r10] }
      mut as bool: iso_10 = (r10 == 10) and (r10 != r1) and (r10 != r4)
      println("   10 esta em componente isolada: " + iso_10)

      #L Contagem de componentes conexas distintas
      mut as int64: comp_count = 0
      mut as int64: ci = 1
      infinite (ci <= n) {
            route {
                  parent[ci] == ci ==> {
                        comp_count = comp_count + 1
                  }
                  _ ==> {
                  }
            }
            ci = ci + 1
      }
      println("4. Total de componentes conexas disjuntas (esperado 4): " + comp_count)

      mut as bool: ok = conn_1_3 and conn_4_7 and (not conn_1_7) and iso_10 and (comp_count == 4)
      println("5. Verificacao de integridade do DSU: " + ok)
      println("Concluido com Sucesso")
}
