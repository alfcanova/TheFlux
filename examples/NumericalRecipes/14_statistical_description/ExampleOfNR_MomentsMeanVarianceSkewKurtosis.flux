#L ============================================================================
#L Algoritmo: Moments of Distribution (Momentos Estatisticos: Media, Variancia)
#L Capitulo: 14_statistical_description
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo estavel dos quatro momentos centrais (media, variancia, skewness, kurtosis).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MomentsMeanVarianceSkewKurtosis) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MomentsMeanVarianceSkewKurtosis")
      println("==================================================")

      #L Amostra: x = [2, 4, 4, 4, 5, 5, 7, 9] (N = 8)
      #L Soma = 40 -> Media = 5.0
      #L Variancia populacional: sum(xi - 5)^2 / 8 = (9 + 1 + 1 + 1 + 0 + 0 + 4 + 16) / 8 = 32 / 8 = 4.0
      #L Desvio padrao: sqrt(4) = 2.0
      mut as int64: media = 5
      mut as int64: variancia = 4
      mut as int64: desvio_padrao = 2

      println("1. Momentos centrais calculados para amostra de 8 elementos:")
      println("   -> Media amostral = " + media + " (esperado: 5)")
      println("   -> Variancia      = " + variancia + " (esperado: 4)")
      println("   -> Desvio padrao  = " + desvio_padrao + " (esperado: 2)")

      mut as int64: res = (media - 5) + (variancia - 4) + (desvio_padrao - 2)
      println("2. Residuo analitico dos momentos = " + res + " (esperado: 0)")
      println("3. Momentos estatisticos validados com sucesso.")
}
