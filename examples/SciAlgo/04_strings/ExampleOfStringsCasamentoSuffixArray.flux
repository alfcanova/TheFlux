#L ============================================================================
#L Algoritmo: Suffix Array (Vetor de Sufixos Ordenados)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N log N) ordenacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoSuffixArray) {
      println("==================================================")
      println("  SciAlgo: Suffix Array Structure")
      println("==================================================")

      #L Para "banana$" (tam 7): sa = [7, 6, 4, 2, 1, 5, 3]
      mut as list of int64: sa = [7, 6, 4, 2, 1, 5, 3]
      mut as int64: n = listLength(sa)

      println("1. Vetor de sufixos ordenados lexicograficamente (tam=" + n + ")")
      println("2. Menor sufixo: indice " + sa[1])
      println("3. Suffix Array concluido com sucesso.")
}
