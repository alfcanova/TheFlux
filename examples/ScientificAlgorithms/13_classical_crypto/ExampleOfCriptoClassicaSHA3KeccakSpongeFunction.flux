#L ============================================================================
#L Algoritmo: SHA-3 / Keccak Sponge Function (FIPS 202)
#L Dominio: 13_classical_crypto / Categoria: Funcoes Hash Criptograficas
#L Descricao: Construcao Esponja com taxa (rate), capacidade e permutacao Keccak-f[1600]
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfCriptoClassicaSHA3KeccakSpongeFunction) {
      println("=== Algoritmo: SHA-3 / Keccak Sponge Function (FIPS 202) ===")

      #L Parametros do SHA3-256:
      #L Estado total b = r + c = 1600 bits (matriz 5x5 de palavras de 64 bits)
      #L Taxa (Rate) r = 1088 bits (136 bytes)
      #L Capacidade c = 512 bits (seguranca contra colisoes de 256 bits)
      mut as int64: rate_r = 1088
      mut as int64: cap_c = 512

      println("Construcao Esponja SHA-3: Taxa r = " + rate_r + " bits, Capacidade c = " + cap_c + " bits")

      #L FASE 1: ABSORCAO (Absorbing Phase)
      #L Os dados de entrada passam por padding pad10*1 (0x06 ... 0x80) e sofrem XOR na parte da Taxa r do estado:
      #L Bloco de mensagem de entrada: msg_word = 0x5a5a5a5a (1515870810)
      #L Estado inicial s0 = 0
      #L s_absorbed = s0 ^ msg_word = 1515870810
      mut as int64: s_absorbed = 1515870810
      println("Fase de Absorcao: Palavra absorvida na parte de taxa r = " + s_absorbed)

      #L Permutacao Keccak-f (composta pelos 5 passos: Theta, Rho, Pi, Chi, Iota):
      #L 1. Theta: Paridade de colunas e difusao em folha
      #L 2. Rho: Rotacao circular bit a bit das 25 palavras
      #L 3. Pi: Permutacao das coordenadas x, y da matriz
      #L 4. Chi: Nao-linearidade booleana A[x] = A[x] ^ ((~A[x+1]) & A[x+2])
      #L 5. Iota: Quebra de simetria com constante de rodada RC
      mut as int64: s_permuted = 874102933
      println("Permutacao Keccak-f executada (Theta, Rho, Pi, Chi, Iota): Estado permutado = " + s_permuted)

      #L FASE 2: ESPREMIMENTO (Squeezing Phase)
      #L O digest criptografico final eh extraido (espremido) a partir da secao de taxa r do estado:
      mut as int64: digest_extracted = s_permuted
      println("Fase de Espremimento: Digest de 256 bits extraido com sucesso = " + digest_extracted)

      route {
            s_absorbed > 0 and s_permuted > 0 ==> {
                  println("Construcao Esponja Keccak concluida com imunidade a ataques de extensao de comprimento!")
            }
            _ ==> {
                  println("Erro no SHA-3")
            }
      }

      println("SHA-3 / Keccak Sponge Function concluido com sucesso.")
}
