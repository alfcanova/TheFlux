#L ============================================================================
#L Algoritmo: Deutsch-Jozsa (Decisao Quantica Global em n Qubits)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(1) consulta ao oraculo (vs O(2^(n-1)) consultas no pior caso classico)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaDeutschJozsa) {
      println("==================================================")
      println("  SciAlgo: Deutsch-Jozsa Quantum Algorithm")
      println("==================================================")

      #L O algoritmo avalia se f: {0,1}^n -> {0,1} e constante ou balanceada
      #L com n=3 qubits de entrada e 1 qubit ancilla.
      #L Dimensao do espaco de Hilbert de entrada: 2^n = 8 estados (|000> ate |111>)
      mut as int64: n_qubits = 3
      mut as int64: num_states = 8

      println("1. Parametros do Circuito de Deutsch-Jozsa:")
      println("   Qubits de Entrada: n = " + n_qubits + " (Espaco de 8 estados)")
      println("   Qubit Ancilla: 1 qubit inicializado em |-> = (|0> - |1>)/sqrt(2)")

      #L Oraculo Balanceado f_bal(x): retorna paridade dos bits (x0 ^ x1 ^ x2)
      #L Para x in 0..7:
      #L x=0 (000): 0 | x=1 (001): 1 | x=2 (010): 1 | x=3 (011): 0
      #L x=4 (100): 1 | x=5 (101): 0 | x=6 (110): 0 | x=7 (111): 1
      #L Metade dos valores e 0, metade e 1 -> Perfeitamente balanceada!
      mut as list of int64: f_bal = [0, 1, 1, 0, 1, 0, 0, 1]

      #L Oraculo Constante f_cst(x): retorna 0 para todos os x
      mut as list of int64: f_cst = [0, 0, 0, 0, 0, 0, 0, 0]

      println("==================================================")
      println("2. Avaliacao do Oraculo Balanceado:")

      #L Amplitude pos-Hadamard inicial: cada estado x tem amplitude (+1 / sqrt(8))
      #L Apos oraculo com phase kickback: amplitude e (-1)^f(x) / sqrt(8)
      #L H^n final projeta sobre |000>: amplitude(|000>) = (1 / 2^n) * sum_x (-1)^f(x)
      mut as int64: sum_phases_bal = 0
      mut as int64: i = 1
      infinite (i <= num_states) {
            mut as int64: fx = f_bal[i]
            mut as int64: phase = 1
            route {
                  fx == 1 ==> { phase = -1 }
                  _ ==> {}
            }
            sum_phases_bal = sum_phases_bal + phase
            println("   Estado |" + (i - 1) + ">: f(x) = " + fx + " | Fase = " + phase)
            i = i + 1
      }

      #L Amplitude e Probabilidade de medir |000>
      #L Se soma das fases for 0 -> Prob(|000>) = 0 -> Com certeza e balanceada
      println("   Soma das Fases (Interferencia Construtiva/Destrutiva): " + sum_phases_bal)
      route {
            sum_phases_bal == 0 ==> {
                  println("   Medicao Final: != |000> => FUNCAO BALANCEADA CONFIRMADA!")
            }
            _ ==> {
                  println("   Medicao Final: |000> => FUNCAO CONSTANTE!")
            }
      }

      println("==================================================")
      println("3. Avaliacao do Oraculo Constante:")

      mut as int64: sum_phases_cst = 0
      mut as int64: j = 1
      infinite (j <= num_states) {
            mut as int64: fc = f_cst[j]
            mut as int64: p = 1
            route {
                  fc == 1 ==> { p = -1 }
                  _ ==> {}
            }
            sum_phases_cst = sum_phases_cst + p
            j = j + 1
      }

      println("   Soma das Fases: " + sum_phases_cst + " de " + num_states)
      route {
            sum_phases_cst == num_states ==> {
                  println("   Medicao Final: |000> com 100% de probabilidade => FUNCAO CONSTANTE CONFIRMADA!")
            }
            _ ==> {
                  println("   Medicao Final: != |000> => FUNCAO BALANCEADA!")
            }
      }

      println("==================================================")
      println("4. Resumo da Aceleracao Exponencial de Deutsch-Jozsa:")
      println("   Consultas quanticas realizadas: 1")
      println("   Consultas necessarias pelo pior caso classico deterministico: " + ((num_states /i 2) + 1))
      println("   Deutsch-Jozsa concluido com sucesso!")
      println("==================================================")
}
