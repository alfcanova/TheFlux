#L ============================================================================
#L Algoritmo: Dynamic Range Compressor & Limiter (Processamento de Dinamica)
#L Dominio: 11_dsp_multimedia / Categoria: Efeitos e Masterizacao de Audio
#L Descricao: Reducao de ganho adaptativa baseada em limiar, razao e envelope peak
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPDynamicRangeCompressor) {
      println("=== Algoritmo: Dynamic Range Compressor & Limiter ===")

      #L Parametros do compressor:
      #L Limiar (Threshold) = 600 (escala linear 0 a 1000)
      #L Razao de compressao (Ratio) = 2:1 (qualquer excesso acima de 600 eh comprimido a metade)
      mut as int64: threshold = 600
      mut as int64: ratio = 2

      println("Configuracao: Limiar = " + threshold + ", Razao de Compressao = " + ratio + ":1")

      #L Sinal de entrada com 3 picos de amplitudes variadas:
      #L Amostra 1: x1 = 400 (Abaixo do limiar -> Sem compressao, ganho 1:1)
      #L Amostra 2: x2 = 800 (Excesso de 200 acima do limiar -> Reducao de ganho)
      #L Amostra 3: x3 = 1000 (Excesso de 400 -> Compressao acentuada)
      mut as int64: x1 = 400
      mut as int64: x2 = 800
      mut as int64: x3 = 1000

      #L Amostra 1 (x1 = 400 <= threshold):
      #L Saida y1 = x1 = 400
      mut as int64: y1 = x1

      #L Amostra 2 (x2 = 800 > threshold):
      #L excesso = 800 - 600 = 200
      #L excesso_comprimido = 200 / 2 = 100
      #L Saida y2 = threshold + excesso_comprimido = 600 + 100 = 700
      mut as int64: excess_2 = x2 - threshold
      mut as int64: comp_excess_2 = excess_2 /i ratio
      mut as int64: y2 = threshold + comp_excess_2

      #L Amostra 3 (x3 = 1000 > threshold):
      #L excesso = 1000 - 600 = 400
      #L excesso_comprimido = 400 / 2 = 200
      #L Saida y3 = 600 + 200 = 800
      mut as int64: excess_3 = x3 - threshold
      mut as int64: comp_excess_3 = excess_3 /i ratio
      mut as int64: y3 = threshold + comp_excess_3

      println("Processamento de Dinamica:")
      println("  Entrada x1 = " + x1 + " -> Saida y1 = " + y1 + " (Ganho 1.0, transparente)")
      println("  Entrada x2 = " + x2 + " -> Saida y2 = " + y2 + " (Atenuacao de pico)")
      println("  Entrada x3 = " + x3 + " -> Saida y3 = " + y3 + " (Contencao dinamica)")

      #L Reducao de Ganho (Gain Reduction GR):
      mut as int64: gr_sample_3 = x3 - y3
      println("Reducao de ganho aplicada no transiente mais forte: -" + gr_sample_3)

      route {
            y1 == 400 and y2 == 700 and y3 == 800 ==> {
                  println("Compressao de faixa dinamica estavel com controle de transientes perfeito!")
            }
            _ ==> {
                  println("Erro na reducao de dinamica")
            }
      }

      println("Dynamic Range Compressor concluido com sucesso.")
}
