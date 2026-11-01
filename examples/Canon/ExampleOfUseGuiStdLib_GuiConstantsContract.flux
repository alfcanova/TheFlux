#L Exemplo de Uso: GuiConstantsContract (Constantes Fisicas de Display, Biofisica e Ergonomia de IHC)
use GuiStdLib as Gui

program (ExampleOfUseGuiStdLib_GuiConstantsContract) {
      println("==================================================")
      println("  Exemplo: GuiConstantsContract                   ")
      println("==================================================")

      #L 1. Constantes Fisicas de Display e Densidade (DPI)
      println("1. Densidade de Pixels (DPI):")
      println("   DPI Standard (Desktop CSS): " + guiDpiStandard())
      println("   DPI Mac Classic (Pontos): " + guiDpiMacClassic())
      println("   DPI Retina (HiDPI): " + guiDpiRetina())
      println("   Milimetros por Polegada: " + guiMmPerInch())

      #L 2. Biofisica da Percepcao Humana e Limiares de Latencia
      println("2. Biofisica e Psicofisica de IHC:")
      println("   Tempo Reacao Visual (ms): " + guiHumanVisualReactionTimeMs())
      println("   Persistencia da Visao (Hz): " + guiPersistenceOfVisionHz())
      println("   Limiar Feedback Instantaneo (ms): " + guiLatencyInstantFeedbackMs())

      #L 3. Metricas Ergonomicas de Design (ISO 9241-9)
      println("3. Ergonomia e Dimensoes Fisicas:")
      println("   Alvo de Toque Minimo (px): " + guiTouchTargetMinPx())
      println("   Fonte Padrao: " + guiFontSizeDefault())
      println("   Fonte Heading: " + guiFontSizeHeading())
      println("   Fonte Titulo: " + guiFontSizeTitle())
      println("   Padding Padrao: " + guiPaddingDefault())
      println("   Espacamento entre Itens: " + guiItemSpacingDefault())
}
