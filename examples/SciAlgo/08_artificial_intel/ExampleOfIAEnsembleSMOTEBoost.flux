#L ============================================================================
#L Algoritmo: SMOTEBoost (Synthetic Minority Over-sampling Boosting)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleSMOTEBoost) {
      println("=== Algoritmo: SMOTEBoost ===")
      mut as int64: sampleMin = 20
      mut as int64: neighborMin = 26
      mut as int64: lambdaInterp = 50
      mut as int64: syntheticPoint = sampleMin + ((neighborMin - sampleMin) * lambdaInterp) /i 100
      println("1. Amostra sintetica gerada via SMOTE: " + syntheticPoint)
      println("Teste concluido com sucesso.")
}
