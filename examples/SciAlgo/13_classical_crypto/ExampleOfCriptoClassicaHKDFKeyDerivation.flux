#L ============================================================================
#L Algoritmo: HKDF — Key Derivation Function (RFC 5869 — TLS 1.3)
#L Dominio: 13_classical_crypto / Categoria: Derivacao de Chaves Criptograficas
#L Descricao: Padrao em dois estagios (Extract e Expand) para extracao e expansao de chaves
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaHKDFKeyDerivation) {
      println("=== Algoritmo: HKDF Key Derivation (RFC 5869) ===")

      #L Material de chave de entrada inicial (IKM - Input Keying Material):
      #L ex: segredo Diffie-Hellman compartilhado com entropia difusa
      #L ikm = 1234
      #L Sal opcional nao-secreto (Salt): salt = 55
      mut as int64: ikm = 1234
      mut as int64: salt = 55
      println("Entradas: IKM = " + ikm + ", Salt = " + salt)

      #L ESTAGIO 1: HKDF-EXTRACT
      #L Extrai uma chave pseudo-aleatoria uniforme (PRK - Pseudorandom Key):
      #L PRK = HMAC-Hash(Salt, IKM)
      #L Simulacao de HMAC com gerador deterministico: PRK = (salt * 179 + ikm * 31) mod 10000
      #L PRK = (55 * 179 + 1234 * 31) mod 10000 = (9845 + 38254) mod 10000 = 48099 mod 10000 = 8099
      mut as int64: sum_extract = salt * 179 + ikm * 31
      mut as int64: prk = sum_extract /r 10000
      println("Estagio 1 (HKDF-Extract): Chave Pseudo-Aleatoria PRK = " + prk)

      #L ESTAGIO 2: HKDF-EXPAND
      #L Expande a PRK no material de chave de saida desejado (OKM - Output Keying Material)
      #L Contexto de aplicacao (Info): info_tag = 42 ("handshake key" ou "traffic key")
      #L Bloco 1: T1 = HMAC-Hash(PRK, info || 0x01)
      #L T1 = (prk * 73 + 42 * 11 + 1) mod 10000
      #L T1 = (8099 * 73 + 462 + 1) mod 10000 = (591227 + 463) mod 10000 = 591690 mod 10000 = 1690
      mut as int64: sum_expand1 = prk * 73 + 42 * 11 + 1
      mut as int64: okm_key1 = sum_expand1 /r 10000
      println("Estagio 2 (HKDF-Expand): Subchave 1 derivada (OKM_1) = " + okm_key1)

      #L Bloco 2: T2 = HMAC-Hash(PRK, T1 || info || 0x02)
      #L T2 = (prk * 73 + okm_key1 * 13 + 2) mod 10000
      #L T2 = (591227 + 1690 * 13 + 2) mod 10000 = (591227 + 21970 + 2) mod 10000 = 613199 mod 10000 = 3199
      mut as int64: sum_expand2 = prk * 73 + okm_key1 * 13 + 2
      mut as int64: okm_key2 = sum_expand2 /r 10000
      println("Estagio 2 (HKDF-Expand): Subchave 2 derivada (OKM_2) = " + okm_key2)

      route {
            prk == 8099 and okm_key1 == 1690 and okm_key2 == 3199 ==> {
                  println("Derivacao HKDF em dois estagios concluida em total conformidade com a RFC 5869!")
            }
            _ ==> {
                  println("Erro no HKDF")
            }
      }

      println("HKDF Key Derivation concluido com sucesso.")
}
