#L ============================================================================
#L Algoritmo: Quantum Search (Busca Quantica Generalizada / Multiplos Alvos)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(sqrt(N / M)) consultas para M alvos em N itens
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaQuantumSearch) {
      println("==================================================")
      println("  SciAlgo: Quantum Search (Multi-Target Database)")
      println("==================================================")

      #L O algoritmo de busca quantica generaliza o algoritmo de Grover
      #L para bases de dados contendo M itens marcados entre N estados possiveis.
      #L A aceleracao quadratica alcanca complexidade O(sqrt(N/M)),
      #L otimizando o numero de reflexoes unitarias.
      #L
      #L Parametros do sistema:
      #L N = 8 estados (3 qubits: |000> a |111>)
      #L M = 2 itens alvo marcados: x = 2 (|010>) e x = 5 (|101>)
      mut as int64: n_qubits = 3
      mut as int64: n_items = 8
      mut as int64: m_targets = 2
      mut as int64: target_1 = 2
      mut as int64: target_2 = 5

      println("1. Parametros do Banco de Dados Quantico:")
      println("   Tamanho da base: N = " + n_items + " (Espaco de Hilbert com " + n_qubits + " qubits)")
      println("   Itens marcados (alvos): M = " + m_targets + " (Estados: |" + target_1 + "> e |" + target_2 + ">)")
      println("   Numero otimo de iteracoes Grover: R = floor(pi/4 * sqrt(8/2)) = 1 iteracao")

      #L Amplitudes de probabilidade escaladas por 1000 (1.000 = 1000)
      #L Inicializacao: Superposicao uniforme |s> = 1/sqrt(8) * sum |x>
      #L 1/sqrt(8) = 0.35355... ~ 354 / 1000
      mut as int64: init_amp = 354
      mut as list of int64: amplitudes = [354, 354, 354, 354, 354, 354, 354, 354]

      println("==================================================")
      println("2. Estado Inicial (Superposicao Uniforme):")
      mut as int64: i = 0
      infinite (i < n_items) {
            println("   Estado |" + i + ">: Amplitude = 0." + amplitudes[i + 1])
            i = i + 1
      }

      println("==================================================")
      println("3. Passo 1 - Aplicacao do Oraculo de Fase (Inversao de Sinal):")
      #L O oraculo inverte a fase apenas dos estados marcados x in {2, 5} (indices 3 e 6):
      #L |x> -> (-1)^f(x) |x>
      amplitudes[target_1 + 1] = 0 - amplitudes[target_1 + 1]
      amplitudes[target_2 + 1] = 0 - amplitudes[target_2 + 1]

      println("   Oraculo inverteu a fase dos alvos |" + target_1 + "> e |" + target_2 + ">:")
      println("   Amplitude |" + target_1 + ">: -0." + (0 - amplitudes[target_1 + 1]))
      println("   Amplitude |" + target_2 + ">: -0." + (0 - amplitudes[target_2 + 1]))

      println("==================================================")
      println("4. Passo 2 - Operador de Difusao (Inversao em Torno da Media):")
      #L Calculo da amplitude media mu:
      mut as int64: sum_amp = 0
      mut as int64: j = 0
      infinite (j < n_items) {
            sum_amp = sum_amp + amplitudes[j + 1]
            j = j + 1
      }
      mut as int64: mean_amp = sum_amp /i n_items
      println("   Amplitude media calculada: mu = 0." + mean_amp)

      #L Inversao em torno da media: A'_x = 2*mu - A_x
      mut as int64: k = 0
      infinite (k < n_items) {
            mut as int64: old_a = amplitudes[k + 1]
            mut as int64: new_a = (2 * mean_amp) - old_a
            amplitudes[k + 1] = new_a
            k = k + 1
      }

      println("==================================================")
      println("5. Amplitudes e Probabilidades Apos Difusao:")
      mut as int64: idx = 0
      infinite (idx < n_items) {
            mut as int64: amp = amplitudes[idx + 1]
            #L Probabilidade escalada por 1000: (amp * amp) / 1000
            mut as int64: prob = (amp * amp) /i 1000
            println("   Estado |" + idx + ">: Amplitude = 0." + amp + " -> Probabilidade = " + (prob /i 10) + "." + (prob /r 10) + "%")
            idx = idx + 1
      }

      println("==================================================")
      println("6. Resultado da Busca:")
      println("   Estados Alvo Localizados com Quase 100% de Sucesso: |" + target_1 + "> e |" + target_2 + ">")
      println("   Quantum Search concluido com sucesso!")
      println("==================================================")
}
