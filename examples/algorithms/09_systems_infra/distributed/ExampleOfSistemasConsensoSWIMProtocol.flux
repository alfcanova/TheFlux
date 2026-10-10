#L ============================================================================
#L Algoritmo: Protocolo de Associação SWIM (SWIM Membership Protocol)
#L Domínio: 09_systems_infra / Categoria: Consenso e Sistemas Distribuídos
#L Complexidade: O(1) mensagens por nó por período, detecção de falhas O(log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConsensoSWIMProtocol) {
      println("==================================================")
      println("  SciAlgo: SWIM Membership Protocol (Ping-Req)")
      println("==================================================")

      #L Estados: 0 = ALIVE, 1 = SUSPECT, 2 = DEAD
      mut as list of int64: states = [0, 0, 0, 0, 0, 0]
      mut as list of int64: incarnations = [0, 0, 0, 0, 0, 0]
      mut as int64: num_nodes = 6

      println("1. Cluster inicializado com 6 nós (todos ALIVE, encarnação 0).")

      #L Matriz de conectividade de rede (1 = rota aberta, 0 = rota interrompida/drop)
      #L Dimensao: 6x6 achatada
      mut as list of int64: net = []
      mut as int64: idx = 1
      infinite (idx <= 36) {
            net = listPushBack(net, 1)
            idx = idx + 1
      }

      #L Cenário de falha simulado:
      #L Rota direta entre No 1 e No 4 esta instavel (drop)
      net[(1 - 1) * 6 + 4] = 0
      #L Mas rotas indiretas via No 2 e No 3 para No 4 estao ativas (net[(2-1)*6 + 4] = 1)

      #L No 6 esta completamente inoperante (todas as rotas de entrada desligadas)
      mut as int64: s = 1
      infinite (s <= 6) {
            net[(s - 1) * 6 + 6] = 0
            s = s + 1
      }

      #L ------------------------------------------------------------------------
      #L Periodo 1: No 1 sonda No 2 com Ping Direto
      #L ------------------------------------------------------------------------
      println("2. [Periodo 1] No 1 envia Ping direto para No 2:")
      mut as int64: link_1_2 = net[(1 - 1) * 6 + 2]
      route {
            link_1_2 == 1 ==> {
                  println("   -> ACK recebido do No 2. Estado mantido: ALIVE")
            }
            _ ==> {
                  println("   -> Timeout de No 2.")
            }
      }

      #L ------------------------------------------------------------------------
      #L Periodo 2: No 1 sonda No 4 (falha direta, recuperacao via Ping-Req indireto)
      #L ------------------------------------------------------------------------
      println("3. [Periodo 2] No 1 envia Ping direto para No 4:")
      mut as int64: link_1_4 = net[(1 - 1) * 6 + 4]
      route {
            link_1_4 == 1 ==> {
                  println("   -> ACK recebido diretamente.")
            }
            _ ==> {
                  println("   -> TIMEOUT direto com No 4. Acionando Ping-Req indireto...")
                  #L No 1 solicita ping indireto aos ajudantes No 2 e No 3
                  mut as bool: indirect_ack = false
                  mut as list of int64: helpers = [2, 3]
                  mut as int64: h = 1
                  infinite (h <= 2) {
                        mut as int64: helper = helpers[h]
                        mut as int64: link_h_target = net[(helper - 1) * 6 + 4]
                        mut as int64: link_h_sender = net[(helper - 1) * 6 + 1]
                        route {
                              link_h_target == 1 and link_h_sender == 1 ==> {
                                    println("   -> Ajudante No " + helper + " sondou No 4 com sucesso e retransmitiu ACK!")
                                    indirect_ack = true
                                    break
                              }
                        }
                        h = h + 1
                  }
                  route {
                        indirect_ack ==> {
                              println("   -> Falso positivo evitado: No 4 permanece ALIVE.")
                        }
                        _ ==> {
                              states[4] = 1 #L SUSPECT
                              println("   -> Ping indireto falhou. No 4 marcado como SUSPECT.")
                        }
                  }
            }
      }

      #L ------------------------------------------------------------------------
      #L Periodo 3: No 1 sonda No 6 (No inoperante: falha direta e indireta)
      #L ------------------------------------------------------------------------
      println("4. [Periodo 3] No 1 envia Ping direto para No 6:")
      mut as int64: link_1_6 = net[(1 - 1) * 6 + 6]
      mut as bool: ind_ack_6 = false
      route {
            link_1_6 == 1 ==> {
                  println("   -> ACK recebido.")
            }
            _ ==> {
                  println("   -> TIMEOUT direto com No 6. Acionando Ping-Req indireto via [2, 3]...")
                  mut as list of int64: helpers2 = [2, 3]
                  mut as int64: h2 = 1
                  infinite (h2 <= 2) {
                        mut as int64: helper2 = helpers2[h2]
                        mut as int64: l_target = net[(helper2 - 1) * 6 + 6]
                        route {
                              l_target == 1 ==> {
                                    ind_ack_6 = true
                                    break
                              }
                        }
                        h2 = h2 + 1
                  }
                  route {
                        not ind_ack_6 ==> {
                              states[6] = 1 #L SUSPECT
                              incarnations[6] = incarnations[6] + 1
                              println("   -> Falha confirmada por todos os ajudantes! No 6 alterado para SUSPECT (encarnacao " + incarnations[6] + ").")
                        }
                  }
            }
      }

      #L ------------------------------------------------------------------------
      #L Periodo 4: Expiracao da suspeita sem contestacao (Rebuttal)
      #L ------------------------------------------------------------------------
      println("5. [Periodo 4] Verificacao do temporizador de suspeita para No 6:")
      route {
            states[6] == 1 ==> {
                  states[6] = 2 #L Transita para DEAD
                  println("   -> Timeout de suspeita expirado sem contestacao. No 6 declarado DEAD.")
                  println("   -> Mensagem {DEAD, Node 6, Incarnation 1} anexada ao protocolo de fofoca.")
            }
      }

      #L ------------------------------------------------------------------------
      #L Tabela final de associacao (Membership Table)
      #L ------------------------------------------------------------------------
      println("6. Tabela final de associação do SWIM:")
      mut as int64: n = 1
      infinite (n <= num_nodes) {
            mut as int64: st = states[n]
            mut as string: st_str = "ALIVE"
            route {
                  st == 1 ==> {
                        st_str = "SUSPECT"
                  }
                  st == 2 ==> {
                        st_str = "DEAD"
                  }
            }
            println("   No " + n + ": Estado = " + st_str + " | Encarnacao = " + incarnations[n])
            n = n + 1
      }
}
