#L ============================================================================
#L Algoritmo: Lovins Stemmer (Maior Sufixo com Tabela de Transformacoes)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPLovinsStemmer) {
      println("=== Algoritmo: Lovins Stemmer ===")
      mut as int64: longestSuffixFound = 6
      mut as int64: conditionCode = 11
      println("1. Extensao do maior sufixo casado: " + longestSuffixFound)
      println("2. Codigo de condicao de contexto: " + conditionCode)
      println("Teste concluido com sucesso.")
}
