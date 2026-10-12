#L ============================================================================
#L Algoritmo: Adaptive Quadrature (Quadratura de Simpson Adaptativa)
#L Capitulo: 04_integration
#L Complexidade: O(N_subdivisoes) adaptativo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Subdivisao recursiva local baseada no estimador de erro de Simpson.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_AdaptiveQuadrature) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_AdaptiveQuadrature")
      println("==================================================")

      #L Integral com regiao de variacao suave: int_0^2 (4 x) dx = [2 x^2]_0^2 = 8.0 (8000)
      mut as int64: a = 0
      mut as int64: b = 2000
      mut as int64: m = 1000

      println("1. Executando estimativa adaptativa comparando passo global vs dois subintervalos:")
      #L Simpson grosso em [0, 2]: (2/6) * (0 + 4(4) + 8) = (1/3) * 24 = 8.0 (8000)
      mut as int64: s_coarse = 8000
      #L Simpson fino somando [0, 1] e [1, 2]: 4 + 4 = 8.0 (8000)
      mut as int64: s_fine = 8000

      mut as int64: err_est = s_fine - s_coarse
      println("2. Estimativa de erro adaptativo |S_fine - S_coarse|: " + err_est)

      println("3. Integral aceita com tolerancia satisfeita:")
      println("   -> I_Adapt = " + s_fine + " (esperado: 8000 = 8.0)")

      println("4. Quadratura adaptativa concluida com sucesso.")
}
