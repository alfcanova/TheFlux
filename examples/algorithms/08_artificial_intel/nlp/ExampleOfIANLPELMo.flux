#L ============================================================================
#L Algoritmo: ELMo (Embeddings from Language Models - BiLM Profundo)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPELMo) {
      println("=== Algoritmo: ELMo BiLM ===")
      mut as int64: hFwd = 45
      mut as int64: hBwd = 55
      mut as int64: gammaScale = 2
      mut as int64: elmoRep = gammaScale * ((hFwd + hBwd) /i 2)
      println("1. Representacao contextual combinada ELMo: " + elmoRep)
      println("Teste concluido com sucesso.")
}
