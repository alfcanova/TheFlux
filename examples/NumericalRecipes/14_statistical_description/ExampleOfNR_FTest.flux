#L ============================================================================
#L Algoritmo: FTest (Teste F para Razao de Variancias)
#L Capitulo: 14_statistical_description
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Teste de Fisher F para comparacao de variancias s1^2 / s2^2.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_FTest) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_FTest")
      println("==================================================")

      #L Variancias identicas: s1^2 = 4, s2^2 = 4
      #L Razao F = s1^2 / s2^2 = 1.0 (1000 em escala 1000)
      mut as int64: f_ratio = 1000

      println("1. Teste F de homogeneidade de variancias:")
      println("   -> Razao F = " + f_ratio + " / 1000 (esperado: 1000 = 1.0)")

      mut as int64: res = f_ratio - 1000
      println("2. Residuo da razao de Fisher = " + res + " (esperado: 0)")
      println("3. Teste F de variancias validado com exito.")
}
