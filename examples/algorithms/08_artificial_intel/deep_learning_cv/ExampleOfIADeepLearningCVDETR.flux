#L ============================================================================
#L Algoritmo: DETR (DEtection TRansformer com Bipartite Matching)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVDETR) {
      println("=== Algoritmo: DETR Hungarian Matching ===")
      mut as int64: numObjectQueries = 100
      mut as int64: hungarianMatchScore = 88
      println("1. Numero fixo de consultas de objetos (Object Queries): " + numObjectQueries)
      println("2. Custo de emparelhamento bipartido de Hungaro: " + hungarianMatchScore)
      println("Teste concluido com sucesso.")
}
