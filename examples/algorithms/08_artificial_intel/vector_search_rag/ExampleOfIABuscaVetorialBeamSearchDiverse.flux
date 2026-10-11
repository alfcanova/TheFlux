#L ============================================================================
#L Algoritmo: Beam Search with Diverse Decoding
#L Dominio: 08_artificial_intel / Subdominio: Busca Vetorial, RAG & Adaptacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIABuscaVetorialBeamSearchDiverse) {
      println("=== Algoritmo: Diverse Beam Search ===")
      mut as int64: cand1Score = 80
      mut as int64: cand2Score = 75
      mut as int64: diversityPenalty = 10
      mut as int64: penalizedCand2 = cand2Score - diversityPenalty
      println("1. Candidato 1 Score: " + cand1Score)
      println("2. Candidato 2 Score Penalizado: " + penalizedCand2)
      println("Teste concluido com sucesso.")
}
