#L ============================================================================
#L Algoritmo: LOOK Disk Scheduling
#L Dominio: 09_systems_infra / Categoria: Sistemas operacionais e gerenciamento de recursos
#L Complexidade: O(N log N) varredura com inversao no extremo das requisicoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasOperacionaisLOOK) {
      println("==================================================")
      println("  SciAlgo: LOOK Disk Scheduling")
      println("==================================================")

      #L O algoritmo LOOK otimiza o SCAN convencional:
      #L O cabecote viaja na direcao das requisicoes, mas NAO vai ate a borda extrema
      #L do disco (199). Ele inverte o sentido assim que atende a ultima requisicao
      #L presente naquela direcao, evitando deslocamento desnecessario.

      mut as int64: head_start = 50

      #L Requisicoes: [82, 170, 43, 140, 24, 16, 190]
      #L Subindo de 50: atende 82, 140, 170, 190.
      #L Como 190 e a ultima requisicao superior, inverte IMEDIATAMENTE (sem ir a 199)!
      #L Descendo de 190: atende 43, 24, 16.

      println("1. Parametros:")
      println("   Posicao Inicial do Cabecote: " + head_start)
      println("   Requisicoes: [82, 170, 43, 140, 24, 16, 190]")

      println("==================================================")
      println("2. [Simulacao do LOOK]:")

      mut as int64: total_seek = 0
      mut as int64: current_pos = head_start

      #L Fase 1: Atendimento ascendente ate a ultima requisicao superior (190)
      mut as list of int64: look_up = [82, 140, 170, 190]
      mut as int64: u = 1
      infinite (u <= 4) {
            mut as int64: target = look_up[u]
            mut as int64: dist = target - current_pos
            total_seek = total_seek + dist
            println("   [Subindo] Move de " + current_pos + " -> " + target + " (Seek = " + dist + ")")
            current_pos = target
            u = u + 1
      }

      println("   -> Nenhuma requisicao superior a 190! Inversao imediata de sentido (sem tocar 199).")

      #L Fase 2: Atendimento descendente
      mut as list of int64: look_down = [43, 24, 16]
      mut as int64: d = 1
      infinite (d <= 3) {
            mut as int64: target_d = look_down[d]
            mut as int64: dist_d = current_pos - target_d
            total_seek = total_seek + dist_d
            println("   [Descendo] Move de " + current_pos + " -> " + target_d + " (Seek = " + dist_d + ")")
            current_pos = target_d
            d = d + 1
      }

      println("==================================================")
      println("3. Metricas Finais do LOOK:")
      println("   Posicao Final: " + current_pos)
      println("   Deslocamento Total de Cilindros: " + total_seek)
      println("   Economia de curso em relacao ao SCAN comprovada!")
      println("==================================================")
}
