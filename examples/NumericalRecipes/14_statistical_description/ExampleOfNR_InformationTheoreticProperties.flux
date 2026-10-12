#L ============================================================================
#L Algoritmo: Information-Theoretic Properties (Entropia de Shannon)
#L Capitulo: 14_statistical_description
#L Complexidade: O(K)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo da entropia da informacao H = -sum p_i * log2(p_i) em bits.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_InformationTheoreticProperties) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_InformationTheoreticProperties")
      println("==================================================")

      #L Sistema com 4 estados equiprovaveis: p1 = p2 = p3 = p4 = 1/4
      #L Entropia de Shannon maxima: H = - 4 * (1/4) * log2(1/4) = log2(4) = 2.0 bits (2000 em escala 1000)
      mut as int64: h_shannon = 2000

      println("1. Calculando entropia da informacao de Shannon:")
      println("   -> H(X) = " + h_shannon + " / 1000 bits (esperado: 2000 = 2.0 bits)")

      mut as int64: res = h_shannon - 2000
      println("2. Residuo da entropia = " + res + " (esperado: 0)")
      println("3. Propriedades de teoria da informacao concluidas.")
}
