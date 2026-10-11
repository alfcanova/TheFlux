#L ============================================================================
#L Algoritmo: Fuzzy C-Means (FCM com Coeficiente de Pertinencia Gradual)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoFuzzyCMeans) {
      println("=== Algoritmo: Fuzzy C-Means ===")
      mut as int64: distC1 = 2
      mut as int64: distC2 = 6
      mut as int64: membership1 = (distC2 * 100) /i (distC1 + distC2)
      mut as int64: membership2 = 100 - membership1
      println("1. Grau de pertinencia no cluster 1: " + membership1)
      println("2. Grau de pertinencia no cluster 2: " + membership2)
      println("Teste concluido com sucesso.")
}
