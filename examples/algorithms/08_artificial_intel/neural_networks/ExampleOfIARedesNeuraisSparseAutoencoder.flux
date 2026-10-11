#L ============================================================================
#L Algoritmo: Sparse Autoencoder (Autoencoder com Penalidade de Esparsidade KL)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisSparseAutoencoder) {
      println("=== Algoritmo: Sparse Autoencoder ===")
      mut as int64: targetRho = 5
      mut as int64: actualRho = 8
      mut as int64: sparsityPenalty = (actualRho - targetRho) * (actualRho - targetRho)
      println("1. Ativacao media alvo rho: " + targetRho)
      println("2. Ativacao media real rho_hat: " + actualRho)
      println("3. Penalidade de esparsidade: " + sparsityPenalty)
      println("Teste concluido com sucesso.")
}
