#L Exemplo de Uso: GfxInputContract (Captura e Polling de Teclado e Mouse)
use GfxStdLib as Gfx

program (ExampleOfUseGfxStdLib_GfxInputContract) {
      println("==================================================")
      println("  Exemplo: GfxInputContract                       ")
      println("==================================================")

      mut as map: inp = gfxInputNew()

      #L 1. Estado Inicial de Input
      println("1. Estado Inicial:")
      println("   Mouse X: " + gfxGetMouseX(inp))
      println("   Mouse Y: " + gfxGetMouseY(inp))
      println("   Key Space pressionada: " + gfxPollInput(inp, "SPACE"))

      #L 2. Simulacao / Evento de Teclado
      inp = gfxSetInputState(inp, "SPACE", true)
      inp = gfxSetInputState(inp, "W", true)
      println("2. Apos Pressionar Teclas:")
      println("   Key SPACE pressionada: " + gfxPollInput(inp, "SPACE"))
      println("   Key W pressionada: " + gfxPollInput(inp, "W"))
      println("   Key S pressionada: " + gfxPollInput(inp, "S"))

      #L 3. Soltura de Tecla
      inp = gfxSetInputState(inp, "SPACE", false)
      println("3. Apos Soltar SPACE:")
      println("   Key SPACE pressionada: " + gfxPollInput(inp, "SPACE"))

      #L 4. Atualizacao de Posicao do Mouse
      inp = gfxSetMousePosition(inp, 450, 320)
      println("4. Posicao Atualizada do Mouse:")
      println("   Mouse X: " + gfxGetMouseX(inp))
      println("   Mouse Y: " + gfxGetMouseY(inp))
}
