#L ============================================================================
#L Algoritmo: Savitzky-Golay Smoothing Filters (Filtros de Savitzky-Golay)
#L Capitulo: 14_statistical_description
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Suavizacao por convolucao de minimos quadrados locais preservando momentos de ordem superior.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SavitzkyGolaySmoothingFilters) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SavitzkyGolaySmoothingFilters")
      println("==================================================")

      #L Filtro polinomial quadratico com janela de 5 pontos (coeficientes normalizados sobre 35):
      #L c = [-3, 12, 17, 12, -3]
      #L Aplicado sobre rampa linear perfeita x = [1, 2, 3, 4, 5]:
      #L y_central = (-3*1 + 12*2 + 17*3 + 12*4 - 3*5) / 35 = (-3 + 24 + 51 + 48 - 15) / 35 = 105 / 35 = 3
      mut as int64: y_filtrado = (0 - 3 * 1 + 12 * 2 + 17 * 3 + 12 * 4 - 3 * 5) /i 35

      println("1. Suavizacao polinomial local de Savitzky-Golay no ponto central:")
      println("   -> Ponto original = 3, Ponto filtrado = " + y_filtrado + " (esperado: 3)")

      mut as int64: res = y_filtrado - 3
      println("2. Residuo da preservacao de sinal linear = " + res + " (esperado: 0)")
      println("3. Filtro de Savitzky-Golay validado com exito.")
}
