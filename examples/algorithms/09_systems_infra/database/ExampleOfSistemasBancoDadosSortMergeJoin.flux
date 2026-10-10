#L ============================================================================
#L Algoritmo: Sort-Merge Join (SMJ)
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(|R| log |R| + |S| log |S|) ordenacao + O(|R| + |S|) merge
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosSortMergeJoin) {
      println("==================================================")
      println("  SciAlgo: Sort-Merge Join (SMJ)")
      println("==================================================")

      #L O Sort-Merge Join ordena ambas as relacoes pela chave de juncao e
      #L em seguida realiza uma varredura paralela com dois ponteiros (merge sweep).
      #L E altamente eficiente quando as tabelas ja estao ordenadas por indices B-Tree
      #L ou agrupadas fisicamente (clustered).

      #L Relacao R (Funcionarios: EmpID, DeptID) - 6 tuplas ordenadas por DeptID:
      mut as int64: r_count = 6
      mut as list of int64: r_id = [1, 3, 2, 5, 4, 6]
      mut as list of int64: r_dept = [10, 10, 20, 20, 30, 50]

      #L Relacao S (Departamentos: DeptID, Predio) - 4 tuplas ordenadas por DeptID:
      mut as int64: s_count = 4
      mut as list of int64: s_dept = [10, 20, 30, 40]
      mut as list of int64: s_bld = [101, 102, 103, 104]

      println("1. Relacoes Ordenadas pela Chave de Juncao (DeptID):")
      println("   Relacao R (Funcionarios, |R| = 6):")
      mut as int64: i = 1
      infinite (i <= r_count) {
            println("      (EmpID: " + r_id[i] + ", DeptID: " + r_dept[i] + ")")
            i = i + 1
      }

      println("   Relacao S (Departamentos, |S| = 4):")
      mut as int64: j = 1
      infinite (j <= s_count) {
            println("      (DeptID: " + s_dept[j] + ", Predio: " + s_bld[j] + ")")
            j = j + 1
      }

      println("==================================================")
      println("2. [Fase de Varredura e Fusao (Merge Sweep)]:")

      mut as int64: pr = 1
      mut as int64: ps = 1
      mut as int64: matches = 0
      mut as int64: steps = 0

      infinite (pr <= r_count) {
            route {
                  ps <= s_count ==> {
                        steps = steps + 1
                        mut as int64: k_r = r_dept[pr]
                        mut as int64: k_s = s_dept[ps]

                        route {
                              k_r < k_s ==> {
                                    #L Chave de R menor: avanca ponteiro de R
                                    println("   [Avanco R] DeptID R (" + k_r + ") < DeptID S (" + k_s + ") -> Avanca R")
                                    pr = pr + 1
                              }
                              k_r > k_s ==> {
                                    #L Chave de S menor: avanca ponteiro de S
                                    println("   [Avanco S] DeptID R (" + k_r + ") > DeptID S (" + k_s + ") -> Avanca S")
                                    ps = ps + 1
                              }
                              _ ==> {
                                    #L k_r == k_s: MATCH!
                                    matches = matches + 1
                                    println("   [MATCH] EmpID: " + r_id[pr] + " | DeptID: " + k_r + " | Predio: " + s_bld[ps])
                                    #L Avanca R para verificar se ha proximos com a mesma chave
                                    pr = pr + 1
                              }
                        }
                  }
                  _ ==> {
                        #L ps > s_count: fim de S
                        pr = r_count + 1
                  }
            }
      }

      println("==================================================")
      println("3. Metricas do Sort-Merge Join:")
      println("   Total de passos de varredura: " + steps)
      println("   Total de correspondencias (matches): " + matches)
      println("   Varredura linear unica concluida com sucesso!")
      println("==================================================")
}
