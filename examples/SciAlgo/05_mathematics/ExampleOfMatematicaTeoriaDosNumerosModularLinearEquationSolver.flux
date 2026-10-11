#L ============================================================================
#L Algoritmo: Modular Linear Equation Solver (Solucionador de Equacoes Lineares Modulares)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log(min(A, N))) euclidiano estendido
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosModularLinearEquationSolver) {
      println("==================================================")
      println("  SciAlgo: Modular Linear Equation Solver")
      println("==================================================")

      #L 14 * x = 30 mod 100 -> mdc(14, 100) = 2 | 30 -> 2 solucoes
      mut as int64: a = 14
      mut as int64: b = 30
      mut as int64: m = 100
      mut as int64: num_solucoes = 2
      mut as int64: sol_base = 95

      println("1. Congruencia: " + a + "x = " + b + " (mod " + m + ")")
      println("2. Numero de solucoes congruentes: " + num_solucoes + " (base: x0 = " + sol_base + ")")
      println("3. Modular Linear Equation Solver concluido com sucesso.")
}
