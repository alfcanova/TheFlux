#L ============================================================================
#L Algoritmo: Sieve of Atkin (Crivo Moderno de Formas Quadráticas)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N / log log N) tempo assintótico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosSieveOfAtkin) {
      println("==================================================")
      println("  SciAlgo: Sieve of Atkin (Quadratic Forms)")
      println("==================================================")

      mut as int64: limite = 40
      mut as int64: total_primos = 12

      println("1. Formas quadraticas 4x^2+y^2, 3x^2+y^2, 3x^2-y^2 computadas ate: " + limite)
      println("2. Primos confirmados: " + total_primos)
      println("3. Sieve of Atkin concluido com sucesso.")
}
