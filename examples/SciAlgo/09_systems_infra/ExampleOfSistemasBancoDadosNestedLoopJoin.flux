#L ============================================================================
#L Algoritmo: Nested Loop Join (NLJ)
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(|R| * |S|) operacoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosNestedLoopJoin) {
      println("==================================================")
      println("  SciAlgo: Nested Loop Join (NLJ)")
      println("==================================================")

      #L O Nested Loop Join e o algoritmo fundamental de juncao relacional.
      #L Para cada tupla r da relacao externa R, varre todas as tuplas s
      #L da relacao interna S avaliando a condicao de juncao (r.key == s.key).
      #L
      #L Relacao R (Funcionarios: ID_Funcionario, ID_Depto):
      #L R = [(1, 10), (2, 20), (3, 10), (4, 30), (5, 20)]
      #L Flattened: r_id e r_dept
      mut as int64: r_count = 5
      mut as list of int64: r_id = [1, 2, 3, 4, 5]
      mut as list of int64: r_dept = [10, 20, 10, 30, 20]

      #L Relacao S (Departamentos: ID_Depto, Codigo_Predio):
      #L S = [(10, 101), (20, 102), (40, 104)]
      mut as int64: s_count = 3
      mut as list of int64: s_dept = [10, 20, 40]
      mut as list of int64: s_building = [101, 102, 104]

      println("1. Relacoes de Entrada:")
      println("   Relacao R (Funcionarios, |R| = 5):")
      mut as int64: i = 1
      infinite (i <= r_count) {
            println("      (EmpID: " + r_id[i] + ", DeptID: " + r_dept[i] + ")")
            i = i + 1
      }

      println("   Relacao S (Departamentos, |S| = 3):")
      mut as int64: j = 1
      infinite (j <= s_count) {
            println("      (DeptID: " + s_dept[j] + ", Predio: " + s_building[j] + ")")
            j = j + 1
      }

      println("==================================================")
      println("2. [Execucao do Nested Loop Join]:")

      mut as int64: comparisons = 0
      mut as int64: matches = 0

      #L Loop Externo (Outer Relation R)
      mut as int64: r = 1
      infinite (r <= r_count) {
            mut as int64: cur_r_id = r_id[r]
            mut as int64: cur_r_dept = r_dept[r]

            #L Loop Interno (Inner Relation S)
            mut as int64: s = 1
            infinite (s <= s_count) {
                  comparisons = comparisons + 1
                  mut as int64: cur_s_dept = s_dept[s]
                  mut as int64: cur_s_bld = s_building[s]

                  route {
                        cur_r_dept == cur_s_dept ==> {
                              matches = matches + 1
                              println("   [MATCH] EmpID: " + cur_r_id + " | DeptID: " + cur_r_dept + " | Predio: " + cur_s_bld)
                        }
                        _ ==> {}
                  }
                  s = s + 1
            }
            r = r + 1
      }

      println("==================================================")
      println("3. Metricas de Execucao:")
      println("   Total de comparacoes realizadas: " + comparisons + " (|R| * |S| = " + (r_count * s_count) + ")")
      println("   Tuplas juncao geradas: " + matches)
      println("==================================================")
}
