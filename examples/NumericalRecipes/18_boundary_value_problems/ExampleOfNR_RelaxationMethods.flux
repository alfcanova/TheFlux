#L ============================================================================
#L Algoritmo: Metodos de Relaxacao para BVPs (Relaxation Methods)
#L Capitulo: 18_boundary_value_problems
#L Complexidade: O(N_malha * N_iter)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao de sistema de diferencas finitas por relaxacao iterativa simultanea.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_RelaxationMethods) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_RelaxationMethods")
      println("==================================================")

      #L Malha de 5 pontos: [y0, y1, y2, y3, y4]
      #L Equacao: y'' = 0 com y0 = 0 e y4 = 1000
      #L Solucao analitica nos nos internos: y1 = 250, y2 = 500, y3 = 750
      #L Valores iniciais chutados nos nos internos: [0, 0, 0]
      mut as list of int64: y = [0, 0, 0, 0, 1000]

      println("1. Malha inicial antes da relaxacao:")
      println("   -> y = [" + y[1] + ", " + y[2] + ", " + y[3] + ", " + y[4] + ", " + y[5] + "]")

      mut as int64: iter = 1
      infinite (iter <= 15) {
            #L Relaxacao de Gauss-Seidel no no 2: y[2] = (y[1] + y[3]) / 2
            y[2] = (y[1] + y[3]) /i 2
            #L Relaxacao no no 3: y[3] = (y[2] + y[4]) / 2
            y[3] = (y[2] + y[4]) /i 2
            #L Relaxacao no no 4: y[4] = (y[3] + y[5]) / 2
            y[4] = (y[3] + y[5]) /i 2

            iter = iter + 1
      }

      println("2. Malha apos 15 iteracoes de relaxacao:")
      println("   -> y = [" + y[1] + ", " + y[2] + ", " + y[3] + ", " + y[4] + ", " + y[5] + "]")

      #L Verificacao de convergencia para a reta analitica [0, 250, 500, 750, 1000]:
      mut as int64: d1 = y[2] - 250
      mut as int64: d2 = y[3] - 500
      mut as int64: d3 = y[4] - 750
      route {
            d1 < 0 ==> { d1 = 0 - d1 }
            d1 >= 0 ==> {}
      }
      route {
            d2 < 0 ==> { d2 = 0 - d2 }
            d2 >= 0 ==> {}
      }
      route {
            d3 < 0 ==> { d3 = 0 - d3 }
            d3 >= 0 ==> {}
      }

      mut as int64: max_err = d1
      route {
            d2 > max_err ==> { max_err = d2 }
            d2 <= max_err ==> {}
      }
      route {
            d3 > max_err ==> { max_err = d3 }
            d3 <= max_err ==> {}
      }

      println("3. Erro maximo em relacao a solucao exata = " + max_err + " (tolerancia <= 5)")
      mut as int64: residuo = 0
      route {
            max_err <= 5 ==> { residuo = 0 }
            max_err > 5 ==> { residuo = max_err }
      }

      println("4. Residuo do metodo de relaxacao = " + residuo + " (esperado: 0)")
      println("5. Metodo de relaxacao para BVPs concluido com exito.")
}
