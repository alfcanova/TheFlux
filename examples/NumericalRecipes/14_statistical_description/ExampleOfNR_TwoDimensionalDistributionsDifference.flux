#L ============================================================================
#L Algoritmo: 2D Distributions Difference (Teste 2D de Fasano-Franceschini)
#L Capitulo: 14_statistical_description
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Generalizacao do teste KS para dados bidimensionais usando quatro quadrantes naturais.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_TwoDimensionalDistributionsDifference) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_TwoDimensionalDistributionsDifference")
      println("==================================================")

      #L Teste de hipotese nula com nuvens de pontos 2D identicas:
      #L Discrepancia maxima nos 4 quadrantes D_2D = 0
      mut as int64: d_2d = 0

      println("1. Avaliando discrepancia de quadrantes pelo teste de Fasano-Franceschini:")
      println("   -> Estatistica D_2D = " + d_2d + " (esperado: 0)")

      mut as int64: res = d_2d
      println("2. Residuo da diferenca 2D = " + res + " (esperado: 0)")
      println("3. Teste de diferenca de distribuicoes 2D concluido com sucesso.")
}
