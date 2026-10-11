#L ============================================================================
#L Algoritmo: Bag of Words (Vetorizacao por Frequencia de Termos)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPBagOfWords) {
      println("=== Algoritmo: Bag of Words ===")
      mut as list of int64: termFreq = [3, 0, 2, 1]
      mut as int64: totalTokens = termFreq[1] + termFreq[2] + termFreq[3] + termFreq[4]
      println("1. Vetor de frequencias BoW: [3, 0, 2, 1]")
      println("2. Total de ocorrencias no documento: " + totalTokens)
      println("Teste concluido com sucesso.")
}
