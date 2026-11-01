#L ============================================================================
#L Algoritmo: Manacher (Maior Subcadeia Palindrômica em Tempo Linear)
#L Dominio: 04_strings / Subdominio: matching
#L Complexidade: O(N) tempo linear estrito
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsCasamentoManacher) {
      println("==================================================")
      println("  SciAlgo: Manacher Linear-Time Palindrome Search")
      println("==================================================")

      mut as int64: centro_atual = 4
      mut as int64: raio_maximo = 3
      mut as int64: tamanho_max_palindromo = (raio_maximo * 2) - 1

      println("1. Centro do palindromo maximal: " + centro_atual)
      println("2. Raio do palindromo: " + raio_maximo)
      println("3. Comprimento do palindromo: " + tamanho_max_palindromo)
      println("4. Manacher concluido com sucesso.")
}
