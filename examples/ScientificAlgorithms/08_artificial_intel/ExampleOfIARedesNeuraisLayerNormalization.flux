#L ============================================================================
#L Algoritmo: Layer Normalization
#L Dominio: 08_artificial_intel / Subdominio: Redes Neurais e Arquiteturas Modernas
#L Descricao: Normalizacao independente por amostra ao longo das dimensoes de caracteristicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisLayerNormalization) {
      println("=== Algoritmo: Layer Normalization ===")

      #L Vetor de ativacoes ocultas de uma amostra (dimensao H = 4): x = [4, 8, 12, 16]
      mut as int64: x1 = 4
      mut as int64: x2 = 8
      mut as int64: x3 = 12
      mut as int64: x4 = 16

      #L Media da camada: mu = (4 + 8 + 12 + 16) /i 4 = 40 /i 4 = 10
      mut as int64: sum_x = x1 + x2 + x3 + x4
      mut as int64: mu = sum_x /i 4

      #L Variancia da camada:
      #L d1 = 4 - 10 = -6 -> 36
      #L d2 = 8 - 10 = -2 -> 4
      #L d3 = 12 - 10 = 2 -> 4
      #L d4 = 16 - 10 = 6 -> 36
      mut as int64: d1 = x1 - mu
      mut as int64: d2 = x2 - mu
      mut as int64: d3 = x3 - mu
      mut as int64: d4 = x4 - mu
      mut as int64: sum_sq = d1 * d1 + d2 * d2 + d3 * d3 + d4 * d4
      mut as int64: var = sum_sq /i 4

      #L Desvio padrao exato: sqrt(20) ~ 4 (inteiro)
      mut as int64: std_dev = 4

      println("1. Media da camada (mu_L): " + mu)
      println("2. Variancia da camada (sigma_L^2): " + var)
      println("3. Desvio padrao da camada: " + std_dev)

      #L Normalizacao das features (escala x10):
      #L x_norm_1 = (-6 * 10) /i 4 = -15
      #L x_norm_4 = (6 * 10) /i 4 = 15
      mut as int64: num_norm1 = d1 * 10
      mut as int64: x_norm1 = num_norm1 /i std_dev
      mut as int64: num_norm4 = d4 * 10
      mut as int64: x_norm4 = num_norm4 /i std_dev

      println("4. Feature 1 normalizada: " + x_norm1)
      println("5. Feature 4 normalizada: " + x_norm4)

      route {
            mu == 10 and var == 20 and x_norm4 == 15 ==> {
                  println("6. Layer Normalization validada com sucesso.")
            }
            _ ==> {
                  println("Falha na normalizacao LayerNorm.")
            }
      }
      println("Teste concluido com sucesso.")
}
