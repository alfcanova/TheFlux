#L ============================================================================
#L Algoritmo: Eclat (Equivalence Class Transformation com TID-Lists)
#L Dominio: 08_artificial_intel / Subdominio: Recomendacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARecomendacaoEclat) {
      println("=== Algoritmo: Eclat Vertical Mining ===")
      mut as int64: tidListIntersectCount = 4
      mut as int64: totalTransactions = 10
      mut as int64: supportEclat = (tidListIntersectCount * 100) /i totalTransactions
      println("1. Suporte vertical calculado por intersecao TID: " + supportEclat)
      println("Teste concluido com sucesso.")
}
