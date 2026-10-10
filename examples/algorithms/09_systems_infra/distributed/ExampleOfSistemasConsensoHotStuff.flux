#L ============================================================================
#L Algoritmo: Consenso HotStuff BFT (Pipelined 3-Phase Consensus)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(N) mensagens por fase com Quorum Certificates (QCs) lineares
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoHotStuff) {
      println("==================================================")
      println("  SciAlgo: HotStuff BFT (Regra do 3-Chain)")
      println("==================================================")

      #L Configuração do cluster HotStuff: N = 4 réplicas (f=1 tolerância)
      #L Quorum necessário para QC: 2f + 1 = 3 assinaturas
      mut as int64: num_nodes = 4
      mut as int64: f = 1
      mut as int64: quorum = 3
      mut as int64: leader = 1

      #L Bloco proposto pelo líder na view 1
      mut as int64: block_id = 1
      mut as int64: block_digest = 55

      println("1. Cluster HotStuff: N=4 réplicas, Quorum QC = " + quorum + ", Líder = Nó " + leader)
      println("   Líder propõe Bloco " + block_id + " (Digest " + block_digest + ")")

      #L ----------------------------------------------------
      #L Fase 1: Prepare
      #L ----------------------------------------------------
      println("2. [Fase 1: Prepare] Líder propõe bloco para a view 1:")
      mut as int64: prepare_votes = 0
      mut as int64: node = 1
      infinite (node <= 3) { #L Nós honestos 1, 2, 3 votam
            println("   -> Nó " + node + " valida e emite voto de Prepare.")
            prepare_votes = prepare_votes + 1
            node = node + 1
      }

      mut as bool: has_prepare_qc = false
      route {
            prepare_votes >= quorum ==> {
                  has_prepare_qc = true
                  println("   => Líder agrega " + prepare_votes + " votos e gera PrepareQC(" + block_id + ")")
            }
      }

      #L ----------------------------------------------------
      #L Fase 2: Pre-Commit
      #L ----------------------------------------------------
      println("3. [Fase 2: Pre-Commit] Líder transmite PrepareQC:")
      mut as int64: precommit_votes = 0
      node = 1
      infinite (node <= 3) {
            println("   -> Nó " + node + " verifica PrepareQC e emite voto de Pre-Commit.")
            precommit_votes = precommit_votes + 1
            node = node + 1
      }

      mut as bool: has_precommit_qc = false
      route {
            precommit_votes >= quorum ==> {
                  has_precommit_qc = true
                  println("   => Líder agrega " + precommit_votes + " votos e gera PreCommitQC(" + block_id + ")")
            }
      }

      #L ----------------------------------------------------
      #L Fase 3: Commit
      #L ----------------------------------------------------
      println("4. [Fase 3: Commit] Líder transmite PreCommitQC:")
      mut as list of int64: locked_qc = [0, 0, 0, 0]
      mut as int64: commit_votes = 0
      node = 1
      infinite (node <= 3) {
            #L Nós travam o bloco (Locked QC)
            locked_qc[node] = block_id
            println("   -> Nó " + node + " adquire trava (Lock) no Bloco " + block_id + " e emite voto de Commit.")
            commit_votes = commit_votes + 1
            node = node + 1
      }

      mut as bool: has_commit_qc = false
      route {
            commit_votes >= quorum ==> {
                  has_commit_qc = true
                  println("   => Líder agrega " + commit_votes + " votos e gera CommitQC(" + block_id + ")")
            }
      }

      #L ----------------------------------------------------
      #L Fase 4: Decide (Efetivação no Ledger)
      #L ----------------------------------------------------
      println("5. [Fase 4: Decide] Líder propaga CommitQC a todo o cluster:")
      mut as list of bool: committed_ledger = [false, false, false, false]
      route {
            has_commit_qc ==> {
                  node = 1
                  infinite (node <= 3) {
                        committed_ledger[node] = true
                        println("   -> Nó " + node + ": Bloco " + block_id + " efetivado permanentemente no Ledger!")
                        node = node + 1
                  }
            }
      }

      println("6. Protocolo HotStuff BFT concluído com sucesso e linearidade de comunicação.")
}
