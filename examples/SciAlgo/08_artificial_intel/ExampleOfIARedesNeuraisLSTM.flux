#L ============================================================================
#L Algoritmo: LSTM (Long Short-Term Memory com Portas de Esquecimento e Entrada)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisLSTM) {
      println("=== Algoritmo: LSTM Gating Unit ===")
      mut as int64: cPrev = 50
      mut as int64: forgetGate = 80
      mut as int64: inputGate = 60
      mut as int64: cCand = 40
      mut as int64: cNew = (cPrev * forgetGate + inputGate * cCand) /i 100
      println("1. Novo estado celular de memoria C_t: " + cNew)
      println("Teste concluido com sucesso.")
}
