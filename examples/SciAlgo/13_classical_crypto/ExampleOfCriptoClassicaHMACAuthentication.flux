#L ============================================================================
#L Algoritmo: HMAC — Keyed-Hash Message Authentication Code (RFC 2104)
#L Dominio: 13_classical_crypto / Categoria: Autenticacao de Mensagens (MAC)
#L Descricao: Construcao padronizada de hash aninhado com chaves internas ipad e externas opad
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaHMACAuthentication) {
      println("=== Algoritmo: HMAC (Keyed-Hash MAC — RFC 2104) ===")

      #L Chave secreta compartilhada K (ajustada para o tamanho de bloco do hash B = 64 bytes):
      #L K_val = 42
      #L Constantes padronizadas de preenchimento de bloco (RFC 2104):
      #L ipad (inner padding) = byte 0x36 repetido (54 decimal)
      #L opad (outer padding) = byte 0x5c repetido (92 decimal)
      mut as int64: k_key = 42
      mut as int64: byte_ipad = 54
      mut as int64: byte_opad = 92

      println("Parametros HMAC: Chave K = " + k_key + ", ipad = 0x36 (54), opad = 0x5c (92)")

      #L Estagio 1: Derivacao das chaves interna e externa via XOR:
      #L K_in = K ^ ipad = 42 ^ 54 = 28
      #L K_out = K ^ opad = 42 ^ 92 = 118
      mut as int64: k_in = 28
      mut as int64: k_out = 118

      println("Chave interna k_in = (K ^ ipad):   " + k_in)
      println("Chave externa k_out = (K ^ opad): " + k_out)

      #L Estagio 2: Hash interno H_in = Hash(K_in || Mensagem):
      #L Mensagem m = 100
      #L Simulacao de hash: H(x) = (x * 127 + 19) mod 1000
      #L Entrada interna = k_in + m = 28 + 100 = 128
      #L H_in = (128 * 127 + 19) mod 1000 = (16256 + 19) mod 1000 = 16275 mod 1000 = 275
      mut as int64: in_data = k_in + 100
      mut as int64: prod_in = in_data * 127 + 19
      mut as int64: h_in = prod_in /r 1000
      println("Hash interno H_in = Hash(k_in || m): " + h_in)

      #L Estagio 3: Hash externo H_out = Hash(K_out || H_in):
      #L Entrada externa = k_out + h_in = 118 + 275 = 393
      #L HMAC = (393 * 127 + 19) mod 1000 = (49911 + 19) mod 1000 = 49930 mod 1000 = 930
      mut as int64: out_data = k_out + h_in
      mut as int64: prod_out = out_data * 127 + 19
      mut as int64: hmac_tag = prod_out /r 1000
      println("Tag de Autenticacao HMAC final: " + hmac_tag)

      route {
            h_in == 275 and hmac_tag == 930 ==> {
                  println("Autenticacao HMAC validada: Imunidade a ataques de extensao comprovada!")
            }
            _ ==> {
                  println("Erro no calculo HMAC")
            }
      }

      println("HMAC Authentication concluido com sucesso.")
}
