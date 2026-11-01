#L ============================================================================
#L Algoritmo: Grace Hash Join (Partitioned Hash Join)
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(|R| + |S|) com I/O particionado em disco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosGraceHashJoin) {
      println("==================================================")
      println("  SciAlgo: Grace Hash Join (Partitioned Hash)")
      println("==================================================")

      #L O Grace Hash Join e projetado para conjuntos de dados que excedem
      #L a capacidade da memoria principal (RAM).
      #L 1. Fase de Particionamento: Aplica funcao hash h1 para dividir
      #L    tanto R quanto S em K particoes em disco (R1..RK e S1..SK).
      #L 2. Fase de Juncao: Para cada par (Ri, Si), carrega Si na memoria,
      #L    constroi tabela hash com h2 e sonda com tuplas de Ri.

      mut as int64: num_partitions = 3 #L K = 3 particoes

      #L Relacao R (Funcionarios: EmpID, DeptID) - 6 tuplas:
      mut as int64: r_count = 6
      mut as list of int64: r_id = [1, 2, 3, 4, 5, 6]
      mut as list of int64: r_dept = [11, 22, 13, 24, 15, 26]

      #L Relacao S (Departamentos: DeptID, Predio) - 4 tuplas:
      mut as int64: s_count = 4
      mut as list of int64: s_dept = [11, 22, 13, 99]
      mut as list of int64: s_bld = [101, 102, 103, 199]

      #L ======================================================================
      #L Fase 1: Particionamento via Hash h1(key) = (key % 3) + 1
      #L ======================================================================
      println("1. [Fase 1: Particionamento das Relacoes em Disco via h1]:")

      #L Particoes de R (vetor de indices de particao para cada tupla)
      mut as list of int64: r_part = [0, 0, 0, 0, 0, 0]
      mut as int64: i = 1
      infinite (i <= r_count) {
            r_part[i] = (r_dept[i] /r num_partitions) + 1
            println("   Tupla R(EmpID=" + r_id[i] + ", Dept=" + r_dept[i] + ") -> gravada na Particao R[" + r_part[i] + "]")
            i = i + 1
      }

      #L Particoes de S
      mut as list of int64: s_part = [0, 0, 0, 0]
      mut as int64: j = 1
      infinite (j <= s_count) {
            s_part[j] = (s_dept[j] /r num_partitions) + 1
            println("   Tupla S(Dept=" + s_dept[j] + ", Predio=" + s_bld[j] + ") -> gravada na Particao S[" + s_part[j] + "]")
            j = j + 1
      }

      #L ======================================================================
      #L Fase 2: Juncao Independente por Particao (Build & Probe in-memory)
      #L ======================================================================
      println("==================================================")
      println("2. [Fase 2: Juncao por Particao (Build Si, Probe Ri)]:")

      mut as int64: total_matches = 0
      mut as int64: p = 1
      infinite (p <= num_partitions) {
            println("   -----------------------------------------------")
            println("   Processando Par de Particoes (" + p + "/" + num_partitions + "): R[" + p + "] e S[" + p + "]")

            #L Varre tuplas de Ri contra tuplas de Si pertencentes a particao p
            mut as int64: r_idx = 1
            infinite (r_idx <= r_count) {
                  route {
                        r_part[r_idx] == p ==> {
                              mut as int64: s_idx = 1
                              infinite (s_idx <= s_count) {
                                    route {
                                          s_part[s_idx] == p ==> {
                                                route {
                                                      r_dept[r_idx] == s_dept[s_idx] ==> {
                                                            total_matches = total_matches + 1
                                                            println("      [MATCH] EmpID=" + r_id[r_idx] + " | DeptID=" + r_dept[r_idx] + " | Predio=" + s_bld[s_idx])
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    s_idx = s_idx + 1
                              }
                        }
                        _ ==> {}
                  }
                  r_idx = r_idx + 1
            }
            p = p + 1
      }

      println("==================================================")
      println("3. Resumo de Execucao do Grace Hash Join:")
      println("   Total de particoes independentes processadas: " + num_partitions)
      println("   Total de juncoes realizadas: " + total_matches)
      println("   Isolamento de memoria garantido para grandes volumes!")
      println("==================================================")
}
