#L ============================================================================
#L Algoritmo: TF-IDF (Term Frequency - Inverse Document Frequency)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPTFIDF) {
      println("=== Algoritmo: TF-IDF ===")
      mut as int64: tfScaled = 25
      mut as int64: idfScaled = 16
      mut as int64: tfidf = (tfScaled * idfScaled) /i 10
      println("1. TF (Term Frequency x100): " + tfScaled)
      println("2. IDF (Inverse Document Frequency x10): " + idfScaled)
      println("3. Score TF-IDF: " + tfidf)
      println("Teste concluido com sucesso.")
}
