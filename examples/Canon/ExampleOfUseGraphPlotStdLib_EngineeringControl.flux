use GraphPlotStdLib

program (ExampleOfUseGraphPlotStdLib_EngineeringControl) {
      println("==================================================")
      println("  TheFlux GraphPlotStdLib: Engineering & Control")
      println("==================================================")

      mut as map: p = plotCreate(800, 600, "Sistemas de Controle e Engenharia")
      println("1. Contexto de engenharia criado: " + (p["width"] == 800))

      #L 1. Diagrama de Bode
      mut as list of float64: omegas = [0.1, 1.0, 10.0, 100.0]
      mut as list of float64: mag_db = [20.0, 15.0, -10.0, -40.0]
      mut as list of float64: phase = [-10.0, -45.0, -85.0, -170.0]
      p = plotBode(p, omegas, mag_db, phase)
      println("2. Diagrama de Bode adicionado: " + (p["items_count"] == 1))

      #L 2. Diagrama de Nyquist
      mut as list of float64: re = [1.0, 0.7, 0.0, -0.5]
      mut as list of float64: im = [0.0, -0.7, -1.0, -0.2]
      p = plotNyquist(p, re, im)
      println("3. Diagrama de Nyquist adicionado: " + (p["items_count"] == 2))

      #L 3. Diagrama de Nichols
      p = plotNichols(p, phase, mag_db)
      println("4. Diagrama de Nichols adicionado: " + (p["items_count"] == 3))

      #L 4. Carta de Smith (Smith Chart)
      mut as list of float64: gre = [0.2, 0.5, 0.0]
      mut as list of float64: gim = [0.1, 0.3, 0.0]
      p = plotSmithChart(p, gre, gim)
      println("5. Carta de Smith adicionada: " + (p["items_count"] == 4))

      #L 5. Curva de Sobrevivência Kaplan-Meier
      mut as list of float64: times = [1.0, 2.0, 5.0, 10.0]
      mut as list of int64: events = [1, 1, 0, 1]
      p = plotKaplanMeier(p, times, events)
      println("6. Curva Kaplan-Meier adicionada: " + (p["items_count"] == 5))

      #L 6. Curva ROC (Receiver Operating Characteristic)
      mut as list of float64: fpr = [0.0, 0.1, 0.3, 0.7, 1.0]
      mut as list of float64: tpr = [0.0, 0.5, 0.8, 0.95, 1.0]
      p = plotRocCurve(p, fpr, tpr)
      println("7. Curva ROC adicionada: " + (p["items_count"] == 6))

      #L 7. Renderizacao das Camadas
      p = plotRender(p)
      println("8. Renderizacao de Engenharia concluida: " + (p["items_count"] == 6))

      #L 8. Exibicao e Permanencia na tela (5s se interativo, 0s se CI)
      mut as bool: shown = plotShow(p, 5000)
      p = plotClose(p)
}
