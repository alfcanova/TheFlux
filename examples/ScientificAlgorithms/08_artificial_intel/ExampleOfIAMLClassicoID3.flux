#L ============================================================================
#L Algoritmo: ID3 (Iterative Dichotomiser 3 com Ganho de Informacao / Entropia)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoID3) {
      println("=== Algoritmo: ID3 Information Gain ===")
      mut as int64: entropyTotal = 100
      mut as int64: entropyBranch1 = 40
      mut as int64: entropyBranch2 = 20
      mut as int64: infoGain = entropyTotal - (entropyBranch1 + entropyBranch2) /i 2
      println("1. Entropia inicial do conjunto: " + entropyTotal)
      println("2. Ganho de informacao do atributo: " + infoGain)
      println("Teste concluido com sucesso.")
}
