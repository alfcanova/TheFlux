#L ============================================================================
#L Algoritmo: Bernstein-Vazirani (Descoberta de Sequencia Oculta em 1 Consulta)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(1) consulta quantica (vs O(n) consultas no melhor caso classico)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaBernsteinVazirani) {
      println("==================================================")
      println("  SciAlgo: Bernstein-Vazirani Algorithm")
      println("==================================================")

      #L O problema de Bernstein-Vazirani busca encontrar uma string secreta s de n bits
      #L tal que o oraculo calcula f(x) = (s . x) mod 2 (produto interno modulo 2).
      #L String secreta s = [1, 0, 1] (em binario: '101' = 5 em decimal)
      mut as int64: n = 3
      mut as list of int64: secret_s = [1, 0, 1]
      mut as int64: s_val = 5

      println("1. Parametros do Oraculo:")
      println("   Numero de qubits de entrada: n = " + n)
      println("   Chave Secreta Oculta no Oraculo: s = [1, 0, 1] (Valor decimal: " + s_val + ")")
      println("   Oraculo f(x): calcula s0*x0 ^ s1*x1 ^ s2*x2")

      println("==================================================")
      println("2. Transformacao Quantica e Interferencia:")

      #L 1. Superposicao total: H^n |000> = (1/sqrt(8)) * sum_x |x>
      #L 2. Phase Kickback com ancilla em |->:
      #L    Estado torna-se (1/sqrt(8)) * sum_x (-1)^(s . x) |x>
      #L 3. Aplicacao da segunda camada de Hadamard H^n:
      #L    A amplitude do estado |y> e dada por:
      #L    Amp(y) = (1 / 2^n) * sum_x (-1)^((s . x) ^ (y . x)) = (1 / 2^n) * sum_x (-1)^((s ^ y) . x)
      #L    Para y != s, a soma alterna perfeitamente entre +1 e -1, resultando em 0.
      #L    Para y == s, (-1)^0 = 1 para todos os 8 termos x, resultando em 8/8 = 1.0!

      println("   Calculando interferencia para cada estado base |y>:")
      mut as int64: measured_state = 0
      mut as int64: max_amp = 0

      mut as int64: y = 0
      infinite (y < 8) {
            #L Extrai bits de y (y0, y1, y2)
            mut as int64: y0 = y /i 4
            mut as int64: y1 = (y /r 4) /i 2
            mut as int64: y2 = y /r 2

            mut as int64: sum_terms = 0
            mut as int64: x = 0
            infinite (x < 8) {
                  mut as int64: x0 = x /i 4
                  mut as int64: x1 = (x /r 4) /i 2
                  mut as int64: x2 = x /r 2

                  #L Produto interno (s ^ y) . x
                  mut as int64: diff0 = secret_s[1] ^ y0
                  mut as int64: diff1 = secret_s[2] ^ y1
                  mut as int64: diff2 = secret_s[3] ^ y2

                  mut as int64: dot = (diff0 * x0) + (diff1 * x1) + (diff2 * x2)
                  mut as int64: phase_bit = dot /r 2

                  mut as int64: term = 1
                  route {
                        phase_bit == 1 ==> { term = -1 }
                        _ ==> {}
                  }
                  sum_terms = sum_terms + term
                  x = x + 1
            }

            println("   Estado |" + y0 + y1 + y2 + "> (dec " + y + "): Amplitude construtiva = " + sum_terms + " / 8")
            route {
                  sum_terms == 8 ==> {
                        measured_state = y
                        max_amp = sum_terms
                  }
                  _ ==> {}
            }
            y = y + 1
      }

      println("==================================================")
      println("3. Medicao e Reconstrucao do Segredo:")
      mut as int64: m0 = measured_state /i 4
      mut as int64: m1 = (measured_state /r 4) /i 2
      mut as int64: m2 = measured_state /r 2
      println("   Estado Medido com 100% de Probabilidade: |" + m0 + m1 + m2 + "> (decimal " + measured_state + ")")
      println("   Bits Reconstruidos: s = [" + m0 + ", " + m1 + ", " + m2 + "]")

      route {
            measured_state == s_val ==> {
                  println("   Sucesso: Chave secreta decodificada perfeitamente em 1 unica consulta!")
            }
            _ ==> {}
      }

      println("==================================================")
      println("4. Resumo da Eficiencia de Bernstein-Vazirani:")
      println("   Consultas Quanticas: 1 consulta")
      println("   Consultas Classicas Necessarias: " + n + " consultas")
      println("   Bernstein-Vazirani concluido com sucesso!")
      println("==================================================")
}
