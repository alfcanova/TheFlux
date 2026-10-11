#L ============================================================================
#L Algoritmo: Stochastic Gradient Descent (SGD com Amostras Individuais)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Epocas * N) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoSGD) {
      println("==================================================")
      println("  SciAlgo: Stochastic Gradient Descent (SGD)")
      println("==================================================")

      #L Regressao 1D: y = 3 * x. Amostras: (1, 3), (2, 6), (3, 9)
      mut as int64: w = 10 #L inicial w = 1.0 (escala x10)
      mut as list of int64: x_data = [1, 2, 3]
      mut as list of int64: y_data = [3, 6, 9]

      println("1. Parametro inicial w = 1.0 (alvo: 3.0)")
      mut as int64: epoch = 1
      infinite (epoch <= 5) {
            mut as int64: i = 1
            infinite (i <= 3) {
                  mut as int64: pred = (w * x_data[i]) /i 10
                  mut as int64: err = pred - y_data[i]
                  mut as int64: grad = err * x_data[i] #L d(MSE)/dw
                  w = w - (grad * 2) #L passo com lr
                  i = i + 1
            }
            epoch = epoch + 1
      }
      println("2. Parametro final w = " + w + " / 10")

      route {
            w >= 28 and w <= 32 ==> {
                  println("   [PASS] SGD convergiu no peso otimo com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no SGD.")
            }
      }

      println("==================================================")
      println("SGD concluido com sucesso!")
}
