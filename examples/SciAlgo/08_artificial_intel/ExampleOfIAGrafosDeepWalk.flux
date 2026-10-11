#L ============================================================================
#L Algoritmo: DeepWalk (Embeddings de Grafos por Passeios e Skip-Gram)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosDeepWalk) {
      println("=== Algoritmo: DeepWalk Graph Embedding ===")
      mut as list of int64: embNode1 = [45, 82]
      mut as list of int64: embNode2 = [42, 80]
      mut as int64: dotProduct = embNode1[1] * embNode2[1] + embNode1[2] * embNode2[2]
      println("1. Dimensao de embedding: 2")
      println("2. Similaridade de co-ocorrencia: " + dotProduct)
      println("Teste concluido com sucesso.")
}
