#L ============================================================================
#L Algoritmo: Local Outlier Factor (LOF - Densidade de Alcance Local)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoLocalOutlierFactor) {
      println("=== Algoritmo: Local Outlier Factor ===")
      mut as int64: lrdPoint = 15
      mut as int64: lrdNeighbors = 30
      mut as int64: lofScore = (lrdNeighbors * 100) /i lrdPoint
      println("1. Indice LOF calculado: " + lofScore)
      println("Teste concluido com sucesso.")
}
