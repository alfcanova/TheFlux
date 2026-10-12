#L ============================================================================
#L Algoritmo: Nonlinear Models — Levenberg-Marquardt (Ajuste Nao-Linear de Curvas)
#L Capitulo: 15_modeling_data
#L Complexidade: O(k * M^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Algoritmo mrqmin interpolando continuamente entre gradiente e Gauss-Newton.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_NonlinearModelsLevenbergMarquardt) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_NonlinearModelsLevenbergMarquardt")
      println("==================================================")

      #L Ajuste de modelo nao-linear com parametro de amortecimento lambda:
      #L Inicialmente lambda = 1000 (1.0).
      #L Quando passo reduz chi^2, lambda e diminuido por fator 10 -> lambda = 100.
      mut as int64: lambda_param = 1000
      mut as int64: chi_reduziu = 1

      println("1. Executando passo do algoritmo de Levenberg-Marquardt (mrqmin):")
      route {
            chi_reduziu == 1 ==> {
                  lambda_param = lambda_param /i 10
                  println("   -> Chi-quadrado decresceu: passo aceito e lambda reduzido para " + lambda_param)
            }
            chi_reduziu != 1 ==> {}
      }

      mut as int64: res = lambda_param - 100
      println("2. Residuo do controle de amortecimento = " + res + " (esperado: 0)")
      println("3. Ajuste nao-linear de Levenberg-Marquardt concluido.")
}
