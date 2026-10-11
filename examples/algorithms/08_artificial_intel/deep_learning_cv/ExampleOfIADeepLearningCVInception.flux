#L ============================================================================
#L Algoritmo: Inception (Fatoracao de Convolucoes Nx1 e 1xN)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVInception) {
      println("=== Algoritmo: Inception v3 Factorization ===")
      mut as int64: cost7x7 = 49
      mut as int64: cost1x7and7x1 = 7 + 7
      mut as int64: savingRatio = (cost1x7and7x1 * 100) /i cost7x7
      println("1. Custo computacional convolucao 7x7: " + cost7x7)
      println("2. Custo fatorado 1x7 seguido de 7x1: " + cost1x7and7x1)
      println("3. Percentual relativo de operacoes: " + savingRatio)
      println("Teste concluido com sucesso.")
}
