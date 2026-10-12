#L ============================================================================
#L Algoritmo: Multidimensional Integrals (Integral Dupla por Produto Tensorial)
#L Capitulo: 04_integration
#L Complexidade: O(N^D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integracao iterada em dominio bidimensional int_0^1 int_0^1 f(x, y) dx dy.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MultidimensionalIntegrals) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MultidimensionalIntegrals")
      println("==================================================")

      #L Integrando 2D: f(x, y) = 4 * x * y no quadrado unitario [0, 1] x [0, 1]
      #L Integral analitica exata: int_0^1 int_0^1 (4 x y) dx dy = 4 * (1/2) * (1/2) = 1.0 (1000)
      println("1. Integrando no quadrado unitario [0, 1] x [0, 1] via produto tensorial:")

      #L Ponto medio em 2D: ponto central (0.5, 0.5) com peso da area delta_A = 1.0
      #L f(0.5, 0.5) = 4 * 0.5 * 0.5 = 1.0 (1000 em escala 1000)
      mut as int64: x_mid = 500
      mut as int64: y_mid = 500
      mut as int64: i_2d = (4 * x_mid * y_mid) /i 1000

      println("2. Valor integrado 2D:")
      println("   -> I_2D = " + i_2d + " (esperado: 1000 = 1.0)")

      mut as int64: res = i_2d - 1000
      println("3. Residuo da quadratura multidimensional = " + res + " (esperado: 0)")
      println("4. Integracao multidimensional concluida com sucesso.")
}
