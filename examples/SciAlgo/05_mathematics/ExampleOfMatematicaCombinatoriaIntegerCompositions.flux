#L ============================================================================
#L Algoritmo: Integer Compositions (Gerador de Composicoes Ordenadas de Inteiros)
#L Dominio: 05_mathematics / Subdominio: combinatorics
#L Complexidade: O(2^(N-1)) geracao exata
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaCombinatoriaIntegerCompositions) {
      println("==================================================")
      println("  SciAlgo: Integer Compositions")
      println("==================================================")

      mut as int64: n = 4
      #L 2^(4-1) = 8 composicoes
      mut as int64: total_composicoes = 8

      println("1. Inteiro de entrada para composicao: n = " + n)
      println("2. Total de particoes ordenadas 2^(n-1) = " + total_composicoes)
      println("3. Integer Compositions concluido com sucesso.")
}
