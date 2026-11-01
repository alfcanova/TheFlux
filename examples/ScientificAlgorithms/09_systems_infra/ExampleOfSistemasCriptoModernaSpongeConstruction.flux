#L ============================================================================
#L Algoritmo: Sponge Construction (Keccak / SHA-3 Permutacao, Absorcao e Espremedura)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaSpongeConstruction) {
      println("==================================================")
      println("  SciAlgo: Cryptographic Sponge Construction")
      println("==================================================")

      #L Largura do estado b = r + c = 4 palavras de 32 bits
      #L Taxa (Rate) r = 2 palavras (v[1], v[2]) - parte exposta a I/O
      #L Capacidade c = 2 palavras (v[3], v[4]) - segredo interno que garante seguranca
      mut as list of int64: state = [0, 0, 0, 0]
      mut as int64: mask32 = 4294967295

      println("1. Parametros da Esponja:")
      println("   Largura do Estado b: 4 palavras (128 bits)")
      println("   Rate r (Exposta):     2 palavras (64 bits)")
      println("   Capacity c (Oculta):  2 palavras (64 bits)")

      #L Mensagem de entrada particionada em 2 blocos de tamanho r (2 palavras cada)
      mut as list of int64: block1 = [12345, 67890]
      mut as list of int64: block2 = [11111, 22222]

      println("==================================================")
      println("2. Fase de Absorcao (Absorbing Phase):")

      #L Absorcao do Bloco 1: XOR nos primeiros r elementos
      state[1] = state[1] ^ block1[1]
      state[2] = state[2] ^ block1[2]
      println("   Absorvido Bloco 1: Rate=[" + state[1] + ", " + state[2] + "]")

      #L Permutacao interna f(State) - 3 rodadas de mistura nao-linear
      mut as int64: rnd = 1
      infinite (rnd <= 3) {
            #L Theta (mistura de paridade)
            mut as int64: cXor = state[1] ^ state[2] ^ state[3] ^ state[4]
            state[1] = (state[1] ^ cXor) & mask32
            state[2] = (state[2] ^ cXor) & mask32
            state[3] = (state[3] ^ cXor) & mask32
            state[4] = (state[4] ^ cXor) & mask32

            #L Rho e Pi (rotacoes e permutacao de posicoes)
            state[1] = ((state[1] << 7) & mask32) | ((state[1] >>> 25) & mask32)
            state[2] = ((state[2] << 12) & mask32) | ((state[2] >>> 20) & mask32)
            state[3] = ((state[3] << 17) & mask32) | ((state[3] >>> 15) & mask32)
            state[4] = ((state[4] << 23) & mask32) | ((state[4] >>> 9) & mask32)

            #L Chi (nao-linearidade) e Iota (constante de rodada)
            state[1] = state[1] ^ ((~state[2]) & state[3] & mask32) ^ rnd
            rnd = rnd + 1
      }
      println("   Estado apos Permutacao 1: [" + state[1] + ", " + state[2] + ", " + state[3] + ", " + state[4] + "]")

      #L Absorcao do Bloco 2
      state[1] = state[1] ^ block2[1]
      state[2] = state[2] ^ block2[2]
      println("   Absorvido Bloco 2: Rate=[" + state[1] + ", " + state[2] + "]")

      rnd = 1
      infinite (rnd <= 3) {
            mut as int64: cXor = state[1] ^ state[2] ^ state[3] ^ state[4]
            state[1] = (state[1] ^ cXor) & mask32
            state[2] = (state[2] ^ cXor) & mask32
            state[3] = (state[3] ^ cXor) & mask32
            state[4] = (state[4] ^ cXor) & mask32

            state[1] = ((state[1] << 7) & mask32) | ((state[1] >>> 25) & mask32)
            state[2] = ((state[2] << 12) & mask32) | ((state[2] >>> 20) & mask32)
            state[3] = ((state[3] << 17) & mask32) | ((state[3] >>> 15) & mask32)
            state[4] = ((state[4] << 23) & mask32) | ((state[4] >>> 9) & mask32)

            state[1] = state[1] ^ ((~state[2]) & state[3] & mask32) ^ rnd
            rnd = rnd + 1
      }
      println("   Estado Final de Absorcao: [" + state[1] + ", " + state[2] + ", " + state[3] + ", " + state[4] + "]")

      println("==================================================")
      println("3. Fase de Espremedura (Squeezing Phase):")
      #L Saida 1: extrai primeiras r palavras
      mut as int64: outWord1 = state[1]
      mut as int64: outWord2 = state[2]
      println("   Saida Bloco 1 (Digest 1..2): [" + outWord1 + ", " + outWord2 + "]")

      #L Permutacao f(State) intermediaria
      rnd = 1
      infinite (rnd <= 3) {
            mut as int64: cXor = state[1] ^ state[2] ^ state[3] ^ state[4]
            state[1] = (state[1] ^ cXor) & mask32
            state[2] = (state[2] ^ cXor) & mask32
            state[3] = (state[3] ^ cXor) & mask32
            state[4] = (state[4] ^ cXor) & mask32

            state[1] = ((state[1] << 7) & mask32) | ((state[1] >>> 25) & mask32)
            state[2] = ((state[2] << 12) & mask32) | ((state[2] >>> 20) & mask32)
            state[3] = ((state[3] << 17) & mask32) | ((state[3] >>> 15) & mask32)
            state[4] = ((state[4] << 23) & mask32) | ((state[4] >>> 9) & mask32)

            state[1] = state[1] ^ ((~state[2]) & state[3] & mask32) ^ rnd
            rnd = rnd + 1
      }

      #L Saida 2: extrai proximas r palavras (tamanho de digest arbitrario)
      mut as int64: outWord3 = state[1]
      mut as int64: outWord4 = state[2]
      println("   Saida Bloco 2 (Digest 3..4): [" + outWord3 + ", " + outWord4 + "]")

      println("==================================================")
      println("4. Verificacao de Seguranca da Capacidade:")
      #L A capacidade nunca foi exposta diretamente nas saidas
      route {
            outWord1 != outWord3 ==> {
                  println("   SUCESSO: Digest gerado pela esponja com independencia entre rodadas de espremedura!")
            }
            _ ==> {}
      }
}
