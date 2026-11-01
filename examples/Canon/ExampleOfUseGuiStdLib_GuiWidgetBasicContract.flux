#L Exemplo de Uso: GuiWidgetBasicContract (Rotulos, Titulos, Separadores e Barra de Progresso)
use GuiStdLib as Gui

program (ExampleOfUseGuiStdLib_GuiWidgetBasicContract) {
      println("==================================================")
      println("  Exemplo: GuiWidgetBasicContract                 ")
      println("==================================================")

      mut as map: ctx = guiInitContext(800, 600)

      #L 1. Titulo e Cabecalhos Tipograficos
      ctx = guiTitle(ctx, "Painel de Controle Principal")
      ctx = guiHeading(ctx, "Secao de Monitoramento")
      ctx = guiLabel(ctx, "Descricao detalhada do status dos servicos.")

      println("1. Apos Tipografia:")
      println("   Total Widgets: " + guiGetWidgetCount(ctx))
      println("   Cursor Y: " + guiGetCursorY(ctx))

      #L 2. Linha Divisoria (Separador)
      ctx = guiSeparator(ctx)
      println("2. Apos Separador - Cursor Y: " + guiGetCursorY(ctx))

      #L 3. Barra de Progresso (75% concluido)
      ctx = guiProgressBar(ctx, 0.75, 200, 20)
      println("3. Apos Barra de Progresso:")
      println("   Total Widgets: " + guiGetWidgetCount(ctx))
      println("   Cursor Y Final: " + guiGetCursorY(ctx))
}
