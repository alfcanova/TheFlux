#L ============================================================================
#L Algoritmo: First-Come, First-Served (FCFS) CPU Scheduling
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N) tempo de execucao | Nao-preemptivo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisFCFSScheduling) {
      println("==================================================")
      println("  SciAlgo: FCFS CPU Scheduling Algorithm")
      println("==================================================")

      #L O escalonamento FCFS atende os processos estritamente na ordem de chegada.
      #L E um algoritmo nao-preemptivo simples, sujeito ao efeito comboio (convoy effect).

      mut as int64: n = 4
      #L Processos 1 a 4: Arrival Time (AT) e Burst Time (BT)
      mut as list of int64: at = [0, 1, 2, 3]
      mut as list of int64: bt = [6, 4, 2, 3]

      mut as list of int64: ct = [0, 0, 0, 0] #L Completion Time
      mut as list of int64: tat = [0, 0, 0, 0] #L Turnaround Time = CT - AT
      mut as list of int64: wt = [0, 0, 0, 0] #L Waiting Time = TAT - BT

      println("1. Tabela de Processos de Entrada:")
      mut as int64: p = 1
      infinite (p <= n) {
            println("   P" + p + ": Chegada (AT) = " + at[p] + " | Duracao (BT) = " + bt[p])
            p = p + 1
      }

      println("==================================================")
      println("2. [Simulacao do Escalonamento FCFS]:")

      mut as int64: current_time = 0
      mut as int64: sum_tat = 0
      mut as int64: sum_wt = 0

      mut as int64: i = 1
      infinite (i <= n) {
            route {
                  current_time < at[i] ==> {
                        current_time = at[i]
                  }
                  _ ==> {}
            }

            mut as int64: start_time = current_time
            current_time = current_time + bt[i]
            ct[i] = current_time
            tat[i] = ct[i] - at[i]
            wt[i] = tat[i] - bt[i]

            sum_tat = sum_tat + tat[i]
            sum_wt = sum_wt + wt[i]

            println("   [" + start_time + " -> " + current_time + "] Executando P" + i + " | CT=" + ct[i] + " | TAT=" + tat[i] + " | WT=" + wt[i])
            i = i + 1
      }

      println("==================================================")
      println("3. Metricas Globais de Desempenho:")
      mut as int64: avg_tat = sum_tat * 10 /i n
      mut as int64: avg_wt = sum_wt * 10 /i n
      println("   Tempo Medio de Retorno (Average TAT): " + (avg_tat /i 10) + "." + (avg_tat /r 10))
      println("   Tempo Medio de Espera  (Average WT):  " + (avg_wt /i 10) + "." + (avg_wt /r 10))
      println("   Escalonamento FCFS concluido com sucesso!")
      println("==================================================")
}
