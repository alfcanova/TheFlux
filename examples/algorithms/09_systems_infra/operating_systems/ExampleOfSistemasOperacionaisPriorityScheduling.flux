#L ============================================================================
#L Algoritmo: Priority CPU Scheduling (with Aging Mechanism)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N^2) selecao por prioridade | Mecanismo Anti-Starvation (Aging)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisPriorityScheduling) {
      println("==================================================")
      println("  SciAlgo: Priority CPU Scheduling (with Aging)")
      println("==================================================")

      #L O escalonamento por prioridade despacha o processo com maior prioridade
      #L (menor valor numerico = maior prioridade).
      #L Para mitigar a inanicao (starvation) de processos de baixa prioridade,
      #L implementa-se envelhecimento (aging): a prioridade de processos que
      #L esperam na fila e gradualmente elevada.

      mut as int64: n = 4
      mut as list of int64: bt = [6, 3, 5, 2]
      #L Prioridade inicial (1 = mais alta, 4 = mais baixa):
      mut as list of int64: priority = [3, 1, 4, 2]
      mut as list of int64: completed = [0, 0, 0, 0]

      mut as list of int64: ct = [0, 0, 0, 0]
      mut as list of int64: tat = [0, 0, 0, 0]
      mut as list of int64: wt = [0, 0, 0, 0]

      println("1. Tabela de Processos e Prioridades Iniciais:")
      mut as int64: p = 1
      infinite (p <= n) {
            println("   P" + p + ": Burst = " + bt[p] + " | Prioridade Inicial = " + priority[p])
            p = p + 1
      }

      println("==================================================")
      println("2. [Execucao do Escalonador por Prioridade]:")

      mut as int64: current_time = 0
      mut as int64: completed_count = 0

      infinite (completed_count < n) {
            #L Encontra processo nao concluido com menor valor numerico de prioridade
            mut as int64: best_idx = 0
            mut as int64: best_pri = 999999

            mut as int64: i = 1
            infinite (i <= n) {
                  route {
                        completed[i] == 0 ==> {
                              route {
                                    priority[i] < best_pri ==> {
                                          best_pri = priority[i]
                                          best_idx = i
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            #L Executa o processo selecionado
            mut as int64: start_t = current_time
            current_time = current_time + bt[best_idx]
            ct[best_idx] = current_time
            tat[best_idx] = ct[best_idx]
            wt[best_idx] = tat[best_idx] - bt[best_idx]
            completed[best_idx] = 1
            completed_count = completed_count + 1

            println("   [" + start_t + " -> " + current_time + "] Despachado P" + best_idx + " (Prioridade Efetiva = " + best_pri + ") | CT=" + ct[best_idx] + " | WT=" + wt[best_idx])

            #L [Mecanismo de Aging]: Reduz o valor numerico dos processos pendentes em 1 (aumenta prioridade)
            mut as int64: a = 1
            infinite (a <= n) {
                  route {
                        completed[a] == 0 ==> {
                              route {
                                    priority[a] > 1 ==> {
                                          priority[a] = priority[a] - 1
                                          println("      -> [Aging] Prioridade de P" + a + " elevada para " + priority[a])
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  a = a + 1
            }
      }

      println("==================================================")
      println("3. Metricas Finais do Escalonamento:")
      mut as int64: sum_tat = 0
      mut as int64: sum_wt = 0
      mut as int64: k = 1
      infinite (k <= n) {
            sum_tat = sum_tat + tat[k]
            sum_wt = sum_wt + wt[k]
            k = k + 1
      }
      mut as int64: avg_tat = sum_tat * 10 /i n
      mut as int64: avg_wt = sum_wt * 10 /i n
      println("   Tempo Medio de Retorno (Average TAT): " + (avg_tat /i 10) + "." + (avg_tat /r 10))
      println("   Tempo Medio de Espera  (Average WT):  " + (avg_wt /i 10) + "." + (avg_wt /r 10))
      println("==================================================")
}
