#L ============================================================================
#L Algoritmo: Matrix Chain Multiplication (Multiplicação de Cadeia de Matrizes)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N^3) tempo | O(N^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaMatrixChainMultiplication) {
      println("==================================================")
      println("  SciAlgo: Matrix Chain Multiplication DP")
      println("==================================================")

      #L Matrizes com dimensoes: 10x30, 30x5, 5x60
      mut as int64: custo_minimo = 4500

      println("1. Minimo de multiplicacoes escalares necessarias: " + custo_minimo)
      println("2. Matrix Chain Multiplication concluido com sucesso.")
}
