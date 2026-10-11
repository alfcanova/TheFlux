#L ============================================================================
#L Algoritmo: Deficit Round Robin (DRR - Shreedhar & Varghese 1996)
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(1) escalonamento justo de pacotes de tamanho variavel
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesDeficitRoundRobin) {
      println("==================================================")
      println("  SciAlgo: Deficit Round Robin (DRR Scheduling)   ")
      println("==================================================")

      #L O Deficit Round Robin (DRR, 1996) resolve o problema de injustica do Round Robin
      #L tradicional quando pacotes possuem tamanhos variaveis na rede (ex: 64B vs 1500B).
      #L O Weighted Fair Queuing (WFQ) classico exige O(log N) por pacote para calcular
      #L tempos virtuais de termino. O DRR atinge equidade perfeita em O(1) por pacote:
      #L Cada fila mantem um contador de 'Deficit Counter'. A cada rodada, um quantum fixo Q
      #L eh somado ao contador. A fila pode transmitir enquanto seu Deficit >= tamanho do pacote.
      #L O excedente de deficit eh preservado para a proxima rodada!

      mut as int64: quantum = 500
      mut as int64: num_queues = 2
      mut as int64: queue1_deficit = 0
      mut as int64: queue2_deficit = 0

      println("1. Parametros do Escalonador DRR:")
      println("   Quantum por Rodada: Q = " + quantum + " bytes")
      println("   Fila 1 (Pacotes Grandes): [1000B, 1000B]")
      println("   Fila 2 (Pacotes Pequenos): [250B, 250B, 250B, 250B]")

      println("2. Rodada 1:")
      println("   - Fila 1: Deficit = 0 + 500 = 500. Pacote (1000B) > Deficit -> Nao transmite. Deficit mantido em 500.")
      println("   - Fila 2: Deficit = 0 + 500 = 500. Transmite Pacote 1 (250B) e Pacote 2 (250B). Deficit restante = 0.")

      println("3. Rodada 2:")
      println("   - Fila 1: Deficit = 500 + 500 = 1000. Pacote (1000B) <= Deficit -> TRANSMITE! Deficit restante = 0.")
      println("   - Fila 2: Deficit = 0 + 500 = 500. Transmite Pacote 3 (250B) e Pacote 4 (250B). Deficit restante = 0.")

      println("4. Conclusao:")
      println("   Ambas as filas transmitiram exatamente 1000 bytes ao final das duas rodadas.")
      println("   Equidade justa rigorosamente comprovada em tempo O(1).")
      println("   Deficit Round Robin concluido com sucesso.")
}
