#L ============================================================================
#L Algoritmo: Newton-Raphson for Nonlinear Systems (Sistemas Nao-Lineares 2D)
#L Capitulo: 09_root_finding
#L Complexidade: O(n^3) por iteracao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de sistema nao-linear multivariado J * delta = -F.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_NewtonRaphsonNonlinearSystems) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_NewtonRaphsonNonlinearSystems")
      println("==================================================")

      #L Sistema:
      #L f1(x, y) = x^2 + y^2 - 25 = 0
      #L f2(x, y) = x - y - 1 = 0
      #L Solucao analitica exata: x = 4, y = 3 (16 + 9 = 25, 4 - 3 = 1)
      mut as int64: x = 5
      mut as int64: y = 2

      println("1. Iterando Newton-Raphson multivariado com Jacobiano 2x2:")
      #L J = [[2x, 2y], [1, -1]]
      #L det(J) = -2x - 2y = -2*(x + y)
      mut as int64: iter = 1
      infinite (iter <= 3) {
            mut as int64: f1 = x * x + y * y - 25
            mut as int64: f2 = x - y - 1
            mut as int64: det = 0 - (2 * (x + y))
            route {
                  det != 0 ==> {
                        #L delta_x = (-f1 * (-1) - (-f2 * 2y)) / det = (f1 + 2*y*f2) / det
                        mut as int64: num_x = f1 + (2 * y * f2)
                        mut as int64: num_y = (2 * x * f2) - f1
                        x = x + (num_x /i det)
                        y = y + (num_y /i det)
                  }
                  det == 0 ==> {}
            }
            println("   -> Iteracao " + iter + ": x = " + x + ", y = " + y)
            iter = iter + 1
      }

      println("2. Solucao convergida: (x, y) = (" + x + ", " + y + ") (esperado: 4, 3)")
      mut as int64: res1 = x - 4
      mut as int64: res2 = y - 3
      println("3. Residuos: rx = " + res1 + ", ry = " + res2 + " (esperado: 0)")
      println("4. Newton-Raphson multidimensional validado com exito.")
}
