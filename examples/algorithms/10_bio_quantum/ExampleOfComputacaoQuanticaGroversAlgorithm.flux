#L ============================================================================
#L Algoritmo: Grover's Algorithm (Busca Quantica em Base Nao-Estruturada)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(sqrt(N)) consultas (vs O(N) no modelo classico)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaGroversAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Grover's Search Algorithm")
      println("==================================================")

      #L Espaco de busca N = 2^3 = 8 itens (|000> ate |111>)
      #L Item marcado alvo: omega = 5 (|101>)
      mut as int64: n = 3
      mut as int64: num_items = 8
      mut as int64: target_item = 5

      println("1. Parametros do Espaco de Busca:")
      println("   Numero de Qubits: n = " + n + " (Espaco N = " + num_items + " estados)")
      println("   Item Alvo Marcado: omega = " + target_item + " (|101>)")

      #L Amplitudes escalonadas por 1000 (Ponto fixo)
      #L Estado inicial uniforme: 1/sqrt(8) ~ 353
      mut as list of int64: amps = [353, 353, 353, 353, 353, 353, 353, 353]
      #L Indice 1-based: target_item=5 esta no indice 6 (0..7 -> 1..8)
      mut as int64: target_idx = target_item + 1

      println("==================================================")
      println("2. Estado Inicial (Superposicao Uniforme H^n |0>):")
      println("   Amplitudes Iniciais: ~353/1000 em todos os estados")

      #L Numero otimo de iteracoes para N=8: round(pi/4 * sqrt(8)) = 2 iteracoes
      mut as int64: num_iter = 2
      mut as int64: it = 1

      infinite (it <= num_iter) {
            println("==================================================")
            println("3. Iteracao de Grover #" + it + ":")

            #L 3.1 Oraculo de Fase O_w: inverte o sinal do item alvo
            amps[target_idx] = 0 - amps[target_idx]
            println("   3.1 Apos Oraculo: Amplitude do Alvo = " + amps[target_idx])

            #L 3.2 Operador de Difusao D = 2|s><s| - I (Inversao sobre a Media):
            #L Calcula media das amplitudes
            mut as int64: sum_amps = 0
            mut as int64: k = 1
            infinite (k <= num_items) {
                  sum_amps = sum_amps + amps[k]
                  k = k + 1
            }
            mut as int64: mean_amp = sum_amps /i num_items
            println("   3.2 Media das Amplitudes: " + mean_amp)

            #L Inversao: amp_novo = 2 * mean - amp_antigo
            mut as int64: j = 1
            infinite (j <= num_items) {
                  amps[j] = (2 * mean_amp) - amps[j]
                  j = j + 1
            }

            mut as int64: target_prob = (amps[target_idx] * amps[target_idx]) /i 1000
            println("   3.3 Amplitude Amplificada do Alvo: " + amps[target_idx] + "/1000")
            println("       Probabilidade Estimada do Alvo: " + target_prob + "/1000 (" + (target_prob /i 10) + "." + (target_prob /r 10) + "%)")

            it = it + 1
      }

      println("==================================================")
      println("4. Medicao Final:")
      println("   Item mais provavel medido: " + target_item + " (|101>)")
      println("   Amplificacao com sucesso apos " + num_iter + " iteracoes!")
      println("   Grover's Algorithm concluido com sucesso!")
      println("==================================================")
}
