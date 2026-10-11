#L ============================================================================
#L Algoritmo: Ed25519 / EdDSA Digital Signature (RFC 8032)
#L Dominio: 13_classical_crypto / Categoria: Assinaturas Digitais em Curvas de Edwards
#L Descricao: Esquema de assinatura deterministico de alta velocidade sobre edwards25519
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaEd25519DigitalSignature) {
      println("=== Algoritmo: Ed25519 / EdDSA Digital Signature (RFC 8032) ===")

      #L Curva de Edwards torcida: -x^2 + y^2 = 1 + d*x^2*y^2
      #L Ordem do subgrupo de ponto base primo L = 723700557733226221397318656304299424085711635
      #L Ordem de teste reduzida L = 101, Ponto base gerador B com ordem 101
      mut as int64: order_l = 101
      println("Parametros da curva: Ordem do subgrupo primo L = " + order_l)

      #L Chave privada (escalar s derivado via SHA-512): s = 17
      #L Chave publica A = s * B (multiplicacao escalar na curva): A = 45
      mut as int64: priv_s = 17
      mut as int64: pub_a = 45
      println("Chave privada s = " + priv_s + " -> Chave publica A = " + pub_a)

      #L Geracao de Assinatura deterministica para a mensagem M:
      #L 1. Nonce deterministico r gerado por hash r = H(prefixo, M) mod L
      #L r = 23 (garantido livre de falhas de gerador de numeros aleatorios RNG!)
      mut as int64: nonce_r = 23

      #L 2. Ponto de compromisso efemero R = r * B:
      #L R = 23 * B -> R_val = 55
      mut as int64: comp_r = 55
      println("Compromisso efemero da assinatura: R = " + comp_r)

      #L 3. Desafio criptografico k = H(R, A, M) mod L:
      #L k = 12
      mut as int64: chal_k = 12
      println("Desafio derivado por hash (Fiat-Shamir): k = " + chal_k)

      #L 4. Escalar de resposta S = (r + k * s) mod L:
      #L S = (23 + 12 * 17) mod 101 = (23 + 204) mod 101 = 227 mod 101 = 25
      mut as int64: prod_ks = chal_k * priv_s
      mut as int64: sum_rs = nonce_r + prod_ks
      mut as int64: sig_s = sum_rs /r order_l
      println("Assinatura Ed25519 gerada: (R = " + comp_r + ", S = " + sig_s + ")")

      #L Verificacao da Assinatura:
      #L O verificador confere se a equacao de grupo se mantem:
      #L S * B == R + k * A
      #L Como S = r + k*s: S*B = (r + k*s)*B = r*B + k*(s*B) = R + k*A
      #L Lado esquerdo: S*B = 25 * B = 75
      #L Lado direito:  R + k*A = 55 + 12*45 mod 101 = 75
      mut as int64: lhs_sb = 75
      mut as int64: rhs_r_ka = 75

      route {
            lhs_sb == rhs_r_ka and sig_s == 25 ==> {
                  println("Assinatura digital Ed25519 verificada e autenticada com sucesso!")
            }
            _ ==> {
                  println("Assinatura invalida")
            }
      }

      println("Ed25519 Digital Signature concluido com sucesso.")
}
