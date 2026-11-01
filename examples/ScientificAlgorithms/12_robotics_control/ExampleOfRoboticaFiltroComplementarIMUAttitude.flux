#L ============================================================================
#L Algoritmo: Filtro Complementar IMU (Fusao Sensorial Giroscopio / Acelerometro)
#L Dominio: 12_robotics_control / Categoria: Estimacao de Estado e Fusao Sensorial
#L Descricao: Fusao espectral passo-alta/baixa para atitude (pitch/roll) sem drift de integracao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaFiltroComplementarIMUAttitude) {
      println("=== Algoritmo: Filtro Complementar IMU (Fusao Giro/Accel) ===")

      #L Estimativa inicial do angulo de inclinacao (pitch): theta = 0 graus
      #L Fator de ponderacao do filtro complementar: alpha = 0.95 (950 em escala x1000)
      #L Peso do giroscopio (passo-alta): 95%
      #L Peso do acelerometro (passo-baixa): 5% (50 em escala x1000)
      #L Intervalo de amostragem dt = 0.1 s (100 ms)
      mut as int64: theta_pitch = 0
      mut as int64: alpha = 950
      mut as int64: one_minus_alpha = 50

      println("Parametros: alpha = " + alpha + "/1000 (Giro), (1-alpha) = " + one_minus_alpha + "/1000 (Accel)")

      #L Amostra 1 do sensor IMU em voo/deslocamento:
      #L Giroscopio mede velocidade angular omega = +10 graus/s
      #L Integracao pura do giroscopio acumularia: omega * dt = 10 * 0.1 = 1 grau (1000 mdeg)
      #L Acelerometro mede inclinacao gravitacional quase estavel: theta_acc = 800 mdeg (0.8 graus)
      mut as int64: gyro_integral_step = 1000
      mut as int64: accel_pitch = 800

      #L Equacao do Filtro Complementar:
      #L theta = alpha * (theta_anterior + gyro_integral) + (1 - alpha) * theta_accel
      #L Termo giro = 950 * (0 + 1000) / 1000 = 950
      #L Termo accel = 50 * 800 / 1000 = 40
      #L Novo theta = 950 + 40 = 990 mdeg (0.99 graus)
      mut as int64: term_gyro = (alpha * (theta_pitch + gyro_integral_step)) /i 1000
      mut as int64: term_acc = (one_minus_alpha * accel_pitch) /i 1000
      theta_pitch = term_gyro + term_acc

      println("Passo 1 de fusao sensorial:")
      println("  Contribuicao do Giroscopio:   " + term_gyro + " mdeg")
      println("  Correcao de drift pelo Accel: " + term_acc + " mdeg")
      println("  Angulo de inclinacao Pitch estimado: " + theta_pitch + " mdeg")

      #L Amostra 2 (estabilizacao do drone):
      #L Giroscopio zera (omega = 0)
      #L Acelerometro confirma inclinacao real de 1000 mdeg
      mut as int64: term_gyro2 = (alpha * theta_pitch) /i 1000
      mut as int64: term_acc2 = (one_minus_alpha * 1000) /i 1000
      theta_pitch = term_gyro2 + term_acc2
      println("Passo 2 (Estabilizacao do Pitch): " + theta_pitch + " mdeg")

      route {
            theta_pitch > 900 and theta_pitch <= 1000 ==> {
                  println("Estimativa de atitude IMU estavel: Deriva eliminada sem custo de matrizes de covariancia!")
            }
            _ ==> {
                  println("Divergencia na estimativa IMU")
            }
      }

      println("Filtro Complementar IMU concluido com sucesso.")
}
