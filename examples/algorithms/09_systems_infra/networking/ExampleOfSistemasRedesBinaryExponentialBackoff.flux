#L ============================================================================
#L Algoritmo: Binary Exponential Backoff (BEB - Ethernet CSMA/CD)
#L Dominio: 09_systems_infra / Categoria: Redes de computadores e protocolos
#L Complexidade: O(C) tempo por estacao | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasRedesBinaryExponentialBackoff) {
      println("==================================================")
      println("  SciAlgo: Binary Exponential Backoff (CSMA/CD)   ")
      println("==================================================")

      #L Parametros do Ethernet CSMA/CD:
      #L slot_time_us: tempo de 1 slot de contenção (51.2 microsegundos em 10 Mbps)
      mut as int64: slot_time_us = 51

      println("1. Parametros do Barramento Ethernet:")
      println("   Slot Time: " + slot_time_us + " us (microssegundos)")
      println("   Regra BEB: Apos colisão c, escolhe k aleatório no intervalo [0, 2^c - 1]")

      #L Simulacao da disputa de canal entre Estacao A e Estacao B:
      #L Sequencia pseudo-aleatoria deterministica de escolhas de slots:
      #L Rodada 1 (c = 1, janela [0..1]):
      #L   Estacao A escolhe slot 1, Estacao B escolhe slot 1 -> EMPATE/COLISAO
      #L Rodada 2 (c = 2, janela [0..3]):
      #L   Estacao A escolhe slot 2, Estacao B escolhe slot 0 -> Estacao B TRANSMITE!
      mut as int64: collision_count = 0
      mut as bool: channel_resolved = false

      #L Vetores com escolhas das estacoes para as rodadas
      mut as list of int64: choices_a = [1, 2]
      mut as list of int64: choices_b = [1, 0]

      println("2. Simulando Contencao do Meio Compartilhado:")

      mut as int64: round = 1
      infinite (round <= 2 and (not channel_resolved)) {
            collision_count = collision_count + 1
            #L Janela de contencao maxima: 2^c - 1
            mut as int64: max_window = 1
            mut as int64: p = 1
            infinite (p <= collision_count) {
                  max_window = max_window * 2
                  p = p + 1
            }
            max_window = max_window - 1

            mut as int64: slot_a = choices_a[round]
            mut as int64: slot_b = choices_b[round]

            println("   Rodada " + round + " (Colisão " + collision_count + "): Janela de Contencao [0 .. " + max_window + "] slots")
            println("      Estacao A escolhe slot: " + slot_a + " (" + (slot_a * slot_time_us) + " us)")
            println("      Estacao B escolhe slot: " + slot_b + " (" + (slot_b * slot_time_us) + " us)")

            route {
                  slot_a == slot_b ==> {
                        println("      [COLISAO DETECTADA] Ambas as estacoes transmitiram no mesmo slot! Multiplicando janela BEB...")
                  }
                  slot_a < slot_b ==> {
                        println("      [CANAL ADQUIRIDO] Estacao A transmitiu primeiro no slot " + slot_a + " com sucesso!")
                        channel_resolved = true
                  }
                  _ ==> {
                        println("      [CANAL ADQUIRIDO] Estacao B transmitiu primeiro no slot " + slot_b + " com sucesso!")
                        channel_resolved = true
                  }
            }

            round = round + 1
      }

      println("3. Resumo da Resolucao BEB:")
      println("   Total de Colisoes Superadas: " + collision_count)
      println("   Canal Desobstruido: " + channel_resolved)

      #L Validacao deterministica
      mut as bool: valid_beb = channel_resolved and collision_count == 2
      println("4. Verificacao de Estabilidade do Algoritmo: " + valid_beb)

      println("Binary Exponential Backoff concluido com sucesso.")
}
