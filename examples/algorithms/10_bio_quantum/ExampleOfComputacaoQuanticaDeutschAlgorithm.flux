#L ============================================================================
#L Algoritmo: Deutsch Algorithm (Algoritmo de Deutsch - Constante vs Balanceada)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: 1 consulta ao oraculo quantico (vs 2 consultas no modelo classico)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaDeutschAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Deutsch Quantum Algorithm")
      println("==================================================")

      #L O algoritmo de Deutsch determina se uma funcao booleana f: {0, 1} -> {0, 1}
      #L e CONSTANTE (f(0) == f(1)) ou BALANCEADA (f(0) != f(1)) com apenas UMA consulta.
      #L Circuito com 2 qubits:
      #L Qubit 0: Qubit de entrada (|0>)
      #L Qubit 1: Qubit ancilla/alvo (|1>)

      println("1. Definicao dos Oraculos Booleanos de Teste f(x):")
      println("   Oraculo 1: f_const(x) = 1 (Constante)")
      println("   Oraculo 2: f_bal(x)   = x (Balanceada / Identidade)")

      #L Amplitudes escalonadas por 1000 (Ponto fixo onde 1.000 = 1000)
      #L 1/sqrt(2) ~ 707
      #L Estado quantico de 2 qubits |q0 q1> tem 4 estados base: |00>, |01>, |10>, |11>
      #L Indice 1-based: 1=|00>, 2=|01>, 3=|10>, 4=|11>

      #L --- TESTE 1: Oraculo Balanceado f(x) = x ---
      println("==================================================")
      println("2. Execucao do Circuito para Oraculo Balanceado f(x) = x:")

      #L Estado inicial: |01> (q0=0, q1=1)
      #L Aplicacao de portas Hadamard em ambos os qubits:
      #L H|0> = (|0> + |1>) / sqrt(2)
      #L H|1> = (|0> - |1>) / sqrt(2)
      #L Estado pos-Hadamard: (|00> - |01> + |10> - |11>) / 2
      #L Cada estado base tem amplitude 500 (ou -500):
      mut as list of int64: state_bal = [500, -500, 500, -500]
      println("   Estado apos Hadamard H (x) H: (|0> + |1>)(|0> - |1>) / 2")

      #L Aplicacao do Oraculo U_f: |x>|y> -> |x>|y ^ f(x)>
      #L Para f(0)=0: |00> -> |00>, |01> -> |01> (sem troca)
      #L Para f(1)=1: |10> -> |11>, |11> -> |10> (inverte q1)
      #L Troca amplitudes dos indices 3 (|10>) e 4 (|11>):
      mut as int64: tmp_bal = state_bal[3]
      state_bal[3] = state_bal[4]
      state_bal[4] = tmp_bal
      println("   Estado apos Oraculo U_f (Phase Kickback aplicado)")

      #L Aplicacao da porta Hadamard final no Qubit 0:
      #L H|x> no primeiro qubit:
      #L Amplitude final de |0> = (amp|0> + amp|1>) / sqrt(2)
      #L Amplitude final de |1> = (amp|0> - amp|1>) / sqrt(2)
      #L Para oraculo balanceado, interferencia destrutiva zera |0> e construtiva gera |1> no Qubit 0
      mut as int64: amp_q0_zero = (state_bal[1] + state_bal[3]) #L projecao no estado 0
      mut as int64: amp_q0_one = (state_bal[1] - state_bal[3])  #L projecao no estado 1

      println("   Amplitudes Finais do Qubit 0:")
      println("      Amplitude |0>: " + amp_q0_zero)
      println("      Amplitude |1>: " + amp_q0_one)

      #L Medicao: Se Qubit 0 for medido como |0> -> Constante; se |1> -> Balanceada
      mut as int64: result_bal = 0
      route {
            amp_q0_zero == 0 ==> {
                  result_bal = 1 #L Mediu |1|
                  println("   Medicao do Qubit 0: |1> => FUNCAO BALANCEADA DETECTADA!")
            }
            _ ==> {
                  println("   Medicao do Qubit 0: |0> => FUNCAO CONSTANTE DETECTADA!")
            }
      }

      #L --- TESTE 2: Oraculo Constante f(x) = 1 ---
      println("==================================================")
      println("3. Execucao do Circuito para Oraculo Constante f(x) = 1:")

      mut as list of int64: state_cst = [500, -500, 500, -500]
      #L Para f(x)=1: inverte q1 para todo x
      #L Troca 1 (|00>) com 2 (|01>), e 3 (|10>) com 4 (|11>)
      mut as int64: t1 = state_cst[1]
      state_cst[1] = state_cst[2]
      state_cst[2] = t1
      mut as int64: t2 = state_cst[3]
      state_cst[3] = state_cst[4]
      state_cst[4] = t2

      mut as int64: amp_cst_zero = (state_cst[1] - state_cst[3])
      mut as int64: amp_cst_one = (state_cst[1] + state_cst[3])
      println("   Amplitudes Finais do Qubit 0:")
      println("      Amplitude |0>: " + amp_cst_zero)
      println("      Amplitude |1>: " + amp_cst_one)

      route {
            amp_cst_one == 0 ==> {
                  println("   Medicao do Qubit 0: |0> => FUNCAO CONSTANTE DETECTADA!")
            }
            _ ==> {
                  println("   Medicao do Qubit 0: |1> => FUNCAO BALANCEADA DETECTADA!")
            }
      }

      println("==================================================")
      println("4. Resumo da Vantagem Quantica de Deutsch:")
      println("   Consultas quanticas necessarias: 1 consulta")
      println("   Consultas classicas minimas: 2 consultas")
      println("   Deutsch Algorithm concluido com sucesso!")
      println("==================================================")
}
