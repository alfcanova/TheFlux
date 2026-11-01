#L ============================================================================
#L Algoritmo: Raymond Tree-Based Distributed Mutual Exclusion Algorithm
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(log N) mensagens em media por entrada na SC
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoRaymond) {
      println("==================================================")
      println("  SciAlgo: Raymond Tree-Based Mutual Exclusion")
      println("==================================================")

      #L O algoritmo de Raymond organiza os nós em uma arvore geradora direcionada.
      #L As arestas apontam na direcao do nó que atualmente detem o PRIVILEGIO (Token).
      #L Cada nó mantem uma fila FIFO de requisicoes locais e de seus filhos.
      #L
      #L Topologia da Arvore (N = 5 nós):
      #L          (1) [Detentor Inicial do Token]
      #L         /   \
      #L       (2)   (3)
      #L       /       \
      #L     (4)       (5)

      mut as int64: num_nodes = 5

      #L holder[i] aponta para o vizinho na direcao do token (se holder[i] == i, nó tem o token)
      mut as list of int64: holder = [1, 1, 1, 2, 3]

      #L Filas de requisicoes simples (tamanho maximo 2 por simplicidade do cenario)
      #L req_head[i] e req_tail[i]
      mut as list of int64: req_q = [0, 0, 0, 0, 0]

      println("1. Topologia da Arvore e Ponteiros Iniciais:")
      println("   No 1: Raiz (possui o token)")
      println("   No 2: aponta para No 1 | No 4: aponta para No 2")
      println("   No 3: aponta para No 1 | No 5: aponta para No 3")

      #L ======================================================================
      #L Cenario: No 4 (folha) deseja entrar na Secao Critica
      #L ======================================================================
      println("2. [Solicitacao de SC] No 4 deseja o Token:")
      mut as int64: requester = 4
      req_q[4] = 4
      println("   -> No 4 enfileira a si mesmo e envia REQUEST para No 2 (holder[4] = 2)")

      #L No 2 recebe REQUEST de No 4
      req_q[2] = 4
      println("   -> No 2 enfileira No 4 e repassa REQUEST para No 1 (holder[2] = 1)")

      #L No 1 (raiz / token holder) recebe REQUEST do No 2
      req_q[1] = 2
      println("   -> No 1 recebe REQUEST de No 2 e atende a cabeca da fila")

      #L ======================================================================
      #L Propagacao do Token de Volta para o Solicitante
      #L ======================================================================
      println("3. [Transferencia do Token pela Arvore]:")

      #L No 1 transfere token para No 2
      holder[1] = 2
      println("   -> No 1 envia TOKEN para No 2 e inverte ponteiro: holder[1] = 2")

      #L No 2 recebe token
      holder[2] = 4
      println("   -> No 2 recebe TOKEN, encaminha para No 4 e inverte ponteiro: holder[2] = 4")

      #L No 4 recebe token
      holder[4] = 4
      println("   -> No 4 recebe TOKEN! holder[4] = 4 (Novo detentor do privilégio)")

      #L ======================================================================
      #L No 4 entra na Secao Critica
      #L ======================================================================
      println("4. [Execucao na Secao Critica]")
      println("   No 4 entra na Secao Critica com exclusao mutua garantida.")
      println("   ... Operacao critica executada com sucesso ...")
      req_q[4] = 0
      println("   No 4 sai da Secao Critica e mantem o token para futuras requisicoes.")

      println("==================================================")
      println("5. Estado Final dos Ponteiros (Arvore Invertida):")
      mut as int64: k = 1
      infinite (k <= num_nodes) {
            println("   No " + k + " aponta para holder: " + holder[k])
            k = k + 1
      }
      println("   Todos os caminhos agora convergem para No 4!")
      println("==================================================")
}
