#L Exemplo de Uso: GfxStateContract (Gerenciamento de Contexto, Viewport e Janela)
use GfxStdLib as Gfx

program (ExampleOfUseGfxStdLib_GfxStateContract) {
      println("==================================================")
      println("  Exemplo: GfxStateContract                       ")
      println("==================================================")

      #L 1. Inicializacao do Contexto Grafico
      mut as map: ctx = gfxInitContext(800, 600, "TheFlux Game Engine")
      println("1. Contexto Inicializado:")
      println("   Largura: " + gfxContextWidth(ctx))
      println("   Altura: " + gfxContextHeight(ctx))
      println("   Titulo: " + gfxContextTitle(ctx))
      println("   FPS Inicial: " + gfxContextGetFps(ctx))
      println("   Should Close: " + gfxContextShouldClose(ctx))

      #L 2. Configuracao de Taxa de Quadros (Target FPS)
      ctx = gfxContextSetFps(ctx, 120)
      println("2. Novo Target FPS: " + gfxContextGetFps(ctx))

      #L 3. Contagem de Draw Calls
      println("3. Draw Calls Inicial: " + gfxContextDrawCalls(ctx))

      #L 4. Validacao de Limites da Viewport (Contratos de Seguranca)
      println("4. Validacao de Limites (InBounds):")
      println("   Elemento em (10, 10, 50, 50): " + gfxCheckInBounds(10.0, 10.0, 50.0, 50.0, 800, 600))
      println("   Elemento fora em (780, 580, 50, 50): " + gfxCheckInBounds(780.0, 580.0, 50.0, 50.0, 800, 600))
      println("   Elemento negativo (-5, 10, 20, 20): " + gfxCheckInBounds(0.0 - 5.0, 10.0, 20.0, 20.0, 800, 600))

      #L 5. Fechamento do Contexto
      ctx = gfxCloseContext(ctx)
      println("5. Contexto Apos Fechamento:")
      println("   Should Close: " + gfxContextShouldClose(ctx))
}
