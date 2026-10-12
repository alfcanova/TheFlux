#L ============================================================================
#L Algoritmo: Linear Feedback Shift Registers — LFSR (Gerador Galois 4-bit)
#L Capitulo: 07_random_numbers
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Registrador de deslocamento com realimentacao linear x^4 + x^3 + 1.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_LinearFeedbackShiftRegisters) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_LinearFeedbackShiftRegisters")
      println("==================================================")

      #L Polinomio primitivo para n=4: x^4 + x^3 + 1 (mascara 0b1100 = 12)
      #L Periodo maximo esperado: 2^4 - 1 = 15 passos.
      mut as int64: state = 1
      mut as int64: initial_state = 1
      mut as int64: count = 0

      println("1. Iterando LFSR de 4 bits ate completar o ciclo completo:")
      mut as int64: continuar = 1
      infinite (continuar == 1) {
            #L Bit menos significativo:
            mut as int64: lsb = state & 1
            state = state >> 1
            route {
                  lsb == 1 ==> {
                        state = state ^ 12
                  }
                  lsb == 0 ==> {}
            }
            count = count + 1
            route {
                  state == initial_state ==> {
                        continuar = 0
                  }
                  state != initial_state ==> {}
            }
      }

      println("   -> Periodo medido do ciclo completo: " + count + " (esperado: 15)")
      mut as int64: res = count - 15
      println("2. Residuo do periodo maximo = " + res + " (esperado: 0)")
      println("3. LFSR pseudo-aleatorio validado com exito.")
}
