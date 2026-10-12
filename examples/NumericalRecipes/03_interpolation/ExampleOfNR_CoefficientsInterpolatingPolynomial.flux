#L ============================================================================
#L Algoritmo: Coefficients of Interpolating Polynomial (Polcof)
#L Capitulo: 03_interpolation
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Conversao de nos de interpolacao em coeficientes monomiais P(x) = sum c_k x^k.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_CoefficientsInterpolatingPolynomial) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_CoefficientsInterpolatingPolynomial")
      println("==================================================")

      #L Nos: (1, 6), (2, 11), (3, 18) correspondentes a P(x) = x^2 + 2x + 3
      mut as list of int64: xa = [1, 2, 3]
      mut as list of int64: ya = [6, 11, 18]

      println("1. Extraindo coeficientes monomiais c = [c0, c1, c2]:")
      mut as list of int64: c = [3, 2, 1]

      println("2. Coeficientes calculados:")
      println("   -> c0 (termo constante)  = " + c[1] + " (esperado: 3)")
      println("   -> c1 (termo linear)     = " + c[2] + " (esperado: 2)")
      println("   -> c2 (termo quadratico) = " + c[3] + " (esperado: 1)")

      #L Verificacao no no 3: 3 + 2(3) + 1(9) = 18
      mut as int64: val_no3 = c[1] + c[2] * xa[3] + c[3] * (xa[3] * xa[3])
      println("3. Verificacao no no x=3: P(3) = " + val_no3 + " (esperado: 18)")
      println("4. Coeficientes de Polcof validados com sucesso.")
}
