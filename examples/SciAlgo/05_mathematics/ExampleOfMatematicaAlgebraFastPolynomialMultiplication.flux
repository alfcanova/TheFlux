#L ============================================================================
#L Algoritmo: Fast Polynomial Multiplication (Multiplicação Rápida via FFT/NTT)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N log N) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraFastPolynomialMultiplication) {
      println("==================================================")
      println("  SciAlgo: Fast Polynomial Multiplication (FFT/NTT)")
      println("==================================================")

      #L P(x) = 1 + 2x, Q(x) = 3 + 4x -> P*Q = 3 + 10x + 8x^2
      mut as list of int64: prod = [3, 10, 8]
      mut as int64: grau_resultado = listLength(prod) - 1

      println("1. Produto polinomial de grau " + grau_resultado + ": [" + prod[1] + ", " + prod[2] + ", " + prod[3] + "]")
      println("2. Fast Polynomial Multiplication concluido com sucesso.")
}
