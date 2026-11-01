#L ============================================================================
#L Algoritmo: Bully Election Algorithm (Garcia-Molina)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(N^2) mensagens no pior caso
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoBullyAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Bully Leader Election Algorithm")
      println("==================================================")

      #L O algoritmo Bully elege como lider o processo ativo de maior ID.
      #L Quando um processo detecta falha do lider, envia mensagem ELECTION
      #L a todos os nós de maior ID. Se receber resposta de algum deles,
      #L o processo recua. Caso nao receba resposta dentro do timeout,
      #L declara-se o novo coordenador (COORDINATOR).

      mut as int64: num_nodes = 5

      #L Estado dos nós: 1 = ATIVO, 0 = FALHO/CRASHED
      mut as list of int64: node_status = [1, 1, 1, 1, 0] #L No 5 esta caido
      mut as list of int64: coordinator = [5, 5, 5, 5, 5]

      println("1. Estado Inicial:")
      println("   Total de nós: 5 (IDs: 1 a 5)")
      println("   Lider anterior (No 5) falhou (status = 0).")

      #L No 2 detecta que o lider 5 nao responde e inicia a eleicao
      mut as int64: initiator = 2
      println("2. [Deteccao de Falha] No " + initiator + " detecta timeout do lider 5 e inicia Eleicao.")

      #L No 2 envia ELECTION para todos os nós com ID > 2
      mut as int64: answers_to_2 = 0
      mut as int64: h = initiator + 1
      infinite (h <= num_nodes) {
            println("   -> No " + initiator + " envia ELECTION para No " + h)
            route {
                  node_status[h] == 1 ==> {
                        answers_to_2 = answers_to_2 + 1
                        println("      <- No " + h + " responde OK (intimidando No " + initiator + ")")
                  }
                  _ ==> {
                        println("      <- No " + h + " nao responde (inativo/timeout)")
                  }
            }
            h = h + 1
      }

      println("   No " + initiator + " recebeu resposta de nós superiores e recua.")

      #L Agora os nós superiores que responderam iniciam suas proprias eleicoes.
      #L O nó ativo de maior ID sera o vencedor.
      println("3. [Propagacao Hierarquica da Eleicao]")

      mut as int64: current_candidate = initiator + 1
      mut as int64: final_leader = 0

      infinite (current_candidate <= num_nodes) {
            route {
                  node_status[current_candidate] == 1 ==> {
                        println("   [Candidatura] No " + current_candidate + " assume e convoca eleicao:")
                        mut as int64: higher_answers = 0
                        mut as int64: next_peer = current_candidate + 1
                        infinite (next_peer <= num_nodes) {
                              println("      -> No " + current_candidate + " envia ELECTION para No " + next_peer)
                              route {
                                    node_status[next_peer] == 1 ==> {
                                          higher_answers = higher_answers + 1
                                          println("         <- No " + next_peer + " responde OK")
                                    }
                                    _ ==> {
                                          println("         <- No " + next_peer + " nao responde (falho)")
                                    }
                              }
                              next_peer = next_peer + 1
                        }

                        route {
                              higher_answers == 0 ==> {
                                    final_leader = current_candidate
                                    println("   -> Nenhum nó com ID superior respondeu a No " + current_candidate + "!")
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            current_candidate = current_candidate + 1
      }

      #L O vencedor transmite mensagem COORDINATOR para todos os nós ativos
      println("4. [Declaracao do Novo Coordenador]")
      println("   No " + final_leader + " declara-se o novo LIDER e envia COORDINATOR aos pares!")

      mut as int64: n = 1
      infinite (n <= num_nodes) {
            route {
                  node_status[n] == 1 ==> {
                        coordinator[n] = final_leader
                        println("   -> No " + n + " atualizou coordenador para: No " + final_leader)
                  }
                  _ ==> {}
            }
            n = n + 1
      }

      println("==================================================")
      println("5. Verificacao Final: Lider Eleito = No " + final_leader)
      println("==================================================")
}
