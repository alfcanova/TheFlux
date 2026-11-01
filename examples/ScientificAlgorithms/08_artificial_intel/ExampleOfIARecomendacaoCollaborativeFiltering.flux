#L ============================================================================
#L Algoritmo: Collaborative Filtering (Filtragem Colaborativa Baseada em Usuarios)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoCollaborativeFiltering) {
      println("=== Algoritmo: User-Based Collaborative Filtering ===")
      mut as int64: simUserA = 90
      mut as int64: ratingUserA = 5
      mut as int64: simUserB = 60
      mut as int64: ratingUserB = 3
      mut as int64: predRating = (simUserA * ratingUserA + simUserB * ratingUserB) /i (simUserA + simUserB)
      println("1. Avaliacao predita para o item: " + predRating)
      println("Teste concluido com sucesso.")
}
