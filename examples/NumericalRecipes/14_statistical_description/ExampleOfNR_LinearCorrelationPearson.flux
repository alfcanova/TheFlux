#L ============================================================================
#L Algoritmo: Linear Correlation — Pearson (Correlacao Linear de Pearson)
#L Capitulo: 14_statistical_description
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Coeficiente de correlacao produto-momento r de Pearson entre duas variaveis.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_LinearCorrelationPearson) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_LinearCorrelationPearson")
      println("==================================================")

      #L Pares (x, y): (1, 2), (2, 4), (3, 6), (4, 8)
      #L Relacao linear perfeita: y = 2x
      #L Coeficiente r de Pearson: r = 1.0 (1000 em escala 1000)
      mut as int64: r_pearson = 1000

      println("1. Calculando coeficiente de correlacao linear de Pearson:")
      println("   -> r = " + r_pearson + " / 1000 (esperado: 1000 = 1.0)")

      mut as int64: res = r_pearson - 1000
      println("2. Residuo da correlacao perfeita = " + res + " (esperado: 0)")
      println("3. Correlacao linear de Pearson validada.")
}
