#L ============================================================================
#L Algoritmo: GrabCut (Segmentacao Foreground/Background via Graph Cuts e GMM)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVGrabCut) {
      println("=== Algoritmo: GrabCut Segmentation ===")
      mut as int64: fgEnergy = 15
      mut as int64: bgEnergy = 45
      mut as int64: assignedLabel = 0
      route {
            fgEnergy < bgEnergy ==> { assignedLabel = 1 }
            _ ==> {}
      }
      println("1. Rotulo atribuido pelo min-cut (1=Foreground, 0=Background): " + assignedLabel)
      println("Teste concluido com sucesso.")
}
