#L ============================================================================
#L Algoritmo: Contractive Autoencoder (CAE com Regularizacao da Norma de Frobenius)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisContractiveAutoencoder) {
      println("=== Algoritmo: Contractive Autoencoder ===")
      mut as int64: jacobianNormSq = 18
      mut as int64: lambdaContractive = 10
      mut as int64: contractivePenalty = lambdaContractive * jacobianNormSq
      println("1. Norma de Frobenius do Jacobiano ||J||^2: " + jacobianNormSq)
      println("2. Penalidade contrativa calculada: " + contractivePenalty)
      println("Teste concluido com sucesso.")
}
