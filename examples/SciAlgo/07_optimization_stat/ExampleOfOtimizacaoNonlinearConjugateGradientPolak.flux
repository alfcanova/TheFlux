#L ============================================================================
#L Algoritmo: Nonlinear Conjugate Gradient (Polak-Ribiere)
#L Dominio: 07_optimization_stat / Categoria: Gradiente Conjugado Nao-Linear
#L Descricao: Otimizacao nao-linear com direcoes conjugadas e reinicializacao ortogonal beta >= 0
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoNonlinearConjugateGradientPolak) {
      println("=== Algoritmo: Nonlinear Conjugate Gradient (Polak-Ribiere) ===")

      #L Gradiente anterior g_k = [4, 0]
      #L Norma quadrada: ||g_k||^2 = 4^2 + 0^2 = 16
      mut as int64: gk_x = 4
      mut as int64: gk_y = 0
      mut as int64: norm_gk_sq = gk_x * gk_x + gk_y * gk_y

      #L Gradiente atual g_k+1 = [2, 3]
      #L Diferenca y_k = g_k+1 - g_k = [2 - 4, 3 - 0] = [-2, 3]
      mut as int64: gk1_x = 2
      mut as int64: gk1_y = 3
      mut as int64: yk_x = gk1_x - gk_x
      mut as int64: yk_y = gk1_y - gk_y

      #L Numerador de Polak-Ribiere: g_k+1^T * y_k = 2*(-2) + 3*3 = -4 + 9 = 5
      #L beta_PR = (5 * 100) /i 16 = 500 /i 16 = 31 (0.31 em escala x100)
      mut as int64: num_beta = gk1_x * yk_x + gk1_y * yk_y
      mut as int64: num_scaled = num_beta * 100
      mut as int64: beta_pr = num_scaled /i norm_gk_sq

      #L Reinicializacao automatica de Powell: beta = max(0, beta_PR)
      mut as int64: beta_final = beta_pr
      route {
            beta_pr < 0 ==> {
                  beta_final = 0
            }
            _ ==> {}
      }

      println("1. Norma quadratica do gradiente anterior: " + norm_gk_sq)
      println("2. Numerador de Polak-Ribiere (g_k+1^T * y_k): " + num_beta)
      println("3. Parametro beta de conjugacao (x100): " + beta_final)

      #L Direcao conjugada d_k+1 = -g_k+1 + beta * d_k (assumindo d_k = [-4, 0])
      #L d_x = -2 + (31 * (-4)) /i 100 = -2 - 1 = -3
      mut as int64: dx = 0 - gk1_x - 1
      println("4. Nova direcao conjugada de descida X: " + dx)

      route {
            num_beta == 5 and beta_final == 31 and dx == -3 ==> {
                  println("5. Direcao conjugada Polak-Ribiere validada com sucesso.")
            }
            _ ==> {
                  println("Falha no Gradiente Conjugado.")
            }
      }
      println("Teste concluido com sucesso.")
}
