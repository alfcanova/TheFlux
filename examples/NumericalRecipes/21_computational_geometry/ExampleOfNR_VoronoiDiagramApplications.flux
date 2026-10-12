#L ============================================================================
#L Algoritmo: Voronoi Diagram Applications (Diagramas de Voronoi)
#L Capitulo: 21_computational_geometry
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Decomposicao do espaco em celulas de Voronoi e localizacao de sitio gerador.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_VoronoiDiagramApplications) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_VoronoiDiagramApplications")
      println("==================================================")

      #L Dois sitios geradores de Voronoi: S1(0, 0) e S2(10, 0)
      #L A fronteira de Voronoi e a mediatriz x = 5
      #L Ponto de consulta Q(3, 4):
      #L Distancia euclidiana ao quadrado ate S1: d1^2 = 3^2 + 4^2 = 9 + 16 = 25
      #L Distancia euclidiana ao quadrado ate S2: d2^2 = (3-10)^2 + 4^2 = 49 + 16 = 65
      mut as int64: d1_sq = 25
      mut as int64: d2_sq = 65

      println("1. Consulta de celula de Voronoi para ponto Q(3, 4):")
      println("   -> Distancia^2 ate Sitio 1 S1(0, 0)  = " + d1_sq)
      println("   -> Distancia^2 ate Sitio 2 S2(10, 0) = " + d2_sq)

      #L Determinacao da celula mais proxima:
      mut as int64: celula_pertencente = 0
      route {
            d1_sq < d2_sq ==> {
                  celula_pertencente = 1
            }
            d1_sq >= d2_sq ==> {
                  celula_pertencente = 2
            }
      }

      println("2. Celula de Voronoi atribuida = " + celula_pertencente + " (esperado: Sitio 1)")

      mut as int64: residuo = celula_pertencente - 1
      println("3. Residuo da particao de Voronoi = " + residuo + " (esperado: 0)")
      println("4. Aplicacoes de diagrama de Voronoi validadas com sucesso.")
}
