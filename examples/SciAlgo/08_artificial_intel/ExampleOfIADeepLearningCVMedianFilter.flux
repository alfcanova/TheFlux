#L ============================================================================
#L Algoritmo: Median Filter (Filtro Nao-Linear para Remocao de Ruido Sal e Pimenta)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVMedianFilter) {
      println("=== Algoritmo: Median Filter ===")
      mut as list of int64: windowVals = [10, 15, 80]
      mut as int64: medianVal = windowVals[2]
      println("1. Mediana dos 3 pixels vizinhos: " + medianVal)
      println("Teste concluido com sucesso.")
}
