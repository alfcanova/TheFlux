#L ============================================================================
#L Algoritmo: Booth's Multiplication Algorithm (Andrew Booth 1951)
#L Dominio: 01_foundations / Categoria: 42. Algoritmos especiais
#L Complexidade: O(k) passos para inteiros de k bits
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosEspeciaisBooth) {
      println("==================================================")
      println("  SciAlgo: Booth's Multiplication Algorithm")
      println("==================================================")

      #L Multiplicando M e Multiplicador Q (com sinal)
      #L Teste: M = 7, Q = -5 -> Produto esperado = -35
      mut as int64: m_val = 7
      mut as int64: q_val = -5

      println("1. Multiplicando M = " + m_val + " | Multiplicador Q = " + q_val)

      #L Simulacao do ciclo de Booth em 8 bits:
      #L Registradores: A = 0, Q = q_val, Q_minus_1 = 0
      mut as int64: a = 0
      mut as int64: q = q_val
      mut as int64: q_last = 0 #L Q_-1

      #L Ajusta q para representacao em 8 bits caso negativo: complemento de 2
      route {
            q < 0 ==> {
                  q = q + 256
            }
      }

      mut as int64: step = 1
      infinite (step <= 8) {
            mut as int64: q0 = q & 1

            #L Examina o par de bits (q0, q_last):
            #L   01 -> A = A + M
            #L   10 -> A = A - M
            #L   00 ou 11 -> nenhum ajuste aritmetico
            route {
                  q0 == 0 and q_last == 1 ==> {
                        a = a + m_val
                  }
                  q0 == 1 and q_last == 0 ==> {
                        a = a - m_val
                  }
            }

            #L Deslocamento aritmetico a direita do conjunto [A, Q, Q_last]:
            q_last = q0
            mut as int64: a_lsb = a & 1
            #L Desloca q a direita e insere o lsb de a no topo de q (bit 7 = 128)
            q = (q /i 2) + (a_lsb * 128)
            #L Deslocamento aritmetico a direita em A com preservacao de sinal
            a = a /i 2

            step = step + 1
      }

      #L Combina os registradores [A, Q] para formar o resultado final
      mut as int64: product = a * 256 + q
      route {
            product >= 32768 ==> {
                  product = product - 65536
            }
      }

      println("2. Produto calculado pelo Algoritmo de Booth: " + product)
      println("3. Produto matematico direto (7 * -5): " + (m_val * q_val))
      println("4. Validacao: " + (product == -35 and product == (m_val * q_val)))
      println("==================================================")
}
