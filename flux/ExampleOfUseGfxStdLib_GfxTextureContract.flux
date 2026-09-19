#L Exemplo de Uso: GfxTextureContract (Criacao e Renderizacao de Texturas e Sprites)
use GfxStdLib as Gfx

program (ExampleOfUseGfxStdLib_GfxTextureContract) {
      println("==================================================")
      println("  Exemplo: GfxTextureContract                     ")
      println("==================================================")

      mut as map: ctx = gfxInitContext(800, 600, "Texture Demo")

      #L 1. Criacao e Metadados de Textura
      mut as map: tex = gfxTextureNew(256, 256)
      println("1. Metadados da Textura:")
      println("   Largura: " + gfxTextureGetWidth(tex))
      println("   Altura: " + gfxTextureGetHeight(tex))
      println("   Loaded: " + gfxTextureIsLoaded(tex))

      #L 2. Renderizacao Basica da Textura
      ctx = gfxDrawTexture(ctx, tex, 100.0, 150.0)
      println("2. Apos desenhar textura simples - Draw Calls: " + gfxContextDrawCalls(ctx))

      #L 3. Renderizacao Avancada Pro (Sub-retangulo e Rotacao de Sprite)
      #L Fonte: recorte (0, 0, 64, 64). Destino: (200, 200, 128, 128), Rotacao: 45 graus
      ctx = gfxDrawTexturePro(ctx, tex, 0.0, 0.0, 64.0, 64.0, 200.0, 200.0, 128.0, 128.0, 45.0)
      println("3. Apos drawTexturePro - Total Draw Calls: " + gfxContextDrawCalls(ctx))
}
