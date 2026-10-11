#L ============================================================================
#L Algoritmo: Amplitude Amplification (Amplificacao Generalizada de Brassard-Hoyer)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(1/sqrt(p)) consultas para probabilidade de sucesso inicial p
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaAmplitudeAmplification) {
      println("==================================================")
      println("  SciAlgo: Quantum Amplitude Amplification")
      println("==================================================")

      #L Generalizacao de Grover (Brassard, Hoyer, Mosca, Tapp):
      #L Dado um estado inicial |Psi> = sin(theta)|Good> + cos(theta)|Bad>
      #L com probabilidade inicial de sucesso p_0 = sin^2(theta).
      #L O operador Q = - S_Psi S_chi rotaciona o vetor de estado em 2*theta a cada passo.

      #L Probabilidade inicial baixa: p_0 = 4% (0.04)
      #L sin(theta) = 0.200 (escalonado por 1000 = 200)
      #L cos(theta) = sqrt(1 - 0.04) = 0.980 (escalonado = 980)
      mut as int64: amp_good = 200
      mut as int64: amp_bad = 980

      println("1. Estado Inicial Arbitrario |Psi>:")
      println("   Amplitude Inicial |Good>: " + amp_good + "/1000")
      println("   Amplitude Inicial |Bad>:  " + amp_bad + "/1000")
      mut as int64: init_prob = (amp_good * amp_good) /i 1000
      println("   Probabilidade Inicial de Sucesso: " + init_prob + "/1000 (" + (init_prob /i 10) + "." + (init_prob /r 10) + "%)")

      #L Angulo theta ~ 0.201 radianos.
      #L A cada aplicacao de Q, theta_k = (2*k + 1) * theta
      #L Para atingir ~pi/2 (1.57 rad, prob ~ 100%), precisamos de k ~ 3 iteracoes.
      mut as int64: num_rotations = 3
      mut as int64: r = 1

      println("==================================================")
      println("2. Rotacoes Sucessivas pelo Operador Q = - S_Psi S_chi:")

      infinite (r <= num_rotations) {
            #L Aplicacao da reflexao do oraculo S_chi: inverte sinal de |Good>
            mut as int64: g1 = 0 - amp_good
            mut as int64: b1 = amp_bad

            #L Reflexao S_Psi em torno de |Psi>_0 = (200, 980):
            #L Produto interno <Psi_0 | Estado>:
            mut as int64: dot = ((200 * g1) + (980 * b1)) /i 1000

            #L 2 * dot * Psi_0 - Estado
            mut as int64: next_good = ((2 * dot * 200) /i 1000) - g1
            mut as int64: next_bad = ((2 * dot * 980) /i 1000) - b1

            amp_good = next_good
            amp_bad = next_bad

            mut as int64: cur_prob = (amp_good * amp_good) /i 1000
            println("   Iteracao #" + r + ": Amp|Good| = " + amp_good + "/1000 | Prob = " + (cur_prob /i 10) + "." + (cur_prob /r 10) + "%")

            r = r + 1
      }

      println("==================================================")
      println("3. Resultado Final da Amplificacao de Amplitude:")
      mut as int64: final_prob = (amp_good * amp_good) /i 1000
      println("   Probabilidade Final de Sucesso Apos " + num_rotations + " Passos: " + (final_prob /i 10) + "." + (final_prob /r 10) + "%")
      println("   Ganho de Aceleracao Quadratica: de 4.0% para > 95%")
      println("   Amplitude Amplification concluido com sucesso!")
      println("==================================================")
}
