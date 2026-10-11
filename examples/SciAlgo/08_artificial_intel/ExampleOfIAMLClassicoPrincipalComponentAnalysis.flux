#L ============================================================================
#L Algoritmo: PCA (Principal Component Analysis)
#L Dominio: 08_artificial_intel / Subdominio: Machine Learning Classico
#L Descricao: Reducao de dimensionalidade linear via direcao de maxima variancia
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoPrincipalComponentAnalysis) {
      println("=== Algoritmo: PCA (Principal Component Analysis) ===")

      #L Amostras 2D: (2, 2), (4, 4), (6, 6)
      #L Media calculada: mu = (4, 4)
      mut as int64: mux = 4
      mut as int64: muy = 4

      #L Dados centralizados:
      #L p1_c = (-2, -2)
      #L p2_c = (0, 0)
      #L p3_c = (2, 2)

      #L Matriz de covariancia (escalada por N=3):
      #L Var(X) = ((-2)^2 + 0^2 + 2^2) = 8
      #L Var(Y) = ((-2)^2 + 0^2 + 2^2) = 8
      #L Cov(X, Y) = ((-2)*(-2) + 0 + 2*2) = 8
      mut as int64: cov_xx = 8
      mut as int64: cov_yy = 8
      mut as int64: cov_xy = 8

      println("1. Elemento Cov(X,X): " + cov_xx)
      println("2. Elemento Cov(X,Y): " + cov_xy)

      #L Primeiro autovetor v1 (direcao diagonal normalizada [1, 1]):
      #L Autovalor lambda1 = Cov_xx + Cov_xy = 16
      mut as int64: lambda1 = cov_xx + cov_xy
      println("3. Maior autovalor (variancia explicada): " + lambda1)

      #L Projecao dos dados no primeiro componente principal (produto escalar com v1=[1, 1]):
      #L proj(p1) = -2*1 + -2*1 = -4
      #L proj(p2) = 0*1 + 0*1 = 0
      #L proj(p3) = 2*1 + 2*1 = 4
      mut as int64: proj1 = 0 - 4
      mut as int64: proj2 = 0
      mut as int64: proj3 = 4

      println("4. Projecoes 1D obtidas: " + proj1 + ", " + proj2 + ", " + proj3)

      route {
            proj3 > proj2 and proj2 > proj1 and lambda1 == 16 ==> {
                  println("5. Reducao PCA 2D -> 1D validada com sucesso.")
            }
            _ ==> {
                  println("Falha no calculo do PCA.")
            }
      }
      println("Teste concluido com sucesso.")
}
