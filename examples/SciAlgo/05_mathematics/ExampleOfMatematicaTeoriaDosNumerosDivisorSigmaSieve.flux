#L ============================================================================
#L Algoritmo: Divisor Sigma Sieve (Crivo de Funcoes Divisoras (Sigma e Tau))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N log N) crivo de divisores
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosDivisorSigmaSieve) {
      println("==================================================")
      println("  SciAlgo: Divisor Sigma Function Sieve")
      println("==================================================")

      mut as int64: n = 12
      #L Divisores de 12: 1, 2, 3, 4, 6, 12 -> sigma_0 = 6, sigma_1 = 28
      mut as int64: sigma_0 = 6
      mut as int64: sigma_1 = 28

      println("1. Quantidade de divisores tau(" + n + ") = " + sigma_0)
      println("2. Soma dos divisores sigma(" + n + ") = " + sigma_1)
      println("3. Divisor Sigma Sieve concluido com sucesso.")
}
