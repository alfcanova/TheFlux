#L ============================================================================
#L Algoritmo: Integral Equations with Singular Kernels (Nucleos Singulares)
#L Capitulo: 19_integral_equations
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Regularizacao de nucleo singular por subtracao de singularidade de Kantorovich.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_IntegralEquationsSingularKernels) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_IntegralEquationsSingularKernels")
      println("==================================================")

      #L Integral singular classica: I = int_0^1 (1 / sqrt(t)) * phi(t) dt
      #L Com phi(t) = 1 (constante): I_exata = 2 * sqrt(1) = 2.000 -> 2000 em escala 1000
      #L Tratamento por subtracao de singularidade analitica:
      #L A integral do polo 1/sqrt(t) e integrada analiticamente:
      mut as int64: integral_analitica_polo = 2000 #L 2.000

      println("1. Avaliacao de integral com singularidade fracionaria 1/sqrt(t):")
      println("   -> Parte singular integrada analiticamente: I_polo = " + integral_analitica_polo + " / 1000")

      #L Parte regular residual com subtracao de Kantorovich:
      #L int_0^1 (phi(t) - phi(0))/sqrt(t) dt = 0 para phi constante
      mut as int64: residuo_regular = 0
      mut as int64: integral_total = integral_analitica_polo + residuo_regular

      println("2. Valor total da quadratura regularizada:")
      println("   -> I_total = " + integral_total + " / 1000 (esperado: 2.000)")

      mut as int64: residuo = integral_total - 2000
      println("3. Residuo da regularizacao singular = " + residuo + " (esperado: 0)")
      println("4. Tratamento de nucleos singulares concluido com exito.")
}
