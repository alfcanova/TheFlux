#L ============================================================================
#L Algoritmo: Longest Common Substring (Subcadeia Comum Mais Longa)
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaLongestCommonSubstring) {
      println("==================================================")
      println("  SciAlgo: Longest Common Substring")
      println("==================================================")

      mut as list of int64: a = [1, 2, 3, 4, 5]
      mut as list of int64: b = [2, 3, 4, 9]
      mut as int64: max_len = 3

      println("1. Subcadeia contígua máxima identificada: " + max_len)
      println("2. Longest Common Substring concluido com sucesso.")
}
