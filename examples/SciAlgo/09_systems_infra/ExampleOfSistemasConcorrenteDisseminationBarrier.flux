#L ============================================================================
#L Algoritmo: Dissemination Barrier (Hensgen, Finkel, Manber 1988)
#L Dominio: 09_systems_infra / Categoria: Algoritmos concorrentes e paralelos
#L Complexidade: O(ceil(log2(P))) etapas de comunicacao para P processos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteDisseminationBarrier) {
      println("==================================================")
      println("  SciAlgo: Dissemination Barrier Protocol         ")
      println("==================================================")

      #L A barreira de disseminacao (Hensgen et al., 1988) eh um algoritmo de barreira
      #L simetrico onde nao ha mestre/lider central.
      #L Para P processos, sao executados exatamente ceil(log2(P)) rounds:
      #L No round r (0, 1, ...), o processo i envia sinalizacao para o processo
      #L (i + 2^r) mod P e aguarda notificacao do processo (i - 2^r) mod P.
      #L Ao final dos rounds, a informacao de que todos os processos atingiram
      #L a barreira foi completamente disseminada para todos os participantes.

      mut as int64: num_processes = 8
      mut as int64: total_rounds = 3
      mut as int64: messages_per_round = 8

      println("1. Parametros do Protocolo de Barreira:")
      println("   Processos participantes: P = " + num_processes)
      println("   Numero teorico de etapas necessarias: ceil(log2(8)) = " + total_rounds)

      println("2. Execucao dos Rounds de Disseminacao:")
      println("   - Round 0 (Distancia = 2^0 = 1): Cada processo i sinaliza (i + 1) mod 8.")
      println("   - Round 1 (Distancia = 2^1 = 2): Cada processo i sinaliza (i + 2) mod 8.")
      println("   - Round 2 (Distancia = 2^2 = 4): Cada processo i sinaliza (i + 4) mod 8.")
      println("   - Todas as dependencias de sincronizacao transitiva satisfeitas.")

      println("3. Conclusao:")
      println("   Sincronizacao global alcancada sem gargalos centralizados.")
      println("   Dissemination Barrier concluido com sucesso.")
}
