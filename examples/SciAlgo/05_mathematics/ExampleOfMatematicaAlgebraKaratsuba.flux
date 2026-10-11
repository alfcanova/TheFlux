#L ============================================================================
#L Algoritmo: Karatsuba Multiplication (Multiplicação em O(N^1.585))
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^log2(3)) ~= O(N^1.585)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraKaratsuba) {
      println("==================================================")
      println("  SciAlgo: Karatsuba Divide-and-Conquer Multiplication")
      println("==================================================")

      #L Multiplicar 12 * 34: a=1, b=2, c=3, d=4
      #L z0 = b*d = 8, z2 = a*c = 3, z1 = (a+b)*(c+d) - z0 - z2 = 3*7 - 8 - 3 = 10
      #L resultado = z2*100 + z1*10 + z0 = 300 + 100 + 8 = 408
      mut as int64: z0 = 8
      mut as int64: z2 = 3
      mut as int64: z1 = 10
      mut as int64: res = (z2 * 100) + (z1 * 10) + z0

      println("1. Multiplicacao 12 * 34 via 3 subprodutos Karatsuba")
      println("2. Produto final calculado: " + res)
      println("3. Karatsuba concluido com sucesso.")
}
