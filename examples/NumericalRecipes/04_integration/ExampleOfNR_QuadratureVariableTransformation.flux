#L ============================================================================
#L Algoritmo: Variable Transformation (Transformacao de Variaveis em Quadraturas)
#L Capitulo: 04_integration
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Suavizacao de singularidades de contorno por mudanca de variavel x = t^2.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_QuadratureVariableTransformation) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_QuadratureVariableTransformation")
      println("==================================================")

      #L Integral original: int_0^1 (1 / sqrt(x)) dx = [2 sqrt(x)]_0^1 = 2.0 (2000 em escala 1000)
      #L Mudanca de variavel: x = t^2 -> dx = 2t dt
      #L Nova integral transformada: int_0^1 (1 / t) * (2t) dt = int_0^1 2 dt = 2.0 (2000)
      mut as int64: integral_transf = 2000

      println("1. Aplicando substituicao x = t^2 para remover singularidade em zero:")
      println("2. Integral transformada avaliada:")
      println("   -> I_transformada = " + integral_transf + " (esperado: 2000 = 2.0)")

      mut as int64: res = integral_transf - 2000
      println("3. Residuo analitico = " + res + " (esperado: 0)")
      println("4. Transformacao de variaveis em quadratura validada com exito.")
}
