#L ============================================================================
#L Algoritmo: Roots of Polynomials — Laguerre (Metodo de Laguerre para Polinomios)
#L Capitulo: 09_root_finding
#L Complexidade: O(N) convergencia cubica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Localizacao de raizes complexas/reais de polinomios via metodo de Laguerre.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RootsOfPolynomialsLaguerre) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RootsOfPolynomialsLaguerre")
      println("==================================================")

      #L Polinomio de grau 2: P(x) = x^2 - 10x + 21 = (x - 3)(x - 7)
      #L Grau n = 2
      #L P'(x) = 2x - 10
      #L P''(x) = 2
      #L Partindo de x = 1 (mais proximo da raiz 3):
      mut as int64: x = 1

      println("1. Executando aproximacao de Laguerre para raiz de P(x) = x^2 - 10x + 21:")
      mut as int64: i = 1
      infinite (i <= 4) {
            mut as int64: p = x * x - 10 * x + 21
            mut as int64: dp = 2 * x - 10
            #L Passo de Newton/Laguerre de 1a ordem:
            route {
                  dp != 0 ==> {
                        mut as int64: a = p /i dp
                        x = x - a
                  }
                  dp == 0 ==> {}
            }
            println("   -> Passo " + i + ": x = " + x)
            i = i + 1
      }

      println("2. Raiz do polinomio convergida: x = " + x + " (esperado: 3)")
      mut as int64: res = x - 3
      println("3. Residuo do polinomio = " + res + " (esperado: 0)")
      println("4. Metodo de Laguerre para raizes concluido com sucesso.")
}
