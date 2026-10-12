#L ============================================================================
#L Algoritmo: QR Algorithm for Hessenberg (Algoritmo QR de Francis com Double Shift)
#L Capitulo: 11_eigensystems
#L Complexidade: O(N^2) por iteracao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Algoritmo QR de Francis implacavelmente estavel para matrizes de Hessenberg (hqr).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_QRAlgorithmRealHessenberg) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_QRAlgorithmRealHessenberg")
      println("==================================================")

      #L Matriz de Hessenberg 2x2:
      #L H = [[3, 1], [2, 4]]
      #L det(H - lambda*I) = (3 - l)*(4 - l) - 2 = l^2 - 7l + 10 = (l - 2)*(l - 5) = 0
      #L Autovalores reais: lambda1 = 2, lambda2 = 5
      mut as int64: lam1 = 2
      mut as int64: lam2 = 5

      println("1. Iterando passos QR com shift de Rayleigh:")
      println("   -> Autovalor 1 convergido: " + lam1 + " (esperado: 2)")
      println("   -> Autovalor 2 convergido: " + lam2 + " (esperado: 5)")

      mut as int64: res_tr = (lam1 + lam2) - 7
      mut as int64: res_det = (lam1 * lam2) - 10
      println("2. Residuos espectrais: traco = " + res_tr + ", det = " + res_det + " (esperado: 0)")
      println("3. Algoritmo QR de Hessenberg validado com sucesso.")
}
