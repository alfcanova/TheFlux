#L ============================================================================
#L Algoritmo: Rtnewt (Newton-Raphson com Derivadas Analiticas)
#L Capitulo: 09_root_finding
#L Complexidade: O(log(log(1/eps))) quadratica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Iteracao de Newton-Raphson x_{k+1} = x_k - f(x_k) / f'(x_k).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Rtnewt) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Rtnewt")
      println("==================================================")

      #L Encontrando raiz de f(x) = x^2 - 144 = 0 (raiz em x = 12):
      #L Derivada f'(x) = 2*x
      #L Chute inicial x0 = 100
      mut as int64: x = 100

      println("1. Executando iteracoes quadraticas de Newton-Raphson com chute x0 = " + x + ":")
      mut as int64: i = 1
      infinite (i <= 6) {
            mut as int64: f = x * x - 144
            mut as int64: df = 2 * x
            mut as int64: dx = f /i df
            x = x - dx
            println("   -> Iteracao " + i + ": x = " + x)
            i = i + 1
      }

      println("2. Raiz convergida: x = " + x + " (esperado: 12)")
      mut as int64: f_final = x * x - 144
      mut as int64: res = x - 12
      println("3. Residuos: |x - 12| = " + res + ", f(x) = " + f_final + " (esperado: 0)")
      println("4. Newton-Raphson Rtnewt concluido com exito.")
}
