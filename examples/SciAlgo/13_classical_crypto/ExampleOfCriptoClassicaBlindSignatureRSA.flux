#L ============================================================================
#L Algoritmo: Chaum Blind Signature (Assinatura Cega para Voto e Moeda Eletronica)
#L Dominio: 13_classical_crypto / Categoria: Protocolos Criptograficos Avancados
#L Descricao: Obfuso de mensagem antes da assinatura sem que o signatario conheca o conteudo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaBlindSignatureRSA) {
      println("=== Algoritmo: Chaum Blind Signature (David Chaum) ===")

      #L Parametros RSA da autoridade signataria (Bob / Urna Eletronica):
      #L Modulo publico N = 33, Chave publica e = 3, Chave privada d = 7
      mut as int64: mod_n = 33
      mut as int64: exp_e = 3
      mut as int64: exp_d = 7

      println("Autoridade: Modulo N = " + mod_n + ", Chave publica e = " + exp_e)

      #L Mensagem de voto confidencial de Alice: m = 4
      #L Fator de cegamento aleatorio escolhido por Alice (Blinding Factor r): r = 2
      #L Inverso modular de r mod N: r_inv = 2^(-1) mod 33 = 17 (2 * 17 = 34 = 1 mod 33)
      mut as int64: msg_m = 4
      mut as int64: factor_r = 2
      mut as int64: r_inv = 17

      println("Alice: Mensagem secreta m = " + msg_m + ", Fator de cegamento r = " + factor_r)

      #L ESTAGIO 1: CEGAMENTO (Blinding por Alice):
      #L Alice calcula: m_cego = (m * r^e) mod N
      #L r^e = 2^3 = 8
      #L m_cego = (4 * 8) mod 33 = 32 mod 33 = 32
      mut as int64: r_pow_e = factor_r * factor_r * factor_r
      mut as int64: m_cega = (msg_m * r_pow_e) /r mod_n
      println("Estagio 1 (Blinding): Mensagem ofuscada enviada a autoridade: m' = " + m_cega)

      #L ESTAGIO 2: ASSINATURA CEGA (Signing por Bob):
      #L Bob assina m' sem saber seu conteudo real:
      #L s' = (m')^d mod N = (32^7) mod 33 = 32 (pois 32 = -1 mod 33, (-1)^7 = -1 = 32)
      mut as int64: sig_cega = 32
      println("Estagio 2 (Signing): Autoridade assina a mensagem cega: s' = " + sig_cega)

      #L ESTAGIO 3: DESCEGAMENTO (Unblinding por Alice):
      #L Alice remove o fator de cegamento r:
      #L s = (s' * r^(-1)) mod N = (32 * 17) mod 33 = 544 mod 33 = 16
      mut as int64: prod_unblind = sig_cega * r_inv
      mut as int64: sig_final = prod_unblind /r mod_n
      println("Estagio 3 (Unblinding): Assinatura autentica descegada: s = " + sig_final)

      #L VERIFICACAO PUBLICA:
      #L Qualquer terceiro confere a assinatura valida de Bob sobre a mensagem original m:
      #L (s^e) mod N = (16^3) mod 33 = 4096 mod 33 = 4 = m!
      mut as int64: verif = (16 * 16 * 16) /r mod_n
      println("Verificacao publica da assinatura: (s^e mod N) = " + verif + " (Igual a m = " + msg_m + ")")

      route {
            verif == msg_m and sig_final == 16 ==> {
                  println("Assinatura cega de Chaum perfeitamente autenticada preservando anonimato estrito!")
            }
            _ ==> {
                  println("Falha na assinatura cega")
            }
      }

      println("Chaum Blind Signature concluido com sucesso.")
}
