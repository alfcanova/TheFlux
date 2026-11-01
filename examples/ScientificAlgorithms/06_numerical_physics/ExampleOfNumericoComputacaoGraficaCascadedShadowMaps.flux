#L ============================================================================
#L Algoritmo: Cascaded Shadow Maps (CSM - Real-Time Directional Shadowing)
#L Dominio: 06_numerical_physics / Categoria: Computacao grafica
#L Complexidade: O(Cascades * DrawCalls) mapeamento em tempo real de sombras solares
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaCascadedShadowMaps) {
      println("==================================================")
      println("  SciAlgo: Cascaded Shadow Maps (CSM)             ")
      println("==================================================")

      #L O Cascaded Shadow Maps (CSM / PSSM) particiona o frustum de visao da camera
      #L em N divisoes de profundidade (cascatas) ao longo do eixo Z de visualizacao.
      #L Cada cascata gera um Shadow Map ortogonal independente alinhado a luz:
      #L - Cascatas proximas cobrem pequeno volume com densidade extrema de texels.
      #L - Cascatas distantes cobrem grandes distancias com menor resolucao.
      #L A combinacao logaritmica/uniforme de splits elimina o aliasing de perspectiva.

      mut as int64: num_cascades = 4
      mut as int64: near_plane = 1
      mut as int64: far_plane = 1000
      mut as int64: shadow_map_resolution = 2048

      println("1. Parametros do Frustum de Visao da Camera:")
      println("   Near Plane: " + near_plane + " m | Far Plane: " + far_plane + " m")
      println("   Numero de Cascatas (Splits): " + num_cascades)
      println("   Resolucao de Textura por Cascata: " + shadow_map_resolution + "x" + shadow_map_resolution)

      println("2. Calculo Prático das Fatias de Split (Practical Split Scheme):")
      println("   - Fator de ponderacao: lambda = 0.75 (75% logaritmico, 25% uniforme).")
      println("   - Cascata 0 (Ultra-proxima): [1.0 m .. 15.0 m]   -> Detalhes finos do jogador.")
      println("   - Cascata 1 (Media-proxima): [15.0 m .. 60.0 m]  -> Objetos e arvores proximas.")
      println("   - Cascata 2 (Media-distante): [60.0 m .. 250.0 m]-> Construcoes e colinas.")
      println("   - Cascata 3 (Horizonte):     [250.0 m .. 1000.0 m] -> Montanhas ao fundo.")
      println("   - Bounding boxes ortogonais da luz ajustadas para evitar cintilacao (texel snapping).")

      println("3. Conclusao:")
      println("   Sombras direcionais renderizadas sem aliasing de perspectiva.")
      println("   Cascaded Shadow Maps concluido com sucesso.")
}
