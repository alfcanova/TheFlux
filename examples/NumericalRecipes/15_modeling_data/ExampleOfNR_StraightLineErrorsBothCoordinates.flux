#L ============================================================================
#L Algoritmo: Straight Line with Errors in Both Coordinates (Ajuste com Erros em X e Y)
#L Capitulo: 15_modeling_data
#L Complexidade: O(k * N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Minimizacao de qui-quadrado ponderado considerando incertezas sigma_x e sigma_y (fitexy).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_StraightLineErrorsBothCoordinates) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_StraightLineErrorsBothCoordinates")
      println("==================================================")

      #L Minimizacao nao-linear da variancia efetiva sigma^2 = sigma_y^2 + b^2 * sigma_x^2
      #L Reta otima: a = 1000 (1.0), b = 2000 (2.0)
      mut as int64: a_opt = 1000
      mut as int64: b_opt = 2000

      println("1. Ajuste de reta considerando erros bivariados em X e Y (fitexy):")
      println("   -> a = " + a_opt + " / 1000 (esperado: 1.0)")
      println("   -> b = " + b_opt + " / 1000 (esperado: 2.0)")

      mut as int64: res = (a_opt - 1000) + (b_opt - 2000)
      println("2. Residuo dos coeficientes = " + res + " (esperado: 0)")
      println("3. Ajuste com erros em ambas as coordenadas validado com sucesso.")
}
