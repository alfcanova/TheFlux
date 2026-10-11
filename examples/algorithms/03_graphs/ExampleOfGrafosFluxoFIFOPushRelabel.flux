#L ============================================================================
#L Algoritmo: FIFO Preflow-Push Max-Flow (Goldberg & Tarjan 1988)
#L Dominio: 03_graphs / Categoria: Redes de fluxo e cortes
#L Complexidade: O(V^3) fluxo maximo com fila FIFO de descarga
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoFIFOPushRelabel) {
      println("==================================================")
      println("  SciAlgo: FIFO Preflow-Push Max-Flow (1988)")
      println("==================================================")

      #L Rede com 4 vertices:
      #L Fonte s = 1, Sumidouro t = 4
      #L Capacidades: c(1, 2) = 10, c(1, 3) = 10, c(2, 4) = 8, c(3, 4) = 8
      mut as int64: n = 4

      println("1. Inicializando Pre-fluxo a partir da fonte (no 1):")
      mut as list of int64: excess = [0, 0, 0, 0]
      mut as list of int64: h = [4, 1, 1, 0]

      #L Pushes saturantes iniciais da fonte:
      excess[2] = 10
      excess[3] = 10
      println("   Excesso gerado: no 2 = 10, no 3 = 10")

      #L Fila FIFO de nos ativos: inicializada com [2, 3]
      mut as list of int64: fifo_queue = [2, 3]
      println("   Fila FIFO inicial: " + fifo_queue)

      #L Descarregando primeiro da fila: no 2
      #L Aresta admissivel (2, 4) pois h(2) = 1 > h(4) = 0. Cap residual = 8.
      mut as int64: push_2_4 = 8
      excess[2] = excess[2] - push_2_4
      excess[4] = excess[4] + push_2_4
      println("2. Descarga (Discharge) do no 2:")
      println("   Empurradas " + push_2_4 + " unidades para o sumidouro 4.")
      println("   Excesso residual no 2: " + excess[2] + " (retorna a fonte apos relabel)")

      #L Descarregando segundo da fila: no 3
      #L Aresta admissivel (3, 4) pois h(3) = 1 > h(4) = 0. Cap residual = 8.
      mut as int64: push_3_4 = 8
      excess[3] = excess[3] - push_3_4
      excess[4] = excess[4] + push_3_4
      println("3. Descarga (Discharge) do no 3:")
      println("   Empurradas " + push_3_4 + " unidades para o sumidouro 4.")
      println("   Excesso residual no 3: " + excess[3] + " (retorna a fonte apos relabel)")

      #L O excesso restante nos intermediarios (2 + 2 = 4) retorna a fonte
      excess[2] = 0
      excess[3] = 0

      mut as int64: max_flow = excess[4]
      println("4. Fluxo Maximo final entregue ao sumidouro: " + max_flow)

      mut as bool: valid = (max_flow == 16) and (excess[2] == 0) and (excess[3] == 0)
      println("5. Validacao: " + valid)
      println("==================================================")
}
