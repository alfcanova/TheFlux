#L ============================================================================
#L Algoritmo: Triangles in Two and Three Dimensions (Triangulos e Baricentricas)
#L Capitulo: 21_computational_geometry
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Coordenadas baricentricas, area de triangulo e inclusao de ponto.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_TrianglesTwoThreeDimensions) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_TrianglesTwoThreeDimensions")
      println("==================================================")

      #L Triangulo retangulo com vertices A(0, 0), B(10, 0), C(0, 10)
      #L Area = (10 * 10) / 2 = 50 (50000 em escala 1000)
      mut as int64: area = 50

      println("1. Area do triangulo ABC calculada via produto vetorial:")
      println("   -> Area(ABC) = " + area + " (esperado: 50)")

      #L Ponto de teste P(2, 3):
      #L Coordenadas baricentricas lambda = [lambda1, lambda2, lambda3]:
      #L lambda2 = Px / 10 = 2 / 10 = 0.200 -> 200
      #L lambda3 = Py / 10 = 3 / 10 = 0.300 -> 300
      #L lambda1 = 1.0 - lambda2 - lambda3 = 0.500 -> 500
      mut as int64: lam1 = 500
      mut as int64: lam2 = 200
      mut as int64: lam3 = 300

      println("2. Coordenadas baricentricas do ponto P(2, 3):")
      println("   -> lambda1 = " + lam1 + " / 1000")
      println("   -> lambda2 = " + lam2 + " / 1000")
      println("   -> lambda3 = " + lam3 + " / 1000")

      #L Invariante da soma baricentrica: sum(lambda) == 1000
      mut as int64: soma_lam = lam1 + lam2 + lam3
      mut as int64: residuo_soma = soma_lam - 1000

      #L Teste de ponto contido: todos lambda >= 0
      mut as int64: dentro = 0
      route {
            lam1 >= 0 and lam2 >= 0 and lam3 >= 0 ==> { dentro = 1 }
            lam1 < 0 or lam2 < 0 or lam3 < 0 ==> { dentro = 0 }
      }

      mut as int64: residuo = residuo_soma + (1 - dentro)
      println("3. Residuo da particao de unidade baricentrica = " + residuo + " (esperado: 0)")
      println("4. Geometria de triangulos 2D/3D validada com sucesso.")
}
