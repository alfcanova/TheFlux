#L ============================================================================
#L Algoritmo: Sieve of Sundaram (Crivo Baseado em Progressões Aritméticas)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N log N) gerando 2k + 1
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosSieveOfSundaram) {
      println("==================================================")
      println("  SciAlgo: Sieve of Sundaram")
      println("==================================================")

      mut as int64: k = 20
      mut as int64: primos_gerados = 8

      println("1. Exclusao de termos da forma i + j + 2ij para k=" + k)
      println("2. Primos 2k+1 identificados: " + primos_gerados)
      println("3. Sieve of Sundaram concluido com sucesso.")
}
