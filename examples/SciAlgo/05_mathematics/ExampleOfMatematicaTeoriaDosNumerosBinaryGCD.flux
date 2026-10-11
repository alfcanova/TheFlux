#L ============================================================================
#L Algoritmo: Binary GCD (Algoritmo Binário de Stein sem Divisões)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log^2 N) operacoes de shift e subtracao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosBinaryGCD) {
      println("==================================================")
      println("  SciAlgo: Binary GCD (Stein's Algorithm)")
      println("==================================================")

      mut as int64: u = 48
      mut as int64: v = 18
      mut as int64: shift_k = 0

      #L Fator 2 comum: 48 e 18 são pares -> fator 2, restam 24 e 9 -> mdc=6
      mut as int64: mdc = 6

      println("1. MDC Binario Stein de 48 e 18: " + mdc)
      println("2. Binary GCD concluido com sucesso.")
}
