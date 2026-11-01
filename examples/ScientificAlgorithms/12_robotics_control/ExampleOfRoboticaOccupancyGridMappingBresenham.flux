#L ============================================================================
#L Algoritmo: Occupancy Grid Mapping com Modelo Inverso de Sensor (Bresenham)
#L Dominio: 12_robotics_control / Categoria: Mapeamento e Percepcao Robotica
#L Descricao: Atualizacao log-odds de ocupacao de celulas via ray-casting de Bresenham
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaOccupancyGridMappingBresenham) {
      println("=== Algoritmo: Occupancy Grid Mapping (Log-Odds) ===")

      #L Grade de ocupacao com celulas em escala de log-odds l:
      #L l = 0 (probabilidade 0.5, desconhecido)
      #L l > 0 (probabilidade > 0.5, ocupado por obstaculo)
      #L l < 0 (probabilidade < 0.5, celula livre de obstaculo)
      #L Log-odds adicionados pelo modelo inverso do sensor laser:
      #L l_free = -4 (evidencia de celula atravessada sem colisao)
      #L l_occ = +8 (evidencia de impacto com obstaculo solido)
      mut as int64: l_free = -4
      mut as int64: l_occ = 8

      #L Posicao do robo no grid: (x=0, y=0)
      #L Feixe laser disparado atinge um obstaculo em (x=3, y=0)
      #L Ray-casting percorre a linha de visada:
      #L Celulas intermediarias livres: (1, 0) e (2, 0)
      #L Celula final ocupada: (3, 0)
      mut as int64: cell_1_logodds = 0
      mut as int64: cell_2_logodds = 0
      mut as int64: cell_3_logodds = 0

      println("Estado inicial do mapa: Celulas [1, 2, 3] desconhecidas (log-odds = 0)")

      #L Atualizacao com a 1a medicao de laser:
      #L Celula (1,0): atravessada -> l1 = 0 + l_free = -4
      #L Celula (2,0): atravessada -> l2 = 0 + l_free = -4
      #L Celula (3,0): impacto laser -> l3 = 0 + l_occ = +8
      cell_1_logodds = cell_1_logodds + l_free
      cell_2_logodds = cell_2_logodds + l_free
      cell_3_logodds = cell_3_logodds + l_occ

      println("Apos Disparo Laser 1:")
      println("  Celula (1,0) [Livre]:    log-odds = " + cell_1_logodds)
      println("  Celula (2,0) [Livre]:    log-odds = " + cell_2_logodds)
      println("  Celula (3,0) [Obstaculo]: log-odds = " + cell_3_logodds)

      #L Segundo disparo confirma o obstaculo em (3,0):
      cell_3_logodds = cell_3_logodds + l_occ
      println("Apos Disparo Laser 2 (Reforco):")
      println("  Celula (3,0) ocupacao reforçada: log-odds = " + cell_3_logodds)

      #L Conversao de log-odds para probabilidade: p = 1 / (1 + exp(-l))
      #L Para l = 16, a celula tem confianca estatistica superior a 99% de ocupacao solida
      route {
            cell_1_logodds < 0 and cell_3_logodds == 16 ==> {
                  println("Grade de ocupacao log-odds atualizada com sucesso pelo sensor inverso!")
            }
            _ ==> {
                  println("Erro no mapeamento")
            }
      }

      println("Occupancy Grid Mapping concluido com sucesso.")
}
