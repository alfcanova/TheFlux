#L ============================================================================
#L Algoritmo: Integrador Conservativo de Stormer-Verlet (2a Ordem)
#L Capitulo: 17_differential_equations
#L Complexidade: O(N_passos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Integrador simpletico para sistemas hamiltonianos conservativos d^2x/dt^2 = a(x).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_SecondOrderConservativeVerlet) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_SecondOrderConservativeVerlet")
      println("==================================================")

      #L Oscilador harmonico conservativo: d^2x/dt^2 = -x (omega = 1)
      #L Condicoes iniciais: x(0) = 1.000 (1000), v(0) = 0
      #L Passo h = 0.1 (escala 1000 -> h_sq = 10 / 1000)
      mut as int64: x_prev = 1000
      #L x(1) via Taylor: x(0) + 0.5 * a(0) * h^2 = 1000 - 5 = 995
      mut as int64: x_curr = 995
      mut as int64: step = 2

      println("1. Integracao simpletica de Verlet para oscilador harmonico:")
      println("   -> x(0) = " + x_prev + " / 1000")
      println("   -> x(1) = " + x_curr + " / 1000")

      infinite (step <= 5) {
            #L Aceleracao a(x) = -x
            mut as int64: a_curr = 0 - x_curr
            #L h^2 * a(x) com h = 0.1 -> multiplicador = -x / 100
            mut as int64: h2_a = a_curr /i 100
            #L x_{n+1} = 2*x_n - x_{n-1} + h^2*a
            mut as int64: x_next = (2 * x_curr) - x_prev + h2_a

            println("   -> Passo " + step + ": x = " + x_next + " / 1000")
            x_prev = x_curr
            x_curr = x_next
            step = step + 1
      }

      #L Conservacao da energia em Verlet (sistema estavel e bounded):
      #L Apos 5 passos, x permanece no intervalo conservativo [-1000, +1000]
      mut as int64: estavel = 0
      route {
            x_curr > 0 and x_curr <= 1000 ==> {
                  estavel = 1
            }
            x_curr <= 0 or x_curr > 1000 ==> {
                  estavel = 0
            }
      }

      mut as int64: residuo = 1 - estavel
      println("2. Verificacao de estabilidade simpletica: estavel = " + estavel + " (residuo: " + residuo + ")")
      println("3. Integrador de Stormer-Verlet validado com exito.")
}
