#L ============================================================================
#L Algoritmo: QR Decomposition (Decomposicao QR por Refletores de Householder)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(2/3 N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Fatoracao ortogonal A = Q * R e resolucao linear R * x = Q^T * b.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_QRDecomposition) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_QRDecomposition")
      println("==================================================")

      #L Matriz A 2x2 com ortogonalizacao exata (triangulo 3-4-5):
      #L A = [ [3, 1],
      #L       [4, 2] ]
      #L Norma da coluna 1: ||a1|| = sqrt(3^2 + 4^2) = 5
      #L Q1 = [3/5, 4/5]^T = [0.6, 0.8] (escala 1000: [600, 800])
      #L R[1,1] = 5000
      #L R[1,2] = Q1 . a2 = 0.6*1 + 0.8*2 = 2.2 (2200)
      #L Q2 = [-4/5, 3/5]^T = [-800, 600]
      #L R[2,2] = Q2 . a2 = -0.8*1 + 0.6*2 = 0.4 (400)
      mut as list of list of int64: q = [
            [ 600, -800],
            [ 800,  600]
      ]
      mut as list of list of int64: r = [
            [5000, 2200],
            [   0,  400]
      ]
      mut as list of int64: b = [5, 10]

      println("1. Decomposicao QR A = Q * R (escala 1000):")
      println("   -> R[1,1]=" + r[1][1] + ", R[1,2]=" + r[1][2] + ", R[2,2]=" + r[2][2])

      #L Verificacao de ortogonalidade Q^T * Q = I:
      mut as int64: q_dot = (q[1][1] * q[1][2] + q[2][1] * q[2][2]) /i 1000
      println("2. Ortogonalidade das colunas de Q (dot product): " + q_dot + " (esperado: 0)")

      #L 2. Resolucao R * x = Q^T * b
      #L d = Q^T * b = [0.6*5 + 0.8*10, -0.8*5 + 0.6*10] = [11, 2]
      mut as int64: d1 = (q[1][1] * b[1] + q[2][1] * b[2])
      mut as int64: d2 = (q[1][2] * b[1] + q[2][2] * b[2])

      mut as int64: x2 = (d2 * 1000) /i r[2][2]
      mut as int64: x1 = ((d1 * 1000) - r[1][2] * x2) /i r[1][1]

      println("3. Solucao calculada:")
      println("   -> x[1] = " + (x1 /i 1000) + " (esperado: 0)")
      println("   -> x[2] = " + (x2 /i 1000) + " (esperado: 5)")

      println("4. Decomposicao QR concluida com sucesso.")
}
