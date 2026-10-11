#L ============================================================================
#L Algoritmo: Sweep Line (Algoritmo de Varredura 1D)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N log N) tempo | O(N) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysSweepLine) {
      println("==================================================")
      println("  SciAlgo: Sweep Line (1D Interval Analysis)")
      println("==================================================")

      #L Conjunto de 4 intervalos: [1, 5], [2, 8], [10, 15], [12, 18]
      mut as list of int64: int_start = [1, 2, 10, 12]
      mut as list of int64: int_end   = [5, 8, 15, 18]
      mut as int64: num_intervals = 4

      println("1. Intervalos informados:")
      mut as int64: p = 1
      infinite (p <= num_intervals) {
            println("   I" + p + ": [" + int_start[p] + ", " + int_end[p] + "]")
            p = p + 1
      }

      #L Eventos da linha de varredura: cada intervalo gera inicio (+1) e fim (-1)
      #L Tipo do evento: +1 para inicio, -1 para fim
      mut as list of int64: ev_x = []
      mut as list of int64: ev_type = []

      mut as int64: i = 1
      infinite (i <= num_intervals) {
            ev_x = listPushBack(ev_x, int_start[i])
            ev_type = listPushBack(ev_type, 1)

            ev_x = listPushBack(ev_x, int_end[i])
            ev_type = listPushBack(ev_type, -1)
            i = i + 1
      }
      mut as int64: num_events = listLength(ev_x)

      #L Ordenacao dos eventos por coordenada X crescente
      #L Se coordenadas forem iguais, inicio (+1) vem antes de fim (-1)
      mut as int64: u = 1
      infinite (u <= num_events) {
            mut as int64: v = u + 1
            infinite (v <= num_events) {
                  mut as bool: swap_ev = false
                  route {
                        ev_x[v] < ev_x[u] ==> {
                              swap_ev = true
                        }
                        ev_x[v] == ev_x[u] and ev_type[v] > ev_type[u] ==> {
                              swap_ev = true
                        }
                        _ ==> {
                        }
                  }

                  route {
                        swap_ev ==> {
                              mut as int64: tx = ev_x[u]
                              ev_x[u] = ev_x[v]
                              ev_x[v] = tx

                              mut as int64: tt = ev_type[u]
                              ev_type[u] = ev_type[v]
                              ev_type[v] = tt
                        }
                        _ ==> {
                        }
                  }
                  v = v + 1
            }
            u = u + 1
      }

      #L Processamento da varredura
      mut as int64: active_count = 0
      mut as int64: max_overlap = 0
      mut as int64: union_length = 0
      mut as int64: last_x = ev_x[1]

      mut as int64: e = 1
      infinite (e <= num_events) {
            mut as int64: cur_x = ev_x[e]

            #L Se houver intervalos ativos entre last_x e cur_x, acumula comprimento
            route {
                  active_count > 0 and cur_x > last_x ==> {
                        union_length = union_length + (cur_x - last_x)
                  }
                  _ ==> {
                  }
            }

            active_count = active_count + ev_type[e]
            route {
                  active_count > max_overlap ==> {
                        max_overlap = active_count
                  }
                  _ ==> {
                  }
            }

            last_x = cur_x
            e = e + 1
      }

      println("2. Analise por Linha de Varredura (Sweep Line):")
      println("   Comprimento total da uniao de intervalos: " + union_length + " (esperado: 15)")
      println("   Maximo de intervalos sobrepostos simultaneos: " + max_overlap + " (esperado: 2)")
}
