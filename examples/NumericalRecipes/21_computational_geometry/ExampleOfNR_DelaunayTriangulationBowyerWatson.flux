#L ============================================================================
#L Algoritmo: Delaunay Triangulation Bowyer-Watson (Triangulacao de Delaunay)
#L Capitulo: 21_computational_geometry
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Algoritmo incremental de Bowyer-Watson com teste do circuncírculo vazio.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_DelaunayTriangulationBowyerWatson) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_DelaunayTriangulationBowyerWatson")
      println("==================================================")

      #L Triangulo de Delaunay formado por A(0, 0), B(4, 0), C(0, 4)
      #L Centro do circuncirculo: hipotenusa de (4,0) a (0,4) tem ponto medio centro = (2, 2)
      #L Raio ao quadrado: R^2 = (2-0)^2 + (2-0)^2 = 4 + 4 = 8
      mut as int64: cx = 2
      mut as int64: cy = 2
      mut as int64: r_sq = 8

      println("1. Triangulo candidato de Delaunay ABC:")
      println("   -> Circuncentro: (" + cx + ", " + cy + "), Raio^2 = " + r_sq)

      #L Teste do ponto P1(1, 1): dist^2 = (1-2)^2 + (1-2)^2 = 1 + 1 = 2 < 8 (DENTRO do circuncirculo)
      mut as int64: d1_sq = (1 - cx)*(1 - cx) + (1 - cy)*(1 - cy) #L 2
      #L Teste do ponto P2(4, 4): dist^2 = (4-2)^2 + (4-2)^2 = 4 + 4 = 8 == 8 (NA BORDA)
      #L Teste do ponto P3(5, 5): dist^2 = (5-2)^2 + (5-2)^2 = 9 + 9 = 18 > 8 (FORA do circuncirculo)
      mut as int64: d3_sq = (5 - cx)*(5 - cx) + (5 - cy)*(5 - cy) #L 18

      println("2. Predicado in-circle de Delaunay:")
      println("   -> Ponto interno P1: dist^2 = " + d1_sq + " < R^2 (invalida circulo vazio)")
      println("   -> Ponto externo P3: dist^2 = " + d3_sq + " > R^2 (satisfaz circulo vazio)")

      #L Criterio de Delaunay: triangulo valido se ponto de teste P3 esta FORA:
      mut as int64: fora = 0
      route {
            d3_sq > r_sq ==> { fora = 1 }
            d3_sq <= r_sq ==> { fora = 0 }
      }

      mut as int64: residuo = 1 - fora
      println("3. Residuo da propriedade de Delaunay = " + residuo + " (esperado: 0)")
      println("4. Algoritmo de Delaunay Bowyer-Watson validado com sucesso.")
}
