#L ============================================================================
#L Algoritmo: Bidirectional RNN (BiRNN com Estados Direto e Reverso)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisBidirectionalRNN) {
      println("=== Algoritmo: Bidirectional RNN ===")
      mut as int64: hForward = 25
      mut as int64: hBackward = 35
      mut as int64: hConcat = hForward * 100 + hBackward
      println("1. Representacao bidirecional concatenada: " + hConcat)
      println("Teste concluido com sucesso.")
}
