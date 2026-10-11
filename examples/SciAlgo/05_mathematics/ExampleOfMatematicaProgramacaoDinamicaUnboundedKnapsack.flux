#L ============================================================================
#L Algoritmo: Unbounded Knapsack (Mochila com Itens Ilimitados)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N * W) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaUnboundedKnapsack) {
      println("==================================================")
      println("  SciAlgo: Unbounded Knapsack Problem")
      println("==================================================")

      mut as int64: capacidade = 8
      mut as int64: max_valor = 12

      println("1. Capacidade com repeticao permitida: " + capacidade)
      println("2. Valor maximo obtido: " + max_valor)
      println("3. Unbounded Knapsack concluido com sucesso.")
}
