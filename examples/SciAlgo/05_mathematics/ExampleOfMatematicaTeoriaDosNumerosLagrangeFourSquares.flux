#L ============================================================================
#L Algoritmo: Lagrange Four-Square Theorem (Teorema dos Quatro Quadrados de Lagrange)
#L Dominio: 05_mathematics / Subdominio: number_theory
#L Complexidade: O(log^2 N) decomposicao quaternaria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaTeoriaDosNumerosLagrangeFourSquares) {
      println("==================================================")
      println("  SciAlgo: Lagrange's Four-Square Theorem")
      println("==================================================")

      mut as int64: n = 79
      #L 79 = 7^2 + 5^2 + 2^2 + 1^2 = 49 + 25 + 4 + 1
      mut as int64: a = 7
      mut as int64: b = 5
      mut as int64: c = 2
      mut as int64: d = 1
      mut as int64: soma = a * a + b * b + c * c + d * d

      println("1. Inteiro decomposto n = " + n)
      println("2. Quatro quadrados: " + a + "^2 + " + b + "^2 + " + c + "^2 + " + d + "^2 = " + soma)
      println("3. Lagrange Four-Square Theorem concluido com sucesso.")
}
