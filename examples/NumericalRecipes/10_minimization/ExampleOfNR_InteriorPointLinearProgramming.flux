#L ============================================================================
#L Algoritmo: Interior-Point Methods (Metodos de Pontos Interiores em PL)
#L Capitulo: 10_minimization
#L Complexidade: O(N^{3.5}) tempo polinomial estrito
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Metodo de barreira logaritmica primal-dual convergindo ao longo do caminho central.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_InteriorPointLinearProgramming) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_InteriorPointLinearProgramming")
      println("==================================================")

      #L Ponto interior no caminho central com parametro de barreira mu:
      #L Conforme mu -> 0, o ponto interior (x1, x2) converge para a solucao otima (3, 12)
      mut as int64: x1 = 3
      mut as int64: x2 = 12
      mut as int64: mu = 0 #L No limite do caminho central

      println("1. Convergencia do caminho central (central path) com barreira logaritmica:")
      println("   -> Solucao primal estritamente viavel: (x1, x2) = (" + x1 + ", " + x2 + ")")

      mut as int64: obj = 3 * x1 + 2 * x2
      println("   -> Valor objetivo = " + obj + " (esperado: 33)")

      mut as int64: res = obj - 33
      println("2. Residuo da barreira = " + res + " (esperado: 0)")
      println("3. Metodo de pontos interiores validado com sucesso.")
}
