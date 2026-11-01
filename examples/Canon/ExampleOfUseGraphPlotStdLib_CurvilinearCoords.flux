use GraphPlotStdLib

program (ExampleOfUseGraphPlotStdLib_CurvilinearCoords) {
      println("==================================================")
      println("  TheFlux GraphPlotStdLib: Curvilinear Coords Demo")
      println("==================================================")

      mut as map: p = plotCreate(800, 600, "Coordenadas Curvilineas")
      println("1. Contexto criado: " + (p["width"] == 800))

      #L 1. Polar (coord_sys = 3): r=2.0, theta=pi/4
      mut as list of float64: pt_polar = plotTransformToCartesian(3, 2.0, 0.7853981633974483, 0.0)
      println("2. Transformada Polar x > 0: " + (pt_polar[1] > 0.0) + ", y > 0: " + (pt_polar[2] > 0.0))

      #L 2. Cilíndrica (coord_sys = 4): r=2.0, theta=pi/2, z=5.0
      mut as list of float64: pt_cyl = plotTransformToCartesian(4, 2.0, 1.5707963267948966, 5.0)
      println("3. Transformada Cilindrica z == 5: " + (pt_cyl[3] == 5.0))

      #L 3. Esférica (coord_sys = 5): r=3.0, theta=pi/2, phi=0
      mut as list of float64: pt_sph = plotTransformToCartesian(5, 3.0, 1.5707963267948966, 0.0)
      println("4. Transformada Esferica x > 2.9: " + (pt_sph[1] > 2.9))

      #L 4. Ternária (coord_sys = 9): a=0.33, b=0.33, c=0.34
      mut as list of float64: pt_ter = plotTransformToCartesian(9, 0.33, 0.33, 0.34)
      println("5. Transformada Ternaria y > 0: " + (pt_ter[2] > 0.0))

      #L 5. Elíptica 2D (coord_sys = 12): mu=1.0, nu=0.0
      mut as list of float64: pt_elp = plotTransformToCartesian(12, 1.0, 0.0, 0.0)
      println("6. Transformada Eliptica x > 1.0: " + (pt_elp[1] > 1.0))

      #L 6. Parabólica 2D (coord_sys = 14): sigma=1.0, tau=1.0
      mut as list of float64: pt_par = plotTransformToCartesian(14, 1.0, 1.0, 0.0)
      println("7. Transformada Parabolica x == 0: " + (pt_par[1] == 0.0) + ", y == 1: " + (pt_par[2] == 1.0))

      #L 7. Toroidal 3D (coord_sys = 19): tau=1.0, sigma=0.5, phi=0.0
      mut as list of float64: pt_tor = plotTransformToCartesian(19, 1.0, 0.5, 0.0)
      println("8. Transformada Toroidal x > 0: " + (pt_tor[1] > 0.0))

      #L 8. Projeção de Tela com Câmera Isométrica
      p = plotSetCamera(p, 3, 45.0) #L ISOMETRIC
      mut as list of int64: scr_pt = plotProjectToScreen(p, 0.5, 0.5, 0.5)
      println("9. Projecao Isometrica de tela: " + (scr_pt[1] > 0) + " e " + (scr_pt[2] > 0))

      #L 9. Curva Curvilínea e Grid
      p = plotCurvilinearGrid(p, 3, 10)
      p = plotCurvilinearCurve(p, 3, [1.0, 2.0], [0.0, 1.57], [0.0, 0.0], [255, 100, 100, 255])
      p = plotRender(p)
      println("10. Renderizacao Curvilinea concluida: " + (p["items_count"] == 2))

      #L 10. Exibicao e Permanencia na tela (5s se interativo, 0s se CI)
      mut as bool: shown = plotShow(p, 5000)
      p = plotClose(p)
}
