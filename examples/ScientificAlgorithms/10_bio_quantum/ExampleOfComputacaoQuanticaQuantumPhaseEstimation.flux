#L ============================================================================
#L Algoritmo: Quantum Phase Estimation (QPE - Estimacao de Fase Quantica)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(t^2) portas com t qubits de medicao para precisao 2^(-t)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaQuantumPhaseEstimation) {
      println("==================================================")
      println("  SciAlgo: Quantum Phase Estimation (QPE)")
      println("==================================================")

      #L O algoritmo QPE estima a fase theta de um autovalor exp(2*pi*i*theta)
      #L de um operador unitario U agindo sobre um autoestado |psi>:
      #L U |psi> = exp(2 * pi * i * theta) |psi>
      #L Usamos t = 3 qubits de precisao (permite estimar 2^3 = 8 valores discretos)
      #L Fase real alvo a ser estimada: theta = 3/8 = 0.375 (binario 0.011_2)
      mut as int64: t_qubits = 3
      mut as int64: n_levels = 8
      mut as int64: target_phase_numerator = 3 #L 3/8

      println("1. Parametros do Circuito QPE:")
      println("   Registrador de Avaliacao: t = " + t_qubits + " qubits")
      println("   Fase Alvo a Estimar: theta = " + target_phase_numerator + "/8 = 0.375")

      println("==================================================")
      println("2. Aplicacao das Portas Unitarias Controladas-U^(2^k):")

      #L Para cada qubit k in 0..2 do registrador de medicao:
      #L Qubit 0 (Lsb): aplica U^(2^0) = U^1 -> injeta fase 2*pi*(3/8)*1 = 2*pi*(3/8)
      #L Qubit 1:      aplica U^(2^1) = U^2 -> injeta fase 2*pi*(3/8)*2 = 2*pi*(6/8)
      #L Qubit 2 (Msb): aplica U^(2^2) = U^4 -> injeta fase 2*pi*(3/8)*4 = 2*pi*(12/8) = 2*pi*(4/8)
      mut as int64: k = 0
      infinite (k < t_qubits) {
            mut as int64: power_two = 1
            mut as int64: p = 0
            infinite (p < k) {
                  power_two = power_two * 2
                  p = p + 1
            }
            mut as int64: phase_k = (target_phase_numerator * power_two) /r n_levels
            println("   Qubit k=" + k + ": Porta Controlada U^" + power_two + " -> Fase Injetada = " + phase_k + "/8 * 2pi")
            k = k + 1
      }

      println("==================================================")
      println("3. Aplicacao da Transformada de Fourier Quantica Inversa (QFT^dagger):")
      println("   A QFT inversa converte a superposicao de fases codificadas")
      println("   diretamente no estado da base computacional |2^t * theta>.")

      #L O estado resultante e |2^3 * theta> = |8 * (3/8)> = |3> (|011>)
      mut as int64: expected_state = target_phase_numerator
      println("   Estado esperado no registrador de avaliacao: |" + expected_state + "> (|011>)")

      #L Decomposicao dos bits medidos (theta_1, theta_2, theta_3):
      mut as int64: b0 = expected_state /i 4
      mut as int64: b1 = (expected_state /r 4) /i 2
      mut as int64: b2 = expected_state /r 2

      println("==================================================")
      println("4. Medicao e Estimativa da Fase:")
      println("   Bits Medidos: [" + b0 + ", " + b1 + ", " + b2 + "]")
      println("   Fase Fracionaria Estimada: 0." + b0 + b1 + b2 + "_2")
      mut as int64: estimated_scaled = (expected_state * 1000) /i n_levels
      println("   Valor Decimal da Fase: 0." + estimated_scaled + " (Exato: 0.375)")
      println("   Quantum Phase Estimation concluido com sucesso!")
      println("==================================================")
}
