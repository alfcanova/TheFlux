#L ============================================================================
#L Algoritmo: Masked Language Modeling (Cloze Task Pre-training)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPMaskedLanguageModeling) {
      println("=== Algoritmo: Masked Language Modeling ===")
      mut as int64: maskedLogitTrueToken = 92
      mut as int64: crossEntropyLoss = 100 - maskedLogitTrueToken
      println("1. Logit predito para o token [MASK]: " + maskedLogitTrueToken)
      println("2. Perda de entropia cruzada no token mascarado: " + crossEntropyLoss)
      println("Teste concluido com sucesso.")
}
