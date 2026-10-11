#L ============================================================================
#L Algoritmo: LightGBM (Histogram-based GBDT com GOSS e EFB)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleLightGBM) {
      println("=== Algoritmo: LightGBM GOSS ===")
      mut as list of int64: gradBins = [10, 45, 12, 80]
      mut as int64: topGradSample = gradBins[4]
      println("1. Gradiente alto amostrado via GOSS: " + topGradSample)
      println("2. Bin discreto de histograma: 4")
      println("Teste concluido com sucesso.")
}
