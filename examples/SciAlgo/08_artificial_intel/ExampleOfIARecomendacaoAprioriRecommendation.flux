#L ============================================================================
#L Algoritmo: Apriori Recommendation (Regras de Associacao e Suporte Frequente)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoAprioriRecommendation) {
      println("=== Algoritmo: Apriori Association Rules ===")
      mut as int64: supportAB = 30
      mut as int64: supportA = 50
      mut as int64: confidenceRule = (supportAB * 100) /i supportA
      println("1. Confianca da regra de recomendacao A -> B: " + confidenceRule)
      println("Teste concluido com sucesso.")
}
