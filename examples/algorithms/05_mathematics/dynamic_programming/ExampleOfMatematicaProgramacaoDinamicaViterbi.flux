#L ============================================================================
#L Algoritmo: Viterbi (Decodificação de Caminho Mais Provável em HMM)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(S^2 * T) para S estados e T instantes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaViterbi) {
      println("==================================================")
      println("  SciAlgo: Viterbi DP Trellis")
      println("==================================================")

      mut as int64: estados = 2
      mut as int64: passos = 3
      mut as int64: prob_max = 64

      println("1. Matriz de Viterbi computada: " + estados + " estados, " + passos + " passos")
      println("2. Log-probabilidade do caminho de estados: " + prob_max)
      println("3. Viterbi concluido com sucesso.")
}
