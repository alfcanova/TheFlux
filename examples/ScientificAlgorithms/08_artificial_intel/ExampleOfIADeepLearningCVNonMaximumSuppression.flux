#L ============================================================================
#L Algoritmo: Non-Maximum Suppression (NMS)
#L Dominio: 08_artificial_intel / Subdominio: Visao Computacional
#L Descricao: Filtragem gulosa de caixas delimitadoras redundantes por sobreposicao IoU
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVNonMaximumSuppression) {
      println("=== Algoritmo: Non-Maximum Suppression (NMS) ===")

      #L Caixa 1: score = 90, area = 100, coords [10, 10, 20, 20]
      #L Caixa 2 (duplicata sobreposta): score = 75, area = 100, coords [11, 11, 21, 21]
      #L Caixa 3 (objeto separado): score = 85, area = 100, coords [50, 50, 60, 60]

      #L Calculo de IoU entre Caixa 1 e Caixa 2:
      #L Intersecao: largura = 9, altura = 9 -> Area_inter = 81
      #L Uniao = Area1 + Area2 - Area_inter = 100 + 100 - 81 = 119
      #L IoU = (81 * 100) /i 119 = 68%
      mut as int64: inter12 = 81
      mut as int64: union12 = 119
      mut as int64: num_iou12 = inter12 * 100
      mut as int64: iou12 = num_iou12 /i union12

      #L IoU entre Caixa 1 e Caixa 3: 0%
      mut as int64: iou13 = 0

      #L Limiar de supressao IoU = 50%
      mut as int64: iou_threshold = 50

      #L Decisao NMS:
      #L Caixa 1 (score 90) e mantida.
      #L Caixa 2 tem IoU (68%) > 50% com Caixa 1 -> SUPRIMIDA!
      #L Caixa 3 tem IoU (0%) <= 50% com Caixa 1 -> MANTIDA!
      mut as int64: mantida_caixa1 = 1
      mut as int64: suprimida_caixa2 = 0
      route {
            iou12 > iou_threshold ==> {
                  suprimida_caixa2 = 1
            }
            _ ==> {}
      }

      mut as int64: mantida_caixa3 = 1

      println("1. Score Caixa 1: 90")
      println("2. Score Caixa 2: 75")
      println("3. IoU entre Caixa 1 e Caixa 2: " + iou12 + "%")
      println("4. Caixa 2 suprimida por sobreposicao redundante: " + suprimida_caixa2)
      println("5. Caixa 3 mantida independentemente: " + mantida_caixa3)

      route {
            iou12 == 68 and suprimida_caixa2 == 1 and mantida_caixa3 == 1 ==> {
                  println("6. Filtragem NMS executada com sucesso.")
            }
            _ ==> {
                  println("Falha na filtragem NMS.")
            }
      }
      println("Teste concluido com sucesso.")
}
