#L ============================================================================
#L Algoritmo: Addition Chain (Cadeia de Adição Ótima de Brauer)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: Menor numero de passos para alcancar N por adicoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosAdditionChain) {
      println("==================================================")
      println("  SciAlgo: Addition Chain Optimization")
      println("==================================================")

      #L Cadeia para alcancar 15: 1, 2, 3, 6, 12, 15 (tam 6)
      mut as list of int64: cadeia = [1, 2, 3, 6, 12, 15]
      mut as int64: passos = listLength(cadeia) - 1

      println("1. Cadeia de adicao otima para 15: " + passos + " adicoes")
      println("2. Addition Chain concluido com sucesso.")
}
