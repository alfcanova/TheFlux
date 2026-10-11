#L ============================================================================
#L Algoritmo: AdaBoost (Adaptive Boosting)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleAdaBoost) {
      println("=== Algoritmo: AdaBoost ===")
      mut as int64: errRate = 20
      mut as int64: alphaWeight = (100 - errRate) /i (errRate + 1)
      mut as int64: basePredictorSign = 1
      mut as int64: finalHypothesis = alphaWeight * basePredictorSign
      println("1. Taxa de erro percentual: " + errRate)
      println("2. Importancia do estimador alfa: " + alphaWeight)
      println("3. Hipotese combinada: " + finalHypothesis)
      println("Teste concluido com sucesso.")
}
