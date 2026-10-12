#L ============================================================================
#L Algoritmo: Real Symmetric Matrices (Propriedades Espectrais e Ortogonalidade)
#L Capitulo: 11_eigensystems
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Teorema espectral, ortogonalidade estrita de autovetores e decomposicao espectral.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RealSymmetricMatricesProperties) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RealSymmetricMatricesProperties")
      println("==================================================")

      #L Matriz Simetrica A = [[3, 1], [1, 3]]
      #L Autovetor 1: v1 = [1, 1], autovalor lambda1 = 4
      #L Autovetor 2: v2 = [1, -1], autovalor lambda2 = 2
      #L Teste de Ortogonalidade: v1 . v2 = 1*1 + 1*(-1) = 0
      mut as int64: v1_x = 1
      mut as int64: v1_y = 1
      mut as int64: v2_x = 1
      mut as int64: v2_y = 0 - 1

      mut as int64: dot_prod = v1_x * v2_x + v1_y * v2_y
      println("1. Verificando ortogonalidade dos autovetores:")
      println("   -> v1 . v2 = " + dot_prod + " (esperado: 0 - ortogonalidade exata)")

      mut as int64: res = dot_prod
      println("2. Residuo da ortogonalidade = " + res + " (esperado: 0)")
      println("3. Propriedades de matrizes simetricas reais concluidas.")
}
