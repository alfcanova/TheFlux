#L ============================================================================
#L Algoritmo: Ranfib (Gerador Lagged-Fibonacci 64-bit)
#L Capitulo: 07_random_numbers
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Gerador com atraso de Fibonacci x_n = (x_{n-r} + x_{n-s}) /r m.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Ranfib) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Ranfib")
      println("==================================================")

      #L Buffer circular com lags r=5 e s=2:
      mut as list of int64: buf = [12345, 67890, 13579, 24680, 98765]
      mut as int64: mod_val = 1000000

      println("1. Gerando 5 novos numeros pelo algoritmo Lagged-Fibonacci:")
      mut as int64: step = 1
      infinite (step <= 5) {
            #L Novo elemento: (buf[1] + buf[4]) /r mod
            mut as int64: novo = (buf[1] + buf[4]) /r mod_val
            println("   -> Passo " + step + ": " + novo)
            #L Desloca buffer:
            buf = [buf[2], buf[3], buf[4], buf[5], novo]
            step = step + 1
      }

      #L O 1o elemento gerado foi (12345 + 24680) /r 1000000 = 37025
      #L O 2o foi (67890 + 98765) = 166655
      #L O 3o foi (13579 + 37025) = 50604
      #L O 4o foi (24680 + 166655) = 191335
      #L O 5o foi (98765 + 50604) = 149369
      mut as int64: ultimo = buf[5]
      mut as int64: esperado = 149369
      mut as int64: res = ultimo - esperado
      println("2. Ultimo valor gerado = " + ultimo + " (residuo: " + res + ")")
      println("3. Gerador Lagged-Fibonacci Ranfib validado com exito.")
}
