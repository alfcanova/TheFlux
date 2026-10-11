#L ============================================================================
#L Algoritmo: YOLO (You Only Look Once - Deteccao de Objetos em Estagio Unico)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVYOLO) {
      println("=== Algoritmo: YOLO Single-Stage Detector ===")
      mut as int64: gridS = 7
      mut as int64: boxesB = 2
      mut as int64: classesC = 20
      mut as int64: outputTensorDepth = boxesB * 5 + classesC
      println("1. Grade de divisao S x S: " + gridS + "x" + gridS)
      println("2. Profundidade do tensor de predicao por celula: " + outputTensorDepth)
      println("Teste concluido com sucesso.")
}
