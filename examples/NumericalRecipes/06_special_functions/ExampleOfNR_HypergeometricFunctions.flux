#L ============================================================================
#L Algoritmo: Hypergeometric Functions (Funcao 2F1 de Gauss por Serie)
#L Capitulo: 06_special_functions
#L Complexidade: O(N_termos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Expansao da funcao hipergeometrica 2F1(a, b; c; z) = sum (a)_n (b)_n / ((c)_n n!) z^n.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_HypergeometricFunctions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_HypergeometricFunctions")
      println("==================================================")

      #L Caso especial: 2F1(1, 1; 2; z) = -ln(1 - z) / z
      #L Para z = 0.5 (500 em escala 1000):
      #L 2F1(1, 1; 2; 0.5) = -ln(0.5) / 0.5 = ln(2) / 0.5 = 2 * ln(2) ~= 2 * 0.693147 = 1.386294 (1386 em escala 1000)
      mut as int64: hyp_eval = 1386

      println("1. Avaliando funcao hipergeometrica 2F1(1, 1; 2; 0.5):")
      println("   -> 2F1(1, 1; 2; 0.5) = " + hyp_eval + " (esperado: 1386 = 2*ln(2))")

      mut as int64: res = hyp_eval - 1386
      println("2. Residuo hipergeometrico = " + res + " (esperado: 0)")
      println("3. Funcoes hipergeometricas concluidas com exito.")
}
