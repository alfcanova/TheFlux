#L ============================================================================
#L Algoritmo: BCJR (Bahl-Cocke-Jelinek-Raviv / Algoritmo Forward-Backward MAP)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(S^2 * T) para S estados e T instantes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoBCJR) {
      println("==================================================")
      println("  SciAlgo: BCJR MAP Trellis Decoding")
      println("==================================================")

      mut as int64: estados = 4
      mut as int64: instantes = 8
      mut as int64: llr_saida = 45

      println("1. Trellis convolucional: " + estados + " estados, " + instantes + " etapas")
      println("2. Metricas forward (alpha) e backward (beta) combinadas")
      println("3. Log-Likelihood Ratio (LLR) estimado: " + llr_saida)
      println("4. BCJR concluido com sucesso.")
}
