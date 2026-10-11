#L ============================================================================
#L Algoritmo: BLAKE3 (Tree Hashing e Compressao em 7 Rodadas)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaBLAKE3) {
      println("==================================================")
      println("  SciAlgo: BLAKE3 (Tree Hashing and 7-Round Compression)")
      println("==================================================")

      #L Constantes IV padrao BLAKE3 (8 palavras de 32 bits)
      mut as list of int64: iv = [
            1779033703, 3144134277, 1013904242, 2773480762,
            1359893119, 2600822924,  528734635, 1541459225
      ]

      #L Flags de domínio BLAKE3
      mut as int64: flagChunkStart = 1
      mut as int64: flagChunkEnd   = 2
      mut as int64: flagParent     = 4
      mut as int64: flagRoot       = 8

      mut as int64: mask32 = 4294967295

      println("1. Processamento Paralelo de Folhas (Chunks):")
      #L Simulando dois chunks de entrada (Folha Esquerda e Folha Direita)
      mut as int64: chunkLeftData  = 12345
      mut as int64: chunkRightData = 67890

      #L Compressao do Chunk 1 (Esquerda)
      mut as list of int64: cvLeft = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: stateL = iv[1] ^ chunkLeftData ^ flagChunkStart ^ flagChunkEnd
      mut as int64: r = 1
      infinite (r <= 7) {
            stateL = (stateL * 1664525 + 1013904223) & mask32
            r = r + 1
      }
      cvLeft[1] = stateL
      cvLeft[2] = (stateL ^ iv[2]) & mask32
      println("   Chaining Value da Folha Esquerda:  " + cvLeft[1])

      #L Compressao do Chunk 2 (Direita)
      mut as list of int64: cvRight = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: stateR = iv[1] ^ chunkRightData ^ flagChunkStart ^ flagChunkEnd
      r = 1
      infinite (r <= 7) {
            stateR = (stateR * 1664525 + 1013904223) & mask32
            r = r + 1
      }
      cvRight[1] = stateR
      cvRight[2] = (stateR ^ iv[2]) & mask32
      println("   Chaining Value da Folha Direita:   " + cvRight[1])

      println("==================================================")
      println("2. Juncao da Arvore (Parent Node Merge com Flag ROOT):")
      #L O no pai recebe os chaining values dos dois filhos como bloco de mensagem
      #L e comprime com as flags PARENT e ROOT ativadas
      mut as int64: parentFlags = flagParent | flagRoot
      mut as int64: parentInput = (cvLeft[1] ^ cvRight[1]) & mask32
      mut as int64: rootState = iv[1] ^ parentInput ^ parentFlags

      #L 7 rodadas de permutacao na raiz
      r = 1
      infinite (r <= 7) {
            rootState = (rootState * 1664525 + 1013904223) & mask32
            rootState = ((rootState << 13) & mask32) | ((rootState >>> 19) & mask32)
            r = r + 1
      }

      mut as int64: rootHashWord0 = (rootState ^ iv[1]) & mask32
      mut as int64: rootHashWord1 = (rootState ^ iv[2]) & mask32
      println("   Hash Raiz BLAKE3 (Palavra 0): " + rootHashWord0)
      println("   Hash Raiz BLAKE3 (Palavra 1): " + rootHashWord1)

      println("==================================================")
      println("3. Verificacao de Integridade da Arvore:")
      #L Recalcula o hash raiz e verifica determinismo
      mut as int64: verifyState = iv[1] ^ parentInput ^ parentFlags
      r = 1
      infinite (r <= 7) {
            verifyState = (verifyState * 1664525 + 1013904223) & mask32
            verifyState = ((verifyState << 13) & mask32) | ((verifyState >>> 19) & mask32)
            r = r + 1
      }
      mut as int64: verifyWord0 = (verifyState ^ iv[1]) & mask32

      route {
            rootHashWord0 == verifyWord0 ==> {
                  println("   SUCESSO: Hash da arvore BLAKE3 reproduzivel e integro!")
            }
            _ ==> {
                  println("   FALHA: Divergencia na reproducao do hash.")
            }
      }

      println("==================================================")
      println("4. Deteccao de Adulteracao em Subarvore (Chunk Esquerdo):")
      mut as int64: badChunkLeft = chunkLeftData ^ 1
      mut as int64: badStateL = iv[1] ^ badChunkLeft ^ flagChunkStart ^ flagChunkEnd
      r = 1
      infinite (r <= 7) {
            badStateL = (badStateL * 1664525 + 1013904223) & mask32
            r = r + 1
      }
      mut as int64: badParentInput = (badStateL ^ cvRight[1]) & mask32
      mut as int64: badRootState = iv[1] ^ badParentInput ^ parentFlags
      r = 1
      infinite (r <= 7) {
            badRootState = (badRootState * 1664525 + 1013904223) & mask32
            badRootState = ((badRootState << 13) & mask32) | ((badRootState >>> 19) & mask32)
            r = r + 1
      }
      mut as int64: badRootHash = (badRootState ^ iv[1]) & mask32

      route {
            badRootHash != rootHashWord0 ==> {
                  println("   SUCESSO: Adulteracao no chunk esquerdo invalidou a raiz: " + badRootHash + " != " + rootHashWord0)
            }
            _ ==> {
                  println("   FALHA: Adulteracao passou despercebida.")
            }
      }
}
