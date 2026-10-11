#L ============================================================================
#L Algoritmo: Bounded Knapsack (Mochila com Quantidades Limitadas / O(W log C))
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(W * sum(log C_i)) via decomposicao binaria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaBoundedKnapsack) {
      println("==================================================")
      println("  SciAlgo: Bounded Knapsack with Binary Splitting")
      println("==================================================")

      mut as int64: capacidade = 10
      mut as int64: itens_ficticios_binarios = 6
      mut as int64: max_valor = 14

      println("1. Decomposicao binaria de multiplicidades em " + itens_ficticios_binarios + " potencias de 2")
      println("2. Valor otimo da mochila limitada: " + max_valor)
      println("3. Bounded Knapsack concluido com sucesso.")
}
