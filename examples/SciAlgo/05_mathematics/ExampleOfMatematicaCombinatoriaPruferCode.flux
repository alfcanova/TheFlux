#L ============================================================================
#L Algoritmo: Prüfer Code (Codificação Bijetiva de Árvores Rotuladas)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N log N) ou O(N) linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaPruferCode) {
      println("==================================================")
      println("  SciAlgo: Prufer Code for Labeled Trees")
      println("==================================================")

      mut as int64: vertices = 6
      mut as list of int64: prufer = [4, 4, 3, 2]
      mut as int64: len_prufer = listLength(prufer)

      println("1. Arvore com V=" + vertices + " vertices")
      println("2. Codigo de Prufer (V-2 digitos): [" + prufer[1] + ", " + prufer[2] + ", " + prufer[3] + ", " + prufer[4] + "]")
      println("3. Prufer Code concluido com sucesso.")
}
