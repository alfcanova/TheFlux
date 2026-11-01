#L ============================================================================
#L Algoritmo: Poly1305 One-Time Authenticator (RFC 8439)
#L Dominio: 13_classical_crypto / Categoria: Autenticacao de Mensagens (MAC)
#L Descricao: MAC baseado em avaliacao de polinomio sobre o primo 2^130 - 5
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaPoly1305OneTimeAuthenticator) {
      println("=== Algoritmo: Poly1305 One-Time Authenticator (RFC 8439) ===")

      #L Primo canonico de Bernstein: p = 2^130 - 5
      #L Chave de 32 bytes dividida em r (16 bytes) e s (16 bytes):
      #L r passa por processo de clamp (fixacao de bits especificos em zero):
      #L r_clamped = 13 (valor escalar representativo)
      #L Segredo aditivo s = 100
      mut as int64: r_clamp = 13
      mut as int64: s_secret = 100
      println("Chave Poly1305: r_clamped = " + r_clamp + ", s = " + s_secret)

      #L Acumulador inicial a = 0
      mut as int64: a_acc = 0

      #L Mensagem dividida em blocos de 16 bytes:
      #L Bloco 1 com bit sentinela adicionado (0x01 no 17o byte): c1 = 25
      #L a = ((a + c1) * r) mod p
      #L a = ((0 + 25) * 13) = 325
      mut as int64: c1 = 25
      a_acc = ((a_acc + c1) * r_clamp)
      println("Processamento do Bloco 1: Acumulador a = " + a_acc)

      #L Bloco 2: c2 = 10
      #L a = ((a + c2) * r) mod p
      #L a = ((325 + 10) * 13) = 335 * 13 = 4355
      mut as int64: c2 = 10
      a_acc = ((a_acc + c2) * r_clamp)
      println("Processamento do Bloco 2: Acumulador a = " + a_acc)

      #L Tag final Poly1305 T = (a + s) mod 2^128:
      #L T = 4355 + 100 = 4455
      mut as int64: tag_poly1305 = a_acc + s_secret
      println("Tag de Autenticacao Poly1305 (MAC) gerada: T = " + tag_poly1305)

      route {
            a_acc == 4355 and tag_poly1305 == 4455 ==> {
                  println("Autenticacao Poly1305 validada: Integridade one-time de mensagem comprovada!")
            }
            _ ==> {
                  println("Erro na geracao do MAC")
            }
      }

      println("Poly1305 Authenticator concluido com sucesso.")
}
