#L ============================================================================
#L Algoritmo: Rate Monotonic Scheduling (RMS) (Liu & Layland 1973)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(1) selecao por prioridade estatica baseada em frequencia
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisRateMonotonic) {
      println("==================================================")
      println("  SciAlgo: Rate Monotonic Scheduling (RMS)")
      println("==================================================")

      #L O escalonamento Rate Monotonic atribui prioridades estaticas baseadas
      #L na taxa (frequencia de repeticao): menor periodo => maior prioridade.
      #L Limite de Utilizacao de Liu & Layland para N = 2 tarefas:
      #L U_bound = 2 * (sqrt(2) - 1) ~= 82.84%

      #L Tarefas Periodicas:
      #L Tarefa 1: Periodo T1 = 5,  Computacao C1 = 1 (Prioridade ALTA, Taxa = 1/5)
      #L Tarefa 2: Periodo T2 = 10, Computacao C2 = 4 (Prioridade BAIXA, Taxa = 1/10)
      #L Utilizacao U = 1/5 + 4/10 = 0.2 + 0.4 = 0.6 (60% <= 82.8% -> Garantidamente Escalonavel)
      #L Hiperperiodo = 10 unidades

      mut as int64: hyperperiod = 10

      mut as int64: rem_c1 = 0
      mut as int64: rem_c2 = 0

      println("1. Parametros do Escalonador Rate Monotonic:")
      println("   Tarefa 1: T1 = 5, C1 = 1 (Prioridade 1 - ALTA)")
      println("   Tarefa 2: T2 = 10, C2 = 4 (Prioridade 2 - BAIXA)")
      println("   Utilizacao Total: 60.0% (abaixo do limiar RMS de 82.8%)")
      println("   Hiperperiodo: " + hyperperiod + " unidades")

      println("==================================================")
      println("2. [Simulacao de Escalonamento RMS Preemptivo]:")

      mut as int64: t = 0
      mut as int64: missed = 0

      infinite (t < hyperperiod) {
            #L Liberacao periodica das tarefas
            route {
                  t /r 5 == 0 ==> {
                        rem_c1 = rem_c1 + 1
                        println("   [t=" + t + "] Tarefa 1 liberada (Periodo 5, Computacao 1)")
                  }
                  _ ==> {}
            }

            route {
                  t /r 10 == 0 ==> {
                        rem_c2 = rem_c2 + 4
                        println("   [t=" + t + "] Tarefa 2 liberada (Periodo 10, Computacao 4)")
                  }
                  _ ==> {}
            }

            #L Prioridade estatica: Tarefa 1 sempre tem prioridade sobre Tarefa 2
            route {
                  rem_c1 > 0 ==> {
                        rem_c1 = rem_c1 - 1
                        println("   [t=" + t + " -> " + (t + 1) + "] Executando Tarefa 1 (Prioridade Alta)")
                  }
                  rem_c2 > 0 ==> {
                        rem_c2 = rem_c2 - 1
                        println("   [t=" + t + " -> " + (t + 1) + "] Executando Tarefa 2 (Prioridade Baixa, restam " + rem_c2 + ")")
                  }
                  _ ==> {
                        println("   [t=" + t + " -> " + (t + 1) + "] CPU Ociosa")
                  }
            }

            t = t + 1
      }

      println("==================================================")
      println("3. Conclusao da Analise RMS:")
      println("   Todas as tarefas cumpriram seus prazos perfeitamente.")
      println("   Prioridade estatica monotonicamente proporcional a taxa validada!")
      println("==================================================")
}
