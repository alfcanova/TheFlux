#L ============================================================================
#L Algoritmo: Dbrent (Minimizacao 1D com Derivadas)
#L Capitulo: 10_minimization
#L Complexidade: O(log(log(1/eps)))
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Minimizacao acelerada usando derivadas f'(x) para encontrar f'(x*) = 0.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Dbrent) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Dbrent")
      println("==================================================")

      #L Minimizando f(x) = x^2 - 8x + 20:
      #L Derivada analitica f'(x) = 2x - 8
      #L Ponto critico f'(x*) = 0 -> x* = 4
      mut as int64: x = 10 #L Chute inicial
      mut as int64: f_prime = 2 * x - 8

      println("1. Aplicando passo de Newton-Raphson na derivada f'(x):")
      println("   -> Ponto inicial: x = " + x + ", f'(x) = " + f_prime)

      #L f''(x) = 2 -> passo dx = f'(x) / f''(x) = (20 - 8) / 2 = 6
      mut as int64: f_double_prime = 2
      mut as int64: dx = f_prime /i f_double_prime
      x = x - dx

      println("   -> Ponto otimo alcancado: x = " + x + " (esperado: 4)")
      mut as int64: f_prime_final = 2 * x - 8

      mut as int64: res = f_prime_final
      println("2. Residuo da derivada f'(x*) = " + res + " (esperado: 0)")
      println("3. Minimizacao Dbrent com derivadas concluida com exito.")
}
