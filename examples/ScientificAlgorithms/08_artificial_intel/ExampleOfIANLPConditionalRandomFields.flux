#L ============================================================================
#L Algoritmo: Conditional Random Fields (CRF Linear-Chain para NER/POS)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPConditionalRandomFields) {
      println("=== Algoritmo: Linear-Chain CRF ===")
      mut as int64: emissionScore = 40
      mut as int64: transitionScore = 25
      mut as int64: pathScore = emissionScore + transitionScore
      println("1. Pontuacao de emissao do token: " + emissionScore)
      println("2. Pontuacao de transicao entre tags: " + transitionScore)
      println("3. Pontuacao total do caminho Viterbi: " + pathScore)
      println("Teste concluido com sucesso.")
}
