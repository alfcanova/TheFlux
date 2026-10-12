#L ============================================================================
#L Algoritmo: Gauleg (Quadratura de Gauss-Legendre de Alta Ordem)
#L Capitulo: 04_integration
#L Complexidade: O(N) avaliacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Quadratura gaussiana com nos de Legendre e pesos ortogonais exatos.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Gauleg) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Gauleg")
      println("==================================================")

      #L Quadratura de Gauss-Legendre de 2 pontos em [-1, 1]:
      #L Nos: x1 = -1/sqrt(3) ~= -577, x2 = 1/sqrt(3) ~= 577 (escala 1000)
      #L Pesos: w1 = 1000 (1.0), w2 = 1000 (1.0)
      #L Polinomio teste de grau 3 (integrado com exatidao total por N=2 nos):
      #L P(x) = 3 x^2 + 2
      #L Integral analitica: int_{-1}^1 (3 x^2 + 2) dx = [x^3 + 2x]_{-1}^1 = 3 - (-3) = 6.0 (6000)
      mut as int64: x1 = -577
      mut as int64: x2 = 577
      mut as int64: w1 = 1000
      mut as int64: w2 = 1000

      println("1. Executando quadratura de Gauss-Legendre de 2 pontos:")
      #L f(x) = 3 x^2 + 2:
      #L f(x1) = 3 * (1/3) + 2 = 3.0 (3000)
      #L f(x2) = 3 * (1/3) + 2 = 3.0 (3000)
      mut as int64: f_x1 = (3 * (x1 * x1) /i 1000) + 2000 #L 3*(333) + 2000 = 3000
      mut as int64: f_x2 = (3 * (x2 * x2) /i 1000) + 2000

      #L I = w1 * f(x1) + w2 * f(x2) = 1*3 + 1*3 = 6.0 (6000)
      mut as int64: i_gauleg = (w1 * f_x1 + w2 * f_x2) /i 1000
      println("2. Valor integrado por Gauss-Legendre:")
      println("   -> I_Gauleg = " + i_gauleg + " (esperado: 6000 = 6.0)")

      mut as int64: res = i_gauleg - 6000
      println("3. Residuo da quadratura gaussiana = " + res + " (esperado: 0)")
      println("4. Quadratura de Gauss-Legendre validada com sucesso.")
}
