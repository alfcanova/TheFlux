use NativeGfxStdLib

program (ExampleOfUseNativeGfxStdLib_CanvasButtons) {
      println("==================================================")
      println("  TheFlux NativeGfxStdLib: Canvas & Buttons Demo")
      println("==================================================")

      mut as int64: win = nativeGfxWindowCreate(800, 600, "TheFlux Canvas")
      println("1. Janela criada com sucesso: " + (win > 0))

      mut as int64: w = nativeGfxWindowWidth(win)
      mut as int64: h = nativeGfxWindowHeight(win)
      println("2. Dimensoes da janela: " + (w >= 800) + " e " + (h >= 600))

      mut as bool: clr = nativeGfxClear(win, 30, 30, 35)
      println("3. Limpeza de fundo: " + clr)

      mut as bool: fr = nativeGfxFillRect(win, 50, 50, 200, 100, 74, 144, 217)
      println("4. Preenchimento de retangulo: " + fr)

      mut as bool: dr = nativeGfxDrawRect(win, 50, 50, 200, 100, 255, 255, 255)
      println("5. Borda de retangulo: " + dr)

      mut as bool: dl = nativeGfxDrawLine(win, 50, 200, 250, 200, 0, 255, 0)
      println("6. Desenho de linha: " + dl)

      mut as bool: fc = nativeGfxFillCircle(win, 400, 150, 50, 255, 100, 100)
      println("7. Preenchimento de circulo: " + fc)

      mut as bool: dc = nativeGfxDrawCircle(win, 400, 150, 50, 255, 255, 255)
      println("8. Borda de circulo: " + dc)

      mut as bool: dt = nativeGfxDrawText(win, 60, 110, "Hello Native Gfx", 255, 255, 255)
      println("9. Renderizacao de texto: " + dt)

      mut as bool: fl = nativeGfxWindowFlush(win)
      println("10. Apresentacao de frame (flush): " + fl)

      mut as int64: ev = nativeGfxEventPoll(win)
      println("11. Polling de eventos: " + (ev >= 0))

      mut as bool: waited = nativeGfxWindowWait(win, 5000)
      println("12. Exibicao na tela (5000ms): " + waited)

      mut as bool: cl = nativeGfxWindowClose(win)
      println("13. Fechamento de janela: " + cl)

      mut as bool: is_closed = nativeGfxWindowClosed(win)
      println("14. Estado de janela fechada: " + is_closed)
}
