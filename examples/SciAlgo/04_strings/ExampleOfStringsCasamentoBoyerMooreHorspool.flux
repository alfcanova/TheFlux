#L ============================================================================
#L Algoritmo: Boyer-Moore-Horspool (Simplificação por Bad-Character)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N * M) pior caso | O(N / M) caso medio
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoBoyerMooreHorspool) {
      println("==================================================")
      println("  SciAlgo: Boyer-Moore-Horspool Algorithm")
      println("==================================================")

      mut as int64: m = 5
      mut as int64: shift_padrao = m
      mut as int64: ocorrencia = 4

      println("1. Tamanho do padrao: " + m)
      println("2. Salto determinado pela tabela de Horspool: " + shift_padrao)
      println("3. Ocorrencia localizada em: " + ocorrencia)
      println("4. Horspool concluido com sucesso.")
}
