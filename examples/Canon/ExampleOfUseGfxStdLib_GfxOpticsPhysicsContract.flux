#L Exemplo de Uso: GfxOpticsPhysicsContract (Fisica Optica, Shaders PBR e Fotometria)
use GfxStdLib as Gfx

program (ExampleOfUseGfxStdLib_GfxOpticsPhysicsContract) {
      println("==================================================")
      println("  Exemplo: GfxOpticsPhysicsContract               ")
      println("==================================================")

      #L 1. Equacao de Fresnel Schlick (Refletancia vs Angulo)
      #L F0 para vidro tipico ~0.04
      mut as float64: f0_glass = 0.04
      println("1. Fresnel Schlick (Vidro f0=0.04):")
      println("   Incidencia Normal (cos=1.0): " + gfxFresnelSchlick(1.0, f0_glass))
      println("   Incidencia a 60 graus (cos=0.5): " + gfxFresnelSchlick(0.5, f0_glass))
      println("   Incidencia Rasante (cos=0.0): " + gfxFresnelSchlick(0.0, f0_glass))

      #L 2. Atenuacao de Luz com Inverso do Quadrado
      #L Coeficientes padrao: const=1.0, linear=0.09, quad=0.032
      println("2. Atenuacao de Luz Pontual:")
      println("   Distancia 0: " + gfxLightAttenuation(0.0, 1.0, 0.09, 0.032))
      println("   Distancia 5: " + gfxLightAttenuation(5.0, 1.0, 0.09, 0.032))
      println("   Distancia 20: " + gfxLightAttenuation(20.0, 1.0, 0.09, 0.032))

      #L 3. Temperatura de Cor (Kelvin para RGB - Espectro de Corpo Negro)
      println("3. Temperatura de Cor para RGB:")
      println("   Vela (1850K): " + gfxKelvinToRgb(1850.0))
      println("   Tungstenio (2800K): " + gfxKelvinToRgb(2800.0))
      println("   D65 Daylight (6504K): " + gfxKelvinToRgb(6504.0))
      println("   Ceu Azul (10000K): " + gfxKelvinToRgb(10000.0))

      #L 4. Luminancia Relativa (Percepcao Humana sRGB)
      mut as list of int64: white = colorWhite()
      mut as list of int64: green = colorGreen()
      mut as list of int64: blue = colorBlue()
      println("4. Luminancia sRGB BT.709:")
      println("   Branco: " + gfxLuminance(white))
      println("   Verde (Pico visual): " + gfxLuminance(green))
      println("   Azul: " + gfxLuminance(blue))
}
