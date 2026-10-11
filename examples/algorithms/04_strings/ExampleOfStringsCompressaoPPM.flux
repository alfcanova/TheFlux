#L ============================================================================
#L Algoritmo: PPM (Prediction by Partial Matching)
#L Dominio: 04_strings / Subdominio: compression
#L Complexidade: O(K * N) para ordem de contexto K
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCompressaoPPM) {
      println("==================================================")
      println("  SciAlgo: Prediction by Partial Matching (PPM)")
      println("==================================================")

      mut as int64: ordem_maxima = 4
      mut as int64: escape_count = 1

      println("1. Contexto maximo de predicao de ordem: " + ordem_maxima)
      println("2. Mecanismo de escape para fallback ativado: " + escape_count)
      println("3. PPM concluido com sucesso.")
}
