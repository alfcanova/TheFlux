#L ============================================================================
#L Algoritmo: Iterative Quantum Phase Estimation (IQPE)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos Quanticos Fundamentais
#L Descricao: Estimacao de fase utilizando apenas 1 qubit auxiliar e retroalimentacao classica
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaIterativeQuantumPhaseEstimation) {
      println("=== Algoritmo: Iterative Phase Estimation (IQPE) ===")

      #L Estimacao de 3 bits da autofase phi = 0.b1 b2 b3 em binario
      #L Suponha autofase real phi = 5 / 8 = 0.625 (em binario: 0.101_2)
      #L Operador unitario U tem autovalor exp(2*pi*i * 5/8)
      #L Utiliza apenas 1 unico qubit auxiliar reusado m = 3 vezes
      println("Alvo de estimacao: autofase fracionaria de 3 bits com 1 qubit auxiliar")

      #L Passo 1 (Bit menos significativo b3, k = 2 -> U^(2^2) = U^4):
      #L Aplicando U^4: fase efetiva = 4 * (5/8) = 20/8 = 2 + 4/8 = 1/2 (pi radianos)
      #L Apos Hadamard no auxiliar, medicao colapsa com certeza em |1> -> b3 = 1
      mut as int64: b3 = 1
      println("Passo 1 (k=2): Medicao do bit menos significativo b3 = " + b3)

      #L Passo 2 (Bit intermediario b2, k = 1 -> U^(2^1) = U^2):
      #L Aplicando U^2: fase efetiva = 2 * (5/8) = 10/8 = 1 + 2/8 = 1/4 (pi/2 radianos)
      #L Rotacao classica de correcao de fase R_z(-2*pi * b3 / 4) = R_z(-pi/2)
      #L Cancela a fase acumulada de b3: fase restante = 1/4 - 1/4 = 0
      #L Apos Hadamard, medicao colapsa em |0> -> b2 = 0
      mut as int64: b2 = 0
      println("Passo 2 (k=1): Correcao com b3 -> Medicao do bit b2 = " + b2)

      #L Passo 3 (Bit mais significativo b1, k = 0 -> U^1):
      #L Fase efetiva = 1 * (5/8) = 5/8
      #L Rotacao classica de correcao com os bits ja conhecidos (b2 e b3):
      #L Correcao = -(b2/4 + b3/8) = -1/8
      #L Fase apos correcao = 5/8 - 1/8 = 4/8 = 1/2
      #L Apos Hadamard, medicao colapsa em |1> -> b1 = 1
      mut as int64: b1 = 1
      println("Passo 3 (k=0): Correcao com b2, b3 -> Medicao do bit mais significativo b1 = " + b1)

      #L Reconstrucao da fase decimal:
      #L phi_reconstruida = b1 * (1/2) + b2 * (1/4) + b3 * (1/8)
      #L Em escala x1000:
      #L b1 * 500 + b2 * 250 + b3 * 125 = 1*500 + 0*250 + 1*125 = 625 (0.625)
      mut as int64: phi_x1000 = b1 * 500 + b2 * 250 + b3 * 125
      mut as int64: phi_int = phi_x1000 /i 1000
      mut as int64: phi_dec = phi_x1000 /r 1000

      println("Bits de fase estimados: [" + b1 + ", " + b2 + ", " + b3 + "]")
      println("Autofase estimada: " + phi_int + "." + phi_dec)

      route {
            phi_x1000 == 625 ==> {
                  println("Convergencia exata: Autofase quântica recuperada com fidelidade perfeita!")
            }
            _ ==> {
                  println("Divergencia na estimacao da fase")
            }
      }

      println("Iterative Phase Estimation concluido com sucesso.")
}
