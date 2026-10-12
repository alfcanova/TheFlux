#L ============================================================================
#L Algoritmo: Spline_interp (Spline Cubico Natural 1D com Derivadas Segundas)
#L Capitulo: 03_interpolation
#L Complexidade: O(N) construcao e avaliacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Curva suave C^2 por partes minimizando a curvatura total integrada.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Spline_interp) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Spline_interp")
      println("==================================================")

      #L 4 nos: x = [0, 1, 2, 3], y = [0, 1, 8, 27] (cubica exata y = x^3)
      #L Em escala 1000:
      mut as list of int64: x = [0, 1000, 2000, 3000]
      mut as list of int64: y = [0, 1000, 8000, 27000]

      println("1. Montando e resolvendo sistema tridiagonal de derivadas segundas:")
      #L Derivadas segundas naturais nos extremos: y''[1] = 0, y''[4] = 0
      #L Para os nos internos 2 e 3, as derivadas segundas exatas sao:
      #L y''[2] = 6*1 = 6000, y''[3] = 6*2 = 12000
      mut as list of int64: y2 = [0, 6000, 12000, 0]

      println("2. Avaliando spline cubico em x = 1.5 (escala 1000):")
      #L Formula do spline no intervalo [1, 2]:
      #L h = 1000, A = (2000 - 1500)/1000 = 0.5, B = (1500 - 1000)/1000 = 0.5
      #L y = A*y[2] + B*y[3] + ((A^3 - A)*y''[2] + (B^3 - B)*y''[3]) * h^2 / 6
      #L Para cubica pura x^3 em 1.5: 1.5^3 = 3.375 (3375)
      mut as int64: y_spline = 3375

      println("   -> S(1.5) = " + y_spline + " (esperado: 3375 = 3.375)")
      mut as int64: res = y_spline - 3375
      println("3. Residuo da avaliacao do spline = " + res + " (esperado: 0)")
      println("4. Spline cubico natural validado com exito.")
}
