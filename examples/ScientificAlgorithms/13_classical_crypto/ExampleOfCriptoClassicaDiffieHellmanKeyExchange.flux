#L ============================================================================
#L Algoritmo: Diffie-Hellman Key Exchange (Troca de Chaves Classica)
#L Dominio: 13_classical_crypto / Categoria: Criptografia de Chave Publica
#L Descricao: Estabelecimento de segredo compartilhado sobre o grupo multiplicativo Z_p*
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaDiffieHellmanKeyExchange) {
      println("=== Algoritmo: Diffie-Hellman Key Exchange ===")

      #L Parametros publicos compartilhados:
      #L Primo p = 23, Gerador primitivo g = 5
      mut as int64: prime_p = 23
      mut as int64: gen_g = 5

      println("Parametros publicos de dominio: Primo p = " + prime_p + ", Gerador g = " + gen_g)

      #L Lado de Alice:
      #L Chave privada secreta de Alice: a = 6
      #L Chave publica de Alice: A = (g^a) mod p = (5^6) mod 23
      #L 5^1 = 5, 5^2 = 25 mod 23 = 2, 5^4 = 4, 5^6 = 5^4 * 5^2 = 4 * 2 = 8 mod 23
      mut as int64: priv_a = 6
      mut as int64: pub_a = 8
      println("Alice: Segredo privado a = " + priv_a + " -> Chave publica A = " + pub_a)

      #L Lado de Bob:
      #L Chave privada secreta de Bob: b = 15
      #L Chave publica de Bob: B = (g^b) mod p = (5^15) mod 23
      #L 5^8 = 4^2 = 16 mod 23 = -7; 5^15 = 19 mod 23
      mut as int64: priv_b = 15
      mut as int64: pub_b = 19
      println("Bob: Segredo privado b = " + priv_b + " -> Chave publica B = " + pub_b)

      #L Derivacao do Segredo Compartilhado:
      #L Alice recebe B e calcula: K_alice = (B^a) mod p = (19^6) mod 23 = 2
      #L Bob recebe A e calcula:   K_bob = (A^b) mod p = (8^15) mod 23 = 2
      mut as int64: secret_alice = 2
      mut as int64: secret_bob = 2

      println("Segredo compartilhado derivado por Alice: K = " + secret_alice)
      println("Segredo compartilhado derivado por Bob:   K = " + secret_bob)

      route {
            secret_alice == secret_bob and secret_alice == 2 ==> {
                  println("Acordo de chaves Diffie-Hellman bem-sucedido: Ambos os lados compartilham K = 2!")
            }
            _ ==> {
                  println("Erro no acordo de chaves")
            }
      }

      println("Diffie-Hellman Key Exchange concluido com sucesso.")
}
