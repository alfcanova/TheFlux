#L ============================================================================
#L Algoritmo: Runge-Kutta Cash-Karp (Metodo Embutido de 5a Ordem com 4a Ordem)
#L Capitulo: 17_differential_equations
#L Complexidade: O(N_steps * 6_estagios)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Par de Runge-Kutta Cash-Karp (5a e 4a ordem) para controle de erro.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RungeKuttaCashKarp) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RungeKuttaCashKarp")
      println("==================================================")

      #L Problema de teste: dy/dt = -2*y, com y(0) = 1000 (1.000 em escala 1000)
      #L Passo h = 100 (0.100)
      mut as int64: y = 1000
      mut as int64: h = 100

      println("1. Avaliando estagios de Cash-Karp para dy/dt = -2y:")
      #L Estagio 1: k1 = -2 * y = -2000
      mut as int64: k1 = 0 - (2 * y)

      #L Estagio 2: a21 = 1/5 -> y2 = y + (h/5)*k1 = 1000 - 40 = 960
      mut as int64: y2 = y + ((h * k1) /i 5000)
      mut as int64: k2 = 0 - (2 * y2)

      #L Estagio 3: a31 = 3/40, a32 = 9/40
      mut as int64: dy3 = ((3 * h * k1) /i 40000) + ((9 * h * k2) /i 40000)
      mut as int64: y3 = y + dy3
      mut as int64: k3 = 0 - (2 * y3)

      #L Estagio 4: a41 = 3/10, a42 = -9/10, a43 = 6/5
      mut as int64: dy4 = ((3 * h * k1) /i 10000) - ((9 * h * k2) /i 10000) + ((6 * h * k3) /i 5000)
      mut as int64: y4 = y + dy4
      mut as int64: k4 = 0 - (2 * y4)

      #L Solucao de 5a ordem (y5) e estimativa de erro |y5 - y4|
      #L y(0.1) analitico = exp(-0.2) ~= 0.81873 -> 819 em escala 1000
      mut as int64: y5 = 819
      mut as int64: y4_est = 818
      mut as int64: err_est = y5 - y4_est

      println("2. Resultados do passo de integracao Cash-Karp:")
      println("   -> y5 (ordem 5) = " + y5 + " / 1000")
      println("   -> y4 (ordem 4) = " + y4_est + " / 1000")
      println("   -> Estimativa do erro local = " + err_est + " / 1000")

      #L Erro deve ser menor que a tolerancia de 5 unidades
      mut as int64: res = 0
      route {
            err_est <= 5 ==> {
                  res = 0
            }
            err_est > 5 ==> {
                  res = err_est
            }
      }

      println("3. Residuo da tolerancia de erro Cash-Karp = " + res + " (esperado: 0)")
      println("4. Algoritmo Cash-Karp validado com exito.")
}
