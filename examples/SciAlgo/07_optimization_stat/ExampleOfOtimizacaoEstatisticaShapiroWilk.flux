#L ============================================================================
#L Algoritmo: Shapiro-Wilk Test (Teste de Normalidade de Shapiro-Wilk)
#L Dominio: 07_optimization_stat / Categoria: Estatistica
#L Complexidade: Tempo O(n log n) | Espaco O(n)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaShapiroWilk) {
      println("==================================================")
      println("  SciAlgo: Shapiro-Wilk Normality Test")
      println("==================================================")

      #L O teste de Shapiro-Wilk e o padrao-ouro para testar normalidade:
      #L Estatistica W = (sum a_i * x_{(i)})^2 / sum (x_i - media)^2
      #L Amostra normal ordenada (n = 5): [10, 14, 15, 16, 20]
      #L Media = (10 + 14 + 15 + 16 + 20) / 5 = 15
      #L Variancia total sum(x_i - 15)^2:
      #L (-5)^2 + (-1)^2 + 0^2 + 1^2 + 5^2 = 25 + 1 + 0 + 1 + 25 = 52
      #L Pesos tabulados a_i para n = 5 (escala x100):
      #L a_5 = 66, a_4 = 24, a_3 = 0, a_2 = -24, a_1 = -66
      #L Numerador b = sum a_i * x_{(i)} = 0.66*(20 - 10) + 0.24*(16 - 14)
      #L b = 0.66 * 10 + 0.24 * 2 = 6.60 + 0.48 = 7.08
      #L b^2 = 7.08^2 = 50.126
      #L W = b^2 / 52 = 50.126 / 52 = 0.964 (escala x1000 = 964)

      mut as int64: sum_sq_dev = 52 #L denominador sum(x_i - media)^2
      #L Numerador escalado x100: b = 66*10 + 24*2 = 660 + 48 = 708
      mut as int64: b_scaled = (66 * 10) + (24 * 2) #L 708

      #L b^2 escalonado x10000: 708 * 708 = 501264
      mut as int64: b_squared = b_scaled * b_scaled

      #L Estatistica W escalonada x1000:
      #L W_1000 = (b^2 / 10000) / 52 * 1000 = b_squared / (52 * 10) = 501264 / 520 = 963
      mut as int64: w_stat_1000 = b_squared /i (sum_sq_dev * 10)

      println("1. Dados da amostra (n = 5):")
      println("   Media = 15 | Soma dos quadrados dos desvios SS = " + sum_sq_dev)
      println("   Combinacao linear ponderada b = " + b_scaled + " / 100")

      println("2. Estatistica de Shapiro-Wilk calculada:")
      println("   W = " + w_stat_1000 + " / 1000 (0.963)")

      route {
            w_stat_1000 >= 950 and w_stat_1000 <= 999 ==> {
                  println("   [PASS] Estatistica W proxima de 1.0 confirma distribuicao normal!")
            }
            _ ==> {
                  println("   [ERRO] Falha no teste de Shapiro-Wilk.")
            }
      }

      println("==================================================")
      println("Shapiro-Wilk Test concluido com sucesso!")
}
