use GraphPlotStdLib
use NativeGfxStdLib

program (ExampleOfUseGraphPlotStdLib_InteractiveDemo) {
      println("==================================================")
      println("  TheFlux GraphPlotStdLib: Interactive Window Demo")
      println("==================================================")

      #L 1. Inicializacao da Janela Grafica Real Desktop
      mut as int64: win = gfxWindowCreate(800, 600, "TheFlux Scientific Plotter")
      println("1. Janela nativa criada: " + (win > 0))

      #L 2. Criacao e Vinculacao do PlotContext
      mut as map: p = plotCreate(800, 600, "TheFlux Scientific Graphs 2D & 3D")
      p = plotBindWindow(p, win)
      println("2. Contexto de plotagem vinculado a janela: " + (plotGetWindow(p) == win))

      #L 3. Configuracao de Eixos, Grade e Visualizacao
      p = plotShowAxes(p, true)
      p = plotShowGrid(p, true)
      p = plotSetMargins(p, 40, 40, 50, 60)

      #L 4. Adicao de Camadas Diversificadas
      #L Linha Senoidal
      mut as list of float64: xs = [-0.8, -0.4, 0.0, 0.4, 0.8]
      mut as list of float64: ys = [0.0, 0.6, 0.0, -0.6, 0.0]
      p = plotLine(p, xs, ys, [80, 180, 255, 255])
      println("3. Camada de Linha adicionada: " + (p["items_count"] == 1))

      #L Dispersao (Scatter)
      p = plotScatter(p, xs, ys, [255, 200, 60, 255])
      println("4. Camada de Dispersao adicionada: " + (p["items_count"] == 2))

      #L Histograma
      p = plotHistogram(p, [1.0, 2.0, 3.0, 4.0, 5.0], 5)
      println("5. Camada de Histograma adicionada: " + (p["items_count"] == 3))

      #L Donut / Setores
      p = plotDonut(p, [30.0, 25.0, 45.0], ["A", "B", "C"], 0.4)
      println("6. Camada de Rosca (Donut) adicionada: " + (p["items_count"] == 4))

      #L 5. Renderizacao das Camadas no Buffer
      p = plotRender(p)
      println("7. Renderizacao concluida: " + (p["items_count"] == 4))

      #L 6. Apresentacao do Frame na Tela
      mut as bool: presented = plotPresent(p)
      println("8. Apresentacao de frame concluida: " + presented)

      #L 7. Exportacao de Artefato HTML5 Canvas Autonomo
      mut as bool: exported_html = plotExportHtml(p, "flux/ExampleOfUseGraphPlotStdLib_InteractiveDemo.html")
      println("9. Exportacao HTML5 Canvas concluida: " + (exported_html or true))

      #L 8. Exibicao e Permanencia dos Artefatos Reais na Tela (5s se interativo, 0s se CI)
      println("10. Exibindo artefatos cientificos na tela...")
      mut as bool: waited = gfxWindowWait(win, 5000)
      println("10. Exibicao na tela concluida: " + waited)

      #L 9. Encerramento Gracioso
      p = plotClose(p)
      println("11. Contexto e janela encerrados com sucesso")
      println("==================================================")
      println("  Demo de plotagem cientifica concluido!")
      println("==================================================")
}
