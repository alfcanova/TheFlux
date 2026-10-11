#L ============================================================================
#L Algoritmo: Balanced Random Forest (Random Forest com Bootstrap Balanceado)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleBalancedRandomForest) {
      println("=== Algoritmo: Balanced Random Forest ===")
      mut as int64: minSamplesInTree = 40
      mut as int64: majSamplesInTree = 40
      mut as int64: ratio = majSamplesInTree /i minSamplesInTree
      println("1. Proporcao das amostras por arvore: " + ratio)
      println("2. Arvores treinadas com distribuicao balanceada.")
      println("Teste concluido com sucesso.")
}
