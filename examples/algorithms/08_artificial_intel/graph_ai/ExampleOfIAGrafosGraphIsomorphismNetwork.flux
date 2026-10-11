#L ============================================================================
#L Algoritmo: GIN (Graph Isomorphism Network)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosGraphIsomorphismNetwork) {
      println("=== Algoritmo: Graph Isomorphism Network ===")
      mut as int64: hSelf = 5
      mut as int64: eps = 1
      mut as int64: sumNeighbors = 15
      mut as int64: ginAgg = (1 + eps) * hSelf + sumNeighbors
      mut as int64: mlpOut = ginAgg * 2 + 3
      println("1. Agregacao injetiva multiconjunto: " + ginAgg)
      println("2. Saida MLP GIN: " + mlpOut)
      println("Teste concluido com sucesso.")
}
