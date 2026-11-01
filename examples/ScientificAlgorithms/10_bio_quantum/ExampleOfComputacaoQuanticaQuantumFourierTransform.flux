#L ============================================================================
#L Algoritmo: Quantum Fourier Transform (QFT - Transformada de Fourier Quantica)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(n^2) portas quanticas (vs O(n * 2^n) do algoritmo FFT classico)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaQuantumFourierTransform) {
      println("==================================================")
      println("  SciAlgo: Quantum Fourier Transform (QFT)")
      println("==================================================")

      #L QFT sobre n = 3 qubits (N = 2^3 = 8 estados de base)
      #L Transforma a base computacional |j> em superposicao de fases:
      #L |j> -> (1 / sqrt(N)) * sum_{k=0}^{N-1} exp(2 * pi * i * j * k / N) |k>
      mut as int64: n_qubits = 3
      mut as int64: n_states = 8

      #L Estado de entrada puro: |j> = |3> (|011> em binario)
      mut as int64: input_j = 3

      println("1. Parametros do Circuito QFT:")
      println("   Numero de Qubits: n = " + n_qubits + " (Espaco de Hilbert N = " + n_states + ")")
      println("   Estado de Entrada: |j> = |" + input_j + "> (|011>)")

      println("==================================================")
      println("2. Estrutura do Circuito em Portas Quanticas:")

      #L O circuito para n qubits e composto por:
      #L - n portas Hadamard H
      #L - n*(n-1)/2 portas de rotacao de fase controlada R_k
      #L - n/2 portas SWAP para inverter a ordem dos qubits
      mut as int64: num_hadamards = n_qubits
      mut as int64: num_controlled_r = (n_qubits * (n_qubits - 1)) /i 2
      mut as int64: num_swaps = n_qubits /i 2
      mut as int64: total_gates = num_hadamards + num_controlled_r + num_swaps

      println("   Portas Hadamard (H): " + num_hadamards)
      println("   Rotacoes de Fase Controladas (R_k): " + num_controlled_r)
      println("   Portas de Permutacao (SWAP): " + num_swaps)
      println("   Total de Portas Elementares: " + total_gates + " (Complexidade O(n^2))")

      println("==================================================")
      println("3. Decomposicao dos Angulos de Fase para cada Estado Base |k>:")
      println("   Fase Angular theta(k) = (2 * pi * j * k) / 8:")

      #L Tabela de fases discretas (j * k) mod 8 para k in 0..7
      mut as list of int64: phase_units = []
      mut as int64: k = 0
      infinite (k < n_states) {
            mut as int64: phase_mult = (input_j * k) /r n_states
            phase_units = listPushBack(phase_units, phase_mult)
            println("   |k=" + k + ">: Exp(2*pi*i * " + phase_mult + "/8) [Angulo: " + (phase_mult * 45) + " graus]")
            k = k + 1
      }

      println("==================================================")
      println("4. Distribuicao de Probabilidade e Superposicao:")
      println("   Todas as amplitudes possuem magnitude uniforme |a_k| = 1/sqrt(8)")
      println("   Probabilidade de medicao de cada estado base: 1/8 = 12.5%")
      println("   A informacao de |j> esta codificada inteiramente na COERENCIA DE FASE!")
      println("   Quantum Fourier Transform concluido com sucesso!")
      println("==================================================")
}
