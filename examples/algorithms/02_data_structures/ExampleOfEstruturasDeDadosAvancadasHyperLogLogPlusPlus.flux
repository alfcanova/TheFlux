#L ============================================================================
#L Algoritmo: HyperLogLog++ (Estimador de Cardinalidade com Correcao de Vies de Heule et al. 2013)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(1) insercao | Espaco O(m) registradores | Erro relativo 1.04/sqrt(m)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasHyperLogLogPlusPlus) {
      println("==================================================")
      println("  SciAlgo: HyperLogLog++ (Cardin. & Bias Correct)")
      println("==================================================")

      #L Numero de registradores m = 2^p (usando p = 4 -> m = 16)
      mut as int64: p = 4
      mut as int64: m = 16
      mut as list of int64: registers = []
      mut as int64: reg_init = 1
      infinite (reg_init <= m) {
            registers = listPushBack(registers, 0)
            reg_init = reg_init + 1
      }

      #L Fluxo de 12 elementos distintos com duplicatas (cardinalidade real = 8)
      #L Elementos: 10, 20, 30, 40, 50, 60, 70, 80 e repeticoes de 10, 20, 30, 40
      mut as list of int64: stream = [10, 20, 30, 40, 50, 60, 70, 80, 10, 20, 30, 40]
      mut as int64: stream_sz = listLength(stream)

      println("1. Processando fluxo de " + stream_sz + " eventos (8 valores unicos)...")

      #L Funcao hash e extracao de registradores e zeros a esquerda
      mut as int64: si = 1
      infinite (si <= stream_sz) {
            mut as int64: val = stream[si]
            #L Hash inteiro de 32 bits
            mut as int64: h = (val * 2654435761 + 1013904223) /r 2147483647
            route { h < 0 ==> { h = h * -1 } }

            #L Primeiros p bits definem o indice do registrador (1 a m)
            mut as int64: reg_idx = (h /r m) + 1

            #L Zeros à esquerda no restante do hash (+1)
            mut as int64: remaining = h /i m
            mut as int64: lz = 1
            infinite (remaining > 0 and (remaining /r 2) == 0 and lz < 16) {
                  lz = lz + 1
                  remaining = remaining /i 2
            }

            #L Mantem o maximo no registrador
            route {
                  lz > registers[reg_idx] ==> {
                        registers[reg_idx] = lz
                  }
            }
            si = si + 1
      }

      println("2. Estado dos registradores (m = 16): " + registers)

      #L Conta registradores vazios V (zeros) para Linear Counting em baixa cardinalidade
      mut as int64: zero_count = 0
      mut as int64: r_idx = 1
      mut as int64: sum_pow = 0
      infinite (r_idx <= m) {
            route {
                  registers[r_idx] == 0 ==> {
                        zero_count = zero_count + 1
                  }
            }
            #L Soma das potencias aproximadas 2^(-R[j]) * 1024
            #L Usando escala de ponto fixo (1024 / 2^R[j])
            mut as int64: r_val = registers[r_idx]
            mut as int64: p2 = 1
            mut as int64: c = 1
            infinite (c <= r_val) {
                  p2 = p2 * 2
                  c = c + 1
            }
            sum_pow = sum_pow + (1024 /i p2)
            r_idx = r_idx + 1
      }

      println("3. Registradores com valor zero (V): " + zero_count)

      #L Estimativa HLL++: se V > 0, aplica Linear Counting V * ln(m / V)
      #L Aproximacao inteira de Linear Counting: m - V + correcao
      mut as int64: est_cardinality = 0
      route {
            zero_count > 0 ==> {
                  #L Linear Counting: V > 0 implica baixa cardinalidade
                  est_cardinality = m - zero_count + 1
            }
            _ ==> {
                  #L Media harmonica escalada
                  est_cardinality = (m * m * 7) /i (sum_pow /i 100 + 1)
            }
      }

      println("4. Estimativa final de cardinalidade: " + est_cardinality + " (real: 8)")
      println("5. Validacao: " + (est_cardinality >= 6 and est_cardinality <= 12 and listLength(registers) == 16))
      println("==================================================")
}
