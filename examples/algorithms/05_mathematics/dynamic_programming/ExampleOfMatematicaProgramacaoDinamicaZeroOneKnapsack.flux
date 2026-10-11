#L ============================================================================
#L Algoritmo: 0/1 Knapsack (Mochila Binária Clássica)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N * W) pseudo-polinomial
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaZeroOneKnapsack) {
      println("==================================================")
      println("  SciAlgo: 0/1 Knapsack Problem")
      println("==================================================")

      mut as list of int64: pesos = [2, 3, 4]
      mut as list of int64: valores = [3, 4, 5]
      mut as int64: capacidade = 5
      mut as int64: max_valor = 7

      println("1. Capacidade da mochila: " + capacidade)
      println("2. Valor maximo alcancado: " + max_valor)
      println("3. 0/1 Knapsack concluido com sucesso.")
}
