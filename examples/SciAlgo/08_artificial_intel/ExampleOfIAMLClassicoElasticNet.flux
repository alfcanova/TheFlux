#L ============================================================================
#L Algoritmo: Elastic Net (Combinacao Convexa L1 e L2)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoElasticNet) {
      println("=== Algoritmo: Elastic Net ===")
      mut as int64: l1Ratio = 60
      mut as int64: lambdaVal = 20
      mut as int64: l1Penalty = (lambdaVal * l1Ratio) /i 100
      mut as int64: l2Penalty = (lambdaVal * (100 - l1Ratio)) /i 100
      println("1. Penalidade L1 combinada: " + l1Penalty)
      println("2. Penalidade L2 combinada: " + l2Penalty)
      println("Teste concluido com sucesso.")
}
