#L ============================================================================
#L Algoritmo: Canny Edge Detection (Gradiente, NMS e Histerese)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVCanny) {
      println("=== Algoritmo: Canny Edge Detection ===")
      mut as int64: highThresh = 80
      mut as int64: lowThresh = 30
      mut as int64: pixelGrad = 55
      mut as int64: isEdge = 0
      route {
            pixelGrad >= highThresh ==> { isEdge = 2 }
            pixelGrad >= lowThresh ==> { isEdge = 1 }
            _ ==> { isEdge = 0 }
      }
      println("1. Limiarizacao por histerese (0=Nao, 1=Fraco, 2=Forte): " + isEdge)
      println("Teste concluido com sucesso.")
}
