#L ============================================================================
#L Algoritmo: RK4 (Metodo de Runge-Kutta Classico de 4a Ordem)
#L Capitulo: 17_differential_equations
#L Complexidade: O(N_steps)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integrador de 4a ordem para EDO dy/dt = f(t, y) com 4 estagios por passo.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RungeKuttaRK4) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RungeKuttaRK4")
      println("==================================================")

      #L Problema de teste: dy/dt = -y, com y(0) = 1.0 (escala 1000 -> 1000)
      #L Passo h = 0.1 (escala 1000 -> 100)
      #L 4 passos de t = 0 ate t = 0.4
      #L Solucao analitica y(0.4) = exp(-0.4) ~= 0.67032 -> 670 em escala 1000
      mut as int64: y = 1000
      mut as int64: h = 100
      mut as int64: step = 1

      println("1. Integracao numerica RK4 para dy/dt = -y [t=0.0 -> 0.4]:")
      println("   -> y(0.0) = " + y + " / 1000")

      infinite (step <= 4) {
            #L Estagio k1 = f(y) = -y
            mut as int64: k1 = 0 - y

            #L Estagio k2 = f(y + (h/2)*k1)
            #L y_k2 = y + (h * k1) / 2000
            mut as int64: dy1 = (h * k1) /i 2000
            mut as int64: y2 = y + dy1
            mut as int64: k2 = 0 - y2

            #L Estagio k3 = f(y + (h/2)*k2)
            mut as int64: dy2 = (h * k2) /i 2000
            mut as int64: y3 = y + dy2
            mut as int64: k3 = 0 - y3

            #L Estagio k4 = f(y + h*k3)
            mut as int64: dy3 = (h * k3) /i 1000
            mut as int64: y4 = y + dy3
            mut as int64: k4 = 0 - y4

            #L y_{n+1} = y + (h/6) * (k1 + 2*k2 + 2*k3 + k4)
            mut as int64: sum_k = k1 + (2 * k2) + (2 * k3) + k4
            mut as int64: dy_total = (h * sum_k) /i 6000
            y = y + dy_total

            println("   -> Passo " + step + " [t=" + (step * 100) + "/1000]: y = " + y + " / 1000")
            step = step + 1
      }

      #L y final esperado apos 4 passos: 670 (0.670)
      mut as int64: y_analitico = 670
      mut as int64: erro = y - y_analitico
      route {
            erro < 0 ==> {
                  erro = 0 - erro
            }
            erro >= 0 ==> {}
      }

      println("2. Verificacao de precisao:")
      println("   -> y numerico final = " + y + " / 1000")
      println("   -> y analitico exp(-0.4) = " + y_analitico + " / 1000")
      println("   -> Erro absoluto residual = " + erro + " (tolerancia <= 1)")

      mut as int64: res = 0
      route {
            erro <= 1 ==> {
                  res = 0
            }
            erro > 1 ==> {
                  res = erro
            }
      }
      println("3. Residuo da integracao RK4 = " + res + " (esperado: 0)")
      println("4. Algoritmo RK4 concluido com sucesso.")
}
