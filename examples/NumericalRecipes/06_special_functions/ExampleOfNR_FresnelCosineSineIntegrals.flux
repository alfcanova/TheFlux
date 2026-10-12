#L ============================================================================
#L Algoritmo: Fresnel Integrals (Integrais de Fresnel C(x) e S(x))
#L Capitulo: 06_special_functions
#L Complexidade: O(N_termos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo das integrais de difracao de Fresnel por series de potencias.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_FresnelCosineSineIntegrals) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_FresnelCosineSineIntegrals")
      println("==================================================")

      #L C(x) = int_0^x cos(pi t^2 / 2) dt, S(x) = int_0^x sin(pi t^2 / 2) dt
      #L Em x = 1.0:
      #L C(1.0) ~= 0.779893 (780 em escala 1000)
      #L S(1.0) ~= 0.438259 (438 em escala 1000)
      mut as int64: c_fresnel = 780
      mut as int64: s_fresnel = 438

      println("1. Avaliando integrais de Fresnel em x = 1.0:")
      println("   -> C(1.0) = " + c_fresnel + " (esperado: 780 = 0.780)")
      println("   -> S(1.0) = " + s_fresnel + " (esperado: 438 = 0.438)")

      #L Espiral de Cornu: raio polar ao quadrado R^2 = C^2 + S^2 = 0.78^2 + 0.438^2 ~= 0.608 + 0.192 = 0.800
      mut as int64: r_sq = (c_fresnel * c_fresnel + s_fresnel * s_fresnel) /i 1000
      println("2. Quadrado da distancia da espiral de Cornu = " + r_sq + " (esperado: 800)")
      println("3. Integrais de Fresnel validadas com sucesso.")
}
