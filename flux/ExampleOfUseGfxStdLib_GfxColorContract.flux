#L Exemplo de Uso: GfxColorContract (Manipulacao de Cores RGBA, Hex, Lerp e Alpha)
use GfxStdLib as Gfx

program (ExampleOfUseGfxStdLib_GfxColorContract) {
      println("==================================================")
      println("  Exemplo: GfxColorContract                       ")
      println("==================================================")

      #L 1. Construcao de Cor RGBA com Clamping
      mut as list of int64: c1 = gfxColorRgba(200, 100, 50, 255)
      println("1. Cor c1:")
      println("   R: " + gfxColorGetR(c1))
      println("   G: " + gfxColorGetG(c1))
      println("   B: " + gfxColorGetB(c1))
      println("   A: " + gfxColorGetA(c1))

      #L 2. Conversao Hexadecimal <-> RGBA
      mut as string: hex1 = gfxColorToHex(c1)
      println("2. Conversao para Hex: " + hex1)

      mut as list of int64: from_hex = gfxColorFromHex("#FF8000FF")
      println("   De '#FF8000FF' para RGBA: " + from_hex)
      println("   Re-exportado para Hex: " + gfxColorToHex(from_hex))

      #L 3. Interpolacao Linear de Cores (Lerp)
      mut as list of int64: c_red = gfxColorRgba(255, 0, 0, 255)
      mut as list of int64: c_blue = gfxColorRgba(0, 0, 255, 255)
      mut as list of int64: c_mid = gfxColorLerp(c_red, c_blue, 0.5)
      println("3. Lerp entre Red e Blue (t=0.5): " + c_mid)
      println("   Lerp no inicio (t=0.0): " + gfxColorLerp(c_red, c_blue, 0.0))
      println("   Lerp no fim (t=1.0): " + gfxColorLerp(c_red, c_blue, 1.0))

      #L 4. Ajuste de Transparencia (Alpha)
      mut as list of int64: c_alpha = gfxColorAlpha(c1, 0.5)
      println("4. c1 com Alpha a 50%: " + c_alpha)
}
