#L ============================================================================
#L Algoritmo: LU Decomposition (Decomposicao LU de Crout com Substituicao)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Fatoracao A = L * U e calculo de determinante.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_LUDecomposition) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_LUDecomposition")
      println("==================================================")

      #L Matriz A 3x3 e vetor b:
      #L A = [ [1, 2,  4],
      #L       [3, 8, 14],
      #L       [2, 6, 13] ]
      #L Fatoracao LU de Doolittle:
      #L L = [ [1, 0, 0],   U = [ [1, 2, 4],
      #L       [3, 1, 0],         [0, 2, 2],
      #L       [2, 1, 1] ]        [0, 0, 3] ]
      #L det(A) = 1 * 2 * 3 = 6
      mut as list of list of int64: a = [
            [1, 2,  4],
            [3, 8, 14],
            [2, 6, 13]
      ]
      mut as list of int64: b = [17, 61, 49]

      println("1. Decomposicao LU da matriz A 3x3:")
      mut as list of list of int64: l = [
            [1, 0, 0],
            [0, 1, 0],
            [0, 0, 1]
      ]
      mut as list of list of int64: u = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
      ]

      #L Linha 1 de U
      u[1][1] = a[1][1]
      u[1][2] = a[1][2]
      u[1][3] = a[1][3]

      #L Coluna 1 de L
      l[2][1] = a[2][1] /i u[1][1]
      l[3][1] = a[3][1] /i u[1][1]

      #L Linha 2 de U
      u[2][2] = a[2][2] - l[2][1] * u[1][2]
      u[2][3] = a[2][3] - l[2][1] * u[1][3]

      #L Coluna 2 de L
      l[3][2] = (a[3][2] - l[3][1] * u[1][2]) /i u[2][2]

      #L Linha 3 de U
      u[3][3] = a[3][3] - (l[3][1] * u[1][3] + l[3][2] * u[2][3])

      mut as int64: det = u[1][1] * u[2][2] * u[3][3]
      println("   -> Determinante det(A) = " + det + " (esperado: 6)")

      println("2. Resolução do sistema L * y = b e U * x = y:")
      #L Forward L * y = b
      mut as list of int64: y = [0, 0, 0]
      y[1] = b[1]
      y[2] = b[2] - l[2][1] * y[1]
      y[3] = b[3] - l[3][1] * y[1] - l[3][2] * y[2]

      #L Backward U * x = y
      mut as list of int64: x = [0, 0, 0]
      x[3] = y[3] /i u[3][3]
      x[2] = (y[2] - u[2][3] * x[3]) /i u[2][2]
      x[1] = (y[1] - u[1][2] * x[2] - u[1][3] * x[3]) /i u[1][1]

      println("   -> x[1] = " + x[1] + " (esperado: 1)")
      println("   -> x[2] = " + x[2] + " (esperado: 2)")
      println("   -> x[3] = " + x[3] + " (esperado: 3)")

      mut as int64: check_eq = a[1][1]*x[1] + a[1][2]*x[2] + a[1][3]*x[3]
      println("3. Verificacao da equacao A[1]*x = " + check_eq + " (esperado: 17)")
      println("4. Fatoracao LU concluida com sucesso.")
}
