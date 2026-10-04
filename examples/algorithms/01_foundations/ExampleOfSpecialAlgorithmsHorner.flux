#L ============================================================================
#L Algoritmo: Horner's Method (Metodo de Horner / Briot-Ruffini)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(N) multiplicacoes e adicoes | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSpecialAlgorithmsHorner) {
      println("==================================================")
      println("  SciAlgo: Horner's Polynomial Evaluation")
      println("==================================================")

      #L Polinomio: P(x) = 2x^3 - 6x^2 + 2x - 1
      #L Coeficientes em ordem decrescente de grau: [2, -6, 2, -1]
      mut as list of int64: poly = [2, -6, 2, -1]
      mut as int64: n = listLength(poly)
      mut as int64: x = 3

      println("1. Polinomio: P(x) = 2x^3 - 6x^2 + 2x - 1")
      println("   Ponto de avaliacao x = " + x)

      #L Avaliacao de P(x) pelo Metodo de Horner:
      #L res = ((2 * x - 6) * x + 2) * x - 1
      mut as int64: res_p = poly[1]
      mut as int64: mult_count = 0

      mut as int64: i = 2
      infinite (i <= n) {
            res_p = res_p * x + poly[i]
            mult_count = mult_count + 1
            i = i + 1
      }
      println("2. Valor de P(3) calculado por Horner: " + res_p)
      println("   Multiplicacoes realizadas: " + mult_count + " (estritamente O(N))")

      #L Calculo simultaneo da Derivada P'(x) = 6x^2 - 12x + 2:
      #L Derivada dos coeficientes:
      #L 2*3 = 6, -6*2 = -12, 2*1 = 2
      mut as list of int64: deriv_poly = [6, -12, 2]
      mut as int64: res_deriv = deriv_poly[1]
      mut as int64: j = 2
      infinite (j <= listLength(deriv_poly)) {
            res_deriv = res_deriv * x + deriv_poly[j]
            j = j + 1
      }
      println("3. Valor da derivada P'(3) via Horner: " + res_deriv)

      println("4. Validacao: " + (res_p == 5 and res_deriv == 20))
      println("==================================================")
}
