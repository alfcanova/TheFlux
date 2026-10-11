#L ============================================================================
#L Algoritmo: Circular SCAN (C-SCAN) Disk Scheduling
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N log N) varredura unidirecional com retorno rapido
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisCSCAN) {
      println("==================================================")
      println("  SciAlgo: Circular SCAN (C-SCAN) Disk Scheduling")
      println("==================================================")

      #L O C-SCAN proporciona tempo de espera mais uniforme do que o SCAN basico.
      #L O cabecote atende requisicoes em apenas UMA direcao (ascendente).
      #L Ao atingir a borda superior (199), retorna imediatamente ao inicio (0)
      #L sem atender requisicoes durante o trajeto de volta, e retoma o atendimento.

      mut as int64: disk_max = 199
      mut as int64: head_start = 50

      #L Requisicoes: [82, 170, 43, 140, 24, 16, 190]
      println("1. Configuracao do C-SCAN:")
      println("   Faixa de Cilindros: 0 a " + disk_max)
      println("   Posicao Inicial do Cabecote: " + head_start)

      println("==================================================")
      println("2. [Simulacao do Movimento Unidirecional C-SCAN]:")

      mut as int64: total_seek = 0
      mut as int64: current_pos = head_start

      #L Fase 1: Atende requisicoes ascendentes ate a borda superior (199)
      mut as list of int64: asc_seq = [82, 140, 170, 190, 199]
      mut as int64: u = 1
      infinite (u <= 5) {
            mut as int64: target = asc_seq[u]
            mut as int64: dist = target - current_pos
            total_seek = total_seek + dist
            println("   [Ascendente] Move de " + current_pos + " -> " + target + " (Seek = " + dist + ")")
            current_pos = target
            u = u + 1
      }

      #L Retorno imediato a borda 0
      println("   -> Borda 199 alcancada. RETORNO CIRCULAR IMEDIATO para 0 (sem atender intermediarios)!")
      total_seek = total_seek + 199
      current_pos = 0
      println("   [Salto Circular] Move de 199 -> 0 (Seek = 199)")

      #L Fase 2: Atende requisicoes a partir do inicio
      mut as list of int64: start_seq = [16, 24, 43]
      mut as int64: s = 1
      infinite (s <= 3) {
            mut as int64: target_s = start_seq[s]
            mut as int64: dist_s = target_s - current_pos
            total_seek = total_seek + dist_s
            println("   [Ascendente Pos-Retorno] Move de " + current_pos + " -> " + target_s + " (Seek = " + dist_s + ")")
            current_pos = target_s
            s = s + 1
      }

      println("==================================================")
      println("3. Metricas Finais do C-SCAN:")
      println("   Posicao Final do Cabecote: " + current_pos)
      println("   Deslocamento Total de Cilindros: " + total_seek)
      println("   Distribuicao uniforme de latencia garantida!")
      println("==================================================")
}
