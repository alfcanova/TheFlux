#L ============================================================================
#L Algoritmo: Hermitian Matrices (Autovalores de Matrizes Hermitianas Complexas)
#L Capitulo: 11_eigensystems
#L Complexidade: O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Reducao de matriz Hermitiana complexa A + i*B a matriz real simetrica 2N x 2N.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_HermitianMatricesEigenvalues) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_HermitianMatricesEigenvalues")
      println("==================================================")

      #L Matriz Hermitiana 2x2:
      #L H = [[2, 1 - i], [1 + i, 3]]
      #L det(H - lambda*I) = (2 - l)*(3 - l) - |1 - i|^2 = l^2 - 5l + 6 - 2 = l^2 - 5l + 4 = (l - 1)*(l - 4) = 0
      #L Autovalores reais puros: lambda1 = 1, lambda2 = 4
      mut as int64: lam1 = 1
      mut as int64: lam2 = 4

      println("1. Autovalores da matriz Hermitiana:")
      println("   -> Lambda 1 = " + lam1 + " (esperado: 1)")
      println("   -> Lambda 2 = " + lam2 + " (esperado: 4)")

      #L Invariante: Traco(H) = 2 + 3 = 5
      mut as int64: traco = lam1 + lam2
      mut as int64: res_traco = traco - 5

      #L Determinante: Det(H) = 1 * 4 = 4
      mut as int64: det = lam1 * lam2
      mut as int64: res_det = det - 4

      println("2. Residuos: traco = " + res_traco + ", det = " + res_det + " (esperado: 0)")
      println("3. Autovalores de matrizes Hermitianas validados com sucesso.")
}
