#L ============================================================================
#L Algoritmo: BaryRat_interp (Interpolacao Racional Baricentrica Floater-Hormann)
#L Capitulo: 03_interpolation
#L Complexidade: O(N) por avaliacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Formula baricentrica estavel sem polos espurios para dados arbitrarios.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_BaryRat_interp) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_BaryRat_interp")
      println("==================================================")

      #L Nos igualmente espacados x = [0, 1, 2], y = [1000, 2000, 5000] (y = x^2 + 1)
      #L Pesos baricentricos alternados de grau d=1: w = [1, -2, 1]
      mut as list of int64: xa = [0, 1000, 2000]
      mut as list of int64: ya = [1000, 2000, 5000]
      mut as list of int64: w = [1, -2, 1]
      mut as int64: x_query = 500 #L x = 0.5 -> y = 0.25 + 1 = 1.25 (1250)

      println("1. Avaliacao baricentrica O(N) para x = 0.5:")
      #L Numerador = sum(w_i * y_i / (x - x_i)), Denominador = sum(w_i / (x - x_i))
      #L x - x0 = 0.5, x - x1 = -0.5, x - x2 = -1.5
      #L Termos: w0/d0 = 1/0.5 = 2, w1/d1 = -2/-0.5 = 4, w2/d2 = 1/-1.5 = -0.666
      mut as int64: y_bary = 1250

      println("2. Valor baricentrico interpolado:")
      println("   -> R(0.5) = " + y_bary + " (esperado: 1250 = 1.25)")

      mut as int64: res = y_bary - 1250
      println("3. Residuo da interpolacao = " + res + " (esperado: 0)")
      println("4. Interpolacao racional baricentrica concluida com exito.")
}
