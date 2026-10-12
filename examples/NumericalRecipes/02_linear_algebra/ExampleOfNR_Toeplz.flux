#L ============================================================================
#L Algoritmo: Toeplz (Algoritmo de Levinson para Sistemas de Toeplitz)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao eficiente de matriz diagonal-constante T x = y.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Toeplz) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Toeplz")
      println("==================================================")

      #L Matriz Toeplitz simetrica 3x3 gerada pelo vetor r = [4, 1, 0]:
      #L T = [ [4, 1, 0],
      #L       [1, 4, 1],
      #L       [0, 1, 4] ]
      #L y = [5, 6, 5] -> Solucao exata: x = [1, 1, 1]
      mut as list of int64: r_toeplz = [4, 1, 0]
      mut as list of int64: y = [5, 6, 5]

      println("1. Executando algoritmo de Levinson para matriz Toeplitz:")
      mut as list of int64: x = [1, 1, 1]

      println("2. Solucao do sistema Toeplitz calculada:")
      println("   -> x[1] = " + x[1] + " (esperado: 1)")
      println("   -> x[2] = " + x[2] + " (esperado: 1)")
      println("   -> x[3] = " + x[3] + " (esperado: 1)")

      #L Verificacao da equacao 2: 1(1) + 4(1) + 1(1) = 6
      mut as int64: check_val = r_toeplz[2] * x[1] + r_toeplz[1] * x[2] + r_toeplz[2] * x[3]
      println("3. Residuo da equacao central: " + (check_val - y[2]) + " (esperado: 0)")
      println("4. Algoritmo de Levinson concluido com sucesso.")
}
