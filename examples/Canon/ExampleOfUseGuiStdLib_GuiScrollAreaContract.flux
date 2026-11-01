#L Exemplo de Uso: GuiScrollAreaContract (Regioes de Rolagem e Deslocamento)
use GuiStdLib as Gui

program (ExampleOfUseGuiStdLib_GuiScrollAreaContract) {
      println("==================================================")
      println("  Exemplo: GuiScrollAreaContract                  ")
      println("==================================================")

      mut as map: ctx = guiInitContext(800, 600)

      #L 1. Criacao de Area de Rolagem
      ctx = guiBeginScrollArea(ctx, "chat_log", 350, 200)
      ctx = guiLabel(ctx, "Mensagem 1: Ola mundo!")
      ctx = guiLabel(ctx, "Mensagem 2: Sistema carregado com sucesso.")
      ctx = guiLabel(ctx, "Mensagem 3: Interface pronta para uso.")
      ctx = guiEndScrollArea(ctx)

      println("1. Area de Rolagem Criada:")
      println("   Total Widgets: " + guiGetWidgetCount(ctx))
      println("   Offset Y Inicial: " + guiGetScrollOffsetY(ctx, "chat_log"))

      #L 2. Deslocamento de Rolagem (Scroll Offset)
      ctx = guiSetScrollOffsetY(ctx, "chat_log", 150)
      println("2. Novo Offset Y Apos Scroll: " + guiGetScrollOffsetY(ctx, "chat_log"))
}
