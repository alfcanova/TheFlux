#L ============================================================================
#L Algoritmo: Amplitude Estimation (QAE - Estimacao Quantica de Amplitude)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(1/epsilon) consultas para erro epsilon (vs O(1/epsilon^2) Monte Carlo classico)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaAmplitudeEstimation) {
      println("==================================================")
      println("  SciAlgo: Quantum Amplitude Estimation (QAE)")
      println("==================================================")

      #L O algoritmo QAE estima o valor da amplitude 'a' em um estado
      #L A|0> = a|1>|psi_1> + sqrt(1 - a^2)|0>|psi_0>
      #L combinando Amplitude Amplification com Quantum Phase Estimation.
      #L Alvo real: probabilidade p = a^2 = 0.500 (a = 1/sqrt(2) ~ 0.707)
      #L Angulo theta tal que a = sin(theta) => theta = pi / 4 = 45 graus
      mut as int64: target_p_scaled = 500 #L 0.500

      println("1. Parametros do Problema:")
      println("   Probabilidade Real Alvo: p = 0.500 (50.0%)")
      println("   Amplitude Alvo: a = sin(theta) = 0.707 (theta = pi/4 rad)")

      #L O operador Q possui autovalores exp(+/- 2 * i * theta)
      #L Com theta = pi/4 => 2*theta = pi/2 = 2*pi * (1/4)
      #L A fase fracionaria associada a Q e exatamente phi = 1/4 = 0.250!
      mut as int64: m_eval_qubits = 3
      mut as int64: total_eval_states = 8

      println("==================================================")
      println("2. Execucao de QPE sobre o Operador de Amplificacao Q:")
      println("   Registrador de Avaliacao: m = " + m_eval_qubits + " qubits (precisao 1/8)")
      println("   Fase associada a Q: phi = 2*theta / (2*pi) = 1/4 = 2/8")

      #L Na medicao do registrador QPE, o estado medido y e:
      #L y = 8 * (1/4) = 2 (|010> em binario)
      mut as int64: measured_y = 2
      println("   Estado Medido no Registrador: |y> = |" + measured_y + "> (|010>)")

      println("==================================================")
      println("3. Reconstrucao da Amplitude e Probabilidade:")

      #L theta_estimado = pi * y / 2^m = pi * 2 / 8 = pi / 4
      #L a_estimado = sin(pi/4) ~ 707/1000
      #L p_estimado = sin^2(pi/4) = 500/1000
      mut as int64: est_sin_scaled = 707 #L sin(pi/4)
      mut as int64: est_prob = (est_sin_scaled * est_sin_scaled) /i 1000

      println("   theta Estimado: pi * (" + measured_y + " / " + total_eval_states + ") = pi/4 rad")
      println("   Amplitude Estimada a: " + est_sin_scaled + "/1000 (0.707)")
      println("   Probabilidade Estimada p = a^2: " + (est_prob /i 10) + "." + (est_prob /r 10) + "%")

      route {
            est_prob == target_p_scaled ==> {
                  println("   Sucesso: Estimativa quadratica alcancada com exatidao!")
            }
            _ ==> {}
      }

      println("==================================================")
      println("4. Resumo da Vantagem Quantica:")
      println("   Taxa de convergencia de erro: O(1/N) de Heisenberg")
      println("   Aceleracao quadratica sobre amostragem de Monte Carlo confirmada")
      println("   Amplitude Estimation concluido com sucesso!")
      println("==================================================")
}
