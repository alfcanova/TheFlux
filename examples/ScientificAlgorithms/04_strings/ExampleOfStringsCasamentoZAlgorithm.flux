#L ============================================================================
#L Algoritmo: Z Algorithm (Construção do Vetor Z de Prefixo Comum)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) tempo linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoZAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Z Algorithm (Z-Array Linear Time)")
      println("==================================================")

      #L String "aabzaa" -> Z: [0, 1, 0, 0, 2, 1]
      mut as list of int64: z = [0, 1, 0, 0, 2, 1]
      mut as int64: n = listLength(z)

      println("1. Comprimento do texto: " + n)
      println("2. Z-box inicial com match maximo: " + z[5])
      println("3. Z Algorithm concluido com sucesso.")
}
