#L ============================================================================
#L Algoritmo: Batch Normalization
#L Dominio: 08_artificial_intel / Subdominio: Redes Neurais e Regularizacao
#L Descricao: Normalizacao de ativacoes por mini-batch com escala gamma e translacao beta
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisBatchNormalization) {
      println("=== Algoritmo: Batch Normalization ===")

      #L Mini-batch de 4 amostras para uma feature: x = [10, 20, 30, 40]
      mut as int64: x1 = 10
      mut as int64: x2 = 20
      mut as int64: x3 = 30
      mut as int64: x4 = 40

      #L Media do batch: mu = (10 + 20 + 30 + 40) /i 4 = 100 /i 4 = 25
      mut as int64: sum_x = x1 + x2 + x3 + x4
      mut as int64: mu = sum_x /i 4

      #L Variancia do batch:
      #L d1 = 10 - 25 = -15 -> 225
      #L d2 = 20 - 25 = -5  -> 25
      #L d3 = 30 - 25 = 5   -> 25
      #L d4 = 40 - 25 = 15  -> 225
      mut as int64: d1 = x1 - mu
      mut as int64: d2 = x2 - mu
      mut as int64: d3 = x3 - mu
      mut as int64: d4 = x4 - mu
      mut as int64: sum_sq = d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4
      mut as int64: var = sum_sq /i 4

      #L Desvio padrao aproximado: sqrt(125) ~ 11
      mut as int64: std_dev = 11

      println("1. Media do batch (mu): " + mu)
      println("2. Variancia do batch (sigma^2): " + var)
      println("3. Desvio padrao aproximado: " + std_dev)

      #L Normalizacao x_hat (escalada por 100):
      #L x_hat_4 = (15 * 100) /i 11 = 1500 /i 11 = 136
      mut as int64: num_hat4 = d4 * 100
      mut as int64: x_hat4 = num_hat4 /i std_dev

      #L Escala e translacao: gamma = 2, beta = 50
      #L y4 = (gamma * x_hat4) /i 100 + beta = (2 * 136) /i 100 + 50 = 2 + 50 = 52
      mut as int64: scaled = 2 * x_hat4
      mut as int64: scaled_div = scaled /i 100
      mut as int64: y4 = scaled_div + 50

      println("4. Ativacao normalizada x_hat_4: " + x_hat4)
      println("5. Saida transformada y4 (gamma * x_hat + beta): " + y4)

      route {
            mu == 25 and var == 125 and y4 == 52 ==> {
                  println("6. Transformacao Batch Normalization validada com sucesso.")
            }
            _ ==> {
                  println("Falha na normalizacao.")
            }
      }
      println("Teste concluido com sucesso.")
}
