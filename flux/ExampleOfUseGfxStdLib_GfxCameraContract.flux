#L Exemplo de Uso: GfxCameraContract (Camera 2D, Zoom e Coordenadas de Mundo / Tela)
use GfxStdLib as Gfx

program (ExampleOfUseGfxStdLib_GfxCameraContract) {
      println("==================================================")
      println("  Exemplo: GfxCameraContract                      ")
      println("==================================================")

      #L 1. Criacao de Camera 2D:
      #L Alvo no jogador (100, 100), centro da tela como offset (400, 300), sem rotacao, zoom 2x
      mut as map: cam = gfxCamera2DNew(100.0, 100.0, 400.0, 300.0, 0.0, 2.0)
      println("1. Camera 2D Criada:")
      println("   Alvo: (" + cam["target_x"] + ", " + cam["target_y"] + ")")
      println("   Offset Tela: (" + cam["offset_x"] + ", " + cam["offset_y"] + ")")
      println("   Zoom: " + cam["zoom"])

      #L 2. Conversao Mundo -> Tela (World to Screen)
      #L O proprio jogador no alvo (100, 100) deve cair exatamente no offset da tela (400, 300)
      mut as list of float64: screen_p1 = gfxWorldToScreen2D(100.0, 100.0, cam)
      println("2. Mundo (100, 100) na Tela: (" + screen_p1[1] + ", " + screen_p1[2] + ")")

      #L Objeto a 50 pixels a direita no mundo: (150, 100) com zoom 2x -> offset + 100 -> tela (500, 300)
      mut as list of float64: screen_p2 = gfxWorldToScreen2D(150.0, 100.0, cam)
      println("   Mundo (150, 100) na Tela: (" + screen_p2[1] + ", " + screen_p2[2] + ")")

      #L 3. Conversao Tela -> Mundo (Screen to World)
      #L O centro da tela (400, 300) deve mapear de volta para o alvo do mundo (100, 100)
      mut as list of float64: world_p1 = gfxScreenToWorld2D(400.0, 300.0, cam)
      println("3. Tela (400, 300) no Mundo: (" + world_p1[1] + ", " + world_p1[2] + ")")
}
