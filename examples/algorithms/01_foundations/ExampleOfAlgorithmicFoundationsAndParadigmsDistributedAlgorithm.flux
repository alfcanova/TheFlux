#L ============================================================================
#L Algoritmo: Distributed Algorithm (Algoritmo Distribuido / Eleicao em Anel)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N log N) mensagens medio | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsDistributedAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Distributed Algorithm (Eleicao em Anel)")
      println("==================================================")

      #L Topologia em anel distribuido unidirecional com N = 6 nos
      #L Cada no possui um identificador unico UID
      mut as list of int64: uids = [17, 42, 5, 88, 23, 9]
      mut as int64: n_nodes = listLength(uids)
      println("1. Identificadores dos nos no anel: " + uids)

      #L Caixas de entrada (inboxes) para simulacao de passagem de mensagens
      #L Inicialmente cada no inicia enviando sua propria UID para seu vizinho a direita
      mut as list of int64: msg_src = []
      mut as list of int64: msg_dest = []
      mut as list of int64: msg_val = []

      mut as int64: init_i = 1
      infinite (init_i <= n_nodes) {
            mut as int64: next_neighbor = (init_i /r n_nodes) + 1
            msg_src = listPushBack(msg_src, init_i)
            msg_dest = listPushBack(msg_dest, next_neighbor)
            msg_val = listPushBack(msg_val, uids[init_i])
            init_i = init_i + 1
      }

      mut as int64: total_messages = listLength(msg_val)
      mut as int64: elected_leader = 0
      mut as int64: leader_node_idx = 0
      mut as int64: rounds = 0

      #L Execucao assincrona por rodadas de despacho de mensagens (Algoritmo de Chang-Roberts)
      infinite (listLength(msg_val) > 0 and elected_leader == 0) {
            rounds = rounds + 1
            mut as list of int64: next_src = []
            mut as list of int64: next_dest = []
            mut as list of int64: next_val = []

            mut as int64: m_idx = 1
            mut as int64: num_msgs = listLength(msg_val)

            infinite (m_idx <= num_msgs and elected_leader == 0) {
                  mut as int64: dest = msg_dest[m_idx]
                  mut as int64: val = msg_val[m_idx]
                  mut as int64: dest_uid = uids[dest]

                  route {
                        val > dest_uid ==> {
                              #L Encaminha a mensagem adiante no anel
                              mut as int64: fwd = (dest /r n_nodes) + 1
                              next_src = listPushBack(next_src, dest)
                              next_dest = listPushBack(next_dest, fwd)
                              next_val = listPushBack(next_val, val)
                              total_messages = total_messages + 1
                        }
                        val == dest_uid ==> {
                              #L A mensagem completou o ciclo: este no e o Lider!
                              elected_leader = val
                              leader_node_idx = dest
                        }
                        _ ==> {
                              #L val < dest_uid: descarta a mensagem (poda distribuida)
                        }
                  }
                  m_idx = m_idx + 1
            }

            msg_src = next_src
            msg_dest = next_dest
            msg_val = next_val
      }

      println("2. Rodadas de comunicacao distribuida: " + rounds)
      println("3. Total de mensagens transitadas pela rede: " + total_messages)
      println("4. Lider eleito democraticamente (UID): " + elected_leader)
      println("5. Indice do no lider no anel: " + leader_node_idx)
      println("Concluido com Sucesso")
}
