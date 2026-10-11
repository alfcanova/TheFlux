#L ============================================================================
#L Algoritmo: Reducao de Cook (Polynomial-Time Turing Reduction com Oraculo SAT)
#L Dominio: 03_graphs / Categoria: Teoria da computacao e complexidade
#L Complexidade: O(n * T_oraculo) tempo | Reducao de Busca para Decisao (Self-Reducibility)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosComplexidadeCookReduction) {
      println("==================================================")
      println("  SciAlgo: Reducao de Cook (Turing Reduction)     ")
      println("==================================================")

      #L Na reducao de Cook (ao contrario da reducao de Karp que eh many-one),
      #L o algoritmo funciona como uma maquina de Turing com oraculo (M^SAT),
      #L podendo realizar multiplas consultas polinomiais adaptativas a um
      #L decisor de SAT para resolver o problema de busca (encontrar a atribuicao).

      #L Formula booleana com n = 4 variaveis e m = 4 clausulas:
      #L C1: ( x1 or  x2)
      #L C2: (not x1 or  x3)
      #L C3: (not x2 or  x4)
      #L C4: (not x3 or not x4)
      mut as int64: n_vars = 4
      mut as int64: m_clauses = 4

      println("1. Problema de Busca (SAT-Search):")
      println("   Encontrar atribuicao tau in {0, 1}^4 satisfativa para a formula:")
      println("   C1: ( x1 or  x2)")
      println("   C2: (not x1 or  x3)")
      println("   C3: (not x2 or  x4)")
      println("   C4: (not x3 or not x4)")

      #L O Oraculo Decisor: dado um prefixo de variaveis fixadas,
      #L determina se existe alguma atribuicao para as variaveis livres que satisfaca todas as 4 clausulas.
      #L Vetor de atribuicao: -1 para livre, 0 para falso, 1 para verdadeiro.
      mut as list of int64: current_assignment = [-1, -1, -1, -1]
      mut as int64: oracle_queries_count = 0

      println("2. Iniciando Reducao de Turing Cook (Self-Reducibility de SAT)...")
      println("   A maquina consulta o oraculo para cada bit de variavel adaptativamente.")

      mut as int64: step_var = 1
      infinite (step_var <= n_vars) {
            #L Hipotese: testar se a formula e satisfativel com step_var = 1
            oracle_queries_count = oracle_queries_count + 1
            mut as list of int64: test_assign = current_assignment
            test_assign[step_var] = 1

            #L Simulacao da Consulta ao Oraculo SAT (test_assign)
            #L Avalia se ha completamento satisfativo para variaveis livres
            mut as bool: oracle_response = false

            #L Como n=4 e restrito, o oraculo testa combinacoes das variaveis livres:
            mut as int64: free_comb = 0
            mut as int64: total_combs = 16 #L 2^4
            infinite (free_comb < total_combs and not oracle_response) {
                  #L Extrai bits da combinacao para as variaveis
                  #L Bit 0 para x1, bit 1 para x2, bit 2 para x3, bit 3 para x4
                  mut as int64: c1 = free_comb /r 2
                  mut as int64: c2 = (free_comb /i 2) /r 2
                  mut as int64: c3 = (free_comb /i 4) /r 2
                  mut as int64: c4 = (free_comb /i 8) /r 2

                  mut as list of int64: full_cand = [c1, c2, c3, c4]

                  #L Verifica consistencia com variaveis ja fixadas em test_assign
                  mut as bool: consistent = true
                  mut as int64: vi = 1
                  infinite (vi <= n_vars) {
                        route {
                              test_assign[vi] != -1 and (test_assign[vi] != full_cand[vi]) ==> {
                                    consistent = false
                              }
                              _ ==> {}
                        }
                        vi = vi + 1
                  }

                  route {
                        consistent ==> {
                              #L Testa se full_cand satisfaz todas as 4 clausulas
                              mut as int64: v1 = full_cand[1]
                              mut as int64: v2 = full_cand[2]
                              mut as int64: v3 = full_cand[3]
                              mut as int64: v4 = full_cand[4]

                              mut as bool: sat1 = (v1 == 1) or (v2 == 1)
                              mut as bool: sat2 = (v1 == 0) or (v3 == 1)
                              mut as bool: sat3 = (v2 == 0) or (v4 == 1)
                              mut as bool: sat4 = (v3 == 0) or (v4 == 0)

                              route {
                                    sat1 and sat2 and sat3 and sat4 ==> {
                                          oracle_response = true
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }

                  free_comb = free_comb + 1
            }

            println("   Consulta #" + oracle_queries_count + ": Formula com x" + step_var + "=1 e satisfativel? " + oracle_response)

            route {
                  oracle_response ==> {
                        #L O ramo x_var = 1 e satisfativel! Fixamos 1.
                        current_assignment[step_var] = 1
                  }
                  _ ==> {
                        #L O ramo x_var = 1 e insatisfativel. Pela auto-redutibilidade, x_var DEVE ser 0!
                        current_assignment[step_var] = 0
                  }
            }

            step_var = step_var + 1
      }

      println("3. Atribuicao Completa Sintetizada pela Reducao de Cook:")
      println("   tau = [x1=" + current_assignment[1] + ", x2=" + current_assignment[2] + ", x3=" + current_assignment[3] + ", x4=" + current_assignment[4] + "]")
      println("   Total de chamadas ao oraculo: " + oracle_queries_count + " (exatamente n consultas)")

      #L Verificacao de Satisfatibilidade da Atribuicao encontrada
      mut as int64: f1 = current_assignment[1]
      mut as int64: f2 = current_assignment[2]
      mut as int64: f3 = current_assignment[3]
      mut as int64: f4 = current_assignment[4]

      mut as bool: c1_ok = (f1 == 1) or (f2 == 1)
      mut as bool: c2_ok = (f1 == 0) or (f3 == 1)
      mut as bool: c3_ok = (f2 == 0) or (f4 == 1)
      mut as bool: c4_ok = (f3 == 0) or (f4 == 0)
      mut as bool: all_clauses_satisfied = c1_ok and c2_ok and c3_ok and c4_ok

      println("4. Verificacao das Clausulas com a Solucao:")
      println("   C1 (x1 or x2): " + c1_ok)
      println("   C2 (not x1 or x3): " + c2_ok)
      println("   C3 (not x2 or x4): " + c3_ok)
      println("   C4 (not x3 or not x4): " + c4_ok)
      println("   Formula inteira satisfeita: " + all_clauses_satisfied)

      #L Propriedade da Reducao de Cook:
      #L O numero de consultas e estritamente linear no numero de variaveis O(n),
      #L demonstrando que Search <=T^P Decision.
      mut as bool: cook_reduction_valid = all_clauses_satisfied and (oracle_queries_count == n_vars)
      println("5. Verificacao da Reducao de Cook: " + cook_reduction_valid)

      println("Concluido com Sucesso")
}
