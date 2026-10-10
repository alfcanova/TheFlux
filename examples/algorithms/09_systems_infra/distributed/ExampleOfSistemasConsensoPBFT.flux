#L ============================================================================
#L Algoritmo: Consenso Bizantino PBFT (Practical Byzantine Fault Tolerance)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(R^2) mensagens por consenso com R = 3f + 1 réplicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoPBFT) {
      println("==================================================")
      println("  SciAlgo: PBFT (Practical Byzantine Fault Tolerance)")
      println("==================================================")

      #L Configuração PBFT com tolerância f=1 a nós bizantinos
      #L Número total de réplicas: R = 3*f + 1 = 4
      #L Réplicas honestas: 1 (Líder/Primário), 2, 3
      #L Réplica bizantina: 4 (envia digests forjados/inconsistentes)
      mut as int64: num_replicas = 4
      mut as int64: f = 1
      mut as int64: quorum = (2 * f) + 1  #L 3 votos necessários

      mut as int64: view = 1
      mut as int64: seq_num = 1
      mut as int64: client_digest = 42 #L Digest autenticado da transação

      println("1. Configuração do Cluster: R=4 réplicas, f=1 falha tolerada, quorum=" + quorum)

      #L ----------------------------------------------------
      #L Fase 1: Pre-Prepare
      #L ----------------------------------------------------
      println("2. [Fase Pre-Prepare] Líder 1 propaga digest=" + client_digest + " (view=" + view + ", seq=" + seq_num + ")")

      #L ----------------------------------------------------
      #L Fase 2: Prepare
      #L ----------------------------------------------------
      #L Matriz de mensagens Prepare: 4 receptoras x 4 emissoras (16 células)
      mut as list of int64: prepare_matrix = []
      mut as int64: ci = 1
      infinite (ci <= 16) {
            prepare_matrix = listPushBack(prepare_matrix, 0)
            ci = ci + 1
      }

      #L Réplicas honestas (1, 2, 3) transmitem digest 42 a todas as réplicas
      mut as int64: sender = 1
      infinite (sender <= 3) {
            mut as int64: receiver = 1
            infinite (receiver <= num_replicas) {
                  prepare_matrix[(receiver - 1) * num_replicas + sender] = client_digest
                  receiver = receiver + 1
            }
            sender = sender + 1
      }

      #L Réplica bizantina 4 tenta sabotar enviando digest falso (999) para 1 e 3, omitindo 2
      prepare_matrix[(1 - 1) * num_replicas + 4] = 999
      prepare_matrix[(2 - 1) * num_replicas + 4] = 0
      prepare_matrix[(3 - 1) * num_replicas + 4] = 999

      println("3. [Fase Prepare] Coleta de votos das réplicas:")
      mut as list of bool: prepared_state = [false, false, false, false]
      mut as int64: rep = 1
      infinite (rep <= 3) {
            mut as int64: votes = 0
            mut as int64: s_node = 1
            infinite (s_node <= num_replicas) {
                  mut as int64: d = prepare_matrix[(rep - 1) * num_replicas + s_node]
                  route {
                        d == client_digest ==> {
                              votes = votes + 1
                        }
                  }
                  s_node = s_node + 1
            }

            route {
                  votes >= quorum ==> {
                        prepared_state[rep] = true
                        println("   -> Réplica " + rep + ": Recebeu " + votes + " votos válidos => Certificado PREPARED formado!")
                  }
            }
            rep = rep + 1
      }

      #L ----------------------------------------------------
      #L Fase 3: Commit
      #L ----------------------------------------------------
      #L Réplicas no estado PREPARED transmitem mensagem COMMIT
      println("4. [Fase Commit] Réplicas preparadas transmitem mensagens COMMIT:")
      mut as list of int64: commit_matrix = []
      ci = 1
      infinite (ci <= 16) {
            commit_matrix = listPushBack(commit_matrix, 0)
            ci = ci + 1
      }

      sender = 1
      infinite (sender <= 3) {
            route {
                  prepared_state[sender] ==> {
                        mut as int64: rec = 1
                        infinite (rec <= num_replicas) {
                              commit_matrix[(rec - 1) * num_replicas + sender] = 1 #L Voto de Commit
                              rec = rec + 1
                        }
                  }
            }
            sender = sender + 1
      }

      mut as list of bool: committed_state = [false, false, false, false]
      rep = 1
      infinite (rep <= 3) {
            mut as int64: commit_votes = 0
            mut as int64: s_node = 1
            infinite (s_node <= num_replicas) {
                  mut as int64: c_vote = commit_matrix[(rep - 1) * num_replicas + s_node]
                  route {
                        c_vote == 1 ==> {
                              commit_votes = commit_votes + 1
                        }
                  }
                  s_node = s_node + 1
            }

            route {
                  commit_votes >= quorum ==> {
                        committed_state[rep] = true
                        println("   -> Réplica " + rep + ": Recebeu " + commit_votes + " votos de commit => Estado COMMITTED alcançado!")
                  }
            }
            rep = rep + 1
      }

      println("5. Transação autenticada executada com sucesso sob tolerância bizantina.")
}
