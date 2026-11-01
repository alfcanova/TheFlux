#L ============================================================================
#L Algoritmo: Monotone Chain Convex Hull (Andrew's Algorithm)
#L Dominio: 01_foundations / Fundamentos e Paradigmas
#L Complexidade: O(n log n) tempo | O(n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasMonotoneChain) {
      println("==================================================")
      println("  SciAlgo: Monotone Chain Convex Hull (Andrew)    ")
      println("==================================================")

      #L 5 pontos 2D previamente ordenados por (x, y):
      #L (0,0), (0,2), (1,1), (2,0), (2,2)
      mut as list of int64: px = [0, 0, 1, 2, 2]
      mut as list of int64: py = [0, 2, 1, 0, 2]
      mut as int64: n = 5
      println("1. Pontos de Entrada: (0,0), (0,2), (1,1), (2,0), (2,2)")

      #L Casco Inferior
      mut as list of int64: hull_lower = []
      mut as int64: i = 1
      infinite (i <= n) {
            mut as bool: pruning = true
            infinite (pruning) {
                  mut as int64: k = listLength(hull_lower)
                  route {
                        k >= 2 ==> {
                              mut as int64: p1 = hull_lower[k - 1]
                              mut as int64: p2 = hull_lower[k]
                              mut as int64: cross = (px[p2] - px[p1]) * (py[i] - py[p1]) - (py[p2] - py[p1]) * (px[i] - px[p1])
                              route {
                                    cross <= 0 ==> {
                                          hull_lower = listSlice(hull_lower, 1, k - 1)
                                    }
                                    _ ==> {
                                          pruning = false
                                    }
                              }
                        }
                        _ ==> {
                              pruning = false
                        }
                  }
            }
            hull_lower = listPushBack(hull_lower, i)
            i = i + 1
      }

      #L Casco Superior
      mut as list of int64: hull_upper = []
      i = n
      infinite (i >= 1) {
            mut as bool: pruning = true
            infinite (pruning) {
                  mut as int64: k = listLength(hull_upper)
                  route {
                        k >= 2 ==> {
                              mut as int64: p1 = hull_upper[k - 1]
                              mut as int64: p2 = hull_upper[k]
                              mut as int64: cross = (px[p2] - px[p1]) * (py[i] - py[p1]) - (py[p2] - py[p1]) * (px[i] - px[p1])
                              route {
                                    cross <= 0 ==> {
                                          hull_upper = listSlice(hull_upper, 1, k - 1)
                                    }
                                    _ ==> {
                                          pruning = false
                                    }
                              }
                        }
                        _ ==> {
                              pruning = false
                        }
                  }
            }
            hull_upper = listPushBack(hull_upper, i)
            i = i - 1
      }

      #L Total de vertices no fecho convexo (removendo repeticao dos extremos)
      mut as int64: hull_vertices = (listLength(hull_lower) - 1) + (listLength(hull_upper) - 1)
      println("2. Vertices do Casco Inferior: " + hull_lower)
      println("3. Vertices do Casco Superior: " + hull_upper)
      println("4. Total de Vertices do Fecho Convexo: " + hull_vertices)

      #L Fecho eh o poligono convexo formado por (0,0), (2,0), (2,2), (0,2) -> 4 vertices
      mut as bool: ok = (hull_vertices == 4)
      println("5. Validacao (4 vertices no poligono convexo): " + ok)
      println("==================================================")
}
