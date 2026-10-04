#L ============================================================================
#L Algoritmo: External Merge Sort (Ordenação Externa por Mesclagem Multi-Vias)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log(N / M)) E/S em disco | O(M) memória interna RAM
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortExternalMerge) {
      println("==================================================")
      println("  SciAlgo: External Merge Sort (Mesclagem Externa)")
      println("==================================================")

      mut as list of int64: disk_input = [73, 21, 58, 9, 84, 15, 62, 33, 91, 4, 47, 18, 55, 2, 80, 29]
      mut as int64: n = listLength(disk_input)
      println("1. Arquivo de entrada em disco (N = 16): " + disk_input)

      mut as int64: ram_buffer_cap = 4
      mut as int64: num_runs = n /i ram_buffer_cap
      println("2. Capacidade da memoria RAM: " + ram_buffer_cap + " itens | Corridas geradas: " + num_runs)

      #L Aloca armazenamento para as corridas no disco secundário
      mut as list of int64: disk_runs = []
      mut as int64: total_run_slots = n
      mut as int64: s = 1
      infinite (s <= total_run_slots) {
            disk_runs = listPushBack(disk_runs, 0)
            s = s + 1
      }

      #L ====================================================================
      #L Fase 1: Geração de Corridas Ordenadas (Run Formation em RAM)
      #L ====================================================================
      mut as int64: run_idx = 1
      infinite (run_idx <= num_runs) {
            #L Carrega bloco de tamanho ram_buffer_cap na memória interna
            mut as list of int64: ram = []
            mut as int64: start_pos = (run_idx - 1) * ram_buffer_cap + 1
            mut as int64: end_pos = run_idx * ram_buffer_cap

            mut as int64: p = start_pos
            infinite (p <= end_pos) {
                  ram = listPushBack(ram, disk_input[p])
                  p = p + 1
            }

            #L Ordena na memória RAM usando Insertion Sort
            mut as int64: ri = 2
            infinite (ri <= ram_buffer_cap) {
                  mut as int64: key = ram[ri]
                  mut as int64: rj = ri - 1
                  infinite (rj >= 1) {
                        route {
                              ram[rj] > key ==> {
                                    ram[rj + 1] = ram[rj]
                                    rj = rj - 1
                              }
                              _ ==> { break }
                        }
                  }
                  ram[rj + 1] = key
                  ri = ri + 1
            }

            #L Grava corrida ordenada no disco secundário
            p = 1
            infinite (p <= ram_buffer_cap) {
                  mut as int64: dest = (run_idx - 1) * ram_buffer_cap + p
                  disk_runs[dest] = ram[p]
                  p = p + 1
            }

            println("   Corrida " + run_idx + " gravada no disco: " + ram)
            run_idx = run_idx + 1
      }

      #L ====================================================================
      #L Fase 2: Mesclagem Multi-Vias (K-way Merge com K = 4)
      #L ====================================================================
      mut as list of int64: disk_output = []
      mut as list of int64: cursors = []
      s = 1
      infinite (s <= num_runs) {
            cursors = listPushBack(cursors, 1)
            s = s + 1
      }

      mut as int64: total_merged = 0
      infinite (total_merged < n) {
            mut as int64: best_run = 0
            mut as int64: best_val = 999999999

            #L Identifica o menor elemento entre as cabeças das K corridas ativas
            mut as int64: r = 1
            infinite (r <= num_runs) {
                  mut as int64: cur_p = cursors[r]
                  route {
                        cur_p <= ram_buffer_cap ==> {
                              mut as int64: slot = (r - 1) * ram_buffer_cap + cur_p
                              mut as int64: val = disk_runs[slot]
                              route {
                                    val < best_val ==> {
                                          best_val = val
                                          best_run = r
                                    }
                              }
                        }
                  }
                  r = r + 1
            }

            #L Emite o menor elemento para o arquivo final de saída em disco
            disk_output = listPushBack(disk_output, best_val)
            cursors[best_run] = cursors[best_run] + 1
            total_merged = total_merged + 1
      }

      println("3. Arquivo final consolidado no disco: " + disk_output)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      mut as int64: vi = 1
      infinite (vi < n) {
            route {
                  disk_output[vi] > disk_output[vi + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            vi = vi + 1
      }
      println("4. Validacao de ordenacao externa: " + sorted_ok)
      println("==================================================")
}
