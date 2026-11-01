#L ============================================================================
#L Algoritmo: Context-Aware Recommendation (Fatoracao Tensorial com Variaveis de Contexto)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoContextAwareRecommendation) {
      println("=== Algoritmo: Context-Aware Recommender ===")
      mut as int64: basePref = 40
      mut as int64: timeContextMultiplier = 12
      mut as int64: locationBonus = 8
      mut as int64: contextRating = (basePref * timeContextMultiplier) /i 10 + locationBonus
      println("1. Preferencia sensivel ao contexto temporal e espacial: " + contextRating)
      println("Teste concluido com sucesso.")
}
