#L ============================================================================
#L Algoritmo: Stacking (Stacked Generalization com Meta-Modelo)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleStacking) {
      println("=== Algoritmo: Stacking Ensemble ===")
      mut as int64: predM1 = 80
      mut as int64: predM2 = 70
      mut as int64: metaWeight1 = 6
      mut as int64: metaWeight2 = 4
      mut as int64: metaPred = (predM1 * metaWeight1 + predM2 * metaWeight2) /i 10
      println("1. Predicao do Modelo Base 1: " + predM1)
      println("2. Predicao do Modelo Base 2: " + predM2)
      println("3. Meta-Predicao Stacking: " + metaPred)
      println("Teste concluido com sucesso.")
}
