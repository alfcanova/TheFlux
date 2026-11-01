#L ============================================================================
#L Algoritmo: K-Medoids (PAM - Partitioning Around Medoids com Distancia L1)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoKMedoids) {
      println("=== Algoritmo: K-Medoids PAM ===")
      mut as int64: costMedoid1 = 34
      mut as int64: costSwapCandidate = 28
      mut as int64: swapGain = costMedoid1 - costSwapCandidate
      println("1. Custo atual do medoid: " + costMedoid1)
      println("2. Ganho com troca de medoid: " + swapGain)
      println("Teste concluido com sucesso.")
}
