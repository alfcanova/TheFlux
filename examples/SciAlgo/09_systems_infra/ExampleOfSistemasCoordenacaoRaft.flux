#L ============================================================================
#L Algoritmo: Raft Consensus Algorithm
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(N) por rodada | Quorum Majoritario (N/2 + 1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoRaft) {
      println("==================================================")
      println("  SciAlgo: Raft Distributed Consensus Algorithm")
      println("==================================================")

      #L O protocolo Raft divide o consenso distribuido em tres subproblemas:
      #L 1. Eleicao de Lider (Leader Election)
      #L 2. Replicacao de Log (Log Replication)
      #L 3. Seguranca (Safety)

      mut as int64: num_nodes = 5
      mut as int64: quorum = 3

      #L Papeis: 1 = FOLLOWER, 2 = CANDIDATE, 3 = LEADER
      mut as list of int64: roles = [1, 1, 1, 1, 1]
      mut as list of int64: current_terms = [1, 1, 1, 1, 1]
      mut as list of int64: voted_for = [0, 0, 0, 0, 0]
      mut as list of int64: commit_indices = [0, 0, 0, 0, 0]

      println("1. Estado Inicial do Cluster (5 nós):")
      println("   Todos os nós estao em Term = 1, Papel = FOLLOWER.")

      #L ======================================================================
      #L Subproblema 1: Eleicao de Lider (Leader Election)
      #L No 1 sofre timeout de eleicao, vira candidato e inicia eleicao para Term 2
      #L ======================================================================
      mut as int64: candidate = 1
      roles[candidate] = 2 #L CANDIDATE
      current_terms[candidate] = current_terms[candidate] + 1
      voted_for[candidate] = candidate
      mut as int64: votes_received = 1

      println("2. [Eleicao de Lider] No 1 sofre timeout, incrementa Term para 2 e se autovota.")
      println("   No 1 envia RequestVote(term=2, candidateId=1) para os pares...")

      mut as int64: peer = 2
      infinite (peer <= num_nodes) {
            #L Peer avalia voto: vota se term >= current_term e nao votou no termo
            route {
                  current_terms[candidate] > current_terms[peer] ==> {
                        current_terms[peer] = current_terms[candidate]
                        voted_for[peer] = candidate
                        votes_received = votes_received + 1
                        println("   -> No " + peer + " concede voto ao Candidato 1")
                  }
                  _ ==> {}
            }
            peer = peer + 1
      }

      println("   Total de votos recebidos: " + votes_received + " / " + num_nodes)
      route {
            votes_received >= quorum ==> {
                  roles[candidate] = 3 #L LEADER
                  println("   VITORIA: No 1 obteve quorum majoritario e assumiu papel de LEADER!")
            }
            _ ==> {
                  println("   Eleicao falhou: quorum nao atingido.")
            }
      }

      #L ======================================================================
      #L Subproblema 2: Replicacao de Log (AppendEntries)
      #L Lider recebe comando do cliente (valor = 500) e replica para os seguidores
      #L ======================================================================
      println("3. [Replicacao de Log] Lider recebe comando: cmd = 500 (indice = 1)")
      mut as int64: cmd_val = 500
      mut as int64: log_index = 1
      mut as int64: leader_term = current_terms[candidate]

      mut as int64: ack_count = 1 #L Lider ja inclui no proprio log
      mut as int64: f = 2
      infinite (f <= num_nodes) {
            println("   -> Lider 1 envia AppendEntries(term=" + leader_term + ", prevIdx=0, prevTerm=0, entry=" + cmd_val + ") para No " + f)
            #L Seguidor f valida lider e aceita
            ack_count = ack_count + 1
            f = f + 1
      }

      println("4. [Commit e Aplicacao na Maquina de Estados]")
      route {
            ack_count >= quorum ==> {
                  println("   Quorum de replicacao atingido (" + ack_count + "/" + num_nodes + ")!")
                  mut as int64: k = 1
                  infinite (k <= num_nodes) {
                        commit_indices[k] = log_index
                        k = k + 1
                  }
                  println("   Lider avanca commitIndex para 1 e responde sucesso ao cliente.")
            }
            _ ==> {}
      }

      println("==================================================")
      println("5. Verificacao de Integridade do Cluster Raft:")
      println("   Lider Atual: No " + candidate)
      println("   Term Atual: " + current_terms[1])
      println("   CommitIndex de todos os nós: " + commit_indices[1])
      println("==================================================")
}
