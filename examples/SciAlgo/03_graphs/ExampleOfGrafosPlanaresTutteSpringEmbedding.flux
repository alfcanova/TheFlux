#L ============================================================================
#L Algoritmo: Tutte Spring Embedding (Desenho Convexo Baricentrico de Tutte 1963)
#L Dominio: 03_graphs / Categoria: Grafos planares e topologia
#L Complexidade: O(V) solucao do sistema de equilibrio baricentrico discreto
#L Paridade: in, vm, vmr, llvm,Root, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosPlanaresTutteSpringEmbedding) {
      println("==================================================")
      println("  SciAlgo: Tutte Spring Barycentric Embedding")
      println("==================================================")

      #L Fixando os 3 vertices da face externa em um triangulo convexo (escala x10):
      #L v1 = (0, 0)
      #L v2 = (60, 0)
      #L v3 = (30, 60)
      mut as int64: x1 = 0
      mut as int64: y1 = 0
      mut as int64: x2 = 60
      mut as int64: y2 = 0
      mut as int64: x3 = 30
      mut as int64: y3 = 60

      println("1. Vertices externos fixados no poligono convexo:")
      println("   v1: (" + x1 + ", " + y1 + ")")
      println("   v2: (" + x2 + ", " + y2 + ")")
      println("   v3: (" + x3 + ", " + y3 + ")")

      #L Vertice interior v4 conectado a v1, v2 e v3 (deg = 3)
      #L Pelo teorema de Tutte, sua posicao de equilibrio baricentrico e:
      #L x4 = (x1 + x2 + x3) /i 3
      #L y4 = (y1 + y2 + y3) /i 3
      mut as int64: x4 = (x1 + x2 + x3) /i 3
      mut as int64: y4 = (y1 + y2 + y3) /i 3

      println("2. Posicao de equilibrio do vertice interior v4:")
      println("   v4: (" + x4 + ", " + y4 + ")")

      #L Forcas de mola resultantes (devem somar 0 em x e em y):
      #L F_x = (x1 - x4) + (x2 - x4) + (x3 - x4)
      #L F_y = (y1 - y4) + (y2 - y4) + (y3 - y4)
      mut as int64: fx = (x1 - x4) + (x2 - x4) + (x3 - x4)
      mut as int64: fy = (y1 - y4) + (y2 - y4) + (y3 - y4)

      println("3. Verificacao de forcas de mola no equilibrio:")
      println("   Forca resultante em X: " + fx)
      println("   Forca resultante em Y: " + fy)

      #L Teste de contencao estrita no triangulo convexo:
      #L y4 > 0 e y4 < 60 e x4 > 0 e x4 < 60
      mut as bool: inside = (x4 > 0) and (x4 < 60) and (y4 > 0) and (y4 < 60)
      println("   v4 estritamente contido no interior da face externa: " + inside)

      mut as bool: valid = (fx == 0) and (fy == 0) and inside and (x4 == 30) and (y4 == 20)
      println("4. Validacao: " + valid)
      println("==================================================")
}
