#L ============================================================================
#L Algoritmo: Recurrent Neural Network (RNN Elman com Estado Oculto Recorrente)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisRecurrentNeuralNetwork) {
      println("=== Algoritmo: Vanilla Recurrent Neural Network ===")
      mut as int64: hPrev = 10
      mut as int64: xCurr = 5
      mut as int64: wH = 2
      mut as int64: wX = 3
      mut as int64: hNew = hPrev * wH + xCurr * wX
      println("1. Estado oculto no passo temporal t: " + hNew)
      println("Teste concluido com sucesso.")
}
