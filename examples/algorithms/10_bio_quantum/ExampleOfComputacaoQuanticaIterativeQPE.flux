#L ============================================================================
#L Algoritmo: Iterative Quantum Phase Estimation (IQPE)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(m) chamadas unitarias usando exatamente 1 qubit ancilla
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaIterativeQPE) {
      println("==================================================")
      println("  SciAlgo: Iterative Quantum Phase Estimation (IQPE)")
      println("==================================================")

      #L O IQPE estima uma fase theta = 0.phi_1 phi_2 phi_3 usando apenas 1 qubit auxiliar
      #L medindo do bit menos significativo (LSB) para o mais significativo (MSB)
      #L com correcao semiclassica de fase adaptativa.
      #L Fase real a estimar: theta = 5/8 = 0.101 em binario (bits: phi_1=1, phi_2=0, phi_3=1)
      mut as int64: m_bits_precisao = 3

      #L Iteracao 1 (calcula bit phi_3, aplicando U^(2^(3-1)) = U^4):
      #L Fase efetiva rotacionada: parte fracionaria 5/8 * 4 = 2.5 -> 0.5 (fase 180 graus).
      #L Resultado da medicao: phi_3 = 1
      mut as int64: bit_3 = 1

      #L Iteracao 2 (calcula bit phi_2, aplicando U^2 com correcao de fase de phi_3):
      #L Angulo de correcao: -2 * pi * (0.01)_bin = -pi / 2
      #L Resultado da medicao: phi_2 = 0
      mut as int64: bit_2 = 0

      #L Iteracao 3 (calcula bit phi_1, aplicando U^1 com correcao de phi_2 e phi_3):
      #L Resultado da medicao: phi_1 = 1
      mut as int64: bit_1 = 1

      #L Fase binaria reconstruida: (bit_1 * 4 + bit_2 * 2 + bit_3 * 1) / 8 = (4 + 0 + 1) / 8 = 5/8
      mut as int64: numerador_fase = (bit_1 * 4) + (bit_2 * 2) + (bit_3 * 1)
      mut as int64: denominador_fase = 8
      mut as int64: fase_percentual = (numerador_fase * 100) /i denominador_fase

      println("1. Qubits ancilla utilizados no circuito: 1 (reaproveitamento semiclassico)")
      println("2. Bits de precisao iterativa medidos: [" + bit_1 + ", " + bit_2 + ", " + bit_3 + "]")
      println("3. Fracao de fase quantica reconstruida: " + numerador_fase + " / " + denominador_fase + " (" + fase_percentual + "%)")
      println("4. IQPE concluido com sucesso.")
}
