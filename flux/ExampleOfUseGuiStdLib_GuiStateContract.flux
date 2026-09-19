#L Exemplo de Uso: GuiStateContract (Contexto de Interface, Ciclo de Vida e Quadros)
use GuiStdLib as Gui

program (ExampleOfUseGuiStdLib_GuiStateContract) {
      println("==================================================")
      println("  Exemplo: GuiStateContract                       ")
      println("==================================================")

      #L 1. Inicializacao do Contexto de UI
      mut as map: ctx = guiInitContext(1280, 720)
      println("1. Contexto Inicializado:")
      println("   Largura da Tela: " + guiGetScreenWidth(ctx))
      println("   Altura da Tela: " + guiGetScreenHeight(ctx))
      println("   Contagem de Widgets Inicial: " + guiGetWidgetCount(ctx))
      println("   Quadro Inicial: " + guiGetFrameCount(ctx))

      #L 2. Registro de Componente e Atualizacao de Quadro
      ctx = guiLabel(ctx, "Status: Sistema Ativo")
      println("2. Apos adicionar label:")
      println("   Contagem de Widgets: " + guiGetWidgetCount(ctx))

      #L 3. Reset de Quadro (Novo Frame da UI)
      ctx = guiContextResetFrame(ctx)
      println("3. Apos reset de quadro:")
      println("   Widgets no novo frame: " + guiGetWidgetCount(ctx))
      println("   Numero do frame: " + guiGetFrameCount(ctx))

      #L 4. Fechamento do Contexto
      ctx = guiCloseContext(ctx)
      println("4. Contexto Finalizado.")
}
