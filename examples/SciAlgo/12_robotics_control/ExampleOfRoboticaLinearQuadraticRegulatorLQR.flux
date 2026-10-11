#L ============================================================================
#L Algoritmo: LQR — Linear Quadratic Regulator (Controle Otimo de Estado)
#L Dominio: 12_robotics_control / Categoria: Controle Otimo e Espaco de Estados
#L Descricao: Realimentacao otima de estados u = -K*x minimizando funcao de custo quadratica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaLinearQuadraticRegulatorLQR) {
      println("=== Algoritmo: LQR (Linear Quadratic Regulator) ===")

      #L Sistema escalar continuo de primeira ordem: dx/dt = a*x + b*u
      #L a = 1 (sistema instavel em malha aberta), b = 1
      #L Pesos de penalizacao quadratica da funcao de custo J = integral(q*x^2 + r*u^2):
      #L q = 3 (peso de erro de estado)
      #L r = 1 (peso de esforco de controle)
      mut as int64: a = 1
      mut as int64: b = 1
      mut as int64: q_weight = 3
      mut as int64: r_weight = 1

      println("Dinamica do sistema: dx/dt = " + a + "*x + " + b + "*u | Pesos: q = " + q_weight + ", r = " + r_weight)

      #L Equacao Algebrica de Riccati (ARE) escalar:
      #L 2*a*P - (b^2 / r)*P^2 + q = 0
      #L 2*1*P - (1 / 1)*P^2 + 3 = 0  ->  -P^2 + 2P + 3 = 0
      #L P^2 - 2P - 3 = 0  ->  (P - 3)*(P + 1) = 0
      #L Solucao positiva definida da matriz de Riccati: P = 3
      mut as int64: p_riccati = 3
      println("Solucao positiva definida da Equacao de Riccati: P = " + p_riccati)

      #L Ganho otimo de realimentacao de estado K:
      #L K = (b / r) * P = (1 / 1) * 3 = 3
      mut as int64: k_gain = (b * p_riccati) /i r_weight
      println("Ganho de realimentacao otimo LQR: K = " + k_gain)

      #L Dinamica em malha fechada: dx/dt = (a - b*K)*x = (1 - 1*3)*x = -2*x
      #L O polo em malha aberta (+1, instavel) foi deslocado otimamente para (-2, estavel!)
      mut as int64: closed_loop_pole = a - b * k_gain
      println("Polo em malha fechada: s = " + closed_loop_pole + " (estabilidade exponencial garantida)")

      #L Simulacao para estado inicial perturbado x0 = 10:
      #L Acao de controle u = -K * x = -3 * 10 = -30
      mut as int64: x0 = 10
      mut as int64: u0 = 0 - (k_gain * x0)
      println("Estado inicial x0 = " + x0 + " -> Comando de controle LQR u0 = " + u0)

      route {
            k_gain == 3 and closed_loop_pole == -2 ==> {
                  println("Regulador Linear Quadratico LQR otimizado e estabilizado com sucesso!")
            }
            _ ==> {
                  println("Falha na sintese LQR")
            }
      }

      println("LQR Linear Quadratic Regulator concluido com sucesso.")
}
