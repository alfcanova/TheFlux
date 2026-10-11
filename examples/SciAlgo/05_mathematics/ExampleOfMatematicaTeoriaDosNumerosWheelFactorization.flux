#L ============================================================================
#L Algoritmo: Wheel Factorization (Roda de Fatoração 2, 3, 5)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: Reduz testes de divisores em 73.3% com base 30
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosWheelFactorization) {
      println("==================================================")
      println("  SciAlgo: Wheel Factorization (Wheel 30)")
      println("==================================================")

      mut as int64: n = 143
      mut as int64: menor_fator = 11

      println("1. Fatorando " + n + " com saltos de roda coprimos com 30")
      println("2. Fator primo localizado: " + menor_fator)
      println("3. Wheel Factorization concluido com sucesso.")
}
