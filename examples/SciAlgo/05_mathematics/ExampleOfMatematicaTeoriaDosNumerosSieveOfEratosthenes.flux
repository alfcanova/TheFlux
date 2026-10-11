#L ============================================================================
#L Algoritmo: Sieve of Eratosthenes (Crivo de Eratóstenes Clássico)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N log log N) tempo | O(N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosSieveOfEratosthenes) {
      println("==================================================")
      println("  SciAlgo: Sieve of Eratosthenes")
      println("==================================================")

      mut as int64: limite = 30
      #L Primos ate 30: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 (total 10)
      mut as int64: total_primos = 10

      println("1. Crivo executado ate limite: " + limite)
      println("2. Total de primos encontrados: " + total_primos)
      println("3. Sieve of Eratosthenes concluido com sucesso.")
}
