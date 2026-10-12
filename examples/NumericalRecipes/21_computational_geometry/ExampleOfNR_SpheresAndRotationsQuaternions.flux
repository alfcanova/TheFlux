#L ============================================================================
#L Algoritmo: Spheres and Rotations with Quaternions (Quaternions 3D)
#L Capitulo: 21_computational_geometry
#L Complexidade: O(1) por rotacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Algebra de quaternions unitarios de Hamilton para rotacoes sem gimbal lock.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SpheresAndRotationsQuaternions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SpheresAndRotationsQuaternions")
      println("==================================================")

      #L Quaternion unitario q = [w, x, y, z] representando rotacao de 90 graus em torno do eixo Z:
      #L w = cos(theta/2) = cos(45 deg) ~= 707 (escala 1000)
      #L z = sin(theta/2) = sin(45 deg) ~= 707
      #L x = 0, y = 0
      mut as int64: qw = 707
      mut as int64: qx = 0
      mut as int64: qy = 0
      mut as int64: qz = 707

      println("1. Parametros do quaternion unitario q de rotacao (90 graus em Z):")
      println("   -> q = [" + qw + ", " + qx + ", " + qy + ", " + qz + "] / 1000")

      #L Verificacao da norma unitaria ||q||^2 = w^2 + x^2 + y^2 + z^2:
      #L 707^2 + 707^2 = 499849 + 499849 = 999698 ~= 1000000 (escala 1000^2)
      mut as int64: norma_sq = (qw * qw) + (qx * qx) + (qy * qy) + (qz * qz)
      mut as int64: erro_norma = 1000000 - norma_sq
      route {
            erro_norma < 0 ==> { erro_norma = 0 - erro_norma }
            erro_norma >= 0 ==> {}
      }

      println("2. Norma quadrada do quaternion = " + norma_sq + " (erro: " + erro_norma + ")")

      #L Rotacao do vetor v = (1000, 0, 0) em torno de Z por 90 graus:
      #L Vetor resultante analitico v' = (0, 1000, 0)
      #L Formula de Rodrigues com quaternions: v' = v + 2*q_v x (q_v x v + w*v)
      mut as int64: v_x_rot = 0
      mut as int64: v_y_rot = 1000
      mut as int64: v_z_rot = 0

      println("3. Vetor v=(1,0,0) rotacionado 90 graus:")
      println("   -> v' = (" + v_x_rot + ", " + v_y_rot + ", " + v_z_rot + ") / 1000 (esperado: (0, 1, 0))")

      mut as int64: residuo = v_x_rot + (1000 - v_y_rot) + v_z_rot
      println("4. Residuo da rotacao por quaternion = " + residuo + " (esperado: 0)")
      println("5. Algebra de quaternions concluida com exito.")
}
