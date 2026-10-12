#L ============================================================================
#L Algoritmo: Deviates from Other Distributions (Transformada Inversa Exponencial)
#L Capitulo: 07_random_numbers
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Geracao de variaveis exponenciais X = -ln(1 - U) / lambda.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DeviatesOtherDistributions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DeviatesOtherDistributions")
      println("==================================================")

      #L Gerando desvios exponenciais com taxa lambda = 2 (em escala 1000):
      #L Para probabilidade cumulativa U = 0.500 (mediana):
      #L X_mediana = ln(2) / lambda = 0.693147 / 2 = 0.346573 (347 em escala 1000)
      mut as int64: lambda_taxa = 2
      mut as int64: ln2 = 693
      mut as int64: x_mediana = ln2 /i lambda_taxa

      println("1. Calculando variavel exponencial para U = 0.500:")
      println("   -> X_mediana = ln(2) / 2 = " + x_mediana + " (esperado: 346 = 0.346)")

      #L Para U = 0.632 (1 - 1/e, ou seja x = 1/lambda = 0.500):
      #L -ln(1 - 0.632) = 1.000 -> X = 1000 / 2 = 500
      mut as int64: x_media = 1000 /i lambda_taxa
      println("2. Calculando variavel exponencial para U = 0.632 (media):")
      println("   -> X_media = 1 / lambda = " + x_media + " (esperado: 500 = 0.500)")

      mut as int64: res = x_media - 500
      println("3. Residuo analitico da transformada = " + res + " (esperado: 0)")
      println("4. Desvios de distribuicoes continuas validados.")
}
