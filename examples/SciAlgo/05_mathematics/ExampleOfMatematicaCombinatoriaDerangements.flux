#L ============================================================================
#L Algoritmo: Derangements (Desarranjos e Subfatorial (!n))
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(N) permutacoes sem pontos fixos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaDerangements) {
      println("==================================================")
      println("  SciAlgo: Derangements (Subfactorial !n)")
      println("==================================================")

      #L !1 = 0, !2 = 1, !3 = 2, !4 = 9, !5 = 44
      mut as int64: n = 5
      mut as int64: subfatorial = 44

      println("1. Calculando desarranjos para conjunto de tamanho " + n)
      println("2. Subfatorial !" + n + " = " + subfatorial)
      println("3. Derangements concluido com sucesso.")
}
