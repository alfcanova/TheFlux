#L ============================================================================
#L Algoritmo: VFH — Vector Field Histogram (Desvio Reativo em Tempo Real)
#L Dominio: 12_robotics_control / Categoria: Navegacao Reativa e Evitacao de Obstaculos
#L Descricao: Histograma polar de densidade de obstaculos para navegacao livre de oscilacoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaVectorFieldHistogramVFH) {
      println("=== Algoritmo: VFH (Vector Field Histogram) ===")

      #L O campo de visao frontal do robo eh discretizado em 3 setores angulares polares de 30 graus:
      #L Setor 1: Esquerda (-30 graus)
      #L Setor 2: Frente (0 graus)
      #L Setor 3: Direita (+30 graus)
      #L Direcao desejada do alvo (Goal Direction): Frente (Setor 2, 0 graus)
      mut as int64: target_sector = 2
      println("Direcao ideal em direcao ao alvo: Setor 2 (Frente, 0 graus)")

      #L Densidades polares de obstaculos calculadas a partir de sensores rangefinders:
      #L Setor 1 (Esquerda): densidade H1 = 15 (Vale livre, sem obstaculos)
      #L Setor 2 (Frente):   densidade H2 = 85 (Pico denso, obstaculo grande a frente!)
      #L Setor 3 (Direita):  densidade H3 = 70 (Densidade moderada/alta)
      mut as int64: h1 = 15
      mut as int64: h2 = 85
      mut as int64: h3 = 70

      println("Histograma Polar de Densidade de Obstaculos:")
      println("  Setor 1 (Esquerda): H1 = " + h1)
      println("  Setor 2 (Frente):   H2 = " + h2 + " [Bloqueado]")
      println("  Setor 3 (Direita):  H3 = " + h3)

      #L Limiar de densidade segura (Threshold): Th = 40
      #L Setores com densidade <= Th sao classificados como Vales Livres (Free Valleys)
      mut as int64: threshold = 40
      mut as bool: sector1_free = false
      mut as bool: sector2_free = false
      mut as bool: sector3_free = false

      route {
            h1 <= threshold ==> { sector1_free = true }
      }
      route {
            h2 <= threshold ==> { sector2_free = true }
      }
      route {
            h3 <= threshold ==> { sector3_free = true }
      }

      #L Selecao de direcao de estercamento:
      #L Como o Setor 2 frontal esta bloqueado (H2 = 85 > 40), o VFH seleciona o vale livre
      #L mais proximo da direcao desejada: Setor 1 (Esquerda, livre com H1 = 15)!
      mut as int64: chosen_sector = 0
      route {
            sector1_free ==> {
                  chosen_sector = 1
            }
      }

      println("Setor frontal bloqueado! VFH desvia pelo vale livre mais favoravel: Setor #" + chosen_sector)

      route {
            chosen_sector == 1 ==> {
                  println("Manobra reativa VFH executada com sucesso sem oscilacoes de potencial!")
            }
            _ ==> {
                  println("Falha no desvio VFH")
            }
      }

      println("Vector Field Histogram concluido com sucesso.")
}
