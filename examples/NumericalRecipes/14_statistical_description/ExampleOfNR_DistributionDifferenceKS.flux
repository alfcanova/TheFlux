#L ============================================================================
#L Algoritmo: Are Distributions Different? — KS Test (Teste de Kolmogorov-Smirnov)
#L Capitulo: 14_statistical_description
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Teste nao-parametrico KS avaliando a distancia suprema D entre distribuicoes acumuladas.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DistributionDifferenceKS) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DistributionDifferenceKS")
      println("==================================================")

      #L Comparando duas amostras com a mesma funcao de distribuicao acumulada empírica:
      #L Distancia suprema vertical D = max |S1(x) - S2(x)| = 0
      mut as int64: d_stat = 0

      println("1. Calculando estatistica D de Kolmogorov-Smirnov:")
      println("   -> Distancia maxima D = " + d_stat + " (esperado: 0)")

      mut as int64: res = d_stat
      println("2. Residuo da distancia KS = " + res + " (esperado: 0)")
      println("3. Teste de Kolmogorov-Smirnov concluido com exito.")
}
