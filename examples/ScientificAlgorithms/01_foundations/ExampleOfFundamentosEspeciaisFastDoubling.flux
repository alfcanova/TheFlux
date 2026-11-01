#L ============================================================================
#L Algoritmo: Fast Doubling Fibonacci (Metodo de Duplicacao Rapida)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(log N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisFastDoubling) {
      println("==================================================")
      println("  SciAlgo: Fast Doubling Fibonacci")
      println("==================================================")

      #L Calcula F(30) usando identidades de duplicacao rapida:
      #L F(2k)   = F(k) * (2*F(k+1) - F(k))
      #L F(2k+1) = F(k+1)^2 + F(k)^2
      mut as int64: n = 30
      println("1. Calculando Fibonacci para N = " + n)

      #L Extrai a sequencia de bits de n = 30 (binario: 11110)
      #L 30 = 16 + 8 + 4 + 2 + 0
      mut as list of int64: bits = [1, 1, 1, 1, 0]

      mut as int64: a = 0 #L F(k)
      mut as int64: b = 1 #L F(k+1)
      mut as int64: step = 1

      infinite (step <= listLength(bits)) {
            mut as int64: bit = bits[step]

            #L Formulas de duplicacao rapida
            mut as int64: c = a * (2 * b - a)
            mut as int64: d = a * a + b * b

            route {
                  bit == 0 ==> {
                        a = c
                        b = d
                  }
                  _ ==> {
                        a = d
                        b = c + d
                  }
            }

            println("  Passo " + step + " (bit=" + bit + ") -> F(" + a + "), F+1(" + b + ")")
            step = step + 1
      }

      println("2. Valor de F(30) calculado por Fast Doubling: " + a)

      #L Validacao com relacao direta: F(30) = 832040
      mut as bool: correct = (a == 832040)
      println("3. Validacao (F(30) == 832040): " + correct)
      println("==================================================")
}
