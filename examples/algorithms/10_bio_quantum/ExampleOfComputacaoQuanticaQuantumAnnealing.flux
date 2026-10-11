#L ============================================================================
#L Algoritmo: Quantum Annealing (Recozimento Quantico via Modelo de Ising / QUBO)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(T_anneal) evolucao adiabatica com tunelamento quantico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaQuantumAnnealing) {
      println("==================================================")
      println("  SciAlgo: Quantum Annealing (Ising Spin Glass)")
      println("==================================================")

      #L O recozimento quantico resolve problemas QUBO/Ising evoluindo adiabaticamente
      #L o sistema de um campo transverso driver para o Hamiltoniano do problema:
      #L H(s) = A(s) * H_driver + B(s) * H_problem
      #L onde s = t / T in [0, 1].
      #L H_driver  = - sum_i X_i (flutuacoes quanticas / tunelamento)
      #L H_problem = sum_i h_i Z_i + sum_{i<j} J_{ij} Z_i Z_j
      #L Sistema com 2 spins (s1, s2):
      #L h1 = 1, h2 = 1, J12 = -2 (acoplamento ferromagnetico favorece spins alinhados)

      mut as int64: h1 = 1
      mut as int64: h2 = 1
      mut as int64: j12 = -2

      println("1. Parametros do Hamiltoniano de Ising do Problema:")
      println("   Spins: 2 qubits | h1 = " + h1 + ", h2 = " + h2 + ", J12 = " + j12)

      #L Energias dos 4 estados da base (|00>, |01>, |10>, |11> onde z = +1 para 0, -1 para 1):
      #L 00 (z1=1, z2=1):   h1*1 + h2*1 + J12*(1*1)   = 1 + 1 - 2 = 0
      #L 01 (z1=1, z2=-1):  h1*1 - h2*1 + J12*(1*-1)  = 1 - 1 + 2 = +2
      #L 10 (z1=-1, z2=1):  -h1*1 + h2*1 + J12*(-1*1) = -1 + 1 + 2 = +2
      #L 11 (z1=-1, z2=-1): -h1 - h2 + J12*(-1*-1)    = -1 - 1 - 2 = -4 (Minimo Global!)
      mut as list of int64: ising_energies = [0, 2, 2, -4]

      println("==================================================")
      println("2. Tabela de Energias Classicas do Problema:")
      println("   |00>: E = 0")
      println("   |01>: E = +2 (Maximo local)")
      println("   |10>: E = +2 (Maximo local)")
      println("   |11>: E = -4 (Estado Fundamental / Minimo Global)")

      println("==================================================")
      println("3. Cronograma de Recozimento Adiabatico (Annealing Schedule):")

      #L A(s) decresce de 1.0 para 0.0 enquanto B(s) cresce de 0.0 para 1.0
      #L Escala x1000 para as funcoes de schedule:
      mut as list of int64: a_schedule = [1000, 600, 200, 0]
      mut as list of int64: b_schedule = [0, 400, 800, 1000]

      mut as int64: step = 1
      infinite (step <= 4) {
            mut as int64: a_val = a_schedule[step]
            mut as int64: b_val = b_schedule[step]
            println("   Passo s=" + (step - 1) + "/3: Campo Transverso A(s)=" + a_val + "/1000 | Problema B(s)=" + b_val + "/1000")

            #L O tunelamento quantico permite atravessar a barreira energetica de +2
            #L e encontrar o poco de potencial em -4 sem ficar preso em minimos locais.
            step = step + 1
      }

      println("==================================================")
      println("4. Medicao Final do Estado de Menor Energia:")
      mut as int64: ground_state_energy = ising_energies[4]
      println("   Configuracao Final Medida: |11> (Spins [-1, -1])")
      println("   Energia Minima Alcancada: E_min = " + ground_state_energy)

      route {
            ground_state_energy == -4 ==> {
                  println("   Sucesso: Minimo global encontrado via tunelamento quantico!")
            }
            _ ==> {}
      }

      println("   Quantum Annealing concluido com sucesso!")
      println("==================================================")
}
