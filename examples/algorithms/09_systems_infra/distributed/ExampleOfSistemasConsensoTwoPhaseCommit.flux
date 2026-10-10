#L ============================================================================
#L Algoritmo: Protocolo de Commit em Duas Fases (Two-Phase Commit - 2PC)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(N) mensagens por transação com N participantes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoTwoPhaseCommit) {
      println("==================================================")
      println("  SciAlgo: Protocolo Two-Phase Commit (2PC)")
      println("==================================================")

      #L Estados: 0 = INIT, 1 = PREPARED, 2 = COMMITTED, 3 = ABORTED
      mut as int64: num_participants = 3

      #L ========================================================================
      #L Caso 1: Transação Bem-Sucedida (Votação Unânime: Todos Votam SIM)
      #L ========================================================================
      println("--- Caso 1: Transacao TX-101 (Commit Global Bem-Sucedido) ---")
      mut as list of int64: states1 = [0, 0, 0] #L P1, P2, P3
      mut as list of int64: votes1 = [1, 1, 1]   #L 1 = SIM, 0 = NAO

      println("1. [Fase 1: Prepare] Coordenador envia PREPARE para P1, P2, P3.")
      mut as bool: all_yes1 = true
      mut as int64: p = 1
      infinite (p <= num_participants) {
            mut as int64: vote = votes1[p]
            route {
                  vote == 1 ==> {
                        states1[p] = 1 #L PREPARED
                        println("   -> Participante P" + p + " vota VOTE_COMMIT (preparado)")
                  }
                  _ ==> {
                        states1[p] = 3 #L ABORTED
                        all_yes1 = false
                        println("   -> Participante P" + p + " vota VOTE_ABORT (falha local)")
                  }
            }
            p = p + 1
      }

      println("2. [Fase 2: Commit] Coordenador avalia votos coletados:")
      route {
            all_yes1 ==> {
                  println("   Decisao do Coordenador: GLOBAL_COMMIT transmitido a todos.")
                  p = 1
                  infinite (p <= num_participants) {
                        states1[p] = 2 #L COMMITTED
                        println("   -> Participante P" + p + " efetiva mudanca: estado = COMMITTED (ACK enviado)")
                        p = p + 1
                  }
                  println("   Transacao TX-101 concluida com SUCESSO.")
            }
            _ ==> {
                  println("   Decisao do Coordenador: GLOBAL_ABORT transmitido a todos.")
            }
      }

      #L ========================================================================
      #L Caso 2: Transação Abortada (P2 Vota NÃO por Conflito de Recursos)
      #L ========================================================================
      println("")
      println("--- Caso 2: Transacao TX-102 (Abort Global por Falha em P2) ---")
      mut as list of int64: states2 = [0, 0, 0]
      mut as list of int64: votes2 = [1, 0, 1]   #L P2 falha/vota NAO

      println("1. [Fase 1: Prepare] Coordenador envia PREPARE para P1, P2, P3.")
      mut as bool: all_yes2 = true
      p = 1
      infinite (p <= num_participants) {
            mut as int64: vote2 = votes2[p]
            route {
                  vote2 == 1 ==> {
                        states2[p] = 1 #L PREPARED
                        println("   -> Participante P" + p + " vota VOTE_COMMIT (recursos bloqueados)")
                  }
                  _ ==> {
                        states2[p] = 3 #L ABORTED
                        all_yes2 = false
                        println("   -> Participante P" + p + " vota VOTE_ABORT (bloqueio indisponivel!)")
                  }
            }
            p = p + 1
      }

      println("2. [Fase 2: Commit/Abort] Coordenador avalia votos coletados:")
      route {
            not all_yes2 ==> {
                  println("   Decisao do Coordenador: GLOBAL_ABORT transmitido a todos.")
                  p = 1
                  infinite (p <= num_participants) {
                        states2[p] = 3 #L ABORTED
                        println("   -> Participante P" + p + " reverte transacao: estado = ABORTED (ACK enviado)")
                        p = p + 1
                  }
                  println("   Transacao TX-102 abortada e atomicidade preservada.")
            }
      }

      println("3. Execucao do protocolo Two-Phase Commit validada.")
}
