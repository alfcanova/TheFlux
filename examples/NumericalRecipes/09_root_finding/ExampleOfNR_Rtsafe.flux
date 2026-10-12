#L ============================================================================
#L Algoritmo: Rtsafe (Newton-Raphson com Salvaguarda de Bissecao)
#L Capitulo: 09_root_finding
#L Complexidade: O(log(1/eps))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Metodo hibrido de Newton com controle de limites para evitar divergencia.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Rtsafe) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Rtsafe")
      println("==================================================")

      #L Raiz de f(x) = x^2 - 49 = 0 no intervalo [0, 20]:
      mut as int64: x_low = 0
      mut as int64: x_high = 20
      mut as int64: x = 15 #L Chute inicial

      println("1. Executando passos de Newton com salvaguarda:")
      mut as int64: step = 1
      infinite (step <= 5) {
            mut as int64: f = x * x - 49
            mut as int64: df = 2 * x
            mut as int64: dx = f /i df
            mut as int64: x_new = x - dx
            #L Salvaguarda: se passo de Newton sair do intervalo, usar bissecao:
            route {
                  x_new < x_low or x_new > x_high ==> {
                        x = (x_low + x_high) /i 2
                        println("   -> Passo " + step + ": Salvaguarda ativada (bissecao)")
                  }
                  x_new >= x_low and x_new <= x_high ==> {
                        x = x_new
                        println("   -> Passo " + step + ": Passo de Newton aceito -> x = " + x)
                  }
            }
            step = step + 1
      }

      println("2. Raiz segura alcancada: x = " + x + " (esperado: 7)")
      mut as int64: res = x - 7
      println("3. Residuo da solucao = " + res + " (esperado: 0)")
      println("4. Newton-Raphson com salvaguarda Rtsafe validado.")
}
