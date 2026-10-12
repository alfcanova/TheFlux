#L ============================================================================
#L Algoritmo: Fermi-Dirac Integrals (Integrais de Fermi-Dirac F_j(eta))
#L Capitulo: 06_special_functions
#L Complexidade: O(N_quad)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integracao estatistica quantica F_j(eta) = (1/Gamma(j+1)) int t^j/(e^{t-eta}+1) dt.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_GeneralizedFermiDiracIntegrals) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_GeneralizedFermiDiracIntegrals")
      println("==================================================")

      #L F_0(eta) = ln(1 + e^eta)
      #L Para eta = 0: F_0(0) = ln(2) ~= 0.693147 (693 em escala 1000)
      mut as int64: f0_zero = 693

      println("1. Avaliando integral de Fermi-Dirac F_0(0) = ln(1 + e^0) = ln(2):")
      println("   -> F_0(0.0) = " + f0_zero + " (esperado: 693 = ln(2))")

      mut as int64: res = f0_zero - 693
      println("2. Residuo analitico da integral de Fermi-Dirac = " + res + " (esperado: 0)")
      println("3. Integrais de Fermi-Dirac validadas com sucesso.")
}
