#L ============================================================================
#L Algoritmo: Merkle–Damgård Construction (Estrutura Sequencial de Hashing com Padding)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaMerkleDamgard) {
      println("==================================================")
      println("  SciAlgo: Merkle–Damgård Construction (MD-Hash)")
      println("==================================================")

      #L Vetor de inicializacao IV
      mut as int64: iv = 1779033703
      mut as int64: mask32 = 4294967295

      #L Mensagem de entrada (3 blocos de dados)
      mut as list of int64: msg = [1100, 2200, 3300]
      mut as int64: origLen = 3
      mut as int64: origBits = origLen * 32

      println("1. Mensagem Original (3 blocos):")
      println("   m = [" + msg[1] + ", " + msg[2] + ", " + msg[3] + "] (Tamanho: " + origBits + " bits)")

      #L MD-Strengthening Padding:
      #L Bloco com bit de parada 0x80 seguido pelo comprimento original da mensagem
      #L Garante resistencia contra ataques de extensao de comprimento e colisao por prefixo
      mut as list of int64: padded = [msg[1], msg[2], msg[3], 128, origBits]
      mut as int64: paddedLen = 5

      println("==================================================")
      println("2. Mensagem com MD-Strengthening Padding (5 blocos):")
      println("   Padding = [" + padded[1] + ", " + padded[2] + ", " + padded[3] + ", " + padded[4] + ", " + padded[5] + "]")

      println("==================================================")
      println("3. Pipeline de Compressao Sequencial (Davies-Meyer f(H_{i-1}, M_i)):")
      mut as int64: hState = iv
      println("   H_0 (IV) = " + hState)

      mut as int64: i = 1
      infinite (i <= paddedLen) {
            mut as int64: block = padded[i]
            #L Funcao de compressao Davies-Meyer: E_M(H) ^ H
            mut as int64: enc = ((hState ^ block) * 1664525 + 1013904223) & mask32
            enc = ((enc << 11) & mask32) | ((enc >>> 21) & mask32)
            hState = (enc ^ hState) & mask32
            println("   Bloco " + i + " processado -> H_" + i + " = " + hState)
            i = i + 1
      }

      mut as int64: finalHash = hState
      println("==================================================")
      println("4. Digest Final Merkle–Damgård: " + finalHash)

      println("==================================================")
      println("5. Verificacao de Resistencia a Colisao por Sufixo:")
      #L Mensagem truncada sem o padding de comprimento correto
      mut as list of int64: unpaddedPadded = [msg[1], msg[2], msg[3], 128, 64]
      mut as int64: altState = iv
      i = 1
      infinite (i <= paddedLen) {
            mut as int64: block = unpaddedPadded[i]
            mut as int64: enc = ((altState ^ block) * 1664525 + 1013904223) & mask32
            enc = ((enc << 11) & mask32) | ((enc >>> 21) & mask32)
            altState = (enc ^ altState) & mask32
            i = i + 1
      }
      println("   Digest com comprimento falso (64 bits): " + altState)

      route {
            finalHash != altState ==> {
                  println("   SUCESSO: MD-Strengthening impediu colisao entre comprimentos distintos.")
            }
            _ ==> {
                  println("   FALHA: Colisao detectada!")
            }
      }
}
