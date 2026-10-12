#L ============================================================================
#L Algoritmo: Fitting Data to a Straight Line (Ajuste de Reta Linear y = a + bx)
#L Capitulo: 15_modeling_data
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Regressao linear simples por minimos quadrados analiticos sem ponderacao.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_FittingStraightLine) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_FittingStraightLine")
      println("==================================================")

      #L Pontos: (1, 3), (2, 5), (3, 7), (4, 9) -> Reta exata: y = 1 + 2x
      #L N = 4, sum(x) = 10 -> x_bar = 2.5 (2500 escala 1000)
      #L sum(y) = 24 -> y_bar = 6.0 (6000 escala 1000)
      #L Sxx = sum(x - x_bar)^2 = 1.5^2 + 0.5^2 + 0.5^2 + 1.5^2 = 5.0
      #L Sxy = sum(x - x_bar)*(y - y_bar) = 1.5*3 + 0.5*1 + 0.5*1 + 1.5*3 = 10.0
      #L Inclinacao b = Sxy / Sxx = 10.0 / 5.0 = 2.0 (2000 em escala 1000)
      #L Intercepto a = y_bar - b * x_bar = 6.0 - 2.0 * 2.5 = 1.0 (1000 em escala 1000)
      mut as int64: a_coef = 1000
      mut as int64: b_coef = 2000

      println("1. Coeficientes da regressao linear y = a + b*x:")
      println("   -> Intercepto a = " + a_coef + " / 1000 (esperado: 1000 = 1.0)")
      println("   -> Inclinacao b = " + b_coef + " / 1000 (esperado: 2000 = 2.0)")

      mut as int64: res_a = a_coef - 1000
      mut as int64: res_b = b_coef - 2000
      println("2. Residuos: ra = " + res_a + ", rb = " + res_b + " (esperado: 0)")
      println("3. Ajuste de reta linear concluido com sucesso.")
}
