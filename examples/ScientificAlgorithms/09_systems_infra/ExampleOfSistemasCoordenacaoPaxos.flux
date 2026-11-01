#L ============================================================================
#L Algoritmo: Paxos Consensus Algorithm (Single-Decree Paxos)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(N) por rodada de proposta | Quorum Majoritario (N/2 + 1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoPaxos) {
      println("==================================================")
      println("  SciAlgo: Paxos Consensus (Single-Decree)")
      println("==================================================")

      #L O algoritmo Paxos garante consenso em sistemas distribuidos assincronos
      #L com tolerancia a falhas de parada (crash-recovery).
      #L Papeis: Propositores (Proposers) e Aceitadores (Acceptors).
      #L
      #L Configuracao:
      #L - 3 Aceitadores (Acceptor 1, 2, 3) -> Quorum majoritario = 2
      #L - Estado de cada aceitador i:
      #L   min_proposal[i]  : maior numero de proposta prometido
      #L   accepted_num[i]  : numero da proposta aceita mais recente
      #L   accepted_val[i]  : valor da proposta aceita mais recente
      mut as int64: num_acceptors = 3
      mut as int64: quorum = 2

      mut as list of int64: min_proposal = [0, 0, 0]
      mut as list of int64: accepted_num = [0, 0, 0]
      mut as list of int64: accepted_val = [0, 0, 0]

      println("1. Estado Inicial:")
      println("   Aceitadores: 3 | Quorum: 2")
      println("   Nenhum valor previamente aceito.")

      #L ======================================================================
      #L Rodada 1: Propositor 1 tenta propor Valor 100 com Proposta ID = 1
      #L ======================================================================
      mut as int64: prop1_id = 1
      mut as int64: prop1_val = 100

      println("2. [Fase 1a: Prepare] Propositor 1 envia Prepare(n = 1)")
      mut as int64: promises_p1 = 0
      mut as int64: highest_accepted_num = 0
      mut as int64: highest_accepted_val = 0

      #L Aceitador 1 e 2 respondem
      mut as int64: i = 1
      infinite (i <= 3) {
            #L Aceitador i recebe Prepare(prop1_id)
            route {
                  prop1_id > min_proposal[i] ==> {
                        min_proposal[i] = prop1_id
                        promises_p1 = promises_p1 + 1
                        println("   -> Aceitador " + i + " promete (Promise n = 1)")
                        route {
                              accepted_num[i] > highest_accepted_num ==> {
                                    highest_accepted_num = accepted_num[i]
                                    highest_accepted_val = accepted_val[i]
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {
                        println("   -> Aceitador " + i + " rejeita Prepare n = 1")
                  }
            }
            i = i + 1
      }

      println("   Total de promessas recebidas: " + promises_p1 + " / " + num_acceptors)

      #L ======================================================================
      #L Fase 2: Accept
      #L ======================================================================
      route {
            promises_p1 >= quorum ==> {
                  println("3. [Fase 2a: Accept] Quorum alcancado! Propositor 1 envia Accept(n = 1, val = 100)")
                  mut as int64: val_to_propose = prop1_val
                  route {
                        highest_accepted_num > 0 ==> {
                              val_to_propose = highest_accepted_val
                        }
                        _ ==> {}
                  }

                  mut as int64: accepts_count = 0
                  mut as int64: j = 1
                  infinite (j <= 3) {
                        #L Aceitador j aceita se n >= min_proposal[j]
                        route {
                              prop1_id >= min_proposal[j] ==> {
                                    min_proposal[j] = prop1_id
                                    accepted_num[j] = prop1_id
                                    accepted_val[j] = val_to_propose
                                    accepts_count = accepts_count + 1
                                    println("   -> Aceitador " + j + " aceitou proposta (n = 1, val = " + val_to_propose + ")")
                              }
                              _ ==> {
                                    println("   -> Aceitador " + j + " rejeitou Accept n = 1")
                              }
                        }
                        j = j + 1
                  }

                  route {
                        accepts_count >= quorum ==> {
                              println("4. [Decisao Consensual] Valor " + val_to_propose + " foi consensuado com sucesso!")
                        }
                        _ ==> {
                              println("4. Falha no consenso: quorum de accepts nao alcancado.")
                        }
                  }
            }
            _ ==> {
                  println("3. Proposta 1 rejeitada: sem quorum de promessas.")
            }
      }

      #L ======================================================================
      #L Rodada 2: Propositor 2 tenta propor Valor 200 com Proposta ID = 2
      #L Paxos garante que ele adotara o valor 100 ja aceito!
      #L ======================================================================
      println("--------------------------------------------------")
      println("5. [Fase 1a: Prepare Concorrente] Propositor 2 envia Prepare(n = 2, val = 200)")
      mut as int64: prop2_id = 2
      mut as int64: prop2_val = 200
      mut as int64: promises_p2 = 0
      mut as int64: p2_highest_num = 0
      mut as int64: p2_highest_val = 0

      mut as int64: k = 1
      infinite (k <= 3) {
            route {
                  prop2_id > min_proposal[k] ==> {
                        min_proposal[k] = prop2_id
                        promises_p2 = promises_p2 + 1
                        route {
                              accepted_num[k] > p2_highest_num ==> {
                                    p2_highest_num = accepted_num[k]
                                    p2_highest_val = accepted_val[k]
                              }
                              _ ==> {}
                        }
                        println("   -> Aceitador " + k + " promete para n = 2 (ultimo aceito: val = " + accepted_val[k] + ")")
                  }
                  _ ==> {
                        println("   -> Aceitador " + k + " rejeita Prepare n = 2")
                  }
            }
            k = k + 1
      }

      route {
            promises_p2 >= quorum ==> {
                  println("6. [Preservacao da Seguranca Paxos]")
                  mut as int64: final_prop2_val = prop2_val
                  route {
                        p2_highest_num > 0 ==> {
                              println("   Propositor 2 descobre valor ja aceito (" + p2_highest_val + ") e DEVE adota-lo!")
                              final_prop2_val = p2_highest_val
                        }
                        _ ==> {}
                  }

                  println("   Propositor 2 propoe Accept(n = 2, val = " + final_prop2_val + ")")
                  mut as int64: accepts_p2 = 0
                  mut as int64: m = 1
                  infinite (m <= 3) {
                        route {
                              prop2_id >= min_proposal[m] ==> {
                                    accepted_num[m] = prop2_id
                                    accepted_val[m] = final_prop2_val
                                    accepts_p2 = accepts_p2 + 1
                              }
                              _ ==> {}
                        }
                        m = m + 1
                  }
                  println("   Consenso mantido de forma imutavel: valor = " + final_prop2_val)
            }
            _ ==> {}
      }

      println("==================================================")
      println("  Paxos Executado com Sucesso!")
      println("==================================================")
}
