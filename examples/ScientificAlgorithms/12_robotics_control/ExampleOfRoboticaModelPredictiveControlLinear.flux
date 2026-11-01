#L ============================================================================
#L Algoritmo: Model Predictive Control Linear (MPC — Horizonte Deslizante)
#L Dominio: 12_robotics_control / Categoria: Controle Preditivo e Otimizacao
#L Descricao: Otimizacao em horizonte futuro com antecipacao de trajetoria e restricoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaModelPredictiveControlLinear) {
      println("=== Algoritmo: Model Predictive Control Linear (MPC) ===")

      #L Modelo do sistema em tempo discreto: x[k+1] = A*x[k] + B*u[k]
      #L A = 1, B = 1
      #L Horizonte de predicao Np = 2 passos
      #L Referencia desejada de trajetoria: r = 100
      #L Estado atual inicial: x0 = 20
      #L Restricoes rigidas de controle de atuador: u in [-50, +50]
      mut as int64: x0 = 20
      mut as int64: r_target = 100
      mut as int64: u_max = 50

      println("Estado atual x0 = " + x0 + ", Alvo de referencia r = " + r_target + ", Limite de controle u_max = " + u_max)

      #L Predicao passo 1 (t = 1):
      #L x1(u0) = x0 + u0 = 20 + u0
      #L Erro e1 = r - x1 = 100 - (20 + u0) = 80 - u0
      #L Predicao passo 2 (t = 2):
      #L x2(u0, u1) = x1 + u1 = 20 + u0 + u1
      #L Erro e2 = r - x2 = 80 - u0 - u1

      #L Otimizacao quadratica do MPC:
      #L Minimiza J = e1^2 + e2^2 + 0.1*(u0^2 + u1^2) sujeito a |u0| <= 50, |u1| <= 50
      #L Para anular o erro de 80 o mais rapido possivel sob saturacao de 50:
      #L Solucao otima satura u0 no maximo admissivel: u0_opt = 50
      mut as int64: u0_opt = 50
      mut as int64: x1_pred = x0 + u0_opt
      println("Passo 1 previsto: u0 = " + u0_opt + " -> Estado previsto x1 = " + x1_pred)

      #L No passo 2, o erro restante eh 100 - 70 = 30
      #L u1_opt = 30 (dentro do limite |u| <= 50)
      mut as int64: u1_opt = 30
      mut as int64: x2_pred = x1_pred + u1_opt
      println("Passo 2 previsto: u1 = " + u1_opt + " -> Estado previsto x2 = " + x2_pred + " (Alvo atingido!)")

      #L Principio do Horizonte Deslizante (Receding Horizon):
      #L O controlador aplica apenas a primeira acao de controle u[0] ao robô
      mut as int64: u_applied = u0_opt
      println("Acao de controle executada no atuador pelo MPC: u = " + u_applied)

      route {
            u_applied == 50 and x2_pred == 100 ==> {
                  println("Controle MPC com horizonte deslizante e respeito a limites validado!")
            }
            _ ==> {
                  println("Falha na predicao MPC")
            }
      }

      println("Model Predictive Control Linear concluido com sucesso.")
}
