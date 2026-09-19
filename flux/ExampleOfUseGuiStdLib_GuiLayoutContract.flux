#L Exemplo de Uso: GuiLayoutContract (Layout Linear Flexbox, Linhas, Colunas e Espacamentos)
use GuiStdLib as Gui

program (ExampleOfUseGuiStdLib_GuiLayoutContract) {
      println("==================================================")
      println("  Exemplo: GuiLayoutContract                      ")
      println("==================================================")

      mut as map: ctx = guiInitContext(800, 600)

      #L 1. Posicao Inicial do Cursor de Layout
      println("1. Cursor Inicial:")
      println("   Cursor X: " + guiGetCursorX(ctx))
      println("   Cursor Y: " + guiGetCursorY(ctx))

      #L 2. Layout Linear Horizontal (BeginRow / EndRow)
      ctx = guiLayoutBeginRow(ctx)
      ctx = guiLabel(ctx, "Item 1")
      ctx = guiLabel(ctx, "Item 2")
      ctx = guiLayoutEndRow(ctx)
      println("2. Apos Linha Horizontal:")
      println("   Cursor X (redefinido para inicio): " + guiGetCursorX(ctx))
      println("   Cursor Y (avancado pela altura): " + guiGetCursorY(ctx))

      #L 3. Espacamento Manual (Spacing)
      ctx = guiSpacing(ctx, 20)
      println("3. Apos Spacing de 20px:")
      println("   Cursor Y: " + guiGetCursorY(ctx))

      #L 4. Definicao Manual de Cursor (SetCursor)
      ctx = guiSetCursor(ctx, 100, 250)
      println("4. Cursor Apos SetCursor(100, 250):")
      println("   Cursor X: " + guiGetCursorX(ctx))
      println("   Cursor Y: " + guiGetCursorY(ctx))
}
