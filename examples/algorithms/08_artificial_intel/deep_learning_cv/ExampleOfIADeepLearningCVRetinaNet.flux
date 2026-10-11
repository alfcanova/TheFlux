#L ============================================================================
#L Algoritmo: RetinaNet (Focal Loss para Desbalanceamento Extremo de Classes)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVRetinaNet) {
      println("=== Algoritmo: RetinaNet Focal Loss ===")
      mut as int64: pEasy = 90
      mut as int64: gammaFocal = 2
      mut as int64: modulatingFactor = (100 - pEasy) * (100 - pEasy) /i 100
      println("1. Probabilidade predita (amostra facil): " + pEasy)
      println("2. Fator modulador de perda reduzido: " + modulatingFactor)
      println("Teste concluido com sucesso.")
}
