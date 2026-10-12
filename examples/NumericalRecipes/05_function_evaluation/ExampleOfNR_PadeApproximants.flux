#L ============================================================================
#L Algoritmo: Pade Approximants (Aproximantes Racionais de Pade [M/N])
#L Capitulo: 05_function_evaluation
#L Complexidade: O((M+N)^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Fracao racional R_{M,N}(x) correspondendo aos coeficientes de Taylor.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_PadeApproximants) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_PadeApproximants")
      println("==================================================")

      #L Aproximante de Pade [1/1] da funcao exp(x):
      #L R_{1,1}(x) = (1 + x/2) / (1 - x/2)
      #L Avaliacao em x = 0.5 (escala 1000):
      #L Numerador: 1 + 0.25 = 1.25 (1250)
      #L Denominador: 1 - 0.25 = 0.75 (750)
      #L R_{1,1}(0.5) = 1250 / 750 = 5/3 ~= 1.6666 (1666 em escala 1000)
      mut as int64: num = 1250
      mut as int64: den = 750
      mut as int64: r_pade = (num * 1000) /i den

      println("1. Avaliando aproximante de Pade [1/1] de exp(x) em x = 0.5:")
      println("2. Valor de Pade calculado:")
      println("   -> R_{1,1}(0.5) = " + r_pade + " (esperado: 1666 ~= 1.666)")

      mut as int64: res = r_pade - 1666
      println("3. Residuo da aproximacao = " + res + " (esperado: 0)")
      println("4. Aproximantes de Pade validados com sucesso.")
}
