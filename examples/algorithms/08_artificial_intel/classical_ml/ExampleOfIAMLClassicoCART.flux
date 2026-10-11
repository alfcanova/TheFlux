#L ============================================================================
#L Algoritmo: CART (Classification and Regression Trees com Impureza de Gini)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoCART) {
      println("=== Algoritmo: CART Gini Impurity ===")
      mut as int64: p1 = 60
      mut as int64: p2 = 40
      mut as int64: gini = 100 - (p1 * p1 + p2 * p2) /i 100
      println("1. Impureza de Gini calculada: " + gini)
      println("Teste concluido com sucesso.")
}
