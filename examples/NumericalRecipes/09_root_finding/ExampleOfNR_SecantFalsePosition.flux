#L ============================================================================
#L Algoritmo: Secant Method & False Position (Metodo da Secante e Regula Falsi)
#L Capitulo: 09_root_finding
#L Complexidade: O(1.618^k)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Interpolacao linear sucessiva entre dois pontos para busca superlinear de raiz.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SecantFalsePosition) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SecantFalsePosition")
      println("==================================================")

      #L Funcao f(x) = x^2 - 16 = 0 (raiz em x = 4)
      #L Pontos iniciais: x1 = 1, x2 = 6
      #L f(1) = 1 - 16 = -15
      #L f(6) = 36 - 16 = 20
      mut as int64: x1 = 1
      mut as int64: x2 = 6

      println("1. Iterando passos do metodo da secante:")
      mut as int64: step = 1
      infinite (step <= 5) {
            mut as int64: f1 = x1 * x1 - 16
            mut as int64: f2 = x2 * x2 - 16
            mut as int64: denom = f2 - f1
            route {
                  denom != 0 ==> {
                        mut as int64: dx = (f2 * (x2 - x1)) /i denom
                        x1 = x2
                        x2 = x2 - dx
                  }
                  denom == 0 ==> {}
            }
            println("   -> Passo " + step + ": x = " + x2)
            step = step + 1
      }

      println("2. Raiz obtida pela secante: x = " + x2 + " (esperado: 4)")
      mut as int64: res = x2 - 4
      println("3. Residuo da raiz f(4) = " + res + " (esperado: 0)")
      println("4. Metodo da secante concluido com sucesso.")
}
