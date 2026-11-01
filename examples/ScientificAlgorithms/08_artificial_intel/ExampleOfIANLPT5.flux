#L ============================================================================
#L Algoritmo: T5 (Text-to-Text Transfer Transformer com Span Corruption)
#L Dominio: 08_artificial_intel / Subdominio: NLP
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIANLPT5) {
      println("=== Algoritmo: T5 Text-to-Text ===")
      mut as int64: sentinelId = 100
      mut as int64: corruptedSpanLen = 3
      println("1. Token sentinela injetado: <extra_id_" + (sentinelId - 100) + ">")
      println("2. Extensao do span corrompido para previsao: " + corruptedSpanLen)
      println("Teste concluido com sucesso.")
}
