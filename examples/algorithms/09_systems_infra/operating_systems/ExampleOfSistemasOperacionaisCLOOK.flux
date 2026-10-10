#L ============================================================================
#L Algoritmo: Circular LOOK (C-LOOK) Disk Scheduling
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N log N) varredura circular restrita ao intervalo util de requisicoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisCLOOK) {
      println("==================================================")
      println("  SciAlgo: Circular LOOK (C-LOOK) Disk Scheduling")
      println("==================================================")

      #L O C-LOOK combina a uniformidade do C-SCAN com a inteligencia do LOOK:
      #L - Move-se apenas na direcao ascendente ate a maior requisicao (190).
      #L - Salta diretamente para a menor requisicao pendente (16), sem ir a 199 nem a 0.
      #L Elimina o desperdicio de tempo nas bordas vazias do disco.

      mut as int64: head_start = 50

      #L Requisicoes: [82, 170, 43, 140, 24, 16, 190]
      println("1. Configuracao:")
      println("   Cabecote Inicial: " + head_start)
      println("   Faixa Util: Min = 16, Max = 190")

      println("==================================================")
      println("2. [Simulacao do C-LOOK]:")

      mut as int64: total_seek = 0
      mut as int64: current_pos = head_start

      #L Fase 1: Atendimento ascendente ate a maior requisicao (190)
      mut as list of int64: clook_up = [82, 140, 170, 190]
      mut as int64: u = 1
      infinite (u <= 4) {
            mut as int64: target = clook_up[u]
            mut as int64: dist = target - current_pos
            total_seek = total_seek + dist
            println("   [Ascendente] Move de " + current_pos + " -> " + target + " (Seek = " + dist + ")")
            current_pos = target
            u = u + 1
      }

      #L Salto circular diretamente para a menor requisicao pendente (16)
      println("   -> Maior requisicao atingida (190). Salto direto para a menor requisicao (16)!")
      mut as int64: jump_dist = 190 - 16
      total_seek = total_seek + jump_dist
      current_pos = 16
      println("   [Salto Circular C-LOOK] Move de 190 -> 16 (Seek = " + jump_dist + ")")

      #L Fase 2: Atendimento ascendente restante a partir de 16
      mut as list of int64: clook_rem = [24, 43]
      mut as int64: r = 1
      infinite (r <= 2) {
            mut as int64: target_r = clook_rem[r]
            mut as int64: dist_r = target_r - current_pos
            total_seek = total_seek + dist_r
            println("   [Ascendente Restante] Move de " + current_pos + " -> " + target_r + " (Seek = " + dist_r + ")")
            current_pos = target_r
            r = r + 1
      }

      println("==================================================")
      println("3. Metricas Finais do C-LOOK:")
      println("   Posicao Final: " + current_pos)
      println("   Deslocamento Total de Cilindros: " + total_seek)
      println("   Eficiencia maxima entre os algoritmos circulares de disco!")
      println("==================================================")
}
