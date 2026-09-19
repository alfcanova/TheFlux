#L Exemplo de Uso: GuiWidgetButtonContract (Botoes, Caixas de Selecao e Radios)
use GuiStdLib as Gui

program (ExampleOfUseGuiStdLib_GuiWidgetButtonContract) {
      println("==================================================")
      println("  Exemplo: GuiWidgetButtonContract                ")
      println("==================================================")

      mut as map: ctx = guiInitContext(800, 600)

      #L 1. Botao Interativo Simples
      mut as list of data: btn_res = guiButton(ctx, "Salvar Alteracoes")
      ctx = btn_res[1] as map
      mut as bool: clicked = btn_res[2] as bool
      println("1. Botao 'Salvar Alteracoes':")
      println("   Clicado: " + clicked)
      println("   Total Widgets: " + guiGetWidgetCount(ctx))

      #L 2. Botao com Dimensoes Customizadas (ButtonEx)
      mut as list of data: btn_ex_res = guiButtonEx(ctx, "Executar Acao", 180, 40)
      ctx = btn_ex_res[1] as map
      mut as bool: clicked_ex = btn_ex_res[2] as bool
      println("2. Botao Customizado (180x40):")
      println("   Clicado: " + clicked_ex)

      #L 3. Caixa de Selecao (Checkbox)
      mut as list of data: chk_res = guiCheckbox(ctx, "Habilitar Notificacoes", false)
      ctx = chk_res[1] as map
      mut as bool: new_state = chk_res[2] as bool
      println("3. Checkbox alternado de false para: " + new_state)

      #L 4. Botao de Radio (Opcao Unica)
      mut as list of data: rad_res = guiRadioButton(ctx, "Opcao A", false)
      ctx = rad_res[1] as map
      mut as bool: radio_sel = rad_res[2] as bool
      println("4. Radio selecionado: " + radio_sel)
}
