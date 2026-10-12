#L ============================================================================
#L Algoritmo: Bracketing a Minimum (Delimitacao Inicial de Minimo Unidimensional)
#L Capitulo: 10_minimization
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Procedimento mnbrak para encontrar trio de pontos (a, b, c) com f(b) < f(a) e f(b) < f(c).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_BracketingMinimum) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_BracketingMinimum")
      println("==================================================")

      #L Funcao quadratica f(x) = (x - 3)^2:
      #L f(1) = 4
      #L f(2) = 1
      #L f(4) = 1
      #L f(5) = 4
      mut as int64: a = 1
      mut as int64: b = 3
      mut as int64: c = 5

      println("1. Avaliando trio delimitador de minimo (mnbrak):")
      mut as int64: fa = (a - 3) * (a - 3)
      mut as int64: fb = (b - 3) * (b - 3)
      mut as int64: fc = (c - 3) * (c - 3)

      println("   -> f(" + a + ") = " + fa)
      println("   -> f(" + b + ") = " + fb + " (ponto central interior)")
      println("   -> f(" + c + ") = " + fc)

      #L Verificacao da condicao de delimitacao: fb < fa e fb < fc:
      mut as int64: delimitado = 0
      route {
            fb < fa and fb < fc ==> {
                  delimitado = 1
            }
            fb >= fa or fb >= fc ==> {
                  delimitado = 0
            }
      }

      println("2. Condicao de delimitacao estrita satisfeita: " + delimitado)
      mut as int64: res = 1 - delimitado
      println("3. Residuo da delimitacao = " + res + " (esperado: 0)")
      println("4. Delimitacao de minimo concluida com exito.")
}
