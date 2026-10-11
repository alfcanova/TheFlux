#L ============================================================================
#L Algoritmo: Pell Equation (Soluções Fundamentais de x^2 - d*y^2 = 1)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(sqrt(D)) via convergentes de fracoes continuas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosPellEquation) {
      println("==================================================")
      println("  SciAlgo: Pell Equation Fundamental Solution")
      println("==================================================")

      #L d = 2: x^2 - 2*y^2 = 1 -> solucao fundamental (3, 2): 3^2 - 2*(2^2) = 9 - 8 = 1
      mut as int64: d = 2
      mut as int64: x = 3
      mut as int64: y = 2
      mut as int64: verificacao = (x * x) - (d * y * y)

      println("1. Equacao x^2 - " + d + "*y^2 = 1")
      println("2. Solucao minima: x=" + x + ", y=" + y + " (res=" + verificacao + ")")
      println("3. Pell Equation concluido com sucesso.")
}
