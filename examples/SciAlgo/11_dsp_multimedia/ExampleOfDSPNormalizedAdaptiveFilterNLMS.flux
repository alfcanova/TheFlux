#L ============================================================================
#L Algoritmo: Filtro Adaptativo NLMS Normalizado (Normalized Least Mean Squares)
#L Dominio: 11_dsp_multimedia / Categoria: Filtragem Adaptativa
#L Descricao: Normalizacao de passo pela energia instantanea para convergencia estavel
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPNormalizedAdaptiveFilterNLMS) {
      println("=== Algoritmo: Filtro Adaptativo NLMS Normalizado ===")

      #L Peso adaptativo inicial w = 0, alvo w* = 400
      #L Fator de escala mu_norm = 500 (0.50 em escala x1000)
      #L Regularizador epsilon = 10 para evitar divisao por zero
      mut as int64: w = 0
      mut as int64: mu_norm = 500
      mut as int64: epsilon = 10

      println("Parametros NLMS: mu_normalizado = " + mu_norm + "/1000, epsilon = " + epsilon)

      #L Iteracao 1 com sinal de entrada de alta potencia x = 2000
      #L Energia do sinal ||x||^2 = (2000 * 2000) / 1000 = 4000 (em escala)
      #L Saida desejada d = 800
      #L y1 = (w * x) / 1000 = 0
      #L e1 = d - y1 = 800 - 0 = 800
      mut as int64: x1 = 2000
      mut as int64: d1 = 800
      mut as int64: y1 = (w * x1) /i 1000
      mut as int64: e1 = d1 - y1

      #L Denominador de energia normalizada:
      #L denom = (x1 * x1) / 1000 + epsilon = 4000 + 10 = 4010
      #L Passo normalizado: dw = (mu_norm * e1 * x1) / (denom * 1000)
      #L dw = (500 * 800 * 2000) / (4010 * 1000) = 800000000 / 4010000 = 199
      mut as int64: energy_term = (x1 * x1) /i 1000
      mut as int64: denom1 = energy_term + epsilon
      mut as int64: num_dw = (mu_norm * e1) /i 1000
      mut as int64: dw1 = (num_dw * x1) /i denom1
      w = w + dw1

      println("Iteracao 1 (Entrada de Alta Energia):")
      println("  Erro e1 = " + e1)
      println("  Ajuste normalizado dw1 = " + dw1)
      println("  Novo peso w = " + w)

      #L Iteracao 2:
      mut as int64: y2 = (w * x1) /i 1000
      mut as int64: e2 = d1 - y2
      println("Iteracao 2: Novo erro residual e2 = " + e2)

      route {
            e2 < e1 and w > 0 ==> {
                  println("Normalizacao NLMS estavel: Passo controlado independente da alta energia da entrada!")
            }
            _ ==> {
                  println("Instabilidade NLMS")
            }
      }

      println("Normalized Adaptive Filter NLMS concluido com sucesso.")
}
