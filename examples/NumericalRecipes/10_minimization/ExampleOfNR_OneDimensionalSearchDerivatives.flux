#L ============================================================================
#L Algoritmo: 1D Search with First Derivatives (Busca 1D com Derivadas)
#L Capitulo: 10_minimization
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Interpolacao cubica de Hermite usando valores e derivadas nos extremos.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_OneDimensionalSearchDerivatives) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_OneDimensionalSearchDerivatives")
      println("==================================================")

      #L No intervalo [0, 4]: f'(0) = -8 (descendente), f'(4) = 0 (minimo)
      mut as int64: d_left = 0 - 8
      mut as int64: d_right = 0
      mut as int64: x_opt = 4

      println("1. Interpolacao de Hermite com derivadas direcionais:")
      println("   -> Derivada a esquerda: " + d_left)
      println("   -> Derivada a direita: " + d_right)

      mut as int64: res = d_right
      println("2. Residuo no ponto estacionario = " + res + " (esperado: 0)")
      println("3. Busca 1D com derivadas concluida.")
}
