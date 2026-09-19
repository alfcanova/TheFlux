#L Exemplo de Uso: GfxConstantsContract (Constantes de Resolucoes, Cores e Optica)
use GfxStdLib as Gfx

program (ExampleOfUseGfxStdLib_GfxConstantsContract) {
      println("==================================================")
      println("  Exemplo: GfxConstantsContract                   ")
      println("==================================================")

      #L 1. Resolucoes Padrao
      println("1. Resolucoes Padrao:")
      println("   720p: " + res720pW() + "x" + res720pH())
      println("   1080p: " + res1080pW() + "x" + res1080pH())
      println("   4K: " + res4kW() + "x" + res4kH())

      #L 2. Proporcoes de Tela (Aspect Ratios)
      println("2. Aspect Ratios:")
      println("   16:9: " + aspect16x9())
      println("   4:3: " + aspect4x3())
      println("   21:9: " + aspect21x9())

      #L 3. Cores Padrao Canônicas
      println("3. Cores Canonicas:")
      println("   White: " + colorWhite())
      println("   Black: " + colorBlack())
      println("   Red: " + colorRed())
      println("   Green: " + colorGreen())
      println("   Blue: " + colorBlue())
      println("   Transparent: " + colorTransparent())

      #L 4. Constantes Fisicas: Indice de Refracao (IOR)
      println("4. Indices de Refracao (IOR):")
      println("   Ar: " + gfxIorAir())
      println("   Agua: " + gfxIorWater())
      println("   Vidro: " + gfxIorGlass())
      println("   Diamante: " + gfxIorDiamond())
      println("   Policarbonato: " + gfxIorPolycarbonate())

      #L 5. Constantes Fisicas: Fotometria e Temperatura de Cor
      println("5. Fotometria e Temperatura de Cor:")
      println("   Sol Direto (lux): " + gfxLuxDirectSun())
      println("   Escritorio (lux): " + gfxLuxOffice())
      println("   D65 Daylight (K): " + gfxKelvinDaylightD65())
      println("   Tungstenio (K): " + gfxKelvinTungsten())
      println("   Vela (K): " + gfxKelvinCandle())
}
