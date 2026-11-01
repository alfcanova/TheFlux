#L ============================================================================
#L Algoritmo: Hybrid Recommendation (Combinacao Ponderada Hibrida)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoHybridRecommendation) {
      println("=== Algoritmo: Hybrid Recommendation ===")
      mut as int64: scoreCollab = 82
      mut as int64: scoreContent = 68
      mut as int64: weightCollab = 60
      mut as int64: hybridScore = (weightCollab * scoreCollab + (100 - weightCollab) * scoreContent) /i 100
      println("1. Score balanceado do sistema hibrido: " + hybridScore)
      println("Teste concluido com sucesso.")
}
