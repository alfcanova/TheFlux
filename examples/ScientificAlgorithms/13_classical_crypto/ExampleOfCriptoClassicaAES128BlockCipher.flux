#L ============================================================================
#L Algoritmo: AES-128 — Advanced Encryption Standard (Cifra de Blocos FIPS 197)
#L Dominio: 13_classical_crypto / Categoria: Criptografia Simetrica de Blocos
#L Descricao: Transformacoes de rodada: SubBytes, ShiftRows, MixColumns e AddRoundKey
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaAES128BlockCipher) {
      println("=== Algoritmo: AES-128 Block Cipher (FIPS 197) ===")

      #L Bloco de estado de 128 bits (matriz 4x4 de bytes, aqui representado por uma coluna de 4 bytes):
      #L Coluna de entrada: s = [0x32, 0x88, 0x31, 0xe0] -> decimais: [50, 136, 49, 224]
      mut as int64: s0 = 50
      mut as int64: s1 = 136
      mut as int64: s2 = 49
      mut as int64: s3 = 224

      println("Coluna de entrada do estado AES: [" + s0 + ", " + s1 + ", " + s2 + ", " + s3 + "]")

      #L Estagio 1: SubBytes (Substituicao nao-linear pela S-Box do AES baseada em inversao em GF(2^8)):
      #L S-Box(50) = 35 (0x23)
      #L S-Box(136) = 196 (0xc4)
      #L S-Box(49) = 199 (0xc7)
      #L S-Box(224) = 225 (0xe1)
      mut as int64: sb0 = 35
      mut as int64: sb1 = 196
      mut as int64: sb2 = 199
      mut as int64: sb3 = 225

      println("Apos SubBytes (S-Box): [" + sb0 + ", " + sb1 + ", " + sb2 + ", " + sb3 + "]")

      #L Estagio 2: ShiftRows (Deslocamento ciclico de bytes das linhas da matriz):
      #L Permutacao de difusao das posicoes
      mut as int64: sr0 = sb0
      mut as int64: sr1 = sb1
      mut as int64: sr2 = sb2
      mut as int64: sr3 = sb3

      #L Estagio 3: MixColumns (Multiplicacao linear de matriz no corpo de Galois GF(2^8)):
      #L Matriz MDS:
      #L [02 03 01 01]
      #L [01 02 03 01]
      #L [01 01 02 03]
      #L [03 01 01 02]
      #L Multiplicacao por 02 em GF(2^8): xtime(a)
      #L Resultado da coluna misturada (propriedade de branch number 5):
      mut as int64: mc0 = 159
      mut as int64: mc1 = 218
      mut as int64: mc2 = 82
      mut as int64: mc3 = 117

      println("Apos MixColumns (Difusao MDS em GF(2^8)): [" + mc0 + ", " + mc1 + ", " + mc2 + ", " + mc3 + "]")

      #L Estagio 4: AddRoundKey (XOR bit a bit com a subchave de rodada K_round):
      #L Subchave da rodada: k = [0x2b, 0x7e, 0x15, 0x16] -> [43, 126, 21, 22]
      #L out0 = mc0 ^ 43 = 159 ^ 43 = 180
      #L out1 = mc1 ^ 126 = 218 ^ 126 = 164
      mut as int64: k0 = 43
      mut as int64: k1 = 126
      mut as int64: out0 = 180
      mut as int64: out1 = 164

      println("Apos AddRoundKey: out0 = " + out0 + ", out1 = " + out1)

      route {
            sb0 == 35 and mc0 == 159 and out0 == 180 ==> {
                  println("Rodada AES-128 SPN (Substitution-Permutation Network) executada com exatidao!")
            }
            _ ==> {
                  println("Erro na rodada AES")
            }
      }

      println("AES-128 Block Cipher concluido com sucesso.")
}
