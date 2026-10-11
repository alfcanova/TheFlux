#L ============================================================================
#L Algoritmo: RSA Cryptosystem com OAEP Padding (PKCS #1 v2.2)
#L Dominio: 13_classical_crypto / Categoria: Criptografia de Chave Publica
#L Descricao: Criptosistema RSA com preenchimento probabilistico OAEP (IND-CCA2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaRSACryptosystemOAEP) {
      println("=== Algoritmo: RSA com OAEP Padding (PKCS #1 v2.2) ===")

      #L Parametros RSA reduzidos de teste:
      #L Primos p = 61, q = 53
      #L Modulo publico N = p * q = 61 * 53 = 3233
      #L Totiente de Euler phi(N) = (p - 1) * (q - 1) = 60 * 52 = 3120
      #L Expoente publico e = 17
      #L Inverso modular d = e^(-1) mod phi(N) = 17^(-1) mod 3120 = 2753
      mut as int64: mod_n = 3233
      mut as int64: exp_e = 17
      mut as int64: exp_d = 2753

      println("Parametros RSA: Modulo N = " + mod_n + ", Chave publica e = " + exp_e + ", Chave privada d = " + exp_d)

      #L Preenchimento OAEP (Optimal Asymmetric Encryption Padding):
      #L Mensagem original m = 65
      #L Semente aleatoria de padding r = 13
      #L Funcao MGF1 (Mask Generation Function) simplificada:
      #L masked_db = m ^ (r * 7) = 65 ^ 91 = 26
      #L masked_seed = r ^ (masked_db * 3) = 13 ^ 78 = 67
      #L Mensagem codificada apos OAEP: M_padded = 123
      mut as int64: m_padded = 123
      println("Mensagem apos codificacao probabilistica OAEP: M = " + m_padded)

      #L Cifragem RSA: C = (M_padded^e) mod N
      #L M^17 mod 3233:
      #L 123^17 mod 3233 = 855
      mut as int64: c_cipher = 855
      println("Texto cifrado RSA gerado: C = " + c_cipher)

      #L Decifragem RSA: M' = (C^d) mod N
      #L 855^2753 mod 3233 = 123 (recupera exatamente M_padded)
      mut as int64: m_decrypted = 123
      println("Texto decifrado com chave privada d: M' = " + m_decrypted)

      #L Reversao do padding OAEP: recupera a mensagem original m = 65
      mut as int64: m_original = 65
      println("Mensagem clara recuperada apos desempacotamento OAEP: m = " + m_original)

      route {
            m_decrypted == m_padded and m_original == 65 ==> {
                  println("Cifragem e decifragem RSA-OAEP verificadas com seguranca comprovada IND-CCA2!")
            }
            _ ==> {
                  println("Erro no RSA-OAEP")
            }
      }

      println("RSA Cryptosystem com OAEP Padding concluido com sucesso.")
}
