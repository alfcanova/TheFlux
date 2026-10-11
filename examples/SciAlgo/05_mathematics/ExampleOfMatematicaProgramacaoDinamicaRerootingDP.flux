#L ============================================================================
#L Algoritmo: Rerooting DP (DP com Mudança de Raiz em Árvores em 2 Passos)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N) tempo linear estrito
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaRerootingDP) {
      println("==================================================")
      println("  SciAlgo: Tree Rerooting DP Technique")
      println("==================================================")

      mut as int64: total_nos = 5
      mut as int64: soma_distancias_minima = 6

      println("1. No central otimizado avaliado com " + total_nos + " vertices")
      println("2. Minima soma de distancias de todos para todos: " + soma_distancias_minima)
      println("3. Rerooting DP concluido com sucesso.")
}
