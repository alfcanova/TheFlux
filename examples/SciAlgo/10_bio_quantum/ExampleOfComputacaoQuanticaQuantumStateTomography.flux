#L ============================================================================
#L Algoritmo: Quantum State Tomography (Tomografia de Estado Quantico)
#L Dominio: 10_bio_quantum / Categoria: Caracterizacao e Tomografia Quantica
#L Descricao: Reconstrucao da matriz de densidade rho via medicoes de Pauli (X, Y, Z)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaQuantumStateTomography) {
      println("=== Algoritmo: Quantum State Tomography (QST) ===")

      #L Tomografia de 1 qubit: medicao nas bases ortogonais de Pauli
      #L Base Pauli-Z (autovetores |0>, |1>):
      #L Contagem de shots: 1000 medicoes
      #L 800 contagens em |0>, 200 em |1>
      #L <Z> = (800 - 200) / 1000 = +0.60 (+600 em escala x1000)
      mut as int64: exp_z = 600

      #L Base Pauli-X (autovetores |+>, |-> com rotacao Hadamard antes da medicao):
      #L 700 contagens em |+>, 300 em |->
      #L <X> = (700 - 300) / 1000 = +0.40 (+400 em escala x1000)
      mut as int64: exp_x = 400

      #L Base Pauli-Y (autovetores |+i>, |-i> com rotacao S^dag * H):
      #L 500 contagens em |+i>, 500 em |-i>
      #L <Y> = (500 - 500) / 1000 = 0.00 (0 em escala x1000)
      mut as int64: exp_y = 0

      println("Valores esperados dos operadores de Pauli medidos:")
      println("  <X> = " + exp_x + "/1000")
      println("  <Y> = " + exp_y + "/1000")
      println("  <Z> = " + exp_z + "/1000")

      #L Vetor de Bloch r = (<X>, <Y>, <Z>):
      #L Comprimento ao quadrado do vetor de Bloch |r|^2 = <X>^2 + <Y>^2 + <Z>^2
      #L Em escala x1000000:
      #L 400^2 + 0^2 + 600^2 = 160000 + 360000 = 520000
      mut as int64: r_sq = exp_x * exp_x + exp_y * exp_y + exp_z * exp_z
      println("Comprimento ao quadrado do vetor de Bloch |r|^2: " + r_sq + " / 1000000")

      #L Pureza do estado quantico gamma = Tr(rho^2) = (1 + |r|^2) / 2
      #L Para estado puro, |r| = 1 e gamma = 1
      #L Para estado misto, |r| < 1 e gamma < 1
      #L Em escala x1000: (1000000 + r_sq) / (2 * 1000) = (1000000 + 520000) / 2000 = 1520000 / 2000 = 760 (0.76)
      mut as int64: num_purity = 1000000 + r_sq
      mut as int64: purity_x1000 = num_purity /i 2000
      println("Pureza do estado reconstruido Tr(rho^2): " + purity_x1000 + "/1000")

      #L Elementos da matriz de densidade rho:
      #L rho_00 = (1 + <Z>) / 2 = (1000 + 600) / 2 = 800 (0.80)
      #L rho_11 = (1 - <Z>) / 2 = (1000 - 600) / 2 = 200 (0.20)
      #L Re(rho_01) = <X> / 2 = 400 / 2 = 200 (0.20)
      mut as int64: rho_00 = (1000 + exp_z) /i 2
      mut as int64: rho_11 = (1000 - exp_z) /i 2
      mut as int64: rho_01_real = exp_x /i 2

      println("Matriz de densidade reconstruida:")
      println("  rho_00: " + rho_00 + "/1000")
      println("  rho_11: " + rho_11 + "/1000")
      println("  Re(rho_01): " + rho_01_real + "/1000")

      route {
            purity_x1000 < 1000 ==> {
                  println("Diagnostico: Estado quantico misto sob efeito de despolarizacao / perda de coerencia")
            }
            purity_x1000 >= 1000 ==> {
                  println("Diagnostico: Estado quantico perfeitamente puro")
            }
      }

      println("Quantum State Tomography concluido com sucesso.")
}
