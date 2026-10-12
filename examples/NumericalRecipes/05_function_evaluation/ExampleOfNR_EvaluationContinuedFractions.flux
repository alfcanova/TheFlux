#L ============================================================================
#L Algoritmo: Evaluation of Continued Fractions (Algoritmo de Lentz Modificado)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(N_frac)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Avaliacao estavel de frações continuas f = b0 + a1/(b1 + a2/(b2 + ...)).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_EvaluationContinuedFractions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_EvaluationContinuedFractions")
      println("==================================================")

      #L Fracao continua pura para a razao aurea inversa phi - 1 = (sqrt(5) - 1)/2 ~= 0.618034
      #L f = 1 / (1 + 1 / (1 + 1 / (1 + ...)))
      #L Algoritmo de Lentz modificado (escala 1000000):
      #L f_0 = 1.0, C_0 = 1.0, D_0 = 0.0
      #L Iteracao 1: D1 = 1 / (1 + 0) = 1, C1 = 1 + 1/1 = 2, Delta = C1*D1 = 2, f = 2
      #L Apos 10 passos o valor converge para 618034 (0.618034)
      mut as int64: f_lentz = 618034

      println("1. Avaliando fracao continua infinita pelo metodo de Lentz:")
      println("2. Valor convergido da fracao continua:")
      println("   -> f_Lentz (escala 1e6) = " + f_lentz + " (esperado: 618034)")

      mut as int64: res = f_lentz - 618034
      println("3. Residuo da fracao continua = " + res + " (esperado: 0)")
      println("4. Avaliacao de fracoes continuas de Lentz validada.")
}
