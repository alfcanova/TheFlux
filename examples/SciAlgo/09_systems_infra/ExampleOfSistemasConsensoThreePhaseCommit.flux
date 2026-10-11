#L ============================================================================
#L Algoritmo: Protocolo de Commit em Três Fases (Three-Phase Commit - 3PC)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(N) mensagens com recuperação não-bloqueante via Pre-Commit
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoThreePhaseCommit) {
      println("==================================================")
      println("  SciAlgo: Protocolo Three-Phase Commit (3PC)")
      println("==================================================")

      #L Estados: 0 = INIT, 1 = READY, 2 = PRECOMMIT, 3 = COMMITTED, 4 = ABORTED
      mut as int64: num_cohorts = 3

      #L ========================================================================
      #L Cenário 1: Fluxo Nominal de 3 Fases (Can-Commit -> Pre-Commit -> Do-Commit)
      #L ========================================================================
      println("--- Cenário 1: Execução Nominal Sem Falhas (TX-201) ---")
      mut as list of int64: states = [0, 0, 0]

      #L Fase 1: Can-Commit?
      println("1. [Fase 1: Can-Commit] Coordenador consulta os 3 participantes:")
      mut as bool: can_all = true
      mut as int64: c = 1
      infinite (c <= num_cohorts) {
            states[c] = 1 #L READY
            println("   -> Participante C" + c + " responde VOTE_YES (estado: READY)")
            c = c + 1
      }

      #L Fase 2: Pre-Commit
      println("2. [Fase 2: Pre-Commit] Todos votaram SIM. Coordenador propaga PRE_COMMIT:")
      c = 1
      infinite (c <= num_cohorts) {
            states[c] = 2 #L PRECOMMIT
            println("   -> Participante C" + c + " transita para PRECOMMIT (envia ACK)")
            c = c + 1
      }

      #L Fase 3: Do-Commit
      println("3. [Fase 3: Do-Commit] ACKs recebidos. Coordenador efetiva DO_COMMIT:")
      c = 1
      infinite (c <= num_cohorts) {
            states[c] = 3 #L COMMITTED
            println("   -> Participante C" + c + " efetiva mudanca: COMMITTED")
            c = c + 1
      }
      println("   TX-201 concluida com sucesso nas 3 fases.")

      #L ========================================================================
      #L Cenário 2: Falha do Coordenador na Fase Pre-Commit (Protocolo de Término)
      #L ========================================================================
      println("")
      println("--- Cenário 2: Falha do Coordenador em Pre-Commit (Recuperação Não-Bloqueante) ---")
      mut as list of int64: states2 = [0, 0, 0]

      #L Fase 1 e 2 ocorrem, participantes estao em PRECOMMIT
      c = 1
      infinite (c <= num_cohorts) {
            states2[c] = 2 #L PRECOMMIT
            c = c + 1
      }
      println("1. Participantes C1, C2, C3 ja haviam alcancado estado PRECOMMIT.")
      println("2. Coordenador original sofre crash antes de enviar DO_COMMIT (timeout detectado).")

      #L Protocolo de Termino do 3PC (Skeen)
      #L Participantes elegem novo lider (ex: C1)
      println("3. Eleicao de novo coordenador temporario: C1 assume o protocolo de termino.")
      println("4. C1 coleta o estado dos participantes remanescentes:")
      mut as bool: any_precommit = false
      mut as bool: any_committed = false
      c = 1
      infinite (c <= num_cohorts) {
            mut as int64: st = states2[c]
            println("   -> Participante C" + c + " reporta estado " + st + " (PRECOMMIT)")
            route {
                  st == 2 ==> {
                        any_precommit = true
                  }
                  st == 3 ==> {
                        any_committed = true
                  }
            }
            c = c + 1
      }

      #L Regra do 3PC: Se pelo menos um participante esta em PRECOMMIT e nenhum em ABORT,
      #L e seguro e compulsorio concluir o commit global.
      route {
            any_precommit or any_committed ==> {
                  println("5. Decisao do Novo Coordenador: Todos estao em Pre-Commit, nenhum abortou.")
                  println("   Transmitindo ordem de DO_COMMIT para desempatar e destravar participantes!")
                  c = 1
                  infinite (c <= num_cohorts) {
                        states2[c] = 3 #L COMMITTED
                        println("   -> Participante C" + c + " transita com seguranca para COMMITTED.")
                        c = c + 1
                  }
            }
      }

      println("6. Propriedade não-bloqueante do 3PC confirmada com sucesso.")
}
