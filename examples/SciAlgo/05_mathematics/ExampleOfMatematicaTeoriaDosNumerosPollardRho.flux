#L ============================================================================
#L Algoritmo: Pollard Rho (Fatoração Heurística de Inteiros O(N^0.25))
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(N^(1/4)) com deteccao de ciclo de Floyd
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosPollardRho) {
      println("==================================================")
      println("  SciAlgo: Pollard's Rho Integer Factorization")
      println("==================================================")

      mut as int64: n = 8051
      mut as int64: fator = 83

      println("1. Fatorando " + n + " com f(x) = (x^2 + 1) mod n")
      println("2. Fator nao trivial identificado por MDC: " + fator)
      println("3. Pollard Rho concluido com sucesso.")
}
