#L ============================================================================
#L Algoritmo: LDA (Linear Discriminant Analysis)
#L Dominio: 08_artificial_intel / Subdominio: Machine Learning Classico
#L Descricao: Reducao de dimensionalidade e classificacao com maximizacao da razao Fisher
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoLinearDiscriminantAnalysis) {
      println("=== Algoritmo: LDA (Linear Discriminant Analysis) ===")

      #L Medias das classes 1 e 2 em 2 dimensoes
      #L Classe 1: mu1 = [2, 3]
      #L Classe 2: mu2 = [6, 7]
      mut as int64: mu1_x = 2
      mut as int64: mu1_y = 3
      mut as int64: mu2_x = 6
      mut as int64: mu2_y = 7

      #L Diferenca entre as medias: d = mu1 - mu2 = [-4, -4]
      mut as int64: diff_x = mu1_x - mu2_x
      mut as int64: diff_y = mu1_y - mu2_y

      #L Dispersao intra-classe (Within-class scatter Sw): assumindo isotropica simplificada Sw = 2 * I
      #L Vetor de projecao w = Sw^(-1) * (mu1 - mu2) proporcional a diff
      mut as int64: w_x = diff_x
      mut as int64: w_y = diff_y

      println("1. Vetor de diferenca entre centros: (" + diff_x + ", " + diff_y + ")")
      println("2. Vetor discriminante de projecao w: (" + w_x + ", " + w_y + ")")

      #L Projecao de um ponto de teste p = [1, 2] (pertencente a classe 1)
      #L proj = p_x * w_x + p_y * w_y
      mut as int64: px = 1
      mut as int64: py = 2
      mut as int64: prod1 = px * w_x
      mut as int64: prod2 = py * w_y
      mut as int64: proj = prod1 + prod2

      #L Projecao dos centros de classe
      mut as int64: c1_prod1 = mu1_x * w_x
      mut as int64: c1_prod2 = mu1_y * w_y
      mut as int64: proj_c1 = c1_prod1 + c1_prod2

      mut as int64: c2_prod1 = mu2_x * w_x
      mut as int64: c2_prod2 = mu2_y * w_y
      mut as int64: proj_c2 = c2_prod1 + c2_prod2

      println("3. Projecao escalar do centro C1: " + proj_c1)
      println("4. Projecao escalar do centro C2: " + proj_c2)
      println("5. Projecao do ponto de teste: " + proj)

      #L Ponto de teste mais proximo da projecao de C1
      mut as int64: dist1 = proj - proj_c1
      route {
            dist1 < 0 ==> { dist1 = 0 - dist1 }
            _ ==> {}
      }
      mut as int64: dist2 = proj - proj_c2
      route {
            dist2 < 0 ==> { dist2 = 0 - dist2 }
            _ ==> {}
      }

      route {
            dist1 < dist2 ==> {
                  println("6. Ponto classificado corretamente como Classe 1 via LDA.")
            }
            _ ==> {
                  println("Classificacao incorreta.")
            }
      }
      println("Teste concluido com sucesso.")
}
