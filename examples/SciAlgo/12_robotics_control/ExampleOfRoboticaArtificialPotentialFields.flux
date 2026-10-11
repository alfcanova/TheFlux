#L ============================================================================
#L Algoritmo: Campos Potenciais Artificiais (Artificial Potential Fields — APF)
#L Dominio: 12_robotics_control / Categoria: Navegacao Reativa e Evitacao de Obstaculos
#L Descricao: Guiamento vetorial somando atracao pelo alvo e repulsao por obstaculos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaArtificialPotentialFields) {
      println("=== Algoritmo: Campos Potenciais Artificiais (APF) ===")

      #L Posicao atual do robo no plano 2D: q = (10, 0)
      #L Posicao do alvo (Goal): q_goal = (50, 0)
      #L Posicao do obstaculo (Obstacle): q_obs = (20, 0)
      mut as int64: q_x = 10
      mut as int64: goal_x = 50
      mut as int64: obs_x = 20

      println("Configuracao: Robo em x=" + q_x + ", Alvo em x=" + goal_x + ", Obstaculo em x=" + obs_x)

      #L 1. Forca Atrativa gerada pelo Alvo:
      #L F_att = k_att * (goal_x - q_x)
      #L Com k_att = 1: F_att = 1 * (50 - 10) = +40 (direcao positiva para a direita)
      mut as int64: f_att_x = goal_x - q_x
      println("Forca Atrativa em direcao ao alvo: F_att = +" + f_att_x)

      #L 2. Forca Repulsiva gerada pelo Obstaculo:
      #L Distancia ao obstaculo d = obs_x - q_x = 20 - 10 = 10
      #L Raio de influencia do obstaculo d0 = 15 unidades
      #L Como d = 10 <= 15, o obstaculo esta dentro da zona de repulsao!
      #L Intensidade da repulsao F_rep = k_rep * (1/d - 1/d0) empurrando para tras (-x)
      #L Em escala simplificada: F_rep = -25
      mut as int64: f_rep_x = -25
      println("Forca Repulsiva exercida pelo obstaculo: F_rep = " + f_rep_x)

      #L 3. Forca Resultante Total F_total = F_att + F_rep:
      #L F_total = +40 + (-25) = +15
      mut as int64: f_total_x = f_att_x + f_rep_x
      println("Forca Resultante de guiamento do robo: F_total = +" + f_total_x)

      #L O robo avanca com velocidade proporcional a forca resultante:
      mut as int64: new_q_x = q_x + (f_total_x /i 5)
      println("Nova posicao reativa do robo: x = " + new_q_x)

      route {
            f_total_x > 0 and new_q_x == 13 ==> {
                  println("Equilibrio dinamico de forcas do APF direciona o robo com seguranca!")
            }
            _ ==> {
                  println("Erro no campo potencial")
            }
      }

      println("Campos Potenciais Artificiais concluido com sucesso.")
}
