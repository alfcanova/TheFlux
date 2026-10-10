#L ============================================================================
#L Algoritmo: Work-Stealing Scheduling (Blumofe & Leiserson, Cilk 1999)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(T1/P + Tinf) tempo provadamente otimo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteWorkStealing) {
      println("==================================================")
      println("  SciAlgo: Work-Stealing Scheduling Algorithm     ")
      println("==================================================")

      #L Modelo Work-Stealing:
      #L Cada worker thread possui uma deque (double-ended queue) local:
      #L - O dono empurra e retira do FUNDO (bottom, LIFO) para maximizar localidade de cache.
      #L - Outros workers ociosos (thieves) roubam do TOPO (top, FIFO) para roubar tarefas maiores.
      #L
      #L Simulacao: 3 Workers
      #L Worker 1 inicializado com 6 tarefas (IDs 101, 102, 103, 104, 105, 106)
      #L Worker 2 inicializado sem tarefas (ocioso)
      #L Worker 3 inicializado sem tarefas (ocioso)

      mut as list of int64: deque1 = [101, 102, 103, 104, 105, 106]
      mut as int64: top1 = 1
      mut as int64: bottom1 = 6

      mut as int64: tasks_done_w1 = 0
      mut as int64: tasks_done_w2 = 0
      mut as int64: tasks_done_w3 = 0

      println("1. Estado Inicial das Deques:")
      println("   Worker 1: 6 tarefas na deque local (IDs 101 a 106)")
      println("   Worker 2: Ocioso (deque vazia)")
      println("   Worker 3: Ocioso (deque vazia)")

      println("2. Executando Processamento e Roubo de Trabalho (Work Stealing):")

      #L Passo 1: Worker 1 consome uma tarefa do fundo (LIFO: bottom)
      mut as int64: t_w1 = deque1[bottom1]
      bottom1 = bottom1 - 1
      tasks_done_w1 = tasks_done_w1 + 1
      println("   [LOCAL] Worker 1 processou sua propria tarefa do fundo: ID " + t_w1)

      #L Passo 2: Worker 2 esta ocioso e rouba do topo de Worker 1 (FIFO: top)
      route {
            top1 <= bottom1 ==> {
                  mut as int64: stolen_w2 = deque1[top1]
                  top1 = top1 + 1
                  tasks_done_w2 = tasks_done_w2 + 1
                  println("   [STEAL] Worker 2 ROUBOU com sucesso do topo do Worker 1: ID " + stolen_w2)
            }
            _ ==> {}
      }

      #L Passo 3: Worker 3 esta ocioso e tambem rouba do topo de Worker 1
      route {
            top1 <= bottom1 ==> {
                  mut as int64: stolen_w3 = deque1[top1]
                  top1 = top1 + 1
                  tasks_done_w3 = tasks_done_w3 + 1
                  println("   [STEAL] Worker 3 ROUBOU com sucesso do topo do Worker 1: ID " + stolen_w3)
            }
            _ ==> {}
      }

      #L Passo 4: Conclusao das tarefas restantes por cada worker
      #L Worker 1 processa restante de sua deque
      infinite (bottom1 >= top1) {
            mut as int64: t = deque1[bottom1]
            bottom1 = bottom1 - 1
            tasks_done_w1 = tasks_done_w1 + 1
            println("   [LOCAL] Worker 1 processou tarefa restante: ID " + t)
      }

      println("3. Resumo de Execucao:")
      println("   Tarefas concluidas por Worker 1: " + tasks_done_w1)
      println("   Tarefas concluidas por Worker 2: " + tasks_done_w2)
      println("   Tarefas concluidas por Worker 3: " + tasks_done_w3)

      mut as int64: total_done = tasks_done_w1 + tasks_done_w2 + tasks_done_w3
      println("   Total de Tarefas Finalizadas: " + total_done + " (Original: 6)")

      #L Validacao
      mut as bool: correct = (total_done == 6) and (tasks_done_w2 == 1) and (tasks_done_w3 == 1)
      println("4. Verificacao de Balanceamento por Roubo: " + correct)

      println("Work-Stealing Scheduling concluido com sucesso.")
}
