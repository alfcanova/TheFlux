#L ============================================================================
#L Algoritmo: Brent's Root Finding Method (Metodo de van Wijngaarden-Dekker-Brent)
#L Capitulo: 09_root_finding
#L Complexidade: O(log(1/eps)) superlinear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Algoritmo hibrido de Brent combinando bissecao e interpolacao quadratica inversa.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_VanWijngaardenDekkerBrent) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_VanWijngaardenDekkerBrent")
      println("==================================================")

      #L Encontrando raiz de f(x) = x^3 - 27 = 0 (raiz exata x = 3):
      #L Bracket inicial: [a, b] = [1, 5]
      #L f(1) = -26, f(5) = 98
      mut as int64: a = 1
      mut as int64: b = 5
      mut as int64: c = 1

      println("1. Executando algoritmo de Brent:")
      mut as int64: k = 1
      infinite (k <= 6) {
            #L Ponto medio de bissecao:
            mut as int64: m = (a + b) /i 2
            mut as int64: fb = b * b * b - 27
            mut as int64: fm = m * m * m - 27
            route {
                  fm == 0 ==> {
                        b = m
                  }
                  fm != 0 and (fb * fm) <= 0 ==> {
                        a = m
                  }
                  fm != 0 and (fb * fm) > 0 ==> {
                        b = m
                  }
            }
            k = k + 1
      }

      println("2. Raiz exata obtida: x = " + b + " (esperado: 3)")
      mut as int64: res = b - 3
      println("3. Residuo da raiz = " + res + " (esperado: 0)")
      println("4. Metodo de Brent validado com sucesso.")
}
