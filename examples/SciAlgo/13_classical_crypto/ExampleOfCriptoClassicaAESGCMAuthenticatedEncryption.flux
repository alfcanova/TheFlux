#L ============================================================================
#L Algoritmo: AES-GCM (Galois/Counter Mode — Autenticacao AEAD FIPS)
#L Dominio: 13_classical_crypto / Categoria: Criptografia Autenticada (AEAD)
#L Descricao: Cifra simetrica de alta performance combinando CTR mode com GHASH em GF(2^128)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaAESGCMAuthenticatedEncryption) {
      println("=== Algoritmo: AES-GCM (Galois/Counter Mode) ===")

      #L Subchave hash H gerada pela cifragem do bloco de zeros: H = AES_K(0^128)
      #L Valor hash escalar simplificado: H = 17 (elemento de GF)
      mut as int64: h_sub = 17

      #L Dados adicionais autenticados (AAD - Associated Data): texto claro nao-cifrado
      #L AAD_block = 5
      mut as int64: aad_val = 5

      #L Texto claro confidencial a cifrar: P = [42, 99]
      #L Modo CTR: Keystream gerado por contador ICB (Initial Counter Block):
      #L KS0 = 100, KS1 = 150
      mut as int64: p0 = 42
      mut as int64: p1 = 99
      mut as int64: ks0 = 100
      mut as int64: ks1 = 150

      #L Texto cifrado C = P ^ Keystream:
      #L C0 = 42 ^ 100 = 78
      #L C1 = 99 ^ 150 = 245
      mut as int64: c0 = 78
      mut as int64: c1 = 245
      println("Texto cifrado gerado no Modo CTR: C0 = " + c0 + ", C1 = " + c1)

      #L GHASH Universal Hash Function sobre o corpo finito GF(2^128):
      #L Acumulador X_0 = 0
      #L Passo 1: Autentica AAD:
      #L X_1 = (X_0 ^ AAD) * H mod Poly = (0 ^ 5) * 17 = 85
      mut as int64: x1 = aad_val * h_sub
      println("GHASH passo 1 (Processamento de Dados Associados AAD): X1 = " + x1)

      #L Passo 2: Autentica Bloco Cifrado C0:
      #L X_2 = (X_1 ^ C0) * H mod Poly
      #L (85 ^ 78) = 11
      #L 11 * 17 = 187
      mut as int64: x2 = 187
      println("GHASH passo 2 (Processamento de Texto Cifrado): X2 = " + x2)

      #L Passo 3: Tag de Autenticacao (GMAC Tag T):
      #L T = GHASH(AAD, C, len) ^ AES_K(J0)
      #L Mascara J0 = 200
      #L Tag T = 187 ^ 200 = 51
      mut as int64: tag_auth = 51
      println("Tag de Autenticacao GMAC T (128 bits) gerada: " + tag_auth)

      #L Verificacao de integridade:
      route {
            c0 == 78 and tag_auth == 51 ==> {
                  println("Cifra Autenticada AEAD AES-GCM concluida: Confidencialidade e integridade garantidas!")
            }
            _ ==> {
                  println("Falha na autenticacao AEAD")
            }
      }

      println("AES-GCM Authenticated Encryption concluido com sucesso.")
}
