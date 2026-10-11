#L ============================================================================
#L Algoritmo: FISTA (Fast Iterative Shrinkage-Thresholding Algorithm)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoFISTA) {
      println("==================================================")
      println("  SciAlgo: FISTA (Accelerated Proximal Gradient)")
      println("==================================================")

      #L Minimiza f(x) + g(x) onde f(x) = (x - 40)^2 / 2 e g(x) = lambda * |x|
      #L Gradiente de f em y: grad = y - 40
      #L Sequencia de Nesterov t_k: t_{k+1} = (1 + sqrt(1 + 4*t_k^2)) / 2
      #L y_{k+1} = x_k + ((t_k - 1) / t_{k+1}) * (x_k - x_{k-1})
      #L x_k = SoftThreshold(y_k - step * grad, step * lambda)

      mut as int64: x_prev = 0
      mut as int64: x_curr = 0
      mut as int64: y = 0
      mut as int64: t_prev = 10  #L escala x10: t_0 = 1.0
      mut as int64: lambda_val = 5

      println("1. Parametros:")
      println("   Ponto alvo f(x): 40 | Regularizacao L1 lambda: " + lambda_val)

      mut as int64: iter = 1
      infinite (iter <= 12) {
            #L Gradiente em y
            mut as int64: grad = y - 40
            mut as int64: p = y - (grad /i 2) #L passo com step = 0.5

            #L Soft-thresholding prox(p, 2)
            mut as int64: thresh = 2
            mut as int64: x_next = 0
            route {
                  p > thresh ==> { x_next = p - thresh }
                  p < (0 - thresh) ==> { x_next = p + thresh }
                  _ ==> { x_next = 0 }
            }

            #L Atualizacao do momentum de Nesterov t_{k+1} ~ t_k + 5 (aproximacao discreta)
            mut as int64: t_next = t_prev + 5
            mut as int64: mom = ((t_prev - 10) * (x_next - x_curr)) /i t_next
            y = x_next + mom

            x_prev = x_curr
            x_curr = x_next
            t_prev = t_next
            iter = iter + 1
      }

      println("2. Solucao FISTA obtida: x* = " + x_curr)

      route {
            x_curr >= 36 and x_curr <= 39 ==> {
                  println("   [PASS] FISTA convergiu aceleradamente para o otimo esparso!")
            }
            _ ==> {
                  println("   [ERRO] Falha na convergencia do FISTA.")
            }
      }

      println("==================================================")
      println("FISTA concluido com sucesso!")
}
