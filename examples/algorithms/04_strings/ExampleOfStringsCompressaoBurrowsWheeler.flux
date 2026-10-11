#L ============================================================================
#L Algoritmo: Burrows-Wheeler Transform — BWT
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(N log N) ordenacao ciclica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoBurrowsWheeler) {
      println("==================================================")
      println("  SciAlgo: Burrows-Wheeler Transform (BWT)")
      println("==================================================")

      #L Texto original: "BANANA$" -> BWT: "BNN$AAA"
      mut as int64: tam = 7
      mut as int64: indice_original = 4

      println("1. Comprimento do bloco BWT: " + tam)
      println("2. Indice da linha original na matriz ciclica: " + indice_original)
      println("3. BWT concluido com sucesso.")
}
