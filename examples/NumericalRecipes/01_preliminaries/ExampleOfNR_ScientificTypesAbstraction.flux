#L ============================================================================
#L Algoritmo: Scientific Types & Abstractions (Abstracoes de Numeros Complexos)
#L Capitulo: 01_preliminaries
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Aritmetica de numeros complexos com partes real e imaginaria.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ScientificTypesAbstraction) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ScientificTypesAbstraction")
      println("==================================================")

      #L Representacao de z1 = (3 + 4i) e z2 = (1 - 2i)
      mut as int64: z1_re = 3
      mut as int64: z1_im = 4
      mut as int64: z2_re = 1
      mut as int64: z2_im = -2

      println("1. Numeros complexos de teste: z1 = 3 + 4i, z2 = 1 - 2i")

      #L Adicao complexa: (z1 + z2)
      mut as int64: sum_re = z1_re + z2_re
      mut as int64: sum_im = z1_im + z2_im
      println("   -> Soma (z1 + z2) = " + sum_re + " + (" + sum_im + ")i (esperado: 4 + 2i)")

      #L Multiplicacao complexa: (a + bi)(c + di) = (ac - bd) + (ad + bc)i
      #L (3*1 - 4*(-2)) = 3 - (-8) = 11
      #L (3*(-2) + 4*1) = -6 + 4 = -2
      mut as int64: mul_re = (z1_re * z2_re) - (z1_im * z2_im)
      mut as int64: mul_im = (z1_re * z2_im) + (z1_im * z2_re)
      println("   -> Produto (z1 * z2) = " + mul_re + " + (" + mul_im + ")i (esperado: 11 - 2i)")

      #L Modulo ao quadrado de z1: |z1|^2 = 3^2 + 4^2 = 25
      mut as int64: norm_sq1 = (z1_re * z1_re) + (z1_im * z1_im)
      println("2. Norma euclidiana ao quadrado |z1|^2 = " + norm_sq1 + " (esperado: 25)")

      println("3. Abstracao de tipos cientificos validada.")
}
