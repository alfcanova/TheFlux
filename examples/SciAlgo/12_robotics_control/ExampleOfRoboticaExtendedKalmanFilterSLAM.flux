#L ============================================================================
#L Algoritmo: EKF-SLAM (Extended Kalman Filter Simultaneous Localization & Mapping)
#L Dominio: 12_robotics_control / Categoria: Localizacao e Mapeamento Simultaneo
#L Descricao: Estimacao conjunta da pose do robo e coordenadas de marcos no mapa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaExtendedKalmanFilterSLAM) {
      println("=== Algoritmo: EKF-SLAM (Simultaneous Localization & Mapping) ===")

      #L Vetor de estado aumentado: [posicao_robo_x, posicao_marco_m1_x]
      #L Pose inicial estimada do robo: x_r = 0, incerteza P_rr = 10
      #L Marco fixo no ambiente: m1_x real = 50
      #L Marco ja mapeado com estimativa inicial m1 = 48, incerteza P_mm = 20
      mut as int64: x_r = 0
      mut as int64: m1 = 48
      mut as int64: p_rr = 10
      mut as int64: p_mm = 20
      mut as int64: p_rm = 0  #L Covariancia cruzada inicial

      println("Estado inicial EKF-SLAM: Robo x_r = " + x_r + ", Marco m1 = " + m1)

      #L Passo 1: Predicao Odrometrica (Movimento do robo)
      #L Comando de odometria delta_x = 20 com ruido Q = 5
      #L x_r_pred = 0 + 20 = 20
      #L P_rr_pred = P_rr + Q = 10 + 5 = 15
      x_r = x_r + 20
      p_rr = p_rr + 5
      println("Apos odometria: Robo previsto x_r = " + x_r + ", incerteza P_rr = " + p_rr)

      #L Passo 2: Medicao do Sensor de Distancia (LiDAR / Range Sensor)
      #L Distancia observada ao marco m1: z_medida = 31 unidades
      #L Distancia prevista pelo modelo: z_pred = m1 - x_r = 48 - 20 = 28 unidades
      #L Inovacao de medicao y = z_medida - z_pred = 31 - 28 = +3 unidades
      mut as int64: z_medida = 31
      mut as int64: z_pred = m1 - x_r
      mut as int64: inovacao = z_medida - z_pred
      println("Medicao do marco: z = " + z_medida + " -> Inovacao residual y = " + inovacao)

      #L Passo 3: Atualizacao de Kalman (Ganho K e correcao simultanea)
      #L Incerteza da inovacao S = P_rr + P_mm + R_sensor = 15 + 20 + 5 = 40
      #L Ganho de Kalman para o robo K_r = P_rr / S = 15 / 40 ~ 0.375 (375/1000)
      #L Ganho de Kalman para o marco K_m = P_mm / S = 20 / 40 = 0.500 (500/1000)
      mut as int64: s_cov = p_rr + p_mm + 5
      mut as int64: k_r_x1000 = (p_rr * 1000) /i s_cov
      mut as int64: k_m_x1000 = (p_mm * 1000) /i s_cov

      #L Atualizacao de pose do robo e coordenada do marco:
      #L dx_r = K_r * inovacao = 375 * 3 / 1000 = 1
      #L dm_1 = K_m * inovacao = 500 * 3 / 1000 = 1
      mut as int64: dx_r = (k_r_x1000 * inovacao) /i 1000
      mut as int64: dm_1 = (k_m_x1000 * inovacao) /i 1000
      x_r = x_r + dx_r
      m1 = m1 + dm_1

      println("Atualizacao EKF-SLAM:")
      println("  Nova pose refinada do robo: x_r = " + x_r)
      println("  Nova coordenada refinada do marco: m1 = " + m1)

      route {
            x_r == 21 and m1 == 49 ==> {
                  println("Localizacao e mapa refinados simultaneamente pelo filtro de Kalman estendido!")
            }
            _ ==> {
                  println("Divergencia no filtro SLAM")
            }
      }

      println("EKF-SLAM concluido com sucesso.")
}
