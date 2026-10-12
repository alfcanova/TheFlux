#L ============================================================================
#L Algoritmo: Metodo Multi-Passo Preditor-Corretor de Adams (PECE)
#L Capitulo: 17_differential_equations
#L Complexidade: O(N_passos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Adams-Bashforth explícito seguido de Adams-Moulton implícito.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_MultistepPredictorCorrectorAdams) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_MultistepPredictorCorrectorAdams")
      println("==================================================")

      #L Historico dos 4 ultimos passos para dy/dt = -y (escala 1000):
      #L y_n = 740, fn = -740, fn_1 = -818, fn_2 = -904, fn_3 = -1000
      mut as int64: y_n = 740
      mut as int64: fn0 = 0 - 740
      mut as int64: fn1 = 0 - 818
      mut as int64: fn2 = 0 - 904
      mut as int64: fn3 = 0 - 1000
      mut as int64: h = 100 #L 0.1

      println("1. Aplicando preditor de Adams-Bashforth de 4 passos:")
      #L dy_pred = (h / 24) * (55*fn - 59*fn1 + 37*fn2 - 9*fn3)
      mut as int64: num_p = (55 * fn0) - (59 * fn1) + (37 * fn2) - (9 * fn3)
      mut as int64: dy_pred = (h * num_p) /i 24000
      mut as int64: y_pred = y_n + dy_pred

      println("   -> y predito (Adams-Bashforth) = " + y_pred)

      #L Avaliacao intermediaria: fp = -y_pred
      mut as int64: fp = 0 - y_pred

      println("2. Aplicando corretor de Adams-Moulton:")
      #L dy_corr = (h / 24) * (9*fp + 19*fn0 - 5*fn1 + fn2)
      mut as int64: num_c = (9 * fp) + (19 * fn0) - (5 * fn1) + fn2
      mut as int64: dy_corr = (h * num_c) /i 24000
      mut as int64: y_corr = y_n + dy_corr

      println("   -> y corrigido (Adams-Moulton) = " + y_corr)

      #L Diferenca preditor-corretor |y_corr - y_pred|
      mut as int64: diff = y_corr - y_pred
      route {
            diff < 0 ==> {
                  diff = 0 - diff
            }
            diff >= 0 ==> {}
      }

      println("3. Discrepancia preditor-corretor = " + diff + " (deve ser <= 2)")
      mut as int64: residuo = 0
      route {
            diff <= 2 ==> {
                  residuo = 0
            }
            diff > 2 ==> {
                  residuo = diff
            }
      }

      println("4. Residuo do par Adams-Bashforth-Moulton = " + residuo + " (esperado: 0)")
      println("5. Algoritmo multi-passo concluido com sucesso.")
}
