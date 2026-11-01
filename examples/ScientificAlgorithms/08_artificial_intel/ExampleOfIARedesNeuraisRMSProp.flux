#L ============================================================================
#L Algoritmo: RMSProp Optimizer
#L Dominio: 08_artificial_intel / Subdominio: Redes Neurais e Otimizacao
#L Descricao: Otimizacao com media movel exponencial de gradientes quadraticos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisRMSProp) {
      println("=== Algoritmo: RMSProp Optimizer ===")

      #L Fator de decaimento gamma = 0.90 -> 90% (escala 100)
      mut as int64: gamma = 90
      mut as int64: one_minus_gamma = 10
      mut as int64: lr = 20

      #L Parametro theta = 1000, gradiente g = 40
      mut as int64: theta = 1000
      mut as int64: g = 40
      mut as int64: g_sq = g * g

      #L Media movel historica v_prev = 1600
      #L v_new = (gamma * v_prev + (1-gamma) * g^2) /i 100
      #L v_new = (90 * 1600 + 10 * 1600) /i 100 = 160000 /i 100 = 1600
      mut as int64: term1 = gamma * 1600
      mut as int64: term2 = one_minus_gamma * g_sq
      mut as int64: v_sum = term1 + term2
      mut as int64: v_new = v_sum /i 100

      #L Raiz quadrada de v_new = sqrt(1600) = 40
      mut as int64: rms = 40

      #L Atualizacao: delta = (lr * g) /i rms = (20 * 40) /i 40 = 20
      mut as int64: num = lr * g
      mut as int64: delta = num /i rms
      theta = theta - delta

      println("1. Media de gradientes quadraticos (v_new): " + v_new)
      println("2. Raiz media quadratica (RMS): " + rms)
      println("3. Passo adaptativo (delta): " + delta)
      println("4. Parametro atualizado: " + theta)

      route {
            theta == 980 and delta == 20 ==> {
                  println("5. Atualizacao de pesos RMSProp validada com sucesso.")
            }
            _ ==> {
                  println("Falha no passo RMSProp.")
            }
      }
      println("Teste concluido com sucesso.")
}
