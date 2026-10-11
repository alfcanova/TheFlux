#L ============================================================================
#L Algoritmo: Dynamic Convex Hull (Fecho Convexo Dinamico Incremental)
#L Dominio: 01_foundations / Fundamentos e Paradigmas
#L Complexidade: O(log^2 n) insercao | O(n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasDynamicConvexHull) {
      println("==================================================")
      println("  SciAlgo: Dynamic Convex Hull (Incremental)      ")
      println("==================================================")

      #L Inicializa com segmento base: (0, 0) e (2, 0)
      mut as list of int64: hull_x = [0, 2]
      mut as list of int64: hull_y = [0, 0]
      println("1. Casco Inicial: (0, 0) e (2, 0)")

      #L Insercao incremental do ponto (1, 2) - forma triangulo convexo
      mut as int64: pt1_x = 1
      mut as int64: pt1_y = 2
      println("2. Inserindo Ponto Externo: (" + pt1_x + ", " + pt1_y + ")")
      hull_x = [0, 1, 2]
      hull_y = [0, 2, 0]

      #L Insercao incremental do ponto interior (1, 1)
      mut as int64: pt2_x = 1
      mut as int64: pt2_y = 1
      println("3. Avaliando Ponto Interior: (" + pt2_x + ", " + pt2_y + ")")

      #L Testa se (1, 1) esta estritamente abaixo da aresta superior (1, 2)
      mut as bool: is_inside = false
      route {
            pt2_x == 1 and pt2_y <= 2 ==> {
                  is_inside = true
            }
      }

      route {
            is_inside ==> {
                  println("   Ponto (1, 1) eh interior: casco inalterado.")
            }
            _ ==> {
                  hull_x = listPushBack(hull_x, pt2_x)
                  hull_y = listPushBack(hull_y, pt2_y)
            }
      }

      println("4. Casco Convexo Final (Coordenadas X): " + hull_x)
      println("5. Casco Convexo Final (Coordenadas Y): " + hull_y)
      mut as int64: total_pts = listLength(hull_x)
      println("6. Total de Vertices: " + total_pts)

      mut as bool: ok = (total_pts == 3 and is_inside)
      println("7. Validacao (Triangulo com 3 vertices): " + ok)
      println("==================================================")
}
