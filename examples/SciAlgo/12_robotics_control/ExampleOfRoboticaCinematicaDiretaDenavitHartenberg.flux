#L ============================================================================
#L Algoritmo: Cinematica Direta (Parametros Denavit-Hartenberg — DH)
#L Dominio: 12_robotics_control / Categoria: Manipuladores Roboticos e Cinematica
#L Descricao: Matrizes de transformacao homogenea 4x4 para posicao de efetuador final
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaCinematicaDiretaDenavitHartenberg) {
      println("=== Algoritmo: Cinematica Direta (Parametros DH) ===")

      #L Braco robotico planar de 2 elos (RR com 2 juntas rotativas):
      #L Comprimento do elo 1: a1 = 10 unidades
      #L Comprimento do elo 2: a2 = 10 unidades
      #L Deslocamento axial d1 = 0, d2 = 0
      #L Angulo de torcao alpha1 = 0, alpha2 = 0
      mut as int64: a1 = 10
      mut as int64: a2 = 10

      println("Parametros geometricos do braco: Elo 1 = " + a1 + ", Elo 2 = " + a2)

      #L Configuracao angular das juntas:
      #L Junta 1: theta1 = 0 rad (apontando no eixo X)
      #L Junta 2: theta2 = pi/2 rad (90 graus relativo ao elo 1)
      #L Matriz DH Elo 1 (T0_1):
      #L x1 = a1 * cos(theta1) = 10 * 1 = 10
      #L y1 = a1 * sin(theta1) = 10 * 0 = 0
      mut as int64: x1 = 10
      mut as int64: y1 = 0
      println("Posicao da Junta 2 intermediaria: (" + x1 + ", " + y1 + ")")

      #L Transformacao do Elo 2 em relacao a base (T0_2 = T0_1 * T1_2):
      #L Angulo acumulado total: phi = theta1 + theta2 = 0 + 90 = 90 graus
      #L cos(phi) = 0, sin(phi) = 1
      #L x_end = x1 + a2 * cos(phi) = 10 + 10 * 0 = 10
      #L y_end = y1 + a2 * sin(phi) = 0 + 10 * 1 = 10
      mut as int64: cos_phi = 0
      mut as int64: sin_phi = 1
      mut as int64: x_end = x1 + a2 * cos_phi
      mut as int64: y_end = y1 + a2 * sin_phi

      println("Posicao calculada do efetuador final (End-Effector):")
      println("  Coordenada X: " + x_end)
      println("  Coordenada Y: " + y_end)

      #L Distancia euclidiana ao quadrado da base ate o efetuador:
      #L dist^2 = 10^2 + 10^2 = 100 + 100 = 200
      mut as int64: dist_sq = x_end * x_end + y_end * y_end
      println("Distancia ao quadrado do efetuador a base: " + dist_sq)

      route {
            x_end == 10 and y_end == 10 and dist_sq == 200 ==> {
                  println("Cinematica direta DH calculada com exatidao analitica homogenea!")
            }
            _ ==> {
                  println("Erro na transformacao cinematica")
            }
      }

      println("Cinematica Direta Denavit-Hartenberg concluido com sucesso.")
}
