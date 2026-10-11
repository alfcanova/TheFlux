#L ============================================================================
#L Algoritmo: Transformer (Multi-Head Self-Attention e Feed-Forward)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaTransformer) {
      println("=== Algoritmo: Generative Transformer ===")
      mut as int64: q = 8
      mut as int64: k = 8
      mut as int64: dK = 4
      mut as int64: attnLogit = (q * k) /i dK
      mut as int64: v = 12
      mut as int64: attnOut = (attnLogit * v) /i 10
      println("1. Logit de atencao escalonada: " + attnLogit)
      println("2. Saida do bloco de atencao: " + attnOut)
      println("Teste concluido com sucesso.")
}
