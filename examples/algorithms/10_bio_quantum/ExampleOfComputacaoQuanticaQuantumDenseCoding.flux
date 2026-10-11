#L ============================================================================
#L Algoritmo: Quantum Dense Coding (Superdense Coding - 2 Bits por Qubit)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos quanticos
#L Complexidade: O(1) circuito | Transmite 2 bits classicos enviando apenas 1 qubit
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfComputacaoQuanticaQuantumDenseCoding) {
      println("==================================================")
      println("  SciAlgo: Quantum Superdense Coding Protocol")
      println("==================================================")

      #L O protocolo de Superdense Coding permite que Alice transmita 2 bits classicos
      #L para Bob manipulando e enviando apenas 1 unico qubit fisico,
      #L explorando o emaranhamento previo de um par de Bell.

      #L Bits classicos que Alice deseja transmitir: (b1, b0) = (1, 1) [valor decimal 3]
      mut as int64: msg_b1 = 1
      mut as int64: msg_b0 = 1

      println("1. Mensagem Classica a ser Transmitida por Alice:")
      println("   Bits: (" + msg_b1 + ", " + msg_b0 + ") [Total: 2 bits classicos]")

      println("==================================================")
      println("2. Par de Bell Compartilhado Inicial (|Phi+>):")
      println("   |Phi+> = 1/sqrt(2) * (|00> + |11>)")
      println("   Alice segura o Qubit A e Bob segura o Qubit B")

      println("==================================================")
      println("3. Codificacao Unitaria Realizada por Alice no Qubit A:")
      #L Tabela de codificacao de Alice:
      #L 00: Porta Identidade I -> |Phi+> = (|00> + |11>)/sqrt(2)
      #L 01: Porta Pauli-X     -> |Psi+> = (|10> + |01>)/sqrt(2)
      #L 10: Porta Pauli-Z     -> |Phi-> = (|00> - |11>)/sqrt(2)
      #L 11: Porta Z * X       -> |Psi-> = (|01> - |10>)/sqrt(2)

      mut as int64: encoded_bell_state = 0 #L 0=|Phi+>, 1=|Psi+>, 2=|Phi->, 3=|Psi->
      route {
            msg_b1 == 0 and msg_b0 == 0 ==> {
                  encoded_bell_state = 0
                  println("   Alice aplica I -> Estado de Bell gerado: |Phi+>")
            }
            msg_b1 == 0 and msg_b0 == 1 ==> {
                  encoded_bell_state = 1
                  println("   Alice aplica X -> Estado de Bell gerado: |Psi+>")
            }
            msg_b1 == 1 and msg_b0 == 0 ==> {
                  encoded_bell_state = 2
                  println("   Alice aplica Z -> Estado de Bell gerado: |Phi->")
            }
            _ ==> {
                  encoded_bell_state = 3
                  println("   Alice aplica Z * X -> Estado de Bell gerado: |Psi->")
            }
      }

      println("   Alice envia seu unico Qubit A para Bob atraves do canal quantico.")

      println("==================================================")
      println("4. Decodificacao por Medicao na Base de Bell por Bob:")
      println("   Bob aplica CNOT(Qubit A, Qubit B) seguido de H(Qubit A):")

      #L As 4 operacoes mapeiam perfeitamente os estados de Bell para os 4 estados computacionais:
      #L |Phi+> -> |00>
      #L |Psi+> -> |01>
      #L |Phi-> -> |10>
      #L |Psi-> -> |11>
      mut as int64: rec_b1 = 0
      mut as int64: rec_b0 = 0

      route {
            encoded_bell_state == 0 ==> {
                  rec_b1 = 0
                  rec_b0 = 0
            }
            encoded_bell_state == 1 ==> {
                  rec_b1 = 0
                  rec_b0 = 1
            }
            encoded_bell_state == 2 ==> {
                  rec_b1 = 1
                  rec_b0 = 0
            }
            _ ==> {
                  rec_b1 = 1
                  rec_b0 = 1
            }
      }

      println("   Medicao Final de Bob: Qubit A = " + rec_b1 + ", Qubit B = " + rec_b0)
      println("   Mensagem Decodificada: (" + rec_b1 + ", " + rec_b0 + ")")

      route {
            rec_b1 == msg_b1 and rec_b0 == msg_b0 ==> {
                  println("   Sucesso: Capacidade de canal duplicada via emaranhamento quantico!")
            }
            _ ==> {}
      }

      println("   Quantum Dense Coding concluido com sucesso!")
      println("==================================================")
}
