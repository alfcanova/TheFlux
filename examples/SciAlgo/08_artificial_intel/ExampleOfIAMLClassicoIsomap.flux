#L ============================================================================
#L Algoritmo: Isomap (Isometric Feature Mapping)
#L Dominio: 08_artificial_intel / Subdominio: Machine Learning Classico
#L Descricao: Reducao de dimensionalidade nao-linear via distancias geodesicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoIsomap) {
      println("=== Algoritmo: Isomap (Geodesic Manifold Learning) ===")

      #L Grafo de vizinhanca k-NN para 4 pontos em variedade curva (ex: Swiss Roll)
      #L Conexoes locais diretas:
      #L (1-2) = 2, (2-3) = 2, (3-4) = 2
      #L Distancia euclidiana direta 1-4 atraves do espaco vazio e enganosa (ex: 3)
      #L A verdadeira distancia na variedade curva passa por 1->2->3->4 = 6
      mut as int64: d12 = 2
      mut as int64: d23 = 2
      mut as int64: d34 = 2

      #L Floyd-Warshall para encontrar distancia geodesica mais curta ao longo da variedade
      mut as int64: geod13 = d12 + d23
      mut as int64: geod14 = geod13 + d34

      println("1. Distancia euclidiana direta (atalho espúrio): 3")
      println("2. Distancia geodesica Isomap (1 -> 3): " + geod13)
      println("3. Distancia geodesica Isomap (1 -> 4): " + geod14)

      #L Coordenada 1D resultante por MDS ao longo do manifold:
      #L pos(1) = 0, pos(2) = 2, pos(3) = 4, pos(4) = 6
      mut as int64: coord1 = 0
      mut as int64: coord4 = geod14

      println("4. Coordenada desdobrada no manifold 1D: P1=" + coord1 + ", P4=" + coord4)

      route {
            geod14 == 6 and coord4 > coord1 ==> {
                  println("5. Variedade desdobrada com preservacao geodesica com sucesso.")
            }
            _ ==> {
                  println("Falha no desdobramento Isomap.")
            }
      }
      println("Teste concluido com sucesso.")
}
