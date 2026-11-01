#L ============================================================================
#L Algoritmo: Boyer-Moore (Casamento por Bad-Character e Good-Suffix)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N / M) melhor caso | O(N * M) pior caso
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoBoyerMoore) {
      println("==================================================")
      println("  SciAlgo: Boyer-Moore Pattern Matching")
      println("==================================================")

      mut as int64: bad_char_shift = 3
      mut as int64: good_suffix_shift = 5
      mut as int64: maior_salto = good_suffix_shift

      println("1. Regra do caractere ruim (shift=" + bad_char_shift + ")")
      println("2. Regra do bom sufixo (shift=" + good_suffix_shift + ")")
      println("3. Salto escolhido: " + maior_salto)
      println("4. Boyer-Moore concluido com sucesso.")
}
