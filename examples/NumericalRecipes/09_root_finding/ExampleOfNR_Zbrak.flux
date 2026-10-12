#L ============================================================================
#L Algoritmo: Zbrak (Bracketing e Varredura de Raizes)
#L Capitulo: 09_root_finding
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Varredura de grade em intervalo [a, b] detectando mudanca de sinal f(x1)*f(x2) < 0.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Zbrak) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Zbrak")
      println("==================================================")

      #L Funcao f(x) = x*x - 49 (raizes em +- 7):
      #L Varrendo de x = 0 a 10 com passo dx = 2:
      #L x = 0: f = -49
      #L x = 2: f = -45
      #L x = 4: f = -33
      #L x = 6: f = -13
      #L x = 8: f = +15  -> Mudanca de sinal em [6, 8]!
      mut as int64: bracket_a = 0
      mut as int64: bracket_b = 0
      mut as int64: achou = 0

      println("1. Varrendo intervalo [0, 10] com dx = 2 para detectar delimitacao de raiz:")
      mut as int64: x1 = 0
      mut as int64: dx = 2
      infinite (x1 <= 8) {
            mut as int64: x2 = x1 + dx
            mut as int64: f1 = x1 * x1 - 49
            mut as int64: f2 = x2 * x2 - 49
            route {
                  (f1 * f2) <= 0 and achou == 0 ==> {
                        bracket_a = x1
                        bracket_b = x2
                        achou = 1
                        println("   -> Raiz delimitada no subintervalo: [" + x1 + ", " + x2 + "]")
                  }
                  (f1 * f2) > 0 or achou != 0 ==> {}
            }
            x1 = x1 + dx
      }

      #L Verificacao: raiz 7 delimitada entre 6 e 8
      mut as int64: res_a = bracket_a - 6
      mut as int64: res_b = bracket_b - 8
      println("2. Residuos da delimitacao: ra = " + res_a + ", rb = " + res_b + " (esperado: 0)")
      println("3. Varredura de raizes Zbrak concluida com sucesso.")
}
