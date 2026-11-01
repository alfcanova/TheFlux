#L ============================================================================
#L Algoritmo: Iterative Quantum Phase Estimation (IQPE - Estimacao de Fase Iterativa)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(m) iteracoes usando apenas 1 qubit auxiliar de medicao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaIterativePhaseEstimation) {
      println("==================================================")
      println("  SciAlgo: Iterative Quantum Phase Estimation (IQPE)")
      println("==================================================")

      #L Diferente do QPE padrao que requer m qubits de medicao em paralelo,
      #L o algoritmo IQPE (Kitaev) utiliza recursivamente um UNICO qubit
      #L ancilar de medicao, extraindo a fase bit a bit do menos significativo
      #L (LSB) ao mais significativo (MSB) com retroalimentacao classica (feedback).
      #L
      #L Suponha que o operador U possua autoestado |psi> com autovalor:
      #L U |psi> = exp(2 * pi * i * theta) |psi>
      #L Fase real alvo: theta = 5/8 = 0.625 (representacao binaria: 0.101_2)
      #L Precisao desejada: m = 3 bits (theta_1, theta_2, theta_3)

      mut as int64: m_bits = 3
      mut as int64: target_num = 5
      mut as int64: target_den = 8

      println("1. Parametros do Algoritmo IQPE:")
      println("   Qubits ancilares necessarios: 1 unico qubit (resetado a cada ciclo)")
      println("   Fase Alvo Teórica: theta = " + target_num + "/" + target_den + " = 0.625")
      println("   Bits binarios esperados: [1, 0, 1] (0.101_2)")

      #L Vetor para armazenar os bits medidos [theta_1, theta_2, theta_3]
      mut as list of int64: measured_bits = [0, 0, 0]

      println("==================================================")
      println("2. Execucao Iterativa (do LSB k=3 ao MSB k=1):")

      #L --- Iteracao 3 (k = 3, LSB theta_3) ---
      #L 1. Ancilla inicializado em |+>
      #L 2. Aplica U^(2^(3-1)) = U^4
      #L    Fase injetada: 4 * (5/8) * 2pi = 2.5 * 2pi = 5pi = pi mod 2pi
      #L 3. Fase de correcao omega_3 = 0 (sem bits anteriores)
      #L 4. Fase liquida = pi. Ancilla colapsa em |->. Apos H, medicao = 1.
      measured_bits[3] = 1
      println("   Iteracao k=3 (LSB):")
      println("     - Porta controlada: U^4 (Fase = 4 * 5/8 * 2pi = 5pi = pi)")
      println("     - Correcao de fase classica: omega_3 = 0")
      println("     - Medicao do qubit ancilar: theta_3 = " + measured_bits[3])

      #L --- Iteracao 2 (k = 2, bit intermediario theta_2) ---
      #L 1. Ancilla resetado para |+>
      #L 2. Aplica U^(2^(2-1)) = U^2
      #L    Fase injetada: 2 * (5/8) * 2pi = 1.25 * 2pi = pi/2 mod 2pi
      #L 3. Correcao de fase com base em theta_3: R_z(-2pi * theta_3 / 4) = -pi/2
      #L 4. Fase liquida = pi/2 - pi/2 = 0. Ancilla colapsa em |+>. Apos H, medicao = 0.
      measured_bits[2] = 0
      println("   Iteracao k=2:")
      println("     - Porta controlada: U^2 (Fase = 2 * 5/8 * 2pi = pi/2)")
      println("     - Correcao de fase classica R_z(-pi/2 * theta_3): -pi/2")
      println("     - Medicao do qubit ancilar: theta_2 = " + measured_bits[2])

      #L --- Iteracao 1 (k = 1, MSB theta_1) ---
      #L 1. Ancilla resetado para |+>
      #L 2. Aplica U^(2^(1-1)) = U^1
      #L    Fase injetada: 1 * (5/8) * 2pi = 5pi/4
      #L 3. Correcao de fase com base em theta_2 e theta_3:
      #L    R_z(-2pi * (theta_2 / 4 + theta_3 / 8)) = -2pi * (1/8) = -pi/4
      #L 4. Fase liquida = 5pi/4 - pi/4 = pi. Ancilla colapsa em |->. Apos H, medicao = 1.
      measured_bits[1] = 1
      println("   Iteracao k=1 (MSB):")
      println("     - Porta controlada: U^1 (Fase = 5/8 * 2pi = 5pi/4)")
      println("     - Correcao de fase classica R_z(-pi/4): -pi/4")
      println("     - Medicao do qubit ancilar: theta_1 = " + measured_bits[1])

      println("==================================================")
      println("3. Reconstrucao da Fase Estimada:")
      mut as int64: b1 = measured_bits[1]
      mut as int64: b2 = measured_bits[2]
      mut as int64: b3 = measured_bits[3]
      println("   Bits medidos [MSB -> LSB]: [" + b1 + ", " + b2 + ", " + b3 + "]")
      println("   Representacao binaria da fase: 0." + b1 + b2 + b3 + "_2")

      mut as int64: recovered_numerator = (b1 * 4) + (b2 * 2) + b3
      mut as int64: estimated_scaled = (recovered_numerator * 1000) /i target_den
      println("   Fase Fracionaria Estimada: " + recovered_numerator + "/" + target_den)
      println("   Valor Decimal da Fase: 0." + estimated_scaled + " (Exato: 0.625)")
      println("   Iterative Quantum Phase Estimation concluido com sucesso!")
      println("==================================================")
}
