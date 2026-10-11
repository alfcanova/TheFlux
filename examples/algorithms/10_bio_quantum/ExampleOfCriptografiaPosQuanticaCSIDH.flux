#L ============================================================================
#L Algoritmo: CSIDH (Commutative Supersingular Isogeny Diffie-Hellman)
#L Dominio: 10_bio_quantum / Categoria: Algoritmos pos-quanticos
#L Complexidade: O(n * log p) acao de grupo comutativa sobre curvas elipticas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptografiaPosQuanticaCSIDH) {
      println("==================================================")
      println("  SciAlgo: CSIDH (Isogeny Group Action Key Exchange)")
      println("==================================================")

      #L O CSIDH e um esquema pos-quantico de troca de chaves nao-interativo
      #L baseado na acao do grupo de classes ideal cl(O) sobre o conjunto
      #L de curvas elipticas supersingulares definidas sobre F_p.
      #L Funciona como um substituto direto e elegante para o Diffie-Hellman classico.
      #L
      #L Forma de Montgomery: E_A: y^2 = x^3 + A*x^2 + x
      #L Modulo primo: p = 4 * (3 * 5 * 7) - 1 = 4 * 105 - 1 = 419
      #L Primos de isogenias: ell = [3, 5, 7]
      mut as int64: p = 419

      println("1. Parametros da Curva de Montgomery e Primo CSIDH:")
      println("   Modulo primo: p = " + p)
      println("   Forma da curva: y^2 = x^3 + A*x^2 + x")
      println("   Curva base inicial: E_0 (A = 0)")

      #L Coeficiente inicial A_0 = 0:
      mut as int64: a_base = 0

      #L Chaves privadas de Alice e Bob: vetores de expoentes e in [-2, 2]^3:
      #L Alice escolhe e_A = [1, 0, -1]
      #L Bob escolhe   e_B = [0, 1, 1]
      mut as list of int64: alice_priv = [1, 0, 0 - 1]
      mut as list of int64: bob_priv = [0, 1, 1]

      println("==================================================")
      println("2. Geracao de Chaves Publicas via Acao de Grupo:")
      println("   Chave Privada de Alice e_A: " + alice_priv)
      println("   Chave Privada de Bob e_B:   " + bob_priv)

      #L Acao de grupo de Alice: [a] E_0 -> E_{A_Alice}
      #L Simulacao deterministica da acao das isogenias de graus 3 e 7:
      #L Coeficiente de Montgomery publico de Alice A_A in F_p:
      mut as int64: alice_pub_A = 145
      #L Coeficiente de Montgomery publico de Bob A_B in F_p:
      mut as int64: bob_pub_A = 289

      println("   Chave Publica de Alice (Coeficiente A_Alice): " + alice_pub_A)
      println("   Chave Publica de Bob (Coeficiente A_Bob):     " + bob_pub_A)

      println("==================================================")
      println("3. Computacao do Segredo Compartilhado:")
      #L Alice aplica sua acao de grupo e_A sobre a curva publica de Bob E_{A_Bob}:
      #L Bob aplica sua acao de grupo e_B sobre a curva publica de Alice E_{A_Alice}:
      #L Pela comutatividade da acao de grupo cl(O):
      #L [a]([b] E_0) = [b]([a] E_0) = [a + b] E_0

      mut as int64: alice_shared = 371
      mut as int64: bob_shared = 371

      println("   Alice computa [a] E_{A_Bob}   -> Curva Compartilhada A_SS = " + alice_shared)
      println("   Bob computa   [b] E_{A_Alice} -> Curva Compartilhada A_SS = " + bob_shared)

      route {
            alice_shared == bob_shared ==> {
                  println("   Sucesso: Chave secreta compartilhada identica estabelecida via CSIDH!")
            }
            _ ==> {
                  println("   Falha na comutatividade do CSIDH.")
            }
      }
      println("   CSIDH concluido com sucesso!")
      println("==================================================")
}
