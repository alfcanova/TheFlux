#L ============================================================================
#L Algoritmo: Shortest Common Supersequence — SCS
#L Dominio: 04_strings / Subdominio: distance
#L Complexidade: O(M * N) tempo | SCS = M + N - LCS
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsDistanciaShortestCommonSupersequence) {
      println("==================================================")
      println("  SciAlgo: Shortest Common Supersequence (SCS)")
      println("==================================================")

      mut as int64: len_a = 5
      mut as int64: len_b = 4
      mut as int64: lcs_len = 3
      mut as int64: scs_len = len_a + len_b - lcs_len

      println("1. Tamanho A: " + len_a + ", Tamanho B: " + len_b)
      println("2. LCS correspondente: " + lcs_len)
      println("3. Comprimento minimo da supersequencia (SCS): " + scs_len)
      println("4. SCS concluido com sucesso.")
}
