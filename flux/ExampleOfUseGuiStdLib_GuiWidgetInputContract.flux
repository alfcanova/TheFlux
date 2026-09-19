#L Exemplo de Uso: GuiWidgetInputContract (Entrada de Texto e Valores Numericos)
use GuiStdLib as Gui

program (ExampleOfUseGuiStdLib_GuiWidgetInputContract) {
      println("==================================================")
      println("  Exemplo: GuiWidgetInputContract                 ")
      println("==================================================")

      mut as map: ctx = guiInitContext(800, 600)

      #L 1. Caixa de Entrada de Texto (InputText)
      mut as list of data: txt_res = guiInputText(ctx, "Nome:", "TheFlux Developer", 64)
      ctx = txt_res[1] as map
      mut as string: text_val = txt_res[2] as string
      println("1. InputText:")
      println("   Valor Atual: " + text_val)

      #L 2. Entrada de Inteiro (InputInt)
      mut as list of data: int_res = guiInputInt(ctx, "Idade:", 30)
      ctx = int_res[1] as map
      mut as int64: int_val = int_res[2] as int64
      println("2. InputInt:")
      println("   Valor Atual: " + int_val)

      #L 3. Entrada de Ponto Flutuante (InputFloat)
      mut as list of data: flt_res = guiInputFloat(ctx, "Taxa:", 3.14159)
      ctx = flt_res[1] as map
      mut as float64: flt_val = flt_res[2] as float64
      println("3. InputFloat:")
      println("   Valor Atual: " + flt_val)
      println("4. Total Widgets: " + guiGetWidgetCount(ctx))
}
