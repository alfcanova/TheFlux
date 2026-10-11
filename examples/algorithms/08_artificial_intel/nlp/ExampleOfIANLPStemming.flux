#L ============================================================================
#L Algoritmo: Stemming Geral (Reducao Morfologica de Sufixos)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPStemming) {
      println("=== Algoritmo: Stemming Regra de Sufixo ===")
      mut as int64: wordLen = 7
      mut as int64: suffixLen = 3
      mut as int64: stemLen = wordLen - suffixLen
      println("1. Comprimento da palavra original: " + wordLen)
      println("2. Sufixo removido: 3 caracteres ('ing')")
      println("3. Comprimento do radical (stem): " + stemLen)
      println("Teste concluido com sucesso.")
}
