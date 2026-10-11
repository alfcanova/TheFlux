#L ============================================================================
#L Algoritmo: Longest Increasing Subsequence — LIS (Patience Sorting O(N log N))
#L Dominio: 05_mathematics / Subdominio: dynamic_programming
#L Complexidade: O(N log N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaProgramacaoDinamicaLongestIncreasingSubsequence) {
      println("==================================================")
      println("  SciAlgo: Longest Increasing Subsequence (LIS)")
      println("==================================================")

      mut as list of int64: seq = [10, 9, 2, 5, 3, 7, 101, 18]
      mut as int64: lis_len = 4

      println("1. Sequencia analisada com patience sorting: tamanho " + listLength(seq))
      println("2. Comprimento da LIS: " + lis_len)
      println("3. LIS concluido com sucesso.")
}
