#L ============================================================================
#L Algoritmo: Blending (Ensemble com Holdout Validation Set)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleBlending) {
      println("=== Algoritmo: Blending ===")
      mut as int64: valScoreA = 85
      mut as int64: valScoreB = 65
      mut as int64: blendWeightA = (valScoreA * 100) /i (valScoreA + valScoreB)
      mut as int64: blendWeightB = 100 - blendWeightA
      println("1. Peso Modelo A no conjunto de holdout: " + blendWeightA)
      println("2. Peso Modelo B no conjunto de holdout: " + blendWeightB)
      println("Teste concluido com sucesso.")
}
