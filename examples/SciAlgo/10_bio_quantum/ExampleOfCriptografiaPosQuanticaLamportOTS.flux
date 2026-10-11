#L ============================================================================
#L Algoritmo: Lamport One-Time Signature (OTS - Assinatura de Uso Unico)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(n) avaliacoes de funcao hash unidirecional
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaLamportOTS) {
      println("==================================================")
      println("  SciAlgo: Lamport One-Time Signature (Lamport OTS)")
      println("==================================================")

      #L O esquema de Lamport (1979) e o protocolo pioneiro de assinatura
      #L digital baseado puramente em funcoes unidirecionais (hash).
      #L Para assinar uma mensagem de n bits, gera 2*n valores secretos.
      #L
      #L Parametros do modelo:
      #L Tamanho da mensagem: n = 4 bits
      mut as int64: n_bits = 4

      println("1. Parametros do Esquema:")
      println("   Comprimento da mensagem: n = " + n_bits + " bits")

      #L Chave privada SK composta por 2 * n segredos:
      #L Par i (bit 0 vs bit 1):
      #L sk_0 = [101, 103, 107, 109] (para bits '0')
      #L sk_1 = [201, 203, 207, 209] (para bits '1')
      mut as list of int64: sk_0 = [101, 103, 107, 109]
      mut as list of int64: sk_1 = [201, 203, 207, 209]

      #L Funcao hash simples deterministica: H(x) = (x * 37 + 11) mod 1000
      #L Chave publica PK = H(sk):
      mut as list of int64: pk_0 = [0, 0, 0, 0]
      mut as list of int64: pk_1 = [0, 0, 0, 0]

      println("==================================================")
      println("2. Geracao de Chave Publica PK = H(SK):")
      mut as int64: i = 0
      infinite (i < n_bits) {
            pk_0[i + 1] = ((sk_0[i + 1] * 37) + 11) /r 1000
            pk_1[i + 1] = ((sk_1[i + 1] * 37) + 11) /r 1000
            i = i + 1
      }

      println("   Chave Privada sk_0: " + sk_0)
      println("   Chave Privada sk_1: " + sk_1)
      println("   Chave Publica pk_0: " + pk_0)
      println("   Chave Publica pk_1: " + pk_1)

      println("==================================================")
      println("3. Assinatura da Mensagem (Sign):")
      #L Mensagem binaria de 4 bits: m = [1, 0, 1, 1]
      mut as list of int64: msg = [1, 0, 1, 1]
      println("   Mensagem a assinar: " + msg)

      #L Para cada bit m[i]: se 0 revela sk_0[i], se 1 revela sk_1[i]:
      mut as list of int64: signature = [0, 0, 0, 0]
      i = 0
      infinite (i < n_bits) {
            route {
                  msg[i + 1] == 0 ==> { signature[i + 1] = sk_0[i + 1] }
                  _ ==> { signature[i + 1] = sk_1[i + 1] }
            }
            i = i + 1
      }

      println("   Assinatura Lamport OTS gerada: " + signature)

      println("==================================================")
      println("4. Verificacao da Assinatura (Verify):")
      #L O verificador aplica hash a cada elemento da assinatura e
      #L compara com a respectiva chave publica:
      mut as bool: all_valid = true
      i = 0
      infinite (i < n_bits) {
            mut as int64: sig_val = signature[i + 1]
            mut as int64: hashed_sig = ((sig_val * 37) + 11) /r 1000
            mut as int64: expected_pk = 0
            route {
                  msg[i + 1] == 0 ==> { expected_pk = pk_0[i + 1] }
                  _ ==> { expected_pk = pk_1[i + 1] }
            }
            println("   Bit " + i + " (" + msg[i + 1] + "): H(" + sig_val + ") = " + hashed_sig + " | Esperado = " + expected_pk)
            route {
                  hashed_sig != expected_pk ==> { all_valid = false }
                  _ ==> {}
            }
            i = i + 1
      }

      route {
            all_valid ==> {
                  println("   Sucesso: Assinatura Lamport OTS verificada e autenticada!")
            }
            _ ==> {
                  println("   Falha: Assinatura Lamport incorreta.")
            }
      }
      println("   Lamport OTS concluido com sucesso!")
      println("==================================================")
}
