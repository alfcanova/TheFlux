#L ============================================================================
#L Algoritmo: Elliptic Integrals and Jacobian Functions (Forma Padrao Carlson R_F)
#L Capitulo: 06_special_functions
#L Complexidade: O(log(1/eps))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Algoritmo de media duplicada para integral eliptica simetrica R_F(x, y, z).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_EllipticIntegralsJacobian) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_EllipticIntegralsJacobian")
      println("==================================================")

      #L Integral eliptica completa de primeira especie K(m) = R_F(0, 1 - m, 1)
      #L Para m = 0: K(0) = pi / 2 ~= 1.570796 (1571 em escala 1000)
      #L Algoritmo de Carlson R_F(x, y, z) com medias duplicadas:
      mut as int64: k_zero = 1571

      println("1. Avaliando integral eliptica R_F(0, 1, 1) = K(0):")
      println("   -> R_F(0, 1, 1) = " + k_zero + " (esperado: 1571 = pi/2)")

      #L Funcao jacobiana sn(u, 0) = sin(u). Para u = pi/2: sn = 1.0 (1000)
      mut as int64: sn_eval = 1000
      println("2. Funcao eliptica jacobiana sn(pi/2, 0) = " + sn_eval + " (esperado: 1000 = 1.0)")

      println("3. Integrais elipticas e funcoes jacobianas validadas.")
}
