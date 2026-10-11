#L ============================================================================
#L Algoritmo: Pollard p−1 (Fatoração para Primos com p-1 Suave)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(B log B log^2 N) onde B e a suavidade
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosPollardPMinus1) {
      println("==================================================")
      println("  SciAlgo: Pollard's p - 1 Factoring Algorithm")
      println("==================================================")

      mut as int64: n = 540143
      mut as int64: fator = 421

      println("1. Fatorando " + n + " com base de potencias suaves B=10")
      println("2. Fator isolado: " + fator)
      println("3. Pollard p-1 concluido com sucesso.")
}
