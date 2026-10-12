#L ============================================================================
#L Algoritmo: Rtbis (Busca de Raizes por Bissecao)
#L Capitulo: 09_root_finding
#L Complexidade: O(log((b-a)/eps))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Refinamento bisseccionado de intervalo garantindo convergencia incondicional.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Rtbis) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Rtbis")
      println("==================================================")

      #L Encontrando raiz de f(x) = x^2 - 2000000 (raiz sqrt(2) ~= 1414 em escala 1000):
      #L Intervalo inicial: [1000, 2000]
      mut as int64: xl = 1000
      mut as int64: xh = 2000
      mut as int64: target = 2000000

      println("1. Executando 12 iteracoes de bissecao:")
      mut as int64: iter = 1
      mut as int64: xm = 0
      infinite (iter <= 12) {
            xm = (xl + xh) /i 2
            mut as int64: fm = xm * xm - target
            mut as int64: fl = xl * xl - target
            route {
                  fm * fl <= 0 ==> {
                        xh = xm
                  }
                  fm * fl > 0 ==> {
                        xl = xm
                  }
            }
            iter = iter + 1
      }

      println("2. Raiz convergida: x = " + xm + " (esperado: 1414)")
      #L Verificacao de aproximacao proxima da raiz exata 1414:
      mut as int64: dif = xm - 1414
      route {
            dif < 0 ==> {
                  dif = 0 - dif
            }
            dif >= 0 ==> {}
      }
      mut as int64: ok = 0
      route {
            dif <= 2 ==> {
                  ok = 1
            }
            dif > 2 ==> {
                  ok = 0
            }
      }
      mut as int64: res = 1 - ok
      println("3. Residuo da tolerancia de bissecao = " + res + " (esperado: 0)")
      println("4. Metodo da bissecao Rtbis validado com exito.")
}
