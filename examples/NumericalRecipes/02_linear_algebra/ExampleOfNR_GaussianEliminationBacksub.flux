#L ============================================================================
#L Algoritmo: Gaussian Elimination with Backsubstitution
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Escalonamento triangular superior com substituicao regressiva.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_GaussianEliminationBacksub) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_GaussianEliminationBacksub")
      println("==================================================")

      #L Matriz aumentada [A | b] para resolucao de 3x3:
      #L  2*x + 1*y - 1*z =  8
      #L -3*x - 1*y + 2*z = -11
      #L -2*x + 1*y + 2*z = -3
      mut as list of list of int64: m = [
            [ 2000,  1000, -1000,   8000],
            [-3000, -1000,  2000, -11000],
            [-2000,  1000,  2000,  -3000]
      ]

      println("1. Escalonando para matriz triangular superior:")
      #L Eliminacao da linha 2 usando linha 1: fator = -3000 * 1000 / 2000 = -1500
      mut as int64: f21 = (m[2][1] * 1000) /i m[1][1]
      mut as int64: c = 1
      infinite (c <= 4) {
            m[2][c] = m[2][c] - (f21 * m[1][c]) /i 1000
            c = c + 1
      }

      #L Eliminacao da linha 3 usando linha 1: fator = -2000 * 1000 / 2000 = -1000
      mut as int64: f31 = (m[3][1] * 1000) /i m[1][1]
      c = 1
      infinite (c <= 4) {
            m[3][c] = m[3][c] - (f31 * m[1][c]) /i 1000
            c = c + 1
      }

      #L Eliminacao da linha 3 usando linha 2: fator = m[3][2] * 1000 / m[2][2]
      mut as int64: f32 = (m[3][2] * 1000) /i m[2][2]
      c = 2
      infinite (c <= 4) {
            m[3][c] = m[3][c] - (f32 * m[2][c]) /i 1000
            c = c + 1
      }

      println("2. Executando substituicao regressiva (Backsubstitution):")
      mut as int64: z = (m[3][4] * 1000) /i m[3][3]
      mut as int64: y = ((m[2][4] - (m[2][3] * z) /i 1000) * 1000) /i m[2][2]
      mut as int64: x = ((m[1][4] - (m[1][2] * y) /i 1000 - (m[1][3] * z) /i 1000) * 1000) /i m[1][1]

      mut as int64: sol_x = x /i 1000
      mut as int64: sol_y = y /i 1000
      mut as int64: sol_z = z /i 1000

      println("   -> x = " + sol_x + " (esperado: 2)")
      println("   -> y = " + sol_y + " (esperado: 3)")
      println("   -> z = " + sol_z + " (esperado: -1)")

      mut as int64: residual = 2 * sol_x + sol_y - sol_z - 8
      println("3. Residuo analitico da equacao = " + residual + " (esperado: 0)")
      println("4. Eliminacao Gaussiana concluida com exito.")
}
