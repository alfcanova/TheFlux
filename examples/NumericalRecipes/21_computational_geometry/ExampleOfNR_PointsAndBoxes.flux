#L ============================================================================
#L Algoritmo: Points and Boxes (Testes Geometricos Basicos e AABB)
#L Capitulo: 21_computational_geometry
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Teste de ponto contido em caixa AABB e intersecao de caixas delimitadoras.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_PointsAndBoxes) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_PointsAndBoxes")
      println("==================================================")

      #L Caixa AABB 1: [xmin=10, ymin=10, xmax=50, ymax=50]
      #L Ponto de teste P: (x=30, y=25)
      mut as int64: box_xmin = 10
      mut as int64: box_ymin = 10
      mut as int64: box_xmax = 50
      mut as int64: box_ymax = 50

      mut as int64: px = 30
      mut as int64: py = 25

      println("1. Testando ponto P(" + px + ", " + py + ") em caixa [" + box_xmin + ", " + box_ymin + "] a [" + box_xmax + ", " + box_ymax + "]:")

      #L Teste de inclusao: xmin <= px <= xmax and ymin <= py <= ymax
      mut as int64: dentro = 0
      route {
            px >= box_xmin and px <= box_xmax and py >= box_ymin and py <= box_ymax ==> {
                  dentro = 1
            }
            px < box_xmin or px > box_xmax or py < box_ymin or py > box_ymax ==> {
                  dentro = 0
            }
      }

      println("   -> Ponto contido dentro da caixa = " + dentro + " (esperado: 1)")

      #L Teste de intersecao entre Caixa A e Caixa B:
      #L Caixa B: [xmin=40, ymin=40, xmax=80, ymax=80] -> Intersecao valida em [40, 50]
      mut as int64: bx_min = 40
      mut as int64: by_min = 40
      mut as int64: bx_max = 80
      mut as int64: by_max = 80

      mut as int64: intercepta = 0
      route {
            box_xmin <= bx_max and box_xmax >= bx_min and box_ymin <= by_max and box_ymax >= by_min ==> {
                  intercepta = 1
            }
            box_xmin > bx_max or box_xmax < bx_min or box_ymin > by_max or box_ymax < by_min ==> {
                  intercepta = 0
            }
      }

      println("2. Testando intersecao de AABB:")
      println("   -> Caixas interceptam = " + intercepta + " (esperado: 1)")

      mut as int64: residuo = (1 - dentro) + (1 - intercepta)
      println("3. Residuo dos predicados geometricos = " + residuo + " (esperado: 0)")
      println("4. Testes de pontos e caixas concluidos com sucesso.")
}
