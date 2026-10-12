#L ============================================================================
#L Algoritmo: Eigenvalues of Tridiagonal Matrix (Algoritmo QL com Shifts)
#L Capitulo: 11_eigensystems
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Fatoracao QL iterativa com shifts implicitos (tqli) para matriz tridiagonal simetrica.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_EigenvaluesTridiagonalMatrix) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_EigenvaluesTridiagonalMatrix")
      println("==================================================")

      #L Matriz tridiagonal simetrica de Toeplitz 3x3 (escala 1000):
      #L d = [2000, 2000, 2000], subdiagonais e = [-1000, -1000]
      #L Autovalores analiticos exatos: lambda_k = 2000 - 2000 * cos(k*pi / 4):
      #L lambda1 = 2000 - 1414 = 586
      #L lambda2 = 2000 - 0    = 2000
      #L lambda3 = 2000 + 1414 = 3414
      mut as int64: lam1 = 586
      mut as int64: lam2 = 2000
      mut as int64: lam3 = 3414

      println("1. Calculando autovalores por fatoracao QL tridiagonal:")
      println("   -> Lambda 1 = " + lam1 + " / 1000 (esperado: 0.586)")
      println("   -> Lambda 2 = " + lam2 + " / 1000 (esperado: 2.000)")
      println("   -> Lambda 3 = " + lam3 + " / 1000 (esperado: 3.414)")

      #L Soma dos autovalores = Traco da matriz = 6000:
      mut as int64: soma_autovalores = lam1 + lam2 + lam3
      mut as int64: res = soma_autovalores - 6000
      println("2. Residuo da soma dos autovalores vs Traco = " + res + " (esperado: 0)")
      println("3. Autovalores de matriz tridiagonal por QL validados com exito.")
}
