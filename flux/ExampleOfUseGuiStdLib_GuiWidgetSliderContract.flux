#L Exemplo de Uso: GuiWidgetSliderContract (Controles Deslizantes / Sliders)
use GuiStdLib as Gui

program (ExampleOfUseGuiStdLib_GuiWidgetSliderContract) {
      println("==================================================")
      println("  Exemplo: GuiWidgetSliderContract                ")
      println("==================================================")

      mut as map: ctx = guiInitContext(800, 600)

      #L 1. Slider Float (Volume de Audio entre 0.0 e 1.0)
      mut as list of data: s_flt = guiSliderFloat(ctx, "Volume", 0.75, 0.0, 1.0)
      ctx = s_flt[1] as map
      mut as float64: vol = s_flt[2] as float64
      println("1. Slider Float (Volume): " + vol)

      #L 2. Slider Float com Clamping (Valor 1.5 acima do max 1.0)
      mut as list of data: s_flt_clamp = guiSliderFloat(ctx, "Brilho", 1.5, 0.0, 1.0)
      ctx = s_flt_clamp[1] as map
      println("2. Slider Float com Clamping: " + (s_flt_clamp[2] as float64))

      #L 3. Slider Inteiro (Sensibilidade do Mouse entre 1 e 100)
      mut as list of data: s_int = guiSliderInt(ctx, "Sensibilidade", 45, 1, 100)
      ctx = s_int[1] as map
      mut as int64: sens = s_int[2] as int64
      println("3. Slider Int (Sensibilidade): " + sens)

      #L 4. Slider Inteiro com Clamping (Valor -10 abaixo do min 0)
      mut as list of data: s_int_clamp = guiSliderInt(ctx, "FOV", 0 - 10, 60, 120)
      ctx = s_int_clamp[1] as map
      println("4. Slider Int com Clamping: " + (s_int_clamp[2] as int64))
      println("5. Total Widgets: " + guiGetWidgetCount(ctx))
}
