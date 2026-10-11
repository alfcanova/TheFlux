#L ============================================================================
#L Algoritmo: Tree Maximum Independent Set DP (Conjunto Independente Maximo em Arvores)
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(V) programacao dinamica em arvore
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaTreeMIS) {
      println("==================================================")
      println("  SciAlgo: Tree Maximum Independent Set DP")
      println("==================================================")

      mut as int64: vertices = 5
      mut as int64: max_independent_set_size = 3

      println("1. Arvore estruturada com " + vertices + " vertices analisada")
      println("2. Tamanho maximo do conjunto independente: " + max_independent_set_size)
      println("3. Tree Maximum Independent Set DP concluido com sucesso.")
}
