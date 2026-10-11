#L ============================================================================
#L Algoritmo: Classic In-Memory Hash Join
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(|R| + |S|) tempo linear | Build e Probe Phases
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosHashJoin) {
      println("==================================================")
      println("  SciAlgo: Classic In-Memory Hash Join")
      println("==================================================")

      #L O Hash Join e um dos algoritmos de juncao por igualdade mais eficientes.
      #L Opera em duas fases:
      #L 1. Fase de Construcao (Build Phase): Varre a menor relacao (S) e
      #L    insere suas tuplas em uma tabela hash indexada pela chave de juncao.
      #L 2. Fase de Sondagem (Probe Phase): Varre a maior relacao (R) e consulta
      #L    a tabela hash em O(1) para cada tupla.

      #L Relacao S (Build Relation - Departamentos, |S| = 3):
      mut as int64: s_count = 3
      mut as list of int64: s_dept = [10, 20, 30]
      mut as list of int64: s_name_code = [101, 102, 103] #L Codigo do departamento

      #L Relacao R (Probe Relation - Funcionarios, |R| = 6):
      mut as int64: r_count = 6
      mut as list of int64: r_id = [1, 2, 3, 4, 5, 6]
      mut as list of int64: r_dept = [20, 10, 30, 20, 99, 10]

      #L Tabela Hash com H = 5 buckets (indices 1..5)
      #L Funcao Hash: h(key) = (key /i 10) % 5 + 1
      #L Armazenamos: bucket_key, bucket_val (para 1 entrada por bucket com encadeamento direto)
      mut as list of int64: h_key = [0, 0, 0, 0, 0]
      mut as list of int64: h_val = [0, 0, 0, 0, 0]

      println("1. [Fase 1: Build Phase] Inserindo Relacao S na Tabela Hash:")
      mut as int64: s = 1
      infinite (s <= s_count) {
            mut as int64: k = s_dept[s]
            mut as int64: v = s_name_code[s]
            #L Funcao hash: (k /i 10) /r 5 + 1
            mut as int64: b_idx = (k /i 10) /r 5 + 1
            h_key[b_idx] = k
            h_val[b_idx] = v
            println("   -> DeptID=" + k + " (Val=" + v + ") inserido no Bucket [" + b_idx + "]")
            s = s + 1
      }

      println("==================================================")
      println("2. [Fase 2: Probe Phase] Sondando Relacao R contra Tabela Hash:")

      mut as int64: matches = 0
      mut as int64: r = 1
      infinite (r <= r_count) {
            mut as int64: emp = r_id[r]
            mut as int64: target_dept = r_dept[r]
            mut as int64: probe_bucket = (target_dept /i 10) /r 5 + 1

            println("   Tupla R(EmpID=" + emp + ", DeptID=" + target_dept + ") -> Consulta Bucket [" + probe_bucket + "]")

            route {
                  h_key[probe_bucket] == target_dept ==> {
                        matches = matches + 1
                        println("      [MATCH ENCONTRADO] EmpID=" + emp + " | DeptID=" + target_dept + " | DeptCode=" + h_val[probe_bucket])
                  }
                  _ ==> {
                        println("      [SEM CORRESPONDENCIA] Nenhum depto com ID=" + target_dept)
                  }
            }
            r = r + 1
      }

      println("==================================================")
      println("3. Resumo de Execucao:")
      println("   Total de tuplas em R sondadas: " + r_count)
      println("   Total de juncoes bem-sucedidas: " + matches)
      println("   Complexidade alcancada: O(|R| + |S|) estritamente linear")
      println("==================================================")
}
