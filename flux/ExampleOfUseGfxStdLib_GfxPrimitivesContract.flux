#L Exemplo de Uso: GfxPrimitivesContract (Primitivas Graficas 2D e Renderizacao Imediata)
use GfxStdLib as Gfx

program (ExampleOfUseGfxStdLib_GfxPrimitivesContract) {
      println("==================================================")
      println("  Exemplo: GfxPrimitivesContract                  ")
      println("==================================================")

      mut as map: ctx = gfxInitContext(1024, 768, "2D Primitives Demo")
      mut as list of int64: white = colorWhite()
      mut as list of int64: red = colorRed()
      mut as list of int64: green = colorGreen()
      mut as list of int64: blue = colorBlue()

      mut as list of int64: yellow = colorYellow()

      #L 1. Limpeza de Fundo
      ctx = gfxClearBackground(ctx, colorBlack())
      println("1. Apos ClearBackground - Draw Calls: " + gfxContextDrawCalls(ctx))

      #L 2. Desenho de Retangulos (Preenchido e Linhas)
      ctx = gfxDrawRect(ctx, 50.0, 50.0, 200.0, 100.0, red)
      ctx = gfxDrawRectLines(ctx, 60.0, 60.0, 180.0, 80.0, white)
      println("2. Apos desenhar retangulos - Draw Calls: " + gfxContextDrawCalls(ctx))

      #L 3. Desenho de Circulos
      ctx = gfxDrawCircle(ctx, 400.0, 200.0, 50.0, green)
      ctx = gfxDrawCircleLines(ctx, 400.0, 200.0, 60.0, white)
      println("3. Apos desenhar circulos - Draw Calls: " + gfxContextDrawCalls(ctx))

      #L 4. Desenho de Linhas e Triangulos
      ctx = gfxDrawLine(ctx, 10.0, 10.0, 300.0, 300.0, blue)
      ctx = gfxDrawTriangle(ctx, 500.0, 100.0, 450.0, 200.0, 550.0, 200.0, yellow)
      println("4. Apos linhas e triangulos - Draw Calls: " + gfxContextDrawCalls(ctx))

      #L 5. Renderizacao de Texto
      ctx = gfxDrawText(ctx, "TheFlux Graphics Engine v1.0", 50.0, 400.0, 24, white)
      println("5. Total Final de Draw Calls no Frame: " + gfxContextDrawCalls(ctx))

      #L 6. Reset de Draw Calls para o proximo frame
      ctx = gfxContextResetDrawCalls(ctx)
      println("6. Draw Calls apos reset: " + gfxContextDrawCalls(ctx))
}
