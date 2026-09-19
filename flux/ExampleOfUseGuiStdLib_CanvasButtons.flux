#L Exemplo de Uso: Canvas 800x600 com Botoes CLS e CLOSE Centralizados
use GuiStdLib as Gui

program (ExampleOfUseGuiStdLib_CanvasButtons) {
      println("==================================================")
      println("  Canvas 800x600 - Botoes CLS e CLOSE            ")
      println("==================================================")

      #L Canvas 800x600
      mut as map: ctx = guiInitContext(800, 600)
      println("Canvas: " + guiGetScreenWidth(ctx) + "x" + guiGetScreenHeight(ctx))

      #L Calculos de centralizacao:
      #L   btn_w=120, btn_h=36, gap=16
      #L   total_w = 120 + 16 + 120 = 256
      #L   start_x = (800 - 256) / 2 = 272
      #L   start_y = 600 * 90 / 100  = 540
      mut as int64: btn_w   = 120
      mut as int64: btn_h   = 36
      mut as int64: gap     = 16
      mut as int64: total_w = btn_w + gap + btn_w
      mut as int64: start_x = (800 - total_w) /i 2
      mut as int64: start_y = (600 * 90) /i 100

      ctx = guiSetCursor(ctx, start_x, start_y)
      println("Cursor antes dos botoes: (" + guiGetCursorX(ctx) + ", " + guiGetCursorY(ctx) + ")")

      #L Linha horizontal com os dois botoes
      ctx = guiLayoutBeginRow(ctx)

      #L Botao CLS
      mut as list of data: cls_res = guiButtonEx(ctx, "CLS", btn_w, btn_h)
      ctx = cls_res[1] as map
      mut as bool: cls_clicked = cls_res[2] as bool

      #L Gap entre botoes
      ctx = guiSpacing(ctx, gap)

      #L Botao CLOSE
      mut as list of data: close_res = guiButtonEx(ctx, "CLOSE", btn_w, btn_h)
      ctx = close_res[1] as map
      mut as bool: close_clicked = close_res[2] as bool

      ctx = guiLayoutEndRow(ctx)

      mut as int64: close_x = start_x + btn_w + gap
      println("Botao CLS:   clicado=" + cls_clicked   + " pos=(" + start_x + ", " + start_y + ") dim=" + btn_w + "x" + btn_h)
      println("Botao CLOSE: clicado=" + close_clicked + " pos=(" + close_x  + ", " + start_y + ") dim=" + btn_w + "x" + btn_h)
      println("Widgets renderizados: " + guiGetWidgetCount(ctx))
      println("Cursor apos linha:    (" + guiGetCursorX(ctx) + ", " + guiGetCursorY(ctx) + ")")

      #L Simular acao CLS -> reset de frame
      println("---")
      println("Acao CLS: resetando frame...")
      ctx = guiContextResetFrame(ctx)
      println("Frame apos CLS: " + guiGetFrameCount(ctx))
      println("Widgets apos CLS: " + guiGetWidgetCount(ctx))
      println("Cursor apos CLS: (" + guiGetCursorX(ctx) + ", " + guiGetCursorY(ctx) + ")")

      #L Simular acao CLOSE -> fechar contexto
      println("---")
      println("Acao CLOSE: fechando contexto...")
      ctx = guiCloseContext(ctx)
      mut as bool: is_closed = ctx["closed"] == true
      println("Contexto fechado: " + is_closed)
}
