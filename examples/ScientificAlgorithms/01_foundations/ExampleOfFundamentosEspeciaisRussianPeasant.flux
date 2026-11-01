#L ============================================================================
#L Algoritmo: Russian Peasant Multiplication (Multiplicacao Camponesa)
#L Dominio: 01_foundations / Algoritmos Especiais
#L Complexidade: O(log a) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisRussianPeasant) {
      println("==================================================")
      println("  SciAlgo: Russian Peasant Multiplication         ")
      println("==================================================")

      mut as int64: a = 18
      mut as int64: b = 23
      println("1. Multiplicandos Originais: a = " + a + " | b = " + b)

      mut as int64: result = 0
      mut as int64: cur_a = a
      mut as int64: cur_b = b
      mut as int64: step = 1

      infinite (cur_a > 0) {
            #L Se cur_a for impar, soma cur_b ao resultado
            route {
                  cur_a /r 2 == 1 ==> {
                        result = result + cur_b
                        println("   Passo " + step + ": a=" + cur_a + " (impar) -> soma b=" + cur_b + " | acum=" + result)
                  }
                  _ ==> {
                        println("   Passo " + step + ": a=" + cur_a + " (par)   -> ignora b=" + cur_b)
                  }
            }

            cur_a = cur_a /i 2
            cur_b = cur_b * 2
            step = step + 1
      }

      println("2. Produto Calculado: " + result)
      mut as int64: expected = a * b
      println("3. Produto Direto:    " + expected)
      mut as bool: ok = (result == expected and result == 414)
      println("4. Validacao (Esperado == 414): " + ok)
      println("==================================================")
}
