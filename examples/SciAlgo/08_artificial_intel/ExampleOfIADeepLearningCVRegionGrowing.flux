#L ============================================================================
#L Algoritmo: Region Growing (Crescimento de Regioes Baseado em Sementes e Similaridade)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVRegionGrowing) {
      println("=== Algoritmo: Region Growing ===")
      mut as int64: seedIntensity = 100
      mut as int64: neighborIntensity = 105
      mut as int64: threshDiff = 10
      mut as int64: diffVal = neighborIntensity - seedIntensity
      mut as int64: isAppended = 0
      route {
            diffVal <= threshDiff ==> { isAppended = 1 }
            _ ==> {}
      }
      println("1. Vizinho assimilado na regiao conexa: " + isAppended)
      println("Teste concluido com sucesso.")
}
