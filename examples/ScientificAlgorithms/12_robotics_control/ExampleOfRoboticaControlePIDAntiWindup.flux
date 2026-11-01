#L ============================================================================
#L Algoritmo: Controle PID com Anti-Windup (Clamping de Saturacao de Atuador)
#L Dominio: 12_robotics_control / Categoria: Controle Classico e Feedback
#L Descricao: Prevencao de sobreacumulo integrador em motores e atuadores fisicos
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfRoboticaControlePIDAntiWindup) {
      println("=== Algoritmo: Controle PID com Anti-Windup ===")

      #L Ganhos do controlador PID: Kp = 2, Ki = 1, Kd = 1
      #L Limites fisicos de saturacao do motor: u_min = -100, u_max = +100
      mut as int64: kp = 2
      mut as int64: ki = 1
      mut as int64: kd = 1
      mut as int64: u_max = 100
      mut as int64: u_min = -100

      println("Ganhos: Kp=" + kp + ", Ki=" + ki + ", Kd=" + kd + " | Limites do atuador: [" + u_min + ", +" + u_max + "]")

      #L Acumulador integrador e erro anterior:
      mut as int64: integral_sum = 0
      mut as int64: prev_error = 0

      #L Ciclo 1: Erro grande e = 60
      #L Termo P = 2 * 60 = 120 (ja ultrapassa o limite do atuador 100 sozinho!)
      #L Se integrassemos sem protecao, o integrador acumularia erro inutil e causaria overshoot massivo.
      #L Termo D = (60 - 0) = 60
      #L u_proporcional_derivativo = 120 + 60 = 180
      mut as int64: e1 = 60
      mut as int64: p_term1 = kp * e1
      mut as int64: d_term1 = kd * (e1 - prev_error)
      mut as int64: u_tentativo = p_term1 + d_term1 + (ki * (integral_sum + e1))

      println("Ciclo 1: Erro e = " + e1 + ", Comando calculado sem saturacao u_tentativo = " + u_tentativo)

      #L Logica de Clamping Anti-Windup:
      #L Se o atuador satura (u_tentativo > u_max) E o erro tem o mesmo sinal (e1 > 0),
      #L o termo integrador congela (nao acumula e1):
      mut as bool: saturado = false
      mut as int64: u_final = u_tentativo
      route {
            u_tentativo > u_max ==> {
                  saturado = true
                  u_final = u_max
            }
      }

      route {
            saturado and e1 > 0 ==> {
                  #L Clamping ativado: nao adiciona ao acumulador integrador!
                  println("Anti-Windup ativado: Integrador congelado para evitar overshoot!")
            }
            not saturado ==> {
                  integral_sum = integral_sum + e1
            }
      }

      println("Comando final aplicado ao atuador u_final: " + u_final)
      println("Acumulador integrador protegido: " + integral_sum)

      route {
            u_final == 100 and integral_sum == 0 ==> {
                  println("PID Anti-Windup operando em conformidade com limites de atuacao fisica!")
            }
            _ ==> {
                  println("Falha no controle Anti-Windup")
            }
      }

      println("Controle PID com Anti-Windup concluido com sucesso.")
}
