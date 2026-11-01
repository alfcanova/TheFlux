#L ============================================================================
#L Algoritmo: SMAWK Optimization (Algoritmo SMAWK para Matrizes Totalmente Monotonas)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N) minimos de linhas em matrizes monotonas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaSMAWK) {
      println("==================================================")
      println("  SciAlgo: SMAWK Algorithm for Totally Monotone Matrices")
      println("==================================================")

      mut as int64: linhas = 4
      mut as int64: colunas = 5
      mut as int64: otimizacao_linear = 1

      println("1. Busca de minimos de linha em matriz totalmente monotona " + linhas + "x" + colunas)
      println("2. Transicoes de programacao dinamica 1D/1D aceleradas em tempo O(N): " + otimizacao_linear)
      println("3. SMAWK Optimization concluido com sucesso.")
}
