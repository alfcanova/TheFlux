#L ============================================================================
#L Algoritmo: Metodo Lagrangiano Aumentado (Augmented Lagrangian Method - ALM)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAugmentedLagrangian) {
      println("==================================================")
      println("  SciAlgo: Augmented Lagrangian Method (ALM)")
      println("==================================================")

      #L Problema com restricao de igualdade:
      #L min f(x) = x^2 / 2 sujeito a c(x) = x - 20 = 0
      #L Lagrangiano Aumentado de Powell-Hestenes:
      #L L_rho(x, lambda) = f(x) + lambda * c(x) + (rho / 2) * c(x)^2
      #L Minimizacao em x: grad_x = x + lambda + rho * (x - 20) = 0
      #L   => x*(lambda, rho) = (20 * rho - lambda) / (1 + rho)
      #L Atualizacao do multiplicador dual: lambda_{k+1} = lambda_k + rho * c(x_k)

      mut as int64: lambda_dual = 0
      mut as int64: rho = 4
      mut as int64: x = 0

      println("1. Parametros iniciais:")
      println("   Restricao x = 20 | Penalidade rho = " + rho + " | Lambda0 = " + lambda_dual)

      mut as int64: iter = 1
      infinite (iter <= 5) {
            #L Minimizacao do subproblema irrestrito em x
            mut as int64: num = (20 * rho) - lambda_dual
            mut as int64: den = 1 + rho
            x = num /i den

            #L Violacao da restricao c(x)
            mut as int64: c_val = x - 20

            #L Atualizacao do multiplicador de Lagrange
            lambda_dual = lambda_dual + (rho * c_val)

            println("   Iteracao " + iter + ": x = " + x + " | c(x) = " + c_val + " | lambda = " + lambda_dual)
            iter = iter + 1
      }

      println("2. Solucao primal-dual obtida por ALM:")
      println("   x* = " + x + " | lambda* = " + lambda_dual)

      route {
            x == 20 ==> {
                  println("   [PASS] Lagrangiano Aumentado alcancou viabilidade exata e multiplicador KKT!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Metodo Lagrangiano Aumentado.")
            }
      }

      println("==================================================")
      println("Augmented Lagrangian Method concluido com sucesso!")
}
