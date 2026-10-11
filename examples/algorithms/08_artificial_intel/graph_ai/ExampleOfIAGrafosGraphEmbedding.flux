#L ============================================================================
#L Algoritmo: Graph Embedding (Laplacian Eigenmaps / Matriz Laplaciana)
#L Dominio: 08_artificial_intel / Subdominio: Grafos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGrafosGraphEmbedding) {
      println("=== Algoritmo: Graph Embedding Estrutural ===")
      mut as int64: deg1 = 2
      mut as int64: deg2 = 2
      mut as int64: laplacian12 = 0 - 1
      mut as int64: energy = deg1 + deg2 + 2 * laplacian12
      println("1. Grau Node 1: " + deg1)
      println("2. Entrada Laplaciana L(1,2): " + laplacian12)
      println("3. Energia de Dirichlet: " + energy)
      println("Teste concluido com sucesso.")
}
