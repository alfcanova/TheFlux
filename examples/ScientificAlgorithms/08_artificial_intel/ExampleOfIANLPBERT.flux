#L ============================================================================
#L Algoritmo: BERT (Bidirectional Encoder Representations from Transformers)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPBERT) {
      println("=== Algoritmo: BERT Encoder ===")
      mut as int64: tokEmb = 25
      mut as int64: posEmb = 5
      mut as int64: segEmb = 1
      mut as int64: bertInput = tokEmb + posEmb + segEmb
      mut as int64: clsScore = bertInput * 2 + 10
      println("1. Embedding de entrada combinado: " + bertInput)
      println("2. Logit do token [CLS]: " + clsScore)
      println("Teste concluido com sucesso.")
}
