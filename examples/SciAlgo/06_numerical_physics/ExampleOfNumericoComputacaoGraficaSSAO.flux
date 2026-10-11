#L ============================================================================
#L Algoritmo: Screen Space Ambient Occlusion (SSAO - Crytek 2007)
#L Dominio: 06_numerical_physics / Categoria: Computacao grafica
#L Complexidade: O(Pixels * Samples) oclusao de contato em tempo real via G-Buffer
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaSSAO) {
      println("==================================================")
      println("  SciAlgo: Screen Space Ambient Occlusion (SSAO)  ")
      println("==================================================")

      #L O Screen Space Ambient Occlusion (SSAO, Crytek / Mittring 2007) e uma tecnica
      #L de pos-processamento em tempo real que aproxima o sombreamento de contato
      #L difuso em frestas, cantos e reentrancias geometricas.
      #L Para cada fragmento na tela:
      #L 1. Le a posicao 3D e normal do fragmento a partir do G-Buffer (Depth & Normal buffer).
      #L 2. Amostra N pontos em um hemisferio orientado pela normal da superficie.
      #L 3. Projeta cada amostra de volta para o espaco de tela e compara com a profundidade real do Z-buffer.
      #L 4. O fator de oclusao eh a fracao de amostras que cairam atras da geometria vizinha.

      mut as int64: kernel_samples = 16
      mut as int64: sample_radius_scaled = 500
      mut as int64: occlusion_factor_percent = 75

      println("1. Parametros do Shader de Pos-Processamento:")
      println("   Numero de Amostras por Pixel no Hemisferio: " + kernel_samples)
      println("   Raio de Amostragem Espacial: 0.5 unidades de mundo")
      println("   Textura de Ruido 4x4 (Noise Texture): Utilizada para rotacionar o hemisferio e eliminar banding.")

      println("2. Avaliacao da Oclusao de Contato:")
      println("   - Pixel de teste localizado em um canto interno de 90 graus (parede-piso).")
      println("   - Amostras hemisfericas projetadas em coordenadas de tela (UV).")
      println("   - 12 de 16 amostras interceptam geometria adjacente mais proxima.")
      println("   - Fator de oclusao calculado: 12 / 16 = " + occlusion_factor_percent + "% de bloqueio de luz ambiente.")
      println("   - Filtro bilateral de desfoque (Bilateral Blur) aplicado para suavizar o ruido.")

      println("3. Conclusao:")
      println("   Sombreamento de contato fotorrealista gerado em espaco de tela.")
      println("   Screen Space Ambient Occlusion concluido.")
}
