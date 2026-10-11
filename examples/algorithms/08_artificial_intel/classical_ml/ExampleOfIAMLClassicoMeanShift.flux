#L ============================================================================
#L Algoritmo: Mean Shift (Busca de Modos de Densidade Nao-Parametrica)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoMeanShift) {
      println("=== Algoritmo: Mean Shift Mode Seeking ===")
      mut as int64: currentPos = 10
      mut as int64: p1 = 12
      mut as int64: p2 = 18
      mut as int64: kernelMean = (p1 + p2) /i 2
      mut as int64: shiftVector = kernelMean - currentPos
      println("1. Posicao atual: " + currentPos)
      println("2. Vetor de deslocamento da media: " + shiftVector)
      println("Teste concluido com sucesso.")
}
