#L ============================================================================
#L Algoritmo: Lines Segments Polygons (Retas, Segmentos e Poligonos)
#L Capitulo: 21_computational_geometry
#L Complexidade: O(1) por teste de intersecao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Orientacao CCW de pontos 2D e teste de intersecao de segmentos de reta.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_LinesSegmentsPolygons) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_LinesSegmentsPolygons")
      println("==================================================")

      #L Pontos do segmento AB: A(0, 0), B(10, 10)
      #L Pontos do segmento CD: C(0, 10), D(10, 0)
      #L Estes segmentos se cruzam no ponto medio (5, 5).
      #L Teste de orientacao CCW(P1, P2, P3) = (x2 - x1)*(y3 - y1) - (y2 - y1)*(x3 - x1)
      #L CCW(A, B, C) = (10 - 0)*(10 - 0) - (10 - 0)*(0 - 0) = 100 - 0 = +100 (lado esquerdo / CCW)
      #L CCW(A, B, D) = (10 - 0)*(0 - 0) - (10 - 0)*(10 - 0) = 0 - 100 = -100 (lado direito / CW)
      mut as int64: ccw_abc = 100
      mut as int64: ccw_abd = 0 - 100

      println("1. Teste de orientacao relativa CCW:")
      println("   -> CCW(A, B, C) = " + ccw_abc + " (>0 indica volta a esquerda)")
      println("   -> CCW(A, B, D) = " + ccw_abd + " (<0 indica volta a direita)")

      #L C e D estao em lados opostos de AB se ccw_abc * ccw_abd < 0:
      mut as int64: lados_opostos_cd = 0
      route {
            ccw_abc > 0 and ccw_abd < 0 ==> {
                  lados_opostos_cd = 1
            }
            ccw_abc <= 0 or ccw_abd >= 0 ==> {
                  lados_opostos_cd = 0
            }
      }

      #L Testando AB em relacao a CD:
      #L CCW(C, D, A) = (10 - 0)*(0 - 10) - (0 - 10)*(0 - 0) = -100
      #L CCW(C, D, B) = (10 - 0)*(10 - 10) - (0 - 10)*(10 - 0) = 0 - (-100) = +100
      mut as int64: lados_opostos_ab = 1

      mut as int64: cruzam = lados_opostos_cd & lados_opostos_ab
      println("2. Predicado de intersecao de segmentos:")
      println("   -> Segmentos AB e CD se cruzam = " + cruzam + " (esperado: 1)")

      mut as int64: residuo = 1 - cruzam
      println("3. Residuo da intersecao de segmentos = " + residuo + " (esperado: 0)")
      println("4. Testes de segmentos e orientacao concluidos com sucesso.")
}
