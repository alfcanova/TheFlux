#L ============================================================================
#L Algoritmo: Relaxation Boundary Value SOR (Successive Over-Relaxation)
#L Capitulo: 20_partial_differential_eqs
#L Complexidade: O(N^2 * N_iter)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Aceleracao de convergencia de Poisson/Laplace via sobre-relaxacao sucessiva SOR.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RelaxationBoundaryValueSOR) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RelaxationBoundaryValueSOR")
      println("==================================================")

      #L Equacao de Laplace: d^2u/dx^2 + d^2u/dy^2 = 0 em no central cercado por 4 contornos
      #L Contornos: C_cima = 1000, C_baixo = 0, C_esq = 500, C_dir = 500
      #L Media analitica de Laplace: u_otimo = (1000 + 0 + 500 + 500) / 4 = 2000 / 4 = 500
      #L Valor inicial do no: u = 0
      mut as int64: u = 0
      #L Parametro de sobre-relaxacao omega = 1.25 (escala 100 -> 125)
      mut as int64: omega = 125
      mut as int64: iter = 1

      println("1. Iteracoes SOR com fator de aceleracao omega = 1.25:")
      println("   -> Valor inicial u^(0) = " + u)

      infinite (iter <= 6) {
            #L Residuo de Gauss-Seidel: r = (u_vizinhos - 4*u) / 4 = 500 - u
            mut as int64: r = 500 - u
            #L Atualizacao SOR: u^{k+1} = u^k + omega * r
            mut as int64: delta = (omega * r) /i 100
            u = u + delta
            println("   -> Iteracao " + iter + ": u = " + u + " (residuo local: " + (500 - u) + ")")
            iter = iter + 1
      }

      #L Convergencia: u deve ter convergido para 500
      mut as int64: residuo_final = 500 - u
      route {
            residuo_final < 0 ==> { residuo_final = 0 - residuo_final }
            residuo_final >= 0 ==> {}
      }

      println("2. Verificacao de convergencia do metodo SOR:")
      println("   -> u final = " + u + " (alvo analitico: 500)")
      println("   -> Residuo final = " + residuo_final + " (tolerancia <= 1)")

      mut as int64: residuo = 0
      route {
            residuo_final <= 1 ==> { residuo = 0 }
            residuo_final > 1 ==> { residuo = residuo_final }
      }

      println("3. Residuo da solucao SOR = " + residuo + " (esperado: 0)")
      println("4. Algoritmo SOR concluido com sucesso.")
}
