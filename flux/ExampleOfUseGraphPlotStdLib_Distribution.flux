use GraphPlotStdLib

program (ExampleOfUseGraphPlotStdLib_Distribution) {
      println("==================================================")
      println("  TheFlux GraphPlotStdLib: Distribution Plots Demo")
      println("==================================================")

      mut as map: p = plotCreate(800, 600, "Distribuicoes e Densidade")
      println("1. Contexto de plotagem criado: " + (p["width"] == 800))

      mut as list of float64: data_vals = [1.2, 2.3, 2.5, 3.1, 3.4, 3.8, 4.0, 4.2, 5.1, 5.9]

      #L 1. Histograma
      p = plotHistogram(p, data_vals, 5)
      println("2. Histograma adicionado: " + (p["items_count"] == 1))

      #L 2. Kernel Density Estimation (KDE)
      p = plotKde(p, data_vals, 0.5)
      println("3. KDE adicionado: " + (p["items_count"] == 2))

      #L 3. Boxplot
      p = plotBoxplot(p, data_vals, 0.0, 0.5)
      println("4. Boxplot adicionado: " + (p["items_count"] == 3))

      #L 4. Violin Plot
      p = plotViolin(p, data_vals, 0.0, 0.5)
      println("5. Violin plot adicionado: " + (p["items_count"] == 4))

      #L 5. Ogiva Cumulativa
      p = plotOgive(p, data_vals)
      println("6. Ogiva adicionada: " + (p["items_count"] == 5))

      #L 6. Q-Q Plot
      p = plotQqPlot(p, data_vals)
      println("7. Q-Q Plot adicionado: " + (p["items_count"] == 6))

      #L 7. Renderizacao das camadas
      p = plotRender(p)
      println("8. Renderizacao concluida: " + (p["items_count"] == 6))

      #L 8. Exibicao e Permanencia dos Artefatos Reais na Tela (5s se interativo, 0s se CI)
      println("9. Exibindo artefatos cientificos na tela...")
      mut as bool: shown = plotShow(p, 5000)
      println("10. Exibicao na tela concluida: " + shown)

      #L 9. Encerramento Gracioso
      p = plotClose(p)
}
