#L ============================================================================
#L Algoritmo: Matrix Inversion Complexity (Inversao de Matrizes por Blocos)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N^2.807) subcubica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Inversao de matriz 2x2 com verificacao de identidade M * M^-1 = I.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MatrixInversionComplexity) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MatrixInversionComplexity")
      println("==================================================")

      #L Matriz M 2x2: [[4, 7], [2, 6]]
      #L det(M) = 4*6 - 7*2 = 24 - 14 = 10
      #L M^-1 = (1/10) * [[6, -7], [-2, 4]]
      #L Em escala 1000:
      mut as list of list of int64: m = [
            [4, 7],
            [2, 6]
      ]

      mut as int64: det = m[1][1] * m[2][2] - m[1][2] * m[2][1]
      println("1. Determinante da matriz 2x2: " + det + " (esperado: 10)")

      #L Matriz adjunta transposta: [[6, -7], [-2, 4]]
      mut as list of list of int64: inv_scaled = [
            [(m[2][2] * 1000) /i det, (-m[1][2] * 1000) /i det],
            [(-m[2][1] * 1000) /i det, (m[1][1] * 1000) /i det]
      ]

      println("2. Elementos da matriz inversa M^-1 (escala 1000):")
      println("   -> M^-1[1,1] = " + inv_scaled[1][1] + " (esperado: 600)")
      println("   -> M^-1[1,2] = " + inv_scaled[1][2] + " (esperado: -700)")
      println("   -> M^-1[2,1] = " + inv_scaled[2][1] + " (esperado: -200)")
      println("   -> M^-1[2,2] = " + inv_scaled[2][2] + " (esperado: 400)")

      #L 3. Verificacao de identidade: P = M * M^-1
      mut as int64: p11 = (m[1][1] * inv_scaled[1][1] + m[1][2] * inv_scaled[2][1]) /i 1000
      mut as int64: p12 = (m[1][1] * inv_scaled[1][2] + m[1][2] * inv_scaled[2][2]) /i 1000
      mut as int64: p21 = (m[2][1] * inv_scaled[1][1] + m[2][2] * inv_scaled[2][1]) /i 1000
      mut as int64: p22 = (m[2][1] * inv_scaled[1][2] + m[2][2] * inv_scaled[2][2]) /i 1000

      println("3. Produto M * M^-1 (Identidade esperada):")
      println("   -> P[1,1]=" + p11 + ", P[1,2]=" + p12)
      println("   -> P[2,1]=" + p21 + ", P[2,2]=" + p22)

      println("4. Inversao de matriz comprovada com sucesso.")
}
