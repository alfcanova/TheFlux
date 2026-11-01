#L Exemplo de Uso: GuiThemeContract (Estilizacao de Componentes e Paletas de Cores)
use GuiStdLib as Gui

program (ExampleOfUseGuiStdLib_GuiThemeContract) {
      println("==================================================")
      println("  Exemplo: GuiThemeContract                       ")
      println("==================================================")

      mut as map: ctx = guiInitContext(800, 600)

      #L 1. Cores do Tema Padrao
      println("1. Cores do Tema Padrao:")
      println("   Fundo (bg): " + guiGetThemeColor(ctx, "bg"))
      println("   Painel: " + guiGetThemeColor(ctx, "panel"))
      println("   Primaria: " + guiGetThemeColor(ctx, "primary"))
      println("   Texto: " + guiGetThemeColor(ctx, "text"))

      #L 2. Aplicacao de Tema Dark (Modo Escuro)
      mut as map: dark = guiThemeDark()
      ctx = guiSetTheme(ctx, dark)
      println("2. Apos Aplicar Tema Dark:")
      println("   Fundo (bg): " + guiGetThemeColor(ctx, "bg"))
      println("   Primaria: " + guiGetThemeColor(ctx, "primary"))

      #L 3. Aplicacao de Tema Light (Modo Claro)
      mut as map: light = guiThemeLight()
      ctx = guiSetTheme(ctx, light)
      println("3. Apos Aplicar Tema Light:")
      println("   Fundo (bg): " + guiGetThemeColor(ctx, "bg"))
      println("   Primaria: " + guiGetThemeColor(ctx, "primary"))
}
