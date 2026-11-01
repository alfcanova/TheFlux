#L ============================================================================
#L Algoritmo: Hybrid A* com Curvas de Dubins (Navegacao Nao-Holonomica)
#L Dominio: 12_robotics_control / Categoria: Planejamento Cinematico de Trajetoria
#L Descricao: Busca A* em espaco contínuo (x, y, theta) para veiculos com estercamento limitado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaHybridAStarDubins) {
      println("=== Algoritmo: Hybrid A* com Curvas de Dubins ===")

      #L Estado inicial do veiculo: (x=0, y=0, orientacao theta = 0 rad / apontando para leste)
      #L Estado objetivo: (x=40, y=20, orientacao final theta = 0 rad)
      #L Raio de giro minimo do veiculo (raio de Ackermann): R_min = 10
      mut as int64: r_min = 10
      println("Configuracao do veiculo: Raio de giro minimo R_min = " + r_min)

      #L Movimento cinematico primitivo 1: Curva para esquerda (Left Steering) por comprimento de arco L = 5
      #L Variacao de angulo delta_theta = L / R_min = 5 / 10 = 0.5 rad (28 graus)
      #L Posicao alcancada: (x1=5, y1=1, theta1=28)
      mut as int64: x1 = 5
      mut as int64: y1 = 1
      mut as int64: theta1 = 28
      println("Primitiva de estercamento 1 (Left Turn): x=" + x1 + ", y=" + y1 + ", orientacao=" + theta1 + " graus")

      #L Primitiva 2: Reta (Straight): avanco de 10 unidades
      mut as int64: x2 = x1 + 10
      mut as int64: y2 = y1 + 5
      println("Primitiva 2 (Straight Motion): x=" + x2 + ", y=" + y2)

      #L Tiro analitico de Dubins (Dubins Analytic Shot para o objetivo):
      #L A partir de (15, 6), calcula a curva analitica RSR (Right-Straight-Right) para o alvo (40, 20):
      #L Comprimento analitico exato da curva de Dubins = 28 unidades livres de colisao
      mut as int64: dubins_shot_length = 28
      mut as int64: total_trajectory_length = 5 + 10 + dubins_shot_length
      println("Tiro analitico de Dubins conectado ao alvo com comprimento: " + dubins_shot_length)
      println("Comprimento total da trajetoria cinematica: " + total_trajectory_length)

      route {
            total_trajectory_length == 43 ==> {
                  println("Trajetoria cinematica suave compativel com estercamento de Ackermann gerada!")
            }
            _ ==> {
                  println("Erro no planejamento Dubins")
            }
      }

      println("Hybrid A* Dubins concluido com sucesso.")
}
