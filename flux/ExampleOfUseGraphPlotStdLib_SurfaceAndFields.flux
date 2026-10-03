use GraphPlotStdLib

program (ExampleOfUseGraphPlotStdLib_SurfaceAndFields) {
      println("==================================================")
      println("  TheFlux GraphPlotStdLib: Surface & Fields Demo")
      println("==================================================")

      mut as map: p = plotCreate(800, 600, "Superficies e Campos Vetoriais")
      println("1. Contexto criado: " + (p["width"] == 800))

      #L 1. Surface 3D
      mut as list of data: gx = [0.0, 1.0, 2.0]
      mut as list of data: gy = [0.0, 1.0, 2.0]
      mut as list of data: gz = [[0.0, 1.0, 4.0], [1.0, 2.0, 5.0], [4.0, 5.0, 8.0]]
      p = plotSurface3D(p, gx, gy, gz)
      println("2. Superficie 3D adicionada: " + (p["items_count"] == 1))

      #L 2. Mesh 3D Wireframe
      p = plotMesh3D(p, gx, gy, gz)
      println("3. Mesh 3D adicionado: " + (p["items_count"] == 2))

      #L 3. Curvas de Nível / Contorno (Contour)
      p = plotContour(p, gz, 5)
      println("4. Curvas de nivel adicionadas: " + (p["items_count"] == 3))

      #L 4. Campo Vetorial (Quiver 2D)
      mut as list of float64: xs = [0.0, 1.0, 2.0]
      mut as list of float64: ys = [0.0, 1.0, 2.0]
      mut as list of float64: us = [1.0, 0.0, -1.0]
      mut as list of float64: vs = [0.0, 1.0, 0.0]
      p = plotQuiver2D(p, xs, ys, us, vs)
      println("5. Campo vetorial Quiver adicionado: " + (p["items_count"] == 4))

      #L 5. Linhas de Fluxo (Streamlines)
      p = plotStreamlines(p, gz, gz)
      println("6. Linhas de fluxo adicionadas: " + (p["items_count"] == 5))

      #L 6. Scatter 3D e Trajetória 3D
      mut as list of float64: zs = [0.5, 1.5, 2.5]
      p = plotScatter3D(p, xs, ys, zs)
      p = plotTrajectory3D(p, xs, ys, zs)
      println("7. Scatter 3D e Trajetoria adicionados: " + (p["items_count"] == 7))

      #L 7. Renderizacao das Camadas
      p = plotRender(p)
      println("8. Renderizacao de Superficies e Campos concluida: " + (p["items_count"] == 7))

      #L 8. Exibicao e Permanencia na tela (5s se interativo, 0s se CI)
      mut as bool: shown = plotShow(p, 5000)
      p = plotClose(p)
}
