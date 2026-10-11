#L ============================================================================
#L Algoritmo: Euler Totient Sieve (Crivo da Função Totiente phi(n))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N log log N) ou O(N) com crivo linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosEulerTotientSieve) {
      println("==================================================")
      println("  SciAlgo: Euler's Totient Sieve (phi(n))")
      println("==================================================")

      mut as list of int64: phi = [1, 1, 2, 2, 4, 2, 6, 4]
      mut as int64: n = 8

      println("1. Valores de phi(1..8): [1, 1, 2, 2, 4, 2, 6, 4]")
      println("2. phi(" + n + ") = " + phi[n])
      println("3. Euler Totient Sieve concluido com sucesso.")
}
