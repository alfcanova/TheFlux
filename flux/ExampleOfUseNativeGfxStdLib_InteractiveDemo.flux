use NativeGfxStdLib
use GfxStdLib
use GuiStdLib

program (ExampleOfUseNativeGfxStdLib_InteractiveDemo) {
      println("==================================================")
      println("  TheFlux NativeGfxStdLib: Interactive Demo")
      println("==================================================")

      #L 1. Inicializacao da Janela Grafica Real
      mut as int64: win = gfxWindowCreate(800, 600, "TheFlux Graphics Demo")
      println("1. Janela nativa criada: " + (win > 0))

      #L 2. Integracao GfxStdLib com NativeGfxStdLib
      mut as map: gctx = gfxInitContext(800, 600, "TheFlux Graphics Demo")
      gctx = gfxBindNativeWindow(gctx, win)
      println("2. Contexto GfxStdLib vinculado a janela: " + (gfxGetNativeWindow(gctx) == win))

      #L 3. Integracao GuiStdLib com NativeGfxStdLib
      mut as map: uictx = guiInitContext(800, 600)
      uictx = guiBindNativeWindow(uictx, win)
      println("3. Contexto GuiStdLib vinculado a janela: " + (guiGetNativeWindow(uictx) == win))

      #L 4. Renderizacao de Fundo e Primitivas
      gctx = gfxClearBackground(gctx, colorBlack())
      gctx = gfxDrawRect(gctx, 50.0, 50.0, 700.0, 100.0, colorBlue())
      gctx = gfxDrawCircle(gctx, 150.0, 250.0, 60.0, colorGreen())
      gctx = gfxDrawLine(gctx, 300.0, 200.0, 500.0, 300.0, colorYellow())
      gctx = gfxDrawText(gctx, "TheFlux Native Graphics 2D", 70.0, 90.0, 24, colorWhite())
      println("4. Primitivas renderizadas via GfxStdLib: " + (gfxContextDrawCalls(gctx) > 0))

      #L 5. Renderizacao de Botoes IMGUI na Tela
      uictx = guiSetCursor(uictx, 250, 480)
      mut as list of data: btn_cls = guiButtonEx(uictx, "Limpar (CLS)", 130, 36)
      uictx = btn_cls[1] as map
      mut as bool: clicked_cls = btn_cls[2] as bool
      println("5. Botao IMGUI CLS processado: " + clicked_cls)

      uictx = guiSameLine(uictx)
      mut as list of data: btn_close = guiButtonEx(uictx, "Fechar (CLOSE)", 130, 36)
      uictx = btn_close[1] as map
      mut as bool: clicked_close = btn_close[2] as bool
      println("6. Botao IMGUI CLOSE processado: " + clicked_close)

      #L 6. Apresentacao do Frame (Double-Buffer Swap / HTML5 Export)
      mut as bool: flushed = gfxPresentFrame(gctx)
      println("7. Apresentacao de frame concluida: " + flushed)

      #L 7. Exibicao e Permanencia dos Artefatos Reais na Tela
      println("8. Exibindo artefatos visuais na tela (5s se interativo, 0s se CI)...")
      mut as bool: waited = gfxWindowWait(win, 5000)
      println("8. Exibicao na tela concluida: " + waited)

      #L 8. Encerramento Gracioso
      mut as bool: closed = gfxWindowClose(win)
      println("9. Janela encerrada: " + closed)
      println("==================================================")
      println("  Demo concluido com sucesso!")
      println("==================================================")
}
