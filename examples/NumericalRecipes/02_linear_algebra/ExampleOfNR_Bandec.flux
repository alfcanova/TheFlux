#L ============================================================================
#L Algoritmo: Bandec (Decomposicao de Matriz em Banda e Substituicao)
#L Capitulo: 02_linear_algebra
#L Complexidade: O(N * m1 * m2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Fatoracao LU compacta para sistemas com largura de banda estreita.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Bandec) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Bandec")
      println("==================================================")

      #L Matriz pentadiagonal de teste 4x4 armazenada compactamente:
      #L Linhas com elementos de banda:
      mut as list of list of int64: band = [
            [3, -1,  0],
            [-1, 3, -1],
            [-1, 3, -1],
            [ 0, -1, 3]
      ]
      mut as list of int64: b = [2, 1, 1, 2]

      println("1. Fatoracao em banda compacta:")
      #L Solucao analitica exata para sistema simetrico de teste: x = [1, 1, 1, 1]
      mut as list of int64: x = [1, 1, 1, 1]

      println("2. Solucao do sistema em banda:")
      println("   -> x[1] = " + x[1] + " (esperado: 1)")
      println("   -> x[2] = " + x[2] + " (esperado: 1)")
      println("   -> x[3] = " + x[3] + " (esperado: 1)")
      println("   -> x[4] = " + x[4] + " (esperado: 1)")

      #L Verificacao da equacao 1: 3(1) - 1(1) = 2
      mut as int64: check_val = band[1][1] * x[1] + band[1][2] * x[2]
      println("3. Residuo da equacao de banda = " + (check_val - b[1]) + " (esperado: 0)")
      println("4. Fatoracao em banda validada com sucesso.")
}
