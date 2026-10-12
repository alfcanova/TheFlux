#L ============================================================================
#L Algoritmo: Ranq1 (Gerador Rapido Xorshift 64-bit)
#L Capitulo: 07_random_numbers
#L Complexidade: O(1) por amostra
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Gerador Xorshift de Marsaglia com deslocamento de bits e XOR.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Ranq1) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Ranq1")
      println("==================================================")

      #L Semente inicial nao-nula de 32-bit:
      mut as int64: state = 12345678

      println("1. Executando gerador Xorshift com semente " + state + ":")
      mut as int64: i = 1
      infinite (i <= 5) {
            #L Tripleto de Marsaglia reduzido para manter dentro do limite de 63-bit:
            state = state ^ (state << 7)
            state = state ^ (state >> 9)
            state = state ^ (state << 8)
            state = state /r 2147483647
            mut as int64: display_val = state /r 1000000
            route {
                  display_val < 0 ==> {
                        display_val = 0 - display_val
                  }
                  display_val >= 0 ==> {}
            }
            println("   -> Passo " + i + " (estado mod 1M): " + display_val)
            i = i + 1
      }

      #L Verificacao de que o gerador progrediu e manteve entropia:
      mut as int64: diff = 0
      route {
            state != 12345678 ==> {
                  diff = 1
            }
            state == 12345678 ==> {
                  diff = 0
            }
      }
      mut as int64: res = 1 - diff
      println("2. Verificacao de transicao de estado: diff = " + diff + " (residuo: " + res + ")")
      println("3. Gerador Xorshift Ranq1 concluido com exito.")
}
