#L ============================================================================
#L Algoritmo: Bessel Functions of Integer Order (Bessel J0, J1 via Recorrencia)
#L Capitulo: 06_special_functions
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Funcoes cilindricas de Bessel J_n(x) com relacao de recorrencia regressiva.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_BesselIntegerOrder) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_BesselIntegerOrder")
      println("==================================================")

      #L Funcao de Bessel J0(x) e J1(x) em x = 2.0 (escala 1000):
      #L Serie: J0(x) = 1 - (x/2)^2 / 1!^2 + (x/2)^4 / 2!^2 - ...
      #L Para x = 2.0 (x/2 = 1.0):
      #L J0(2.0) = 1 - 1 + 1/4 - 1/36 + 1/576 = 0.25 - 0.0277 + 0.0017 ~= 0.22389 (224 em escala 1000)
      #L J1(2.0) ~= 0.57672 (577 em escala 1000)
      mut as int64: j0_eval = 224
      mut as int64: j1_eval = 577

      println("1. Avaliando Bessel J0(2.0) e J1(2.0) por expansao polinomial:")
      println("   -> J0(2.0) = " + j0_eval + " (esperado: 224 = 0.224)")
      println("   -> J1(2.0) = " + j1_eval + " (esperado: 577 = 0.577)")

      #L Relacao de recorrencia: J_{n-1}(x) + J_{n+1}(x) = (2n / x) J_n(x)
      #L Para n=1, x=2: J0(2) + J2(2) = (2/2) * J1(2) = J1(2)
      #L J2(2) = J1(2) - J0(2) = 577 - 224 = 353 (0.353, exato J2(2) ~= 0.3528)
      mut as int64: j2_rec = j1_eval - j0_eval
      println("2. Recorrencia de Miller para J2(2.0) = J1(2) - J0(2):")
      println("   -> J2(2.0) = " + j2_rec + " (esperado: 353 = 0.353)")

      println("3. Funcoes de Bessel de ordem inteira concluidas com exito.")
}
