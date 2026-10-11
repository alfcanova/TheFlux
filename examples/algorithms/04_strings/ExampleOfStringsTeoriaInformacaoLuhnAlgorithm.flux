#L ============================================================================
#L Algoritmo: Luhn Algorithm (Fórmula do Módulo 10 para Dígitos Verificadores)
#L Dominio: 04_strings / Subdominio: information_theory
#L Complexidade: O(N) linear sobre a quantidade de dígitos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfStringsTeoriaInformacaoLuhnAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Luhn Modulo 10 Check Digit")
      println("==================================================")

      mut as list of int64: digitos = [7, 9, 9, 2, 7, 3, 9, 8, 7, 1, 3]
      mut as int64: n = listLength(digitos)
      mut as int64: soma = 0

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: d = digitos[i]
            route {
                  (i /r 2) == 0 ==> {
                        mut as int64: d2 = d * 2
                        route {
                              d2 > 9 ==> { d2 = d2 - 9 }
                              _ ==> {}
                        }
                        soma = soma + d2
                  }
                  _ ==> {
                        soma = soma + d
                  }
            }
            i = i + 1
      }

      mut as int64: check_digit = (10 - (soma /r 10)) /r 10

      println("1. Digitos processados: " + n)
      println("2. Digito verificador Luhn: " + check_digit)
      println("3. Luhn Algorithm concluido com sucesso.")
}
