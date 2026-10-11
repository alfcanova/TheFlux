#L ============================================================================
#L Algoritmo: HyperLogLog (Estimacao de Cardinalidade em Streaming)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados / Streaming
#L Complexidade: add O(1) | estimate O(m) | Espaco O(m) registers
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingHyperLogLog) {
      println("==================================================")
      println("  SciAlgo: HyperLogLog Cardinality Estimator")
      println("==================================================")

      #L m = 16 registradores (b = 4 bits de precisao de bucket)
      mut as int64: m = 16
      println("1. Inicializando HyperLogLog com m = " + m + " registradores...")

      mut as list of int64: registers = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

      #L Stream de entrada: 20 elementos distintos (1..20), muitos repetidos varias vezes
      #L Total de eventos no stream = 40
      mut as list of int64: stream = [
            1, 2, 3, 4, 5, 1, 2, 3, 6, 7, 8, 9, 10,
            5, 6, 11, 12, 13, 14, 15, 1, 7, 16, 17, 18,
            19, 20, 2, 4, 8, 10, 12, 14, 16, 18, 20, 15, 13, 11, 9
      ]
      mut as int64: n_events = listLength(stream)
      mut as int64: true_distinct = 20

      println("2. Processando stream de " + n_events + " eventos com " + true_distinct + " itens distintos reais...")

      mut as int64: i = 1
      infinite (i <= n_events) {
            mut as int64: val = stream[i]

            #L Funcao hash deterministica 32-bit (Knuth multiplicative hash)
            mut as int64: h = ((val * 2654435761) + 12345) /r 1048576

            #L Determina o registrador (1..m) a partir dos ultimos 4 bits
            mut as int64: bucket = (h /r m) + 1

            #L Determina sequencia de zeros a direita (rho) no restante dos bits
            mut as int64: w = h /i m
            route {
                  w == 0 ==> { w = 1 }
            }

            mut as int64: zeros = 1
            mut as int64: temp = w
            infinite (temp > 0) {
                  mut as int64: bit = temp /r 2
                  route {
                        bit == 0 ==> {
                              zeros = zeros + 1
                              temp = temp /i 2
                        }
                        _ ==> {
                              break
                        }
                  }
            }

            #L Atualiza registrador se zeros for maior que o valor atual
            route {
                  zeros > registers[bucket] ==> {
                        registers[bucket] = zeros
                  }
            }

            i = i + 1
      }
      println("   Registradores populados com sucesso.")

      #L 3. Calculo da Media Harmonica (Ponto fixo: SCALE = 65536)
      #L Z = soma de 2^(-registers[j])
      #L Cada termo em ponto fixo: 65536 / 2^(reg)
      println("3. Computando media harmonica dos registradores...")
      mut as int64: scale = 65536
      mut as int64: sum_terms = 0

      mut as int64: r = 1
      infinite (r <= m) {
            mut as int64: reg_val = registers[r]

            #L Calcula 2^reg_val
            mut as int64: p2 = 1
            mut as int64: k = 1
            infinite (k <= reg_val) {
                  p2 = p2 * 2
                  k = k + 1
            }

            mut as int64: term = scale /i p2
            sum_terms = sum_terms + term
            r = r + 1
      }

      #L Formula do estimador HLL:
      #L E = alpha_m * m^2 / Z
      #L alpha_16 = 0.673 -> (673 / 1000)
      #L E = (673 * m * m * scale) / (1000 * sum_terms)
      mut as int64: num = 673 * m * m * scale
      mut as int64: den = 1000 * sum_terms
      mut as int64: raw_estimate = num /i den

      println("   Estimativa bruta HLL: " + raw_estimate)
      println("   Cardinalidade real: " + true_distinct)

      #L Verificacao de intervalo razoavel para HLL com m=16 (margem estatistica esperada)
      mut as bool: ok = (raw_estimate >= 10) and (raw_estimate <= 35) and (sum_terms > 0)
      println("4. Verificacao de precisao da estimativa: " + ok)
      println("Concluido com Sucesso")
}
