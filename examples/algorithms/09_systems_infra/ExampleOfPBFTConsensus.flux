#L ============================================================================
#L Algoritmo: Consenso Bizantino PBFT (Practical Byzantine Fault Tolerance)
#L Domínio: 09_systems_infra / Categoria: Algoritmos de Consenso e BFT
#L Complexidade: O(R^2) mensagens por consenso com R = 3f + 1 réplicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfPBFTConsensus) {
      println("==================================================")
      println("  SciAlgo: PBFT (Practical Byzantine Fault Tolerance)")
      println("==================================================")

      #L Configuracao PBFT com f=1 no bizantino (falho/malicioso)
      #L Numero total de replicas: R = 3*f + 1 = 4
      #L Replicas honestas: 1 (Lider/Primario), 2, 3
      #L Replica bizantina: 4 (envia digests forjados/inconsistentes)
      mut as int64: num_replicas = 4
      mut as int64: f = 1
      mut as int64: quorum = (2 * f) + 1  #L 3 votos necessarios

      mut as int64: view = 1
      mut as int64: seq_num = 1
      mut as int64: client_digest = 42 #L Digest autenticado da transacao cliente

      println("1. Configuracao: R=4 replicas, tolerancia f=1, quorum=" + quorum)

      #L ----------------------------------------------------
      #L Fase 1: Pre-Prepare
      #L ----------------------------------------------------
      #L O Lider (Replica 1) propoe digest 42 para view 1 e seq 1
      println("2. [Fase Pre-Prepare] Lider 1 propaga digest=" + client_digest)

      #L ----------------------------------------------------
      #L Fase 2: Prepare
      #L ----------------------------------------------------
      #L Matriz de mensagens Prepare: 4 receptoras x 4 emissoras (16 celulas)
      mut as list of int64: prepare_matrix = []
      mut as int64: ci = 1
      infinite (ci <= 16) {
            prepare_matrix = listPushBack(prepare_matrix, 0)
            ci = ci + 1
      }

      #L Replicas honestas (1, 2, 3) transmitem digest 42 a todas as replicas
      mut as int64: sender = 1
      infinite (sender <= 3) {
            mut as int64: receiver = 1
            infinite (receiver <= num_replicas) {
                  prepare_matrix[(receiver - 1) * num_replicas + sender] = client_digest
                  receiver = receiver + 1
            }
            sender = sender + 1
      }

      #L Replica bizantina 4 tenta sabotar enviando digest falso (999) para replica 1 e 3
      prepare_matrix[(1 - 1) * num_replicas + 4] = 999
      prepare_matrix[(2 - 1) * num_replicas + 4] = 0   #L Drop / silenciosa
      prepare_matrix[(3 - 1) * num_replicas + 4] = 999
      prepare_matrix[(4 - 1) * num_replicas + 4] = 999

      #L Avalia se cada replica honesta atinge o predicado PREPARED(v, s, d)
      mut as list of int64: is_prepared = [0, 0, 0, 0]
      mut as int64: r = 1
      infinite (r <= 3) {
            mut as int64: valid_votes = 0
            mut as int64: s_idx = 1
            infinite (s_idx <= num_replicas) {
                  route {
                        prepare_matrix[(r - 1) * num_replicas + s_idx] == client_digest ==> {
                              valid_votes = valid_votes + 1
                        }
                  }
                  s_idx = s_idx + 1
            }
            route {
                  valid_votes >= quorum ==> {
                        is_prepared[r] = 1
                  }
            }
            r = r + 1
      }

      println("3. [Fase Prepare] Status prepared nas replicas honestas (1..3): " + is_prepared)

      #L ----------------------------------------------------
      #L Fase 3: Commit
      #L ----------------------------------------------------
      #L Matriz de mensagens Commit: 4 receptoras x 4 emissoras
      mut as list of int64: commit_matrix = []
      ci = 1
      infinite (ci <= 16) {
            commit_matrix = listPushBack(commit_matrix, 0)
            ci = ci + 1
      }

      #L Replicas que alcancaram PREPARED transmitem mensagem COMMIT
      sender = 1
      infinite (sender <= 3) {
            route {
                  is_prepared[sender] == 1 ==> {
                        mut as int64: receiver = 1
                        infinite (receiver <= num_replicas) {
                              commit_matrix[(receiver - 1) * num_replicas + sender] = client_digest
                              receiver = receiver + 1
                        }
                  }
            }
            sender = sender + 1
      }

      #L Replica 4 bizantina envia commit invalido
      commit_matrix[(1 - 1) * num_replicas + 4] = 999

      #L Avalia se cada replica honesta atinge COMMITTED-LOCAL(v, s, d)
      mut as list of int64: is_committed = [0, 0, 0, 0]
      r = 1
      infinite (r <= 3) {
            mut as int64: commit_votes = 0
            mut as int64: s_idx = 1
            infinite (s_idx <= num_replicas) {
                  route {
                        commit_matrix[(r - 1) * num_replicas + s_idx] == client_digest ==> {
                              commit_votes = commit_votes + 1
                        }
                  }
                  s_idx = s_idx + 1
            }
            route {
                  commit_votes >= quorum ==> {
                        is_committed[r] = 1
                  }
            }
            r = r + 1
      }

      println("4. [Fase Commit] Status committed nas replicas honestas (1..3): " + is_committed)

      #L ----------------------------------------------------
      #L Verificação de Segurança e Consenso Bizantino
      #L ----------------------------------------------------
      mut as bool: consenso_alcancado = (is_committed[1] == 1) and (is_committed[2] == 1) and (is_committed[3] == 1)
      println("5. Transacao executada com seguranca apesar da replica bizantina: " + consenso_alcancado)
      println("==================================================")
}
