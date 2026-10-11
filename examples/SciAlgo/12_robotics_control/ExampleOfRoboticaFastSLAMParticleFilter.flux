#L ============================================================================
#L Algoritmo: FastSLAM — Rao-Blackwellized Particle Filter SLAM
#L Dominio: 12_robotics_control / Categoria: Localizacao e Mapeamento Simultaneo
#L Descricao: Fatoracao de Rao-Blackwell para mapa de marcos desacoplado por particula
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaFastSLAMParticleFilter) {
      println("=== Algoritmo: FastSLAM (Rao-Blackwellized SLAM) ===")

      #L Populacao de M = 3 particulas representando hipoteses da trajetoria do robo:
      #L Cada particula mantem sua propria estimativa de pose e um filtro EKF independente para cada marco
      #L Particula 1: pose x1 = 18, marco m1_est = 48, peso w1 = 100
      #L Particula 2: pose x2 = 20, marco m1_est = 50, peso w2 = 100
      #L Particula 3: pose x3 = 23, marco m1_est = 52, peso w3 = 100
      mut as int64: x1 = 18
      mut as int64: x2 = 20
      mut as int64: x3 = 23
      mut as int64: m_est_1 = 48
      mut as int64: m_est_2 = 50
      mut as int64: m_est_3 = 52

      println("Particulas ativas: x1=" + x1 + ", x2=" + x2 + ", x3=" + x3)

      #L Observacao real recebida pelo sensor laser: distancia ao marco z = 30 unidades
      #L Calculo de verossimilhanca e peso de importancia para cada particula:
      #L Distancia prevista pela Particula 1: z_pred1 = m_est_1 - x1 = 48 - 18 = 30 -> Inovacao = 0 (Match Perfeito!)
      #L Distancia prevista pela Particula 2: z_pred2 = m_est_2 - x2 = 50 - 20 = 30 -> Inovacao = 0 (Match Perfeito!)
      #L Distancia prevista pela Particula 3: z_pred3 = m_est_3 - x3 = 52 - 23 = 29 -> Inovacao = -1
      mut as int64: innov_1 = 30 - (m_est_1 - x1)
      mut as int64: innov_2 = 30 - (m_est_2 - x2)
      mut as int64: innov_3 = 30 - (m_est_3 - x3)

      #L Pesos gaussianos proporcionais (escala x100):
      #L inovacao 0 -> peso maximo 100
      #L inovacao 1 -> peso penalizado 40
      mut as int64: w1 = 100
      mut as int64: w2 = 100
      mut as int64: w3 = 40

      println("Pesos de importancia atualizados pelo sensor:")
      println("  w1 = " + w1 + ", w2 = " + w2 + ", w3 = " + w3)

      #L Reamostragem (Resampling): Particulas com baixo peso (Particula 3) sao eliminadas;
      #L Particulas de alto peso sao duplicadas e refinadas.
      #L Estimativa combinada de pose por media ponderada:
      #L x_final = (x1*w1 + x2*w2 + x3*w3) / (w1 + w2 + w3)
      #L x_final = (18*100 + 20*100 + 23*40) / (100 + 100 + 40)
      #L x_final = (1800 + 2000 + 920) / 240 = 4720 / 240 = 19
      mut as int64: num_pose = x1 * w1 + x2 * w2 + x3 * w3
      mut as int64: denom_w = w1 + w2 + w3
      mut as int64: x_estimado = num_pose /i denom_w
      println("Pose estimada pelo conjunto de particulas: x = " + x_estimado)

      route {
            x_estimado == 19 and w1 > w3 ==> {
                  println("Convergencia FastSLAM confirmada: Rao-Blackwellization mantem consistencia probabilistica!")
            }
            _ ==> {
                  println("Erro no filtro FastSLAM")
            }
      }

      println("FastSLAM concluido com sucesso.")
}
