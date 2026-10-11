#L ============================================================================
#L Algoritmo: Reducao de Karp (Many-One Polynomial-Time Reduction 3-SAT <=p IS)
#L Dominio: 03_graphs / Categoria: Teoria da computacao e complexidade
#L Complexidade: O(m^2) tempo de reducao | |V| = 3m, K = m
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosComplexidadeKarpReduction) {
      println("==================================================")
      println("  SciAlgo: Reducao de Karp (3-SAT <=p Indep Set)  ")
      println("==================================================")

      #L Instancia original em 3-SAT:
      #L Formula com n = 3 variaveis (x1, x2, x3) e m = 3 clausulas
      #L Convencao de literais: +k para variavel xk, -k para negacao not xk
      #L C1: ( x1 or  x2 or not x3) -> [ 1,  2, -3]
      #L C2: (not x1 or  x2 or  x3) -> [-1,  2,  3]
      #L C3: (not x1 or not x2 or  x3) -> [-1, -2,  3]
      mut as int64: m_clauses = 3
      mut as list of int64: lit1 = [ 1, -1, -1]
      mut as list of int64: lit2 = [ 2,  2, -2]
      mut as list of int64: lit3 = [-3,  3,  3]

      println("1. Instancia Original 3-SAT:")
      println("   Clausula 1: (x1 or x2 or not x3)")
      println("   Clausula 2: (not x1 or x2 or x3)")
      println("   Clausula 3: (not x1 or not x2 or x3)")
      println("   Numero de clausulas m = " + m_clauses)

      #L CONSTRUCAO DA REDUCAO DE KARP (f: 3-SAT -> Independent Set):
      #L Para cada clausula C_j, criamos 3 vertices (um para cada literal).
      #L Total de vertices |V| = 3 * m = 9.
      #L Mapeamento de indice de vertice: vert = (j - 1) * 3 + pos (1..3)
      println("2. Aplicando a Transformacao Polinomial de Karp f(phi)...")
      mut as int64: total_v = 3 * m_clauses
      mut as list of int64: vert_literal = []
      mut as list of int64: vert_clause = []

      mut as int64: c = 1
      infinite (c <= m_clauses) {
            vert_literal = listPushBack(vert_literal, lit1[c])
            vert_clause = listPushBack(vert_clause, c)

            vert_literal = listPushBack(vert_literal, lit2[c])
            vert_clause = listPushBack(vert_clause, c)

            vert_literal = listPushBack(vert_literal, lit3[c])
            vert_clause = listPushBack(vert_clause, c)

            c = c + 1
      }

      #L Matriz de adjacencia do grafo gerado (tamanho 9x9 = 81)
      mut as list of int64: adj = []
      mut as int64: cell = 1
      infinite (cell <= total_v * total_v) {
            adj = listPushBack(adj, 0)
            cell = cell + 1
      }

      #L Regra A de Arestas: Intra-clausula (triangulo em cada clausula).
      #L Nenhum conjunto independente podera selecionar mais de 1 literal por clausula.
      mut as int64: intra_edges = 0
      mut as int64: cj = 1
      infinite (cj <= m_clauses) {
            mut as int64: base = (cj - 1) * 3
            mut as int64: v1 = base + 1
            mut as int64: v2 = base + 2
            mut as int64: v3 = base + 3

            #L Arestas (v1, v2), (v1, v3), (v2, v3)
            adj[(v1 - 1) * total_v + v2] = 1
            adj[(v2 - 1) * total_v + v1] = 1
            adj[(v1 - 1) * total_v + v3] = 1
            adj[(v3 - 1) * total_v + v1] = 1
            adj[(v2 - 1) * total_v + v3] = 1
            adj[(v3 - 1) * total_v + v2] = 1
            intra_edges = intra_edges + 3

            cj = cj + 1
      }

      #L Regra B de Arestas: Conflito Inter-clausula.
      #L Liga dois vertices u e v de clausulas distintas se representam literais contraditorios (l_u == -l_v).
      mut as int64: conflict_edges = 0
      mut as int64: u = 1
      infinite (u <= total_v) {
            mut as int64: v = u + 1
            infinite (v <= total_v) {
                  route {
                        vert_clause[u] != vert_clause[v] ==> {
                              mut as int64: lu = vert_literal[u]
                              mut as int64: lv = vert_literal[v]
                              route {
                                    lu + lv == 0 ==> {
                                          #L Literais opostos (ex: x1 e not x1)
                                          adj[(u - 1) * total_v + v] = 1
                                          adj[(v - 1) * total_v + u] = 1
                                          conflict_edges = conflict_edges + 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
            u = u + 1
      }

      mut as int64: total_edges = intra_edges + conflict_edges
      mut as int64: target_k = m_clauses

      println("3. Grafo G=(V, E) Gerado pela Reducao:")
      println("   |V| = " + total_v)
      println("   |E| = " + total_edges + " (" + intra_edges + " intra-clausula + " + conflict_edges + " conflitos)")
      println("   Parametro do Conjunto Independente K = m = " + target_k)

      #L DEMONSTRACAO DA EQUIVALENCIA (Mapeamento de Testemunha):
      #L Consideremos a atribuicao booleana satisfativa tau: (x1=true, x2=true, x3=true).
      #L C1: x1 e verdadeiro -> escolhe vertice 1 (literal x1 em C1)
      #L C2: x2 e verdadeiro -> escolhe vertice 5 (literal x2 em C2)
      #L C3: x3 e verdadeiro -> escolhe vertice 9 (literal x3 em C3)
      mut as list of int64: chosen_witness = [1, 5, 9]
      println("4. Mapeamento da Atribuicao Satisfativa (x1=1, x2=1, x3=1) no Grafo:")
      println("   Vertices selecionados: " + chosen_witness)

      #L Verifica se o conjunto selecionado e de fato um Independent Set em G
      mut as bool: is_independent = true
      mut as int64: i = 1
      infinite (i <= 3) {
            mut as int64: j = i + 1
            infinite (j <= 3) {
                  mut as int64: vi = chosen_witness[i]
                  mut as int64: vj = chosen_witness[j]
                  route {
                        adj[(vi - 1) * total_v + vj] == 1 ==> {
                              is_independent = false
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("   Vertices selecionados formam Independent Set em G? " + is_independent)
      println("   Tamanho do conjunto = " + listLength(chosen_witness) + " == K (" + target_k + ")")

      #L Propriedade da Reducao de Karp:
      #L phi eh satisfativel <==> G tem Independent Set de tamanho >= K.
      mut as bool: karp_reduction_valid = is_independent and (listLength(chosen_witness) == target_k)
      println("5. Verificacao da Reducao de Karp: " + karp_reduction_valid)

      println("Concluido com Sucesso")
}
