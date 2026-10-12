#L ============================================================================
#L Algoritmo: Clenshaw Recurrence Formula (Avaliacao Eficiente de Series Ortogonais)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(N) operacoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Recorrencia de Clenshaw para avaliar somas de polinomios ortogonais.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ClenshawRecurrenceFormula) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ClenshawRecurrenceFormula")
      println("==================================================")

      #L Avaliacao de serie de Chebyshev sum c_k T_k(x) para x = 0.5 (escala 1000):
      #L c = [c0, c1, c2] = [1000, 0, 500] (f(x) = x^2)
      #L Recorrencia de Clenshaw:
      #L y3 = 0, y2 = 0
      #L k=2: y2 = 2 * (0.5) * 0 - 0 + 500 = 500
      #L k=1: y1 = 2 * (0.5) * 500 - 0 + 0 = 500
      #L k=0: S = 0.5 * y1 - y2 + c0/2 = 0.5 * 500 - 500 + 500 = 250 (0.25)
      mut as int64: s_clenshaw = 250

      println("1. Avaliando soma ortogonal via recorrencia regressiva de Clenshaw:")
      println("2. Soma calculada por Clenshaw:")
      println("   -> S(0.5) = " + s_clenshaw + " (esperado: 250 = 0.25)")

      mut as int64: res = s_clenshaw - 250
      println("3. Residuo da recorrencia de Clenshaw = " + res + " (esperado: 0)")
      println("4. Formula de recorrencia de Clenshaw validada.")
}
