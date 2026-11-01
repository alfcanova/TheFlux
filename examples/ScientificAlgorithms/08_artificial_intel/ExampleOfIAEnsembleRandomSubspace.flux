#L ============================================================================
#L Algoritmo: Random Subspace Method (Amostragem de Features para Ensemble)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleRandomSubspace) {
      println("=== Algoritmo: Random Subspace Method ===")
      mut as list of int64: totalFeatures = [1, 2, 3, 4, 5, 6, 7, 8]
      mut as list of int64: subFeatures = [totalFeatures[1], totalFeatures[3], totalFeatures[6]]
      println("1. Numero de atributos amostrados no subespaco: " + listLength(subFeatures))
      println("2. Atributos selecionados: [1, 3, 6]")
      println("Teste concluido com sucesso.")
}
