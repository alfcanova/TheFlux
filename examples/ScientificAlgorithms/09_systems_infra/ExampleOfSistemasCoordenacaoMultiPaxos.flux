#L ============================================================================
#L Algoritmo: Multi-Paxos Consensus Protocol
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: 1 Round-Trip por comando com lider estavel | Quorum Majoritario
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoMultiPaxos) {
      println("==================================================")
      println("  SciAlgo: Multi-Paxos Replicated Log Protocol")
      println("==================================================")

      #L O Multi-Paxos otimiza o Paxos basico para fluxos de comandos de log:
      #L A Fase 1 (Prepare/Promise) e executada uma unica vez para eleger o lider
      #L e adquirir o direito de propor em todos os slots subsequentes.
      #L Comandos seguintes requerem apenas a Fase 2 (Accept/Accepted),
      #L reduzindo a latencia de 2 RTTs para 1 RTT por operacao.

      mut as int64: num_nodes = 3
      mut as int64: quorum = 2
      mut as int64: leader_id = 1
      mut as int64: ballot_number = 10

      println("1. Fase 1 Global: Eleicao e Consolidacao do Lider")
      println("   No " + leader_id + " eleito lider com Ballot = " + ballot_number)
      println("   Promessas recebidas dos nós 1, 2 e 3 (Quorum majoritario alcancado).")
      println("   Otimizacao ativada: Fase 1 omitida para todos os slots seguintes!")

      #L Estado do log distribuido em cada um dos 3 nós (3 slots por nó)
      #L Flat array: (node - 1) * 3 + slot
      mut as list of int64: replica_logs = [0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: commit_indices = [0, 0, 0]

      #L Comandos a replicar: [CMD_SET_X = 101, CMD_SET_Y = 202, CMD_SET_Z = 303]
      mut as list of int64: commands = [101, 202, 303]
      mut as int64: num_commands = 3

      println("2. Replicando Sequencia de Comandos via Fase 2 Direta:")
      mut as int64: slot = 1
      infinite (slot <= num_commands) {
            mut as int64: cmd = commands[slot]
            println("   -----------------------------------------------")
            println("   [Slot " + slot + "] Lider envia Accept(ballot=" + ballot_number + ", slot=" + slot + ", cmd=" + cmd + ")")

            #L Cada replica avalia e responde Accepted
            mut as int64: accepted_count = 0
            mut as int64: node = 1
            infinite (node <= num_nodes) {
                  #L Simula resposta da replica: todos aceitam
                  mut as int64: log_idx = (node - 1) * 3 + slot
                  replica_logs[log_idx] = cmd
                  accepted_count = accepted_count + 1
                  println("      -> Replica " + node + " registrou Accepted no Slot " + slot)
                  node = node + 1
            }

            #L Lider verifica quorum de aceitacao
            route {
                  accepted_count >= quorum ==> {
                        commit_indices[leader_id] = slot
                        println("   [Slot " + slot + " Commit] Quorum (" + accepted_count + "/" + num_nodes + ") atingido! Lider comita slot.")

                        #L Notifica replicas sobre o novo commitIndex
                        mut as int64: rep = 1
                        infinite (rep <= num_nodes) {
                              commit_indices[rep] = slot
                              rep = rep + 1
                        }
                  }
                  _ ==> {}
            }

            slot = slot + 1
      }

      println("==================================================")
      println("3. Estado Final dos Logs das Replicas:")
      mut as int64: n = 1
      infinite (n <= num_nodes) {
            mut as int64: s1 = replica_logs[(n - 1) * 3 + 1]
            mut as int64: s2 = replica_logs[(n - 1) * 3 + 2]
            mut as int64: s3 = replica_logs[(n - 1) * 3 + 3]
            println("   Replica " + n + ": [" + s1 + ", " + s2 + ", " + s3 + "] | CommitIndex = " + commit_indices[n])
            n = n + 1
      }

      println("Consistencia forte garantida em todos os nós.")
      println("==================================================")
}
