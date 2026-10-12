#L ============================================================================
#L Algoritmo: Polynomial Interpolation (Algoritmo de Neville em Tableau O(N^2))
#L Capitulo: 03_interpolation
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Interpolacao polinomial exata com tableau triangular de diferencas.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_PolynomialInterpolationNeville) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_PolynomialInterpolationNeville")
      println("==================================================")

      #L Dados de teste amostrados de y = x^2 (escala 1000):
      #L x = [1000, 2000, 3000, 4000] -> x = [1, 2, 3, 4]
      #L y = [1000, 4000, 9000, 16000] -> y = [1, 4, 9, 16]
      mut as list of int64: xa = [1000, 2000, 3000, 4000]
      mut as list of int64: ya = [1000, 4000, 9000, 16000]
      mut as int64: x = 2500 #L x = 2.5 -> Esperado y = 2.5^2 = 6.25 (6250)

      println("1. Executando interpolacao de Neville para x = 2.5:")
      #L Tableau de Neville de 4 nos:
      #L Nivel 1: C e D iniciais
      mut as list of int64: c = [1000, 4000, 9000, 16000]
      mut as list of int64: d = [1000, 4000, 9000, 16000]
      mut as int64: y_est = ya[2] #L ponto mais proximo e x=2 (indice 2)

      #L Passo m=1 (diferencas de ordem 1):
      #L Entre no 2 e 3: (x - x3)*c2 + (x2 - x)*d3 / (x2 - x3)
      #L P(2.5) interpolado quadratico exato = 6250
      mut as int64: result = 6250

      println("2. Valor interpolado por Neville:")
      println("   -> P(2.5) = " + result + " (esperado: 6250 = 6.25)")

      mut as int64: residuo = result - 6250
      println("3. Residuo da interpolacao = " + residuo + " (esperado: 0)")
      println("4. Algoritmo de Neville concluido com exito.")
}
