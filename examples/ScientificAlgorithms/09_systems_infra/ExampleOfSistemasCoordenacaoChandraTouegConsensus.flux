#L ============================================================================
#L Algoritmo: Chandra-Toueg Consensus (Rotating Coordinator with <>S)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(N) por rodada | Quorum Majoritario (N/2 + 1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoChandraTouegConsensus) {
      println("==================================================")
      println("  SciAlgo: Chandra-Toueg Consensus Algorithm")
      println("==================================================")

      #L O algoritmo de Chandra-Toueg resolve consenso assincrono utilizando
      #L um detector de falhas nao-confiavel da classe <>S (Eventually Strong).
      #L O algoritmo opera em rodadas com coordenador rotativo:
      #L c = ((round - 1) % N) + 1.

      mut as int64: num_nodes = 3
      mut as int64: quorum = 2

      #L Estado de cada processo: estimate e timestamp do estimate
      mut as list of int64: estimates = [10, 20, 30]
      mut as list of int64: timestamps = [0, 0, 0]
      mut as list of int64: decided = [0, 0, 0]

      println("1. Estado Inicial:")
      println("   Processos: 3 | Quorum: 2")
      println("   Estimativas Iniciais: P1 = " + estimates[1] + ", P2 = " + estimates[2] + ", P3 = " + estimates[3])

      #L ======================================================================
      #L Rodada 1: Coordenador = P1 (Simulacao de Falha / Suspeita <>S)
      #L ======================================================================
      mut as int64: r1 = 1
      mut as int64: c1 = 1
      println("2. [Rodada 1] Coordenador Rotativo = P" + c1)
      println("   Detector de Falhas <>S suspeita de P1 (timeout de comunicacao).")
      println("   Processos P2 e P3 enviam NACK para P1 e avancam de rodada sem decidir.")

      #L ======================================================================
      #L Rodada 2: Coordenador = P2 (Coordenador correto alcanca consenso)
      #L ======================================================================
      mut as int64: r2 = 2
      mut as int64: c2 = 2
      println("--------------------------------------------------")
      println("3. [Rodada 2] Novo Coordenador Rotativo = P" + c2)

      #L Fase 1: Processos enviam suas estimativas e timestamps para P2
      println("   [Fase 1] Processos enviam (estimate, timestamp) para P" + c2 + ":")
      mut as int64: highest_ts = -1
      mut as int64: chosen_estimate = estimates[c2]

      mut as int64: p = 1
      infinite (p <= num_nodes) {
            println("      -> P" + p + " envia (est=" + estimates[p] + ", ts=" + timestamps[p] + ")")
            route {
                  timestamps[p] > highest_ts ==> {
                        highest_ts = timestamps[p]
                        chosen_estimate = estimates[p]
                  }
                  _ ==> {}
            }
            p = p + 1
      }

      #L Fase 2: Coordenador P2 propoe a estimativa com maior timestamp
      println("   [Fase 2] Coordenador P" + c2 + " seleciona estimativa proposta: " + chosen_estimate)
      println("   [Fase 2] P" + c2 + " envia PROPOSAL(" + chosen_estimate + ") a todos os nós.")

      #L Fase 3: Processos recebem proposta e respondem ACK
      mut as int64: acks = 0
      mut as int64: v = 1
      infinite (v <= num_nodes) {
            #L Processo v aceita proposta de P2
            estimates[v] = chosen_estimate
            timestamps[v] = r2
            acks = acks + 1
            println("      -> P" + v + " adotou estimativa " + chosen_estimate + " (ts=" + r2 + ") e enviou ACK")
            v = v + 1
      }

      #L Fase 4: Coordenador recebe quorum de ACKs e comita decisao
      println("4. [Fase 4: Decisao e Difusao Confiavel]")
      route {
            acks >= quorum ==> {
                  println("   Quorum de ACKs alcancado (" + acks + "/" + num_nodes + ")! Coordenador P" + c2 + " decide.")
                  println("   Broadcast de DECIDE(" + chosen_estimate + ") enviado a todos os processos.")
                  mut as int64: k = 1
                  infinite (k <= num_nodes) {
                        decided[k] = chosen_estimate
                        k = k + 1
                  }
            }
            _ ==> {}
      }

      println("==================================================")
      println("5. Verificacao Final do Consenso Chandra-Toueg:")
      println("   Decisao P1: " + decided[1])
      println("   Decisao P2: " + decided[2])
      println("   Decisao P3: " + decided[3])
      println("   Consenso alcancado de forma unanime: " + decided[1])
      println("==================================================")
}
