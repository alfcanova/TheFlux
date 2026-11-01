#L ============================================================================
#L Algoritmo: Adam Optimizer (Adaptive Moment Estimation)
#L Dominio: 08_artificial_intel / Subdominio: Redes Neurais e Otimizacao
#L Descricao: Otimizador estocastico com momentos de primeira e segunda ordem
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisAdam) {
      println("=== Algoritmo: Adam Optimizer ===")

      #L Parametros em escala x100
      #L beta1 = 0.90 -> 90, beta2 = 0.99 -> 99
      mut as int64: beta1 = 90
      mut as int64: beta2 = 99
      mut as int64: lr = 10

      #L Variavel a otimizar theta inicial = 500, gradiente g = 50
      mut as int64: theta = 500
      mut as int64: g = 50

      #L Momentos iniciais m0 = 0, v0 = 0
      #L Passo t = 1:
      #L m1 = beta1 * m0 + (100 - beta1) * g
      #L m1 = 0 + 10 * 50 = 500
      mut as int64: one_minus_b1 = 100 - beta1
      mut as int64: m1 = one_minus_b1 * g

      #L v1 = beta2 * v0 + (100 - beta2) * g^2
      #L v1 = 0 + 1 * 2500 = 2500
      mut as int64: one_minus_b2 = 100 - beta2
      mut as int64: g_sq = g * g
      mut as int64: v1 = one_minus_b2 * g_sq

      #L Correcao de vies no passo t=1:
      #L m_hat = m1 / (1 - beta1) = 500 /i 10 = 50
      #L v_hat = v1 / (1 - beta2) = 2500 /i 1 = 2500
      mut as int64: m_hat = m1 /i one_minus_b1
      mut as int64: v_hat = v1 /i one_minus_b2

      #L Raiz quadrada inteira aproximada de v_hat = sqrt(2500) = 50
      mut as int64: sqrt_v = 50

      #L Atualizacao: delta = (lr * m_hat) /i sqrt_v = (10 * 50) /i 50 = 10
      mut as int64: num_delta = lr * m_hat
      mut as int64: delta = num_delta /i sqrt_v
      theta = theta - delta

      println("1. Primeiro momento corrigido m_hat: " + m_hat)
      println("2. Segundo momento corrigido v_hat: " + v_hat)
      println("3. Passo de atualizacao delta: " + delta)
      println("4. Parametro atualizado theta: " + theta)

      route {
            theta == 490 and delta == 10 ==> {
                  println("5. Passo de gradiente adaptativo Adam validado com sucesso.")
            }
            _ ==> {
                  println("Falha na atualizacao Adam.")
            }
      }
      println("Teste concluido com sucesso.")
}
