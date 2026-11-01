#L ============================================================================
#L Algoritmo: DPO (Direct Preference Optimization)
#L Dominio: 08_artificial_intel / Subdominio: Modelos Generativos e Alinhamento
#L Descricao: Alinhamento de preferencias de LLMs sem necessidade de Reward Model explicito
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaDirectPreferenceOptimization) {
      println("=== Algoritmo: DPO (Direct Preference Optimization) ===")

      #L Par de respostas para o prompt x:
      #L y_w: resposta preferida (vencedora)
      #L y_l: resposta rejeitada (perdedora)

      #L Log-probabilidades sob a politica de referencia pi_ref (escala x10):
      #L log pi_ref(y_w | x) = -15
      #L log pi_ref(y_l | x) = -18
      mut as int64: log_ref_w = 0 - 15
      mut as int64: log_ref_l = 0 - 18

      #L Log-probabilidades sob a politica treinada pi_theta:
      #L log pi_theta(y_w | x) = -10 (aumentou probabilidade do vencedor)
      #L log pi_theta(y_l | x) = -25 (diminuiu probabilidade do perdedor)
      mut as int64: log_theta_w = 0 - 10
      mut as int64: log_theta_l = 0 - 25

      #L Parametro de regularizacao beta = 1 (escala x1)
      #L Razao implicita de recompensa r_hat(x, y) = beta * (log pi_theta - log pi_ref)
      #L r_hat_w = (-10) - (-15) = +5
      #L r_hat_l = (-25) - (-18) = -7
      mut as int64: r_hat_w = log_theta_w - log_ref_w
      mut as int64: r_hat_l = log_theta_l - log_ref_l

      #L Margem de recompensa implicita entre vencedor e perdedor:
      #L margin = r_hat_w - r_hat_l = 5 - (-7) = 12
      mut as int64: margin = r_hat_w - r_hat_l

      println("1. Recompensa implicita da resposta escolhida (r_hat_w): " + r_hat_w)
      println("2. Recompensa implicita da resposta rejeitada (r_hat_l): " + r_hat_l)
      println("3. Margem preferencial DPO acumulada: " + margin)

      route {
            r_hat_w > 0 and r_hat_l < 0 and margin == 12 ==> {
                  println("4. Otimizacao direta por preferencias DPO validada com sucesso.")
            }
            _ ==> {
                  println("Falha no alinhamento DPO.")
            }
      }
      println("Teste concluido com sucesso.")
}
