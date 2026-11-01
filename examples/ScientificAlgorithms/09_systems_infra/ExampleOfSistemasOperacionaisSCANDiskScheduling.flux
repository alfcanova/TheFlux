#L ============================================================================
#L Algoritmo: SCAN Disk Scheduling (Elevator Algorithm)
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N log N) ordenacao e varredura de trilhas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisSCANDiskScheduling) {
      println("==================================================")
      println("  SciAlgo: SCAN Disk Scheduling (Elevator)")
      println("==================================================")

      #L O algoritmo SCAN (ou algoritmo do elevador) move o cabecote de disco
      #L em uma direcao continua (ex: subindo ate o limite superior do disco),
      #L atendendo todas as requisicoes no caminho, e ao atingir a borda inverte
      #L o sentido atendendo as requisicoes restantes.

      mut as int64: disk_max = 199
      mut as int64: head_start = 50

      #L Requisicoes de cilindros: [82, 170, 43, 140, 24, 16, 190]
      #L Subindo de 50: atende [82, 140, 170, 190] -> alcanca 199
      #L Descendo de 199: atende [43, 24, 16]

      println("1. Parametros do Disco:")
      println("   Faixa de Cilindros: 0 a " + disk_max)
      println("   Posicao Inicial do Cabecote: " + head_start)
      println("   Fila de Requisicoes: [82, 170, 43, 140, 24, 16, 190]")

      println("==================================================")
      println("2. [Simulacao do Movimento do Cabecote SCAN]:")

      mut as int64: total_seek = 0
      mut as int64: current_pos = head_start

      #L Fase 1: Subindo em direcao ao limite superior (199)
      mut as list of int64: up_seq = [82, 140, 170, 190, 199]
      mut as int64: u = 1
      infinite (u <= 5) {
            mut as int64: target = up_seq[u]
            mut as int64: dist = target - current_pos
            total_seek = total_seek + dist
            println("   [Subindo] Move de " + current_pos + " -> " + target + " (Seek = " + dist + ")")
            current_pos = target
            u = u + 1
      }

      println("   -> Borda superior (199) atingida! Invertendo direcao do cabecote...")

      #L Fase 2: Descendo em direcao ao restante das requisicoes
      mut as list of int64: down_seq = [43, 24, 16]
      mut as int64: d = 1
      infinite (d <= 3) {
            mut as int64: target_d = down_seq[d]
            mut as int64: dist_d = current_pos - target_d
            total_seek = total_seek + dist_d
            println("   [Descendo] Move de " + current_pos + " -> " + target_d + " (Seek = " + dist_d + ")")
            current_pos = target_d
            d = d + 1
      }

      println("==================================================")
      println("3. Metricas Finais de Deslocamento:")
      println("   Posicao Final do Cabecote: " + current_pos)
      println("   Deslocamento Total de Trilhas (Total Seek Distance): " + total_seek)
      println("   Algoritmo SCAN executado com sucesso!")
      println("==================================================")
}
