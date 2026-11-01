#L ============================================================================
#L Algoritmo: SVD Recommendation (Funk SVD com Vieses Globais e Regulares)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoSVDRecommendation) {
      println("=== Algoritmo: Funk SVD ===")
      mut as int64: muGlobal = 35
      mut as int64: bUser = 5
      mut as int64: bItem = 0 - 2
      mut as int64: dotLatent = 8
      mut as int64: svdPred = muGlobal + bUser + bItem + dotLatent
      println("1. Nota predita ajustada por vieses (escala x10): " + svdPred)
      println("Teste concluido com sucesso.")
}
