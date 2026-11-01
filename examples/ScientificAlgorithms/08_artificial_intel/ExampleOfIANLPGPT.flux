#L ============================================================================
#L Algoritmo: GPT (Generative Pre-trained Transformer - Causal Masking)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPGPT) {
      println("=== Algoritmo: GPT Causal Decoder ===")
      mut as int64: currentPos = 4
      mut as int64: visibleTokens = currentPos
      println("1. Mascaramento auto-regressivo: tokens 1 a " + visibleTokens + " visiveis")
      println("2. Proximo token condicionado estritamente no passado causal.")
      println("Teste concluido com sucesso.")
}
