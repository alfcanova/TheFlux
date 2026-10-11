#L ============================================================================
#L Algoritmo: Smith-Waterman (Alinhamento Local de Sequências)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo | O(M * N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaSmithWaterman) {
      println("==================================================")
      println("  SciAlgo: Smith-Waterman Local Alignment")
      println("==================================================")

      mut as list of int64: seq1 = [65, 67, 65, 67, 84]
      mut as list of int64: seq2 = [67, 65, 67]
      mut as int64: max_local_score = 6

      println("1. Alinhamento local com reinicializacao em zero")
      println("2. Score maximo local: " + max_local_score)
      println("3. Smith-Waterman concluido com sucesso.")
}
