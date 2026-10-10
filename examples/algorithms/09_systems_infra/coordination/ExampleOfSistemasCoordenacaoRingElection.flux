#L ============================================================================
#L Algoritmo: Ring Election Algorithm (Chang-Roberts)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(N log N) medio | O(N^2) pior caso de mensagens
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoRingElection) {
      println("==================================================")
      println("  SciAlgo: Ring Leader Election (Chang-Roberts)")
      println("==================================================")

      #L O algoritmo de Chang-Roberts organiza os nós em um anel logico
      #L unidirecional (1 -> 2 -> 3 -> ... -> N -> 1).
      #L Cada nó possui um identificador unico.
      #L Mensagens contendo o maior ID circulam pelo anel; IDs menores sao descartados.
      #L Quando um nó recebe seu proprio ID de volta, ele foi eleito líder!

      mut as int64: num_nodes = 6
      #L Identificadores dos nós posicionados no anel (indices 1 a 6)
      mut as list of int64: node_ids = [17, 42, 5, 89, 23, 61]
      mut as list of int64: elected_leaders = [0, 0, 0, 0, 0, 0]

      println("1. Topologia do Anel Logico:")
      mut as int64: p = 1
      infinite (p <= num_nodes) {
            mut as int64: nxt = (p /r num_nodes) + 1
            println("   No Posicao " + p + " (ID=" + node_ids[p] + ") -> Sucessor Posicao " + nxt + " (ID=" + node_ids[nxt] + ")")
            p = p + 1
      }

      #L ======================================================================
      #L Simulacao da Eleicao: Posicao 3 (ID = 5) inicia a eleicao
      #L ======================================================================
      mut as int64: initiator_pos = 3
      println("2. [Inicio da Eleicao] Posicao " + initiator_pos + " (ID=" + node_ids[initiator_pos] + ") detecta falha e lanca ELECTION(" + node_ids[initiator_pos] + ")")

      #L Acompanhamento da circulacao do token de maior valor
      mut as int64: current_token = node_ids[initiator_pos]
      mut as int64: current_pos = initiator_pos
      mut as int64: leader_pos = 0
      mut as int64: leader_id = 0
      mut as int64: total_messages = 0

      mut as int64: election_active = 1
      infinite (election_active == 1) {
            #L Proximo nó no anel
            mut as int64: next_pos = (current_pos /r num_nodes) + 1
            mut as int64: next_id = node_ids[next_pos]
            total_messages = total_messages + 1

            println("   -> Token ID=" + current_token + " chega na Posicao " + next_pos + " (ID=" + next_id + ")")

            route {
                  current_token > next_id ==> {
                        println("      [Propagacao] " + current_token + " > " + next_id + " -> Repassa token adiante.")
                        current_pos = next_pos
                  }
                  current_token < next_id ==> {
                        println("      [Substituicao] " + current_token + " < " + next_id + " -> Adota maior ID (" + next_id + ") e repassa.")
                        current_token = next_id
                        current_pos = next_pos
                  }
                  _ ==> {
                        #L current_token == next_id: token completou a volta inteira no anel!
                        leader_pos = next_pos
                        leader_id = current_token
                        election_active = 0
                        println("      [Vitoria] Token ID=" + current_token + " retornou a sua origem! LIDER ELEITO!")
                  }
            }
      }

      println("3. [Difusao do Coordenador]")
      println("   No Posicao " + leader_pos + " (ID=" + leader_id + ") transmite COORDINATOR(" + leader_id + ") pelo anel.")

      mut as int64: k = 1
      infinite (k <= num_nodes) {
            elected_leaders[k] = leader_id
            k = k + 1
      }

      println("==================================================")
      println("4. Verificacao Final do Anel:")
      println("   Lider Eleito: ID = " + leader_id + " (na Posicao " + leader_pos + ")")
      println("   Total de mensagens de eleicao: " + total_messages)
      println("   Todos os nós reconhecem o mesmo lider: " + elected_leaders[1])
      println("==================================================")
}
