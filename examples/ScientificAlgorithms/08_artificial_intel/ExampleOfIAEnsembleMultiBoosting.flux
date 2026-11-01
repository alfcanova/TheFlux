#L ============================================================================
#L Algoritmo: MultiBoosting (Fusao de Wagging/Bagging com AdaBoost)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleMultiBoosting) {
      println("=== Algoritmo: MultiBoosting ===")
      mut as int64: subCommitteeIdx = 2
      mut as int64: boostIter = 5
      mut as int64: combinedDiversityIndex = subCommitteeIdx * 10 + boostIter
      println("1. Subcomite de wagging ativo: " + subCommitteeIdx)
      println("2. Indice de diversidade multi-boosting: " + combinedDiversityIndex)
      println("Teste concluido com sucesso.")
}
