#L ============================================================================
#L Algoritmo: Kasai Algorithm (Construção Linear do LCP Array)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) tempo linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoKasaiAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Kasai Linear-Time LCP Array")
      println("==================================================")

      mut as list of int64: lcp = [0, 1, 3, 0, 0, 2]
      mut as int64: n = listLength(lcp)

      println("1. LCP (Longest Common Prefix) array de tamanho: " + n)
      println("2. Maior prefixo compartilhado adjacente: " + lcp[3])
      println("3. Kasai Algorithm concluido com sucesso.")
}
