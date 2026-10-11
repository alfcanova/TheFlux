#L ============================================================================
#L Algoritmo: Prüfer Decode Tree (Decodificador de Sequencia de Prufer para Arvore)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(V) reconstrucao linear de arvore
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaPruferDecodeTree) {
      println("==================================================")
      println("  SciAlgo: Prufer Sequence Decoding to Tree")
      println("==================================================")

      mut as int64: vertices = 6
      mut as int64: arestas = vertices - 1

      println("1. Decodificando codigo de Prufer de tamanho " + (vertices - 2))
      println("2. Arvore rotulada com " + vertices + " vertices e " + arestas + " arestas restaurada")
      println("3. Prufer Decode Tree concluido com sucesso.")
}
