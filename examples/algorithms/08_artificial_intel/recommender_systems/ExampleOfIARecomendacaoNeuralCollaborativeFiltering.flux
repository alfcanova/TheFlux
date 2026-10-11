#L ============================================================================
#L Algoritmo: Neural Collaborative Filtering (NCF - Fusao GMF e MLP)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoNeuralCollaborativeFiltering) {
      println("=== Algoritmo: Neural Collaborative Filtering ===")
      mut as int64: gmfOutput = 35
      mut as int64: mlpOutput = 45
      mut as int64: ncfPrediction = (gmfOutput + mlpOutput) /i 2
      println("1. Score unificado NCF: " + ncfPrediction)
      println("Teste concluido com sucesso.")
}
