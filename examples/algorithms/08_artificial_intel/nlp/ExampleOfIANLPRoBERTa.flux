#L ============================================================================
#L Algoritmo: RoBERTa (Robustly Optimized BERT Approach com Dynamic Masking)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPRoBERTa) {
      println("=== Algoritmo: RoBERTa Dynamic Masking ===")
      mut as int64: seqLen = 128
      mut as int64: maskPct = 15
      mut as int64: numMaskedTokens = (seqLen * maskPct) /i 100
      println("1. Tamanho da sequencia de treino: " + seqLen)
      println("2. Quantidade de tokens mascarados dinamicamente: " + numMaskedTokens)
      println("Teste concluido com sucesso.")
}
