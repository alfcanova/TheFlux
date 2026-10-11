#L ============================================================================
#L Algoritmo: STFT — Short-Time Fourier Transform (Espectrograma Temporal)
#L Dominio: 11_dsp_multimedia / Categoria: Analise Tempo-Frequencia
#L Descricao: Transformada de Fourier de tempo curto com janelas deslizantes sobrepostas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfDSPShortTimeFourierTransformSTFT) {
      println("=== Algoritmo: Short-Time Fourier Transform (STFT) ===")

      #L Sinal de áudio discreto de 6 amostras com mudanca de frequencia no tempo:
      #L Primeiras 3 amostras: componente constante DC (baixa frequencia)
      #L Ultimas 3 amostras: oscilacao rapida alternada (alta frequencia)
      #L x = [10, 10, 10, 20, -20, 20]
      println("Sinal temporal nao-estacionario: [10, 10, 10, 20, -20, 20]")

      #L Parametros de janelamento:
      #L Tamanho do frame (Window Size N = 3)
      #L Avanco entre frames (Hop Size H = 3, sem sobreposicao para demonstracao concisa)
      mut as int64: win_size = 3
      mut as int64: hop_size = 3

      #L Frame 1: Janela retangular sobre amostras [10, 10, 10]
      #L DFT no Frame 1 para bin 0 (DC) e bin 1 (Nyquist alternado):
      #L Bin 0 (Soma / DC): 10 + 10 + 10 = 30
      #L Bin 1 (Diferenca espectral): 10 - 10 + 10 = 10
      mut as int64: frame1_dc = 10 + 10 + 10
      mut as int64: frame1_ac = 10 - 10 + 10

      println("Frame 1 (t = 0..2):")
      println("  Energia em Baixa Frequencia (DC): " + frame1_dc)
      println("  Energia em Alta Frequencia (AC):  " + frame1_ac)

      #L Frame 2: Janela sobre amostras [20, -20, 20]
      #L DFT no Frame 2:
      #L Bin 0 (DC): 20 + (-20) + 20 = 20
      #L Bin 1 (Nyquist alternado com fase): 20 - (-20) + 20 = 20 + 20 + 20 = 60
      mut as int64: frame2_dc = 20 - 20 + 20
      mut as int64: frame2_ac = 20 + 20 + 20

      println("Frame 2 (t = 3..5):")
      println("  Energia em Baixa Frequencia (DC): " + frame2_dc)
      println("  Energia em Alta Frequencia (AC):  " + frame2_ac)

      #L Diagnostico da mudanca de conteudo espectral no tempo:
      #L No Frame 1, DC domina (30 > 10)
      #L No Frame 2, a componente de alta frequencia domina amplamente (60 > 20)
      route {
            frame1_dc > frame1_ac and frame2_ac > frame2_dc ==> {
                  println("Espectrograma STFT detectou com exatidao a transicao dinamica de frequencia no tempo!")
            }
            _ ==> {
                  println("Falha na analise tempo-frequencia")
            }
      }

      println("STFT concluido com sucesso.")
}
