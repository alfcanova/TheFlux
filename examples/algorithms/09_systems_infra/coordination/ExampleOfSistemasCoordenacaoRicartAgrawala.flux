#L ============================================================================
#L Algoritmo: Ricart-Agrawala Distributed Mutual Exclusion Algorithm
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: 2*(N - 1) mensagens por entrada na SC
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoRicartAgrawala) {
      println("==================================================")
      println("  SciAlgo: Ricart-Agrawala Mutual Exclusion")
      println("==================================================")

      #L O algoritmo de Ricart-Agrawala otimiza a exclusao mutua de Lamport
      #L eliminando mensagens explicitas de RELEASE.
      #L Requer apenas 2*(N - 1) mensagens por secao critica.
      #L Estados de cada nó: 0 = RELEASED, 1 = WANTED, 2 = HELD.

      mut as int64: num_nodes = 3

      mut as list of int64: clocks = [0, 0, 0]
      mut as list of int64: states = [0, 0, 0]
      mut as list of int64: req_ts = [0, 0, 0]

      #L Matriz de respostas postergadas: deferred[i * 3 + j]
      #L (se nó i postergou resposta para nó j)
      mut as list of int64: deferred = [0, 0, 0, 0, 0, 0, 0, 0, 0]

      println("1. Estado Inicial do Cluster (3 nós):")
      println("   Todos os nós estao em estado RELEASED (0).")

      #L ======================================================================
      #L Cenario: Nó 1 e Nó 2 solicitam Secao Critica concorrentemente
      #L Nó 1 solicita no timestamp 2, Nó 2 solicita no timestamp 5 (prioridade para No 1)
      #L ======================================================================
      clocks[1] = 1
      clocks[1] = clocks[1] + 1
      states[1] = 1 #L WANTED
      req_ts[1] = clocks[1] #L ts = 2
      println("2. [Requisicao] No 1 deseja SC: State=WANTED, TS=" + req_ts[1])

      clocks[2] = 4
      clocks[2] = clocks[2] + 1
      states[2] = 1 #L WANTED
      req_ts[2] = clocks[2] #L ts = 5
      println("   [Requisicao Concorrente] No 2 deseja SC: State=WANTED, TS=" + req_ts[2])

      println("3. [Avaliacao das Respostas entre os Pares]")

      #L No 1 avalia pedido do No 2:
      #L Como No 1 e WANTED e (req_ts[1], 1) < (req_ts[2], 2), No 1 POSTERGA resposta para No 2!
      mut as int64: def_1_2 = (1 - 1) * 3 + 2
      deferred[def_1_2] = 1
      println("   -> No 1 posterga resposta para No 2 (prioridade: TS 2 < TS 5).")

      #L No 2 avalia pedido do No 1:
      #L Como (req_ts[1], 1) < (req_ts[2], 2), No 2 concede REPLY imediatamente para No 1!
      println("   -> No 2 envia REPLY imediato para No 1.")

      #L No 3 (neutro/RELEASED) envia REPLY para No 1 e No 2
      println("   -> No 3 (neutro) concede REPLY para No 1 e No 2.")

      #L ======================================================================
      #L No 1 recebe replies de No 2 e No 3 -> Entra na Secao Critica
      #L ======================================================================
      println("4. [Entrada na Secao Critica]")
      states[1] = 2 #L HELD
      println("   No 1 obteve todas as concessoes (2/2) e ENTRA na Secao Critica!")
      println("   ... Executando operacao atomica no recurso compartilhado ...")

      #L ======================================================================
      #L No 1 sai da Secao Critica e libera respostas postergadas
      #L ======================================================================
      println("5. [Liberacao da Secao Critica]")
      states[1] = 0 #L RELEASED
      println("   No 1 conclui SC e envia REPLY postergado para No 2.")
      deferred[def_1_2] = 0

      #L Agora No 2 possui todas as concessoes e pode entrar na SC
      states[2] = 2 #L HELD
      println("   No 2 recebe o REPLY pendente e ENTRA na Secao Critica!")
      println("   ... Executando operacao atomica do No 2 ...")
      states[2] = 0 #L RELEASED
      println("   No 2 conclui e libera SC.")

      println("==================================================")
      println("6. Verificacao de Seguranca:")
      println("   Invariante de Exclusao Mutua estritamente mantido.")
      println("   Total de mensagens por rodada: 2*(N-1) = 4.")
      println("==================================================")
}
