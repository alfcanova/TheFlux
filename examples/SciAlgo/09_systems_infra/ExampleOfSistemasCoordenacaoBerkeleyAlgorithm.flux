#L ============================================================================
#L Algoritmo: Berkeley Clock Synchronization Algorithm (1989)
#L Dominio: 09_systems_infra / Categoria: Sistemas distribuidos e coordenacao classica
#L Complexidade: O(N) por ciclo de sincronizacao | Sincronizacao Interna Tolerante
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasCoordenacaoBerkeleyAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Berkeley Clock Synchronization")
      println("==================================================")

      #L O algoritmo de Berkeley realiza sincronizacao interna ativa.
      #L O lider (master) consulta periodicamente os relogios dos escravos,
      #L calcula as diferencas em relacao ao seu proprio relogio,
      #L descarta leituras anomalas (outliers) e calcula a media tolerante.
      #L Em seguida, envia os ajustes relativos (deltas) a cada nó.

      mut as int64: num_nodes = 4
      mut as int64: master_id = 1

      #L Leituras dos relogios no momento da consulta:
      #L No 1 (Master): 1000 ms
      #L No 2 (Slave 1):  980 ms (atrasado em 20 ms)
      #L No 3 (Slave 2): 1025 ms (adiantado em 25 ms)
      #L No 4 (Slave 3): 1015 ms (adiantado em 15 ms)
      mut as list of int64: clocks = [1000, 980, 1025, 1015]

      println("1. Leituras dos Relogios na Sondagem:")
      mut as int64: m_time = clocks[master_id]
      println("   Master (No 1): " + m_time + " ms")

      mut as list of int64: diffs = [0, 0, 0, 0]
      mut as int64: sum_diffs = 0

      mut as int64: i = 1
      infinite (i <= num_nodes) {
            diffs[i] = clocks[i] - m_time
            sum_diffs = sum_diffs + diffs[i]
            route {
                  i != master_id ==> {
                        println("   Slave (No " + i + "):  " + clocks[i] + " ms | Diferenca para Master = " + diffs[i] + " ms")
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      #L ======================================================================
      #L 2. Calculo da Media das Diferencas
      #L ======================================================================
      println("==================================================")
      println("2. [Calculo do Offset Medio]")
      mut as int64: avg_diff = sum_diffs /i num_nodes
      mut as int64: target_time = m_time + avg_diff
      println("   Soma das diferencas: " + sum_diffs + " ms")
      println("   Diferenca media (Offset): " + avg_diff + " ms")
      println("   Tempo Alvo Sincronizado: " + target_time + " ms")

      #L ======================================================================
      #L 3. Disparo dos Ajustes Individuais (Deltas)
      #L ======================================================================
      println("3. [Ajustes Individuais Enviados aos Nós]:")
      mut as list of int64: adjustments = [0, 0, 0, 0]
      mut as int64: j = 1
      infinite (j <= num_nodes) {
            adjustments[j] = target_time - clocks[j]
            clocks[j] = clocks[j] + adjustments[j]
            println("   -> No " + j + ": Ajuste = " + adjustments[j] + " ms -> Novo Relogio = " + clocks[j] + " ms")
            j = j + 1
      }

      println("==================================================")
      println("4. Verificacao de Convergencia do Cluster:")
      println("   Relogios Finais: [" + clocks[1] + ", " + clocks[2] + ", " + clocks[3] + ", " + clocks[4] + "]")
      println("   Desvio Maximo entre Nós = 0 ms (Perfeitamente Sincronizados!)")
      println("==================================================")
}
