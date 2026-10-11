#L ============================================================================
#L Algoritmo: Niederreiter Cryptosystem (Variante Dual por Sindromes)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(n * (n - k)) criptografia compacta baseada em sindromes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaNiederreiter) {
      println("==================================================")
      println("  SciAlgo: Niederreiter Cryptosystem (Syndrome PKE)")
      println("==================================================")

      #L O criptossistema de Niederreiter (1986) e a formulacao dual do McEliece.
      #L Enquanto o McEliece cifra palavras de codigo adicionando erro, o Niederreiter
      #L codifica a mensagem diretamente no proprio vetor de erro esparso e,
      #L e o texto cifrado e a sindrome compacta s = H_pub * e^T.
      #L Isso reduz drasticamente o tamanho do texto cifrado de n bits para (n - k) bits.
      #L
      #L Parametros do modelo:
      #L Codigo de bloco n = 7, dimensao k = 4, comprimento da sindrome m = n - k = 3
      #L Peso do erro (mensagem): t = 1
      mut as int64: n = 7
      mut as int64: k = 4
      mut as int64: syndrome_len = 3

      println("1. Parametros do Criptossistema:")
      println("   Comprimento de bloco: n = " + n)
      println("   Tamanho do texto cifrado (sindrome): m = " + syndrome_len + " bits")
      println("   Peso da mensagem e: t = 1")

      #L Matriz de Paridade Publica H_pub (3 x 7) em GF(2):
      #L H_pub = M * H * P
      mut as list of int64: h1 = [1, 0, 1, 1, 1, 0, 0]
      mut as list of int64: h2 = [0, 1, 1, 1, 0, 1, 0]
      mut as list of int64: h3 = [1, 1, 0, 1, 0, 0, 1]

      println("==================================================")
      println("2. Criptografia Niederreiter (Encrypt):")
      #L A mensagem de segredo e um vetor esparso e in GF(2)^7 com peso exato t = 1:
      #L e = [0, 1, 0, 0, 0, 0, 0] (bit 1 ativo)
      mut as list of int64: msg_error = [0, 1, 0, 0, 0, 0, 0]
      println("   Mensagem Original (Vetor Esparso e): " + msg_error)

      #L Texto cifrado e a sindrome s = H_pub * e^T em GF(2):
      mut as int64: s1 = 0
      mut as int64: s2 = 0
      mut as int64: s3 = 0
      mut as int64: j = 0
      infinite (j < n) {
            s1 = (s1 + (h1[j + 1] * msg_error[j + 1])) /r 2
            s2 = (s2 + (h2[j + 1] * msg_error[j + 1])) /r 2
            s3 = (s3 + (h3[j + 1] * msg_error[j + 1])) /r 2
            j = j + 1
      }

      mut as list of int64: ciphertext_syndrome = [s1, s2, s3]
      println("   Texto Cifrado (Sindrome s = H_pub * e): " + ciphertext_syndrome)

      println("==================================================")
      println("3. Descriptografia Niederreiter (Decrypt):")
      #L O receptor usa o decodificador de sindromes de Goppa para inverter
      #L s -> e. Como H_pub e conhecida pela chave privada:
      #L O vetor sindrome s = [0, 1, 1] corresponde identicamente a coluna 2 de H_pub!
      mut as int64: match_col = 0
      j = 0
      infinite (j < n) {
            route {
                  (h1[j + 1] == s1) and (h2[j + 1] == s2) and (h3[j + 1] == s3) ==> {
                        match_col = j + 1
                  }
                  _ ==> {}
            }
            j = j + 1
      }

      println("   Decodificacao de sindrome: Coluna identificada = " + match_col)

      #L Reconstrucao do vetor esparso recuperado:
      mut as list of int64: recovered_e = [0, 0, 0, 0, 0, 0, 0]
      route {
            match_col > 0 ==> { recovered_e[match_col] = 1 }
            _ ==> {}
      }

      println("   Mensagem Recuperada e': " + recovered_e)

      route {
            recovered_e == msg_error ==> {
                  println("   Sucesso: Mensagem decodificada por sindrome com precisao absoluta!")
            }
            _ ==> {
                  println("   Falha na descriptografia Niederreiter.")
            }
      }
      println("   Niederreiter Cryptosystem concluido com sucesso!")
      println("==================================================")
}
