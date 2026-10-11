#L ============================================================================
#L Algoritmo: Easy Ensemble (Conjunto Independente de Sub-amostras com AdaBoost)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleEasyEnsemble) {
      println("=== Algoritmo: Easy Ensemble ===")
      mut as list of int64: subBagAcc = [88, 91, 87, 89]
      mut as int64: sumAcc = 0
      mut as int64: i = 1
      infinite (i <= 4) {
            sumAcc = sumAcc + subBagAcc[i]
            i = i + 1
      }
      mut as int64: meanAcc = sumAcc /i 4
      println("1. Acuracia media dos sub-ensembles: " + meanAcc)
      println("Teste concluido com sucesso.")
}
