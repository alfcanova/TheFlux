#L ============================================================================
#L Algoritmo: Heterogeneous Graph Neural Network (Relational GNN)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosHeterogeneousGraphNeuralNetwork) {
      println("=== Algoritmo: Heterogeneous Graph Neural Network ===")
      mut as int64: userFeat = 20
      mut as int64: itemFeat = 40
      mut as int64: wBuy = 2
      mut as int64: wView = 1
      mut as int64: outUser = (userFeat + itemFeat * wBuy + itemFeat * wView) /i 3
      println("1. Agregacao heterogenea multi-relacao: " + outUser)
      println("Teste concluido com sucesso.")
}
