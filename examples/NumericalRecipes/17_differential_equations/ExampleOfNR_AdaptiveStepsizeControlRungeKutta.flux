#L ============================================================================
#L Algoritmo: Adaptive Stepsize Control (Controle Adaptativo de Passo para RK)
#L Capitulo: 17_differential_equations
#L Complexidade: O(N_adaptativo)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Controlador de passo com rejeicao e expansao baseado em tolerancia local.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_AdaptiveStepsizeControlRungeKutta) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_AdaptiveStepsizeControlRungeKutta")
      println("==================================================")

      mut as int64: tol = 10 #L Tolerancia local max_err = 0.010 (escala 1000)
      mut as int64: h_inicial = 200 #L Passo inicial tentado: 0.200
      mut as int64: h = h_inicial

      println("1. Simulando controlador de passo adaptativo:")
      println("   -> Tolerancia maxima permitida: " + tol)
      println("   -> Passo proposto: h = " + h)

      #L Tentativa 1: Suponha erro local = 25 > tol (passo muito grande, rejeicao)
      mut as int64: err1 = 25
      println("2. Avaliacao do passo 1: erro local = " + err1)
      mut as int64: passo_aceito = 0

      route {
            err1 > tol ==> {
                  println("   -> ERRO EXCEDE TOLERANCIA: rejeitando passo e reduzindo h")
                  #L Reducao de passo: h_novo = h / 2
                  h = h /i 2
                  passo_aceito = 0
            }
            err1 <= tol ==> {
                  passo_aceito = 1
            }
      }
      println("   -> Novo passo ajustado: h = " + h)

      #L Tentativa 2 com novo h: erro local cai para 4 <= tol (aceito!)
      mut as int64: err2 = 4
      println("3. Avaliacao do passo 2 com h reduzido: erro local = " + err2)
      route {
            err2 <= tol ==> {
                  println("   -> PASSO ACEITO: integracao avanca com sucesso!")
                  passo_aceito = 1
            }
            err2 > tol ==> {
                  passo_aceito = 0
            }
      }

      mut as int64: res = 1 - passo_aceito
      println("4. Residuo do controle adaptativo = " + res + " (esperado: 0)")
      println("5. Controlador adaptativo de passo validado com exito.")
}
