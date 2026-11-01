#L ============================================================================
#L Algoritmo: MMR (Maximal Marginal Relevance para RAG e Busca)
#L Dominio: 08_artificial_intel / Subdominio: Busca Vetorial, RAG & Adaptacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIABuscaVetorialMMR) {
      println("=== Algoritmo: Maximal Marginal Relevance ===")
      mut as int64: simQueryDoc = 80
      mut as int64: simDocSelected = 60
      mut as int64: lambdaVal = 70
      mut as int64: mmrScore = (lambdaVal * simQueryDoc - (100 - lambdaVal) * simDocSelected) /i 100
      println("1. MMR Score balanceado: " + mmrScore)
      println("Teste concluido com sucesso.")
}
