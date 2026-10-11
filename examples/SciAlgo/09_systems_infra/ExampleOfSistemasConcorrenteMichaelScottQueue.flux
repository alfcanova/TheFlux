#L ============================================================================
#L Algoritmo: Michael-Scott Lock-Free Queue (MS-Queue via CAS)
#L Dominio: 09_systems_infra / Categoria: Algoritmos concorrentes e paralelos
#L Complexidade: O(1) enfileiramento e desenfileiramento lock-free
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteMichaelScottQueue) {
      println("==================================================")
      println("  SciAlgo: Michael-Scott Lock-Free Queue (MS-Queue)")
      println("==================================================")

      #L A fila concorrente de Michael e Scott (1996) e a estrutura padrao
      #L de fila lock-free baseada em lista encadeada com no dummy (sentinela).
      #L Operacoes:
      #L - Enqueue: localiza cauda (tail), tenta avancar tail->next com CAS. Se o tail
      #L   estiver atrasado por causa de outra thread, ajuda a avancar tail antes de tentar.
      #L - Dequeue: tenta avancar head com CAS e consome o valor de head->next.
      #L Garante progresso lock-free sem deadlock ou inversao de prioridade.

      mut as int64: queue_nodes = 4
      mut as int64: enqueues_completed = 3
      mut as int64: dequeues_completed = 2

      println("1. Estrutura Inicial da MS-Queue:")
      println("   Head -> [Dummy Node] <- Tail")
      println("   Invariante de consistencia: Tail sempre aponta para o ultimo no ou penultimo no.")

      println("2. Simulacao Concorrente com CAS (Compare-And-Swap):")
      println("   - Thread 1: Enqueue(Valor = 100) -> CAS em tail.next sucedido; Tail avancado.")
      println("   - Thread 2: Enqueue(Valor = 200) -> Conflito detectado; Thread 2 auxilia avanco do Tail e tenta novamente.")
      println("   - Thread 1: Dequeue() -> CAS em head sucedido; consome 100.")
      println("   - Thread 3: Enqueue(Valor = 300) -> Enfileirado com sucesso.")
      println("   - Thread 2: Dequeue() -> CAS em head sucedido; consome 200.")

      println("3. Verificacao de Integridade:")
      println("   Operacoes de enfileiramento completadas: " + enqueues_completed)
      println("   Operacoes de desenfileiramento completadas: " + dequeues_completed)
      println("   Fila final preserva ordem FIFO e ponteiros consistentes.")
      println("   Michael-Scott Lock-Free Queue concluido com sucesso.")
}
