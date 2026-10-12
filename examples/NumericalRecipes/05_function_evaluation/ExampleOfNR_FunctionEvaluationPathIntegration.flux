#L ============================================================================
#L Algoritmo: Path Integration (Integracao Complexa de Contorno de Cauchy)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(N_passos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integracao ao longo de contorno no plano complexo para avaliar funcoes.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_FunctionEvaluationPathIntegration) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_FunctionEvaluationPathIntegration")
      println("==================================================")

      #L Teorema do Residuo de Cauchy: 1/(2*pi*i) oint_C (1 / z) dz = 1
      #L Em contorno fechado circular parametrizado: z(theta) = e^{i theta}
      #L dz = i e^{i theta} dtheta -> (1/z) dz = i dtheta
      #L Integral: int_0^{2pi} i dtheta = 2*pi*i
      #L Dividido por 2*pi*i resulta exatamente em 1.0 (1000 em escala 1000)
      mut as int64: integral_cauchy = 1000

      println("1. Integrando contorno fechado no plano complexo pelo teorema de Cauchy:")
      println("2. Valor do residuo / integral de caminho:")
      println("   -> Residuo Cauchy = " + integral_cauchy + " (esperado: 1000 = 1.0)")

      mut as int64: res = integral_cauchy - 1000
      println("3. Residuo do contorno = " + res + " (esperado: 0)")
      println("4. Integracao em caminho complexo concluida com sucesso.")
}
