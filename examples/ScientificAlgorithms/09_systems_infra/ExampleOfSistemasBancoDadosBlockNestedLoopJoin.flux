#L ============================================================================
#L Algoritmo: Block Nested Loop Join (BNLJ)
#L Dominio: 09_systems_infra / Categoria: Bancos de dados e armazenamento
#L Complexidade: O(ceil(|R|/B) * |S|) varreduras de I/O de S
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasBancoDadosBlockNestedLoopJoin) {
      println("==================================================")
      println("  SciAlgo: Block Nested Loop Join (BNLJ)")
      println("==================================================")

      #L O Block Nested Loop Join otimiza o acesso a disco dividindo a relacao
      #L externa R em blocos de tamanho B mantidos no buffer pool.
      #L Para cada bloco de R em memoria, a relacao interna S e varrida apenas
      #L UMA vez, reduzindo o numero de varreduras de S de |R| para ceil(|R|/B).

      #L Relacao R (6 tuplas):
      mut as int64: r_count = 6
      mut as list of int64: r_id = [1, 2, 3, 4, 5, 6]
      mut as list of int64: r_dept = [10, 20, 10, 30, 20, 40]

      #L Relacao S (3 tuplas):
      mut as int64: s_count = 3
      mut as list of int64: s_dept = [10, 20, 40]
      mut as list of int64: s_bld = [101, 102, 104]

      #L Tamanho do Bloco de Buffer: B = 2 tuplas de R por bloco
      mut as int64: block_size = 2
      #L ceil(6 / 2) = 3 blocos
      mut as int64: num_blocks = (r_count + block_size - 1) /i block_size

      println("1. Parametros do Buffer Pool:")
      println("   Tuplas em R: " + r_count + " | Tuplas em S: " + s_count)
      println("   Tamanho do Bloco de Memoria (B): " + block_size + " tuplas")
      println("   Total de Blocos de R: " + num_blocks)

      println("==================================================")
      println("2. [Execucao de Juncao por Blocos]:")

      mut as int64: total_s_scans = 0
      mut as int64: total_matches = 0

      mut as int64: blk = 1
      infinite (blk <= num_blocks) {
            mut as int64: r_start = (blk - 1) * block_size + 1
            mut as int64: r_end = blk * block_size
            route {
                  r_end > r_count ==> { r_end = r_count }
                  _ ==> {}
            }

            println("   -----------------------------------------------")
            println("   [Bloco " + blk + "/" + num_blocks + "] Carregando R[" + r_start + ".." + r_end + "] no Buffer de Memoria:")
            mut as int64: cur_r = r_start
            infinite (cur_r <= r_end) {
                  println("      -> Buffer Slot: EmpID=" + r_id[cur_r] + ", DeptID=" + r_dept[cur_r])
                  cur_r = cur_r + 1
            }

            println("   Iniciando Varredura Unica da Relacao S para o Bloco " + blk + "...")
            total_s_scans = total_s_scans + 1

            #L Varre cada tupla de S contra todas as tuplas do bloco atual de R
            mut as int64: s = 1
            infinite (s <= s_count) {
                  mut as int64: cur_s_d = s_dept[s]
                  mut as int64: cur_s_b = s_bld[s]

                  mut as int64: r_idx = r_start
                  infinite (r_idx <= r_end) {
                        route {
                              r_dept[r_idx] == cur_s_d ==> {
                                    total_matches = total_matches + 1
                                    println("      [MATCH] EmpID=" + r_id[r_idx] + " | DeptID=" + cur_s_d + " | Predio=" + cur_s_b)
                              }
                              _ ==> {}
                        }
                        r_idx = r_idx + 1
                  }
                  s = s + 1
            }
            blk = blk + 1
      }

      println("==================================================")
      println("3. Metricas de I/O e Desempenho:")
      println("   Varreduras da Relacao Interna S: " + total_s_scans + " (vs " + r_count + " no NLJ ingenuo)")
      println("   Reducao de I/O em S: " + ((r_count - total_s_scans) * 100 /i r_count) + "% de ganho")
      println("   Total de juncoes realizadas: " + total_matches)
      println("==================================================")
}
