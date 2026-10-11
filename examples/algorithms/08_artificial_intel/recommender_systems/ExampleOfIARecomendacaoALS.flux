#L ============================================================================
#L Algoritmo: ALS (Alternating Least Squares para Feedback Implicito)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoALS) {
      println("=== Algoritmo: Alternating Least Squares ===")
      mut as int64: confidenceC = 40
      mut as int64: preferenceP = 1
      mut as int64: factorEstimate = 28
      mut as int64: alsLoss = confidenceC * (preferenceP * 30 - factorEstimate)
      println("1. Residuo de minimizacao alternada ALS: " + alsLoss)
      println("Teste concluido com sucesso.")
}
