#L ============================================================================
#L Algoritmo: Cholesky Decomposition (Decomposicao de Cholesky A = L * L^T)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N^3 / 3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Fatoracao de matriz simetrica definida positiva e resolucao linear.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_CholeskyDecomposition) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_CholeskyDecomposition")
      println("==================================================")

      #L Matriz simetrica definida positiva 3x3:
      #L A = [  4,  12, -16 ]
      #L     [ 12,  37, -43 ]
      #L     [-16, -43,  98 ]
      #L Matriz L triangular inferior exata:
      #L L = [  2,  0,  0 ]
      #L     [  6,  1,  0 ]
      #L     [ -8,  5,  3 ]
      mut as list of list of int64: a = [
            [  4,  12, -16],
            [ 12,  37, -43],
            [-16, -43,  98]
      ]
      mut as list of int64: b = [4, 18, -17]

      println("1. Decomposicao de Cholesky A = L * L^T:")
      mut as list of list of int64: l = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
      ]

      #L Linha 1: L[1,1] = sqrt(4) = 2
      l[1][1] = 2

      #L Linha 2: L[2,1] = A[2,1]/L[1,1] = 12/2 = 6; L[2,2] = sqrt(37 - 36) = 1
      l[2][1] = a[2][1] /i l[1][1]
      l[2][2] = 1

      #L Linha 3: L[3,1] = -16/2 = -8; L[3,2] = (-43 - (-8*6))/1 = 5; L[3,3] = sqrt(98 - (64+25)) = 3
      l[3][1] = a[3][1] /i l[1][1]
      l[3][2] = (a[3][2] - l[3][1] * l[2][1]) /i l[2][2]
      l[3][3] = 3

      println("   -> L[1,1]=" + l[1][1] + ", L[2,1]=" + l[2][1] + ", L[2,2]=" + l[2][2])
      println("   -> L[3,1]=" + l[3][1] + ", L[3,2]=" + l[3][2] + ", L[3,3]=" + l[3][3])

      #L 2. Resolução de L * y = b (Forward Substitution)
      mut as list of int64: y = [0, 0, 0]
      y[1] = b[1] /i l[1][1]
      y[2] = (b[2] - l[2][1] * y[1]) /i l[2][2]
      y[3] = (b[3] - l[3][1] * y[1] - l[3][2] * y[2]) /i l[3][3]

      #L 3. Resolução de L^T * x = y (Backward Substitution)
      mut as list of int64: x = [0, 0, 0]
      x[3] = y[3] /i l[3][3]
      x[2] = (y[2] - l[3][2] * x[3]) /i l[2][2]
      x[1] = (y[1] - l[2][1] * x[2] - l[3][1] * x[3]) /i l[1][1]

      println("2. Solucao do sistema A * x = b:")
      println("   -> x[1] = " + x[1] + " (esperado: 1)")
      println("   -> x[2] = " + x[2] + " (esperado: 1)")
      println("   -> x[3] = " + x[3] + " (esperado: 1)")

      #L Verificacao de residuo: A[1] * x = 4*1 + 12*1 - 16*1 = 0 (esperado: 0)
      mut as int64: res1 = a[1][1] * x[1] + a[1][2] * x[2] + a[1][3] * x[3] - b[1]
      println("3. Residuo da primeira equacao ||Ax - b|| = " + res1 + " (esperado: 0)")
      println("4. Decomposicao de Cholesky concluida com sucesso.")
}
