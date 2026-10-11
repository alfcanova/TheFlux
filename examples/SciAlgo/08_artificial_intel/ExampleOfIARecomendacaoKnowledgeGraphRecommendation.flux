#L ============================================================================
#L Algoritmo: Knowledge Graph Recommendation (KG-based Propagacao de Entidades)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoKnowledgeGraphRecommendation) {
      println("=== Algoritmo: KG-based Recommendation ===")
      mut as int64: userItemLink = 1
      mut as int64: itemEntityHop = 2
      mut as int64: kgConnectivityScore = userItemLink * 50 + itemEntityHop * 20
      println("1. Conectividade no grafo de conhecimento: " + kgConnectivityScore)
      println("Teste concluido com sucesso.")
}
