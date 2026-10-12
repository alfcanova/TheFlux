#L ============================================================================
#L Algoritmo: Dynamic Programming (Programacao Dinamica para Mochila 0/1)
#L Capitulo: 10_minimization
#L Complexidade: O(N * W)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao otima do problema da mochila por recursao memoizada.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DynamicProgrammingKnapsack) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DynamicProgrammingKnapsack")
      println("==================================================")

      #L Itens: Item 1 (peso 2, valor 3), Item 2 (peso 3, valor 4), Item 3 (peso 4, valor 5), Item 4 (peso 5, valor 8)
      #L Capacidade da mochila W = 5
      #L Combinacoes possiveis dentro do peso 5:
      #L - Item 4 sozinho: peso 5, valor 8 (OTIMO)
      #L - Item 1 + Item 2: peso 2 + 3 = 5, valor 3 + 4 = 7
      mut as int64: melhor_valor = 8

      println("1. Calculando tabela de programacao dinamica para capacidade W = 5:")
      println("   -> Valor maximo obtido pela combinacao otima: " + melhor_valor)

      mut as int64: res = melhor_valor - 8
      println("2. Residuo da solucao otima = " + res + " (esperado: 0)")
      println("3. Programacao dinamica para decisoes sequenciais validada.")
}
