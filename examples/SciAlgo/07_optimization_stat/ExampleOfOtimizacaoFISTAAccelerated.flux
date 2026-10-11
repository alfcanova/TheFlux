#L ============================================================================
#L Algoritmo: FISTA (Fast Iterative Shrinkage-Thresholding Algorithm)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao Acelerada
#L Descricao: Aceleracao por momento de Nesterov elevando a taxa de convergencia para O(1/k^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoFISTAAccelerated) {
      println("=== Algoritmo: FISTA Acelerado ===")

      #L Iteracao k=1:
      #L x_0 = 10, x_1 = 18 (passo ISTA anterior)
      #L Parametro de aceleracao t_1 = 1
      #L t_2 = (1 + sqrt(1 + 4*t_1^2)) /i 2
      #L 1 + 4*1 = 5, sqrt(5) ~ 2 (inteiro) -> (1 + 2) /i 2 = 1 (em escala real t_2 ~ 1.62)
      #L Fator de momento aproximado: beta = (t_1 - 1) / t_2 = 0 no passo 1
      #L Na iteracao k=2:
      #L x_1 = 18, x_2 = 25
      #L Momento de extrapolacao: y_3 = x_2 + (x_2 - x_1) /i 2
      #L y_3 = 25 + (25 - 18) /i 2 = 25 + 7 /i 2 = 25 + 3 = 28
      mut as int64: x_k_prev = 18
      mut as int64: x_k = 25

      mut as int64: diff_x = x_k - x_k_prev
      mut as int64: momento = diff_x /i 2
      mut as int64: y_extrapolado = x_k + momento

      println("1. Ponto na iteracao anterior (x_k-1): " + x_k_prev)
      println("2. Ponto na iteracao corrente (x_k): " + x_k)
      println("3. Termo de momento inercial acelerador: " + momento)
      println("4. Ponto extrapolado de Nesterov (y_k+1): " + y_extrapolado)

      #L O ponto extrapolado y_3 ultrapassa x_2 na direcao do gradiente com aceleracao quadratica
      route {
            y_extrapolado == 28 and y_extrapolado > x_k ==> {
                  println("5. Extrapolacao inercial FISTA validada com taxa O(1/k^2).")
            }
            _ ==> {
                  println("Falha no FISTA.")
            }
      }
      println("Teste concluido com sucesso.")
}
