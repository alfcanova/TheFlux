#L ============================================================================
#L Algoritmo: Seam Carving (Redimensionamento Consciente de Conteudo com Cost Seams)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVSeamCarving) {
      println("=== Algoritmo: Seam Carving Energy ===")
      mut as int64: energy1 = 20
      mut as int64: energy2 = 12
      mut as int64: energy3 = 35
      mut as int64: minCostSeam = energy1
      route {
            energy2 < minCostSeam ==> { minCostSeam = energy2 }
            _ ==> {}
      }
      route {
            energy3 < minCostSeam ==> { minCostSeam = energy3 }
            _ ==> {}
      }
      println("1. Menor energia de costura vertical selecionada: " + minCostSeam)
      println("Teste concluido com sucesso.")
}
