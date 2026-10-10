#L ============================================================================
#L Algoritmo: Escalonamento com Roubo de Carga (Work Stealing Deque)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(1) push/pop local, tempo total ótimo O(T1/P + T_inf)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoWorkStealing) {
      println("==================================================")
      println("  SciAlgo: Escalonamento Work Stealing (Cilk Deque)")
      println("==================================================")

      #L Simulação com 3 processadores/workers: W1, W2, W3
      #L Deque do Trabalhador W1 representado por fila linear com ponteiros top e bottom
      #L Tarefas: [10, 20, 30, 40, 50, 60]
      mut as list of int64: deque1 = [10, 20, 30, 40, 50, 60]
      mut as int64: top1 = 1      #L Roubo ocorre no Top (FIFO)
      mut as int64: bottom1 = 6   #L Execução local ocorre no Bottom (LIFO)

      #L Contadores de tarefas executadas por cada worker
      mut as int64: done_w1 = 0
      mut as int64: done_w2 = 0
      mut as int64: done_w3 = 0

      println("1. Estado Inicial:")
      println("   W1 possui 6 tarefas no deque local (Top=10 ... Bottom=60).")
      println("   W2 e W3 estão ociosos (deques vazios).")

      #L ----------------------------------------------------
      #L Rodada 1: W1 executa local; W2 e W3 roubam do Top
      #L ----------------------------------------------------
      println("2. [Rodada 1]")
      #L W1 consome do bottom
      route {
            bottom1 >= top1 ==> {
                  mut as int64: t_w1 = deque1[bottom1]
                  bottom1 = bottom1 - 1
                  done_w1 = done_w1 + 1
                  println("   -> W1 consome tarefa local " + t_w1 + " do Bottom (LIFO).")
            }
      }

      #L W2 ocioso rouba do top de W1
      route {
            top1 <= bottom1 ==> {
                  mut as int64: t_w2 = deque1[top1]
                  top1 = top1 + 1
                  done_w2 = done_w2 + 1
                  println("   -> W2 (ocioso) rouba tarefa " + t_w2 + " do Top de W1 (FIFO).")
            }
      }

      #L W3 ocioso rouba do top de W1
      route {
            top1 <= bottom1 ==> {
                  mut as int64: t_w3 = deque1[top1]
                  top1 = top1 + 1
                  done_w3 = done_w3 + 1
                  println("   -> W3 (ocioso) rouba tarefa " + t_w3 + " do Top de W1 (FIFO).")
            }
      }

      #L ----------------------------------------------------
      #L Rodada 2: W1 executa local; W2 e W3 tentam roubar
      #L ----------------------------------------------------
      println("3. [Rodada 2]")
      route {
            bottom1 >= top1 ==> {
                  mut as int64: t2_w1 = deque1[bottom1]
                  bottom1 = bottom1 - 1
                  done_w1 = done_w1 + 1
                  println("   -> W1 consome tarefa local " + t2_w1 + " do Bottom.")
            }
      }

      route {
            top1 <= bottom1 ==> {
                  mut as int64: t2_w2 = deque1[top1]
                  top1 = top1 + 1
                  done_w2 = done_w2 + 1
                  println("   -> W2 rouba tarefa " + t2_w2 + " do Top de W1.")
            }
      }

      route {
            top1 <= bottom1 ==> {
                  mut as int64: t2_w3 = deque1[top1]
                  top1 = top1 + 1
                  done_w3 = done_w3 + 1
                  println("   -> W3 rouba tarefa " + t2_w3 + " do Top de W1.")
            }
            _ ==> {
                  println("   -> W3 tenta roubar de W1 mas deque está reservado.")
            }
      }

      #L ----------------------------------------------------
      #L Rodada 3: W1 executa última tarefa restante
      #L ----------------------------------------------------
      println("4. [Rodada 3]")
      route {
            bottom1 >= top1 ==> {
                  mut as int64: t3_w1 = deque1[bottom1]
                  bottom1 = bottom1 - 1
                  done_w1 = done_w1 + 1
                  println("   -> W1 consome tarefa final " + t3_w1 + " do Bottom.")
            }
      }

      println("5. Balanço Final da Distribuição de Carga:")
      println("   -> Tarefas concluídas por W1: " + done_w1)
      println("   -> Tarefas concluídas por W2 (roubos): " + done_w2)
      println("   -> Tarefas concluídas por W3 (roubos): " + done_w3)
      mut as int64: total_done = done_w1 + done_w2 + done_w3
      println("   Total de tarefas concluídas: " + total_done + " de 6")
      println("   Carga balanceada com sucesso pelo algoritmo Work Stealing.")
}
