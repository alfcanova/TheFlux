#L ============================================================================
#L Algoritmo: Multidimensional Grid Interpolation (Interpolacao Bilinear)
#L Capitulo: 03_interpolation
#L Complexidade: O(2^D) onde D e a dimensao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Interpolacao multilinear em hipercubo cartesiano.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MultidimensionalGridInterpolation) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MultidimensionalGridInterpolation")
      println("==================================================")

      #L Celula unitaria [0, 1] x [0, 1] com valores nos 4 vertices:
      #L f(0,0) = 1000, f(1,0) = 2000
      #L f(0,1) = 3000, f(1,1) = 6000
      mut as int64: f00 = 1000
      mut as int64: f10 = 2000
      mut as int64: f01 = 3000
      mut as int64: f11 = 6000

      #L Ponto de consulta central: (u, v) = (0.5, 0.5) (500, 500 em escala 1000)
      mut as int64: u = 500
      mut as int64: v = 500

      println("1. Interpolando no centro da celula (0.5, 0.5):")
      #L f = (1-u)(1-v)*f00 + u(1-v)*f10 + (1-u)v*f01 + u*v*f11
      #L (0.5*0.5)*1000 + (0.5*0.5)*2000 + (0.5*0.5)*3000 + (0.5*0.5)*6000 = 0.25 * 12000 = 3000
      mut as int64: f_interp = ((1000 - u) * (1000 - v) * f00 + u * (1000 - v) * f10 + (1000 - u) * v * f01 + u * v * f11) /i 1000000

      println("2. Valor bilinear interpolado:")
      println("   -> f(0.5, 0.5) = " + f_interp + " (esperado: 3000 = 3.0)")

      mut as int64: res = f_interp - 3000
      println("3. Residuo da interpolacao = " + res + " (esperado: 0)")
      println("4. Interpolacao em grade multidimensional concluida com exito.")
}
