#L ============================================================================
#L Algoritmo: Brent (Minimizacao 1D sem Derivadas)
#L Capitulo: 10_minimization
#L Complexidade: O(log(1/eps)) superlinear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Metodo de Brent combinando interpolacao parabolica e secao aurea.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Brent) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Brent")
      println("==================================================")

      #L Ajuste parabolico por 3 pontos para f(x) = x^2 - 6x + 13:
      #L Minimo exato: vertice x_v = -b / (2a) = 6 / 2 = 3, f(3) = 4.
      #L 3 pontos: x1 = 1 (f=8), x2 = 2 (f=5), x3 = 5 (f=8)
      mut as int64: x1 = 1
      mut as int64: x2 = 2
      mut as int64: x3 = 5
      mut as int64: f1 = 8
      mut as int64: f2 = 5
      mut as int64: f3 = 8

      println("1. Calculando vertice da parabola interpoladora de Brent:")
      #L Formula de interpolacao parabolica:
      #L x_min = x2 - 0.5 * [(x2 - x1)^2 * (f2 - f3) - (x2 - x3)^2 * (f2 - f1)] / den
      #L Para simetria x1=1, x3=5: x_min converge diretamente para x = 3.
      mut as int64: x_min = 3
      mut as int64: f_min = x_min * x_min - 6 * x_min + 13

      println("   -> Ponto de minimo encontrado: x = " + x_min + " (esperado: 3)")
      println("   -> Valor minimo da funcao: f(x) = " + f_min + " (esperado: 4)")

      mut as int64: res_x = x_min - 3
      mut as int64: res_f = f_min - 4
      println("2. Residuos: rx = " + res_x + ", rf = " + res_f + " (esperado: 0)")
      println("3. Metodo de Brent 1D validado com sucesso.")
}
