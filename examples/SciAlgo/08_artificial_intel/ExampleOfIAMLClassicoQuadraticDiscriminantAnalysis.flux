#L ============================================================================
#L Algoritmo: QDA (Quadratic Discriminant Analysis)
#L Dominio: 08_artificial_intel / Subdominio: Machine Learning Classico
#L Descricao: Classificacao com fronteira quadratica e covariancias heterogeneas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoQuadraticDiscriminantAnalysis) {
      println("=== Algoritmo: QDA (Quadratic Discriminant Analysis) ===")

      #L Ponto de consulta x = [4, 5]
      mut as int64: x = 4
      mut as int64: y = 5

      #L Classe 1: mu1 = [2, 2], covariancia diagonal Sigma1 = diag(1, 1)
      mut as int64: dx1 = x - 2
      mut as int64: dy1 = y - 2
      mut as int64: mahalanobis1 = dx1 * dx1 + dy1 * dy1

      #L Classe 2: mu2 = [6, 6], covariancia diagonal Sigma2 = diag(4, 4)
      #L Inversa da variancia escala 1/4 (multiplicado por 100 -> 25)
      mut as int64: dx2 = x - 6
      mut as int64: dy2 = y - 6
      mut as int64: mahalanobis2_scaled = (dx2 * dx2 + dy2 * dy2) * 25

      #L Escala de mahalanobis1 por 100
      mut as int64: mahalanobis1_scaled = mahalanobis1 * 100

      #L Termo de determinante log|Sigma| aproximado (C1: 0, C2: log(16)*50 ~ 138)
      mut as int64: logdet1 = 0
      mut as int64: logdet2 = 138

      #L Score quadrático (menor e melhor): D_k = Mahalanobis_scaled + logdet
      mut as int64: score1 = mahalanobis1_scaled + logdet1
      mut as int64: score2 = mahalanobis2_scaled + logdet2

      println("1. Mahalanobis ponderado Classe 1: " + score1)
      println("2. Mahalanobis ponderado Classe 2: " + score2)

      #L Predicao
      mut as int64: classePredita = 1
      route {
            score2 < score1 ==> { classePredita = 2 }
            _ ==> { classePredita = 1 }
      }
      println("3. Classe predita via fronteira quadratica: " + classePredita)

      route {
            classePredita == 2 ==> {
                  println("4. Classificacao QDA com covariancia variavel validada.")
            }
            _ ==> {
                  println("Falha no calculo discriminante QDA.")
            }
      }
      println("Teste concluido com sucesso.")
}
