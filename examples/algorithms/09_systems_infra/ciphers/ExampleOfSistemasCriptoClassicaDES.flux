#L ============================================================================
#L Algoritmo: DES (Data Encryption Standard - Rede de Feistel)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaDES) {
      println("==================================================")
      println("  SciAlgo: Data Encryption Standard (DES Feistel)")
      println("==================================================")

      #L Bloco de 64 bits dividido em duas metades de 32 bits: L0 e R0
      mut as int64: plainL = 305419896 #L 0x12345678
      mut as int64: plainR = 259606910 #L 0x0F7945FE

      #L Subchaves de rodada (16 rodadas)
      mut as list of int64: roundKeys = [
            1234567, 2345678, 3456789, 4567890,
            5678901, 6789012, 7890123, 8901234,
            9012345, 1238945, 2349056, 3450167,
            4561278, 5672389, 6783490, 7894501
      ]

      println("1. Bloco de Entrada (64 bits):")
      println("   L0: " + plainL + ", R0: " + plainR)

      #L Estado corrente
      mut as int64: curL = plainL
      mut as int64: curR = plainR

      println("==================================================")
      println("2. Execucao das 16 Rodadas da Rede de Feistel (Encriptacao):")

      #L Rodada de Feistel: L_i = R_{i-1}, R_i = L_{i-1} ^ f(R_{i-1}, K_i)
      #L Funcao f(R, K): expansao/mistura nao-linear: ((R * 3 + K) ^ (R /i 4)) & 0xFFFFFFFF
      mut as int64: round = 1
      infinite (round <= 16) {
            mut as int64: k = roundKeys[round]
            #L Funcao Feistel f:
            mut as int64: fVal = ((curR * 3 + k) ^ (curR /i 4)) /r 4294967296
            route { fVal < 0 ==> { fVal = fVal + 4294967296 } _ ==> {} }

            mut as int64: nextL = curR
            mut as int64: nextR = curL ^ fVal

            curL = nextL
            curR = nextR
            round = round + 1
      }

      #L Troca final de 32 bits (swap de saída Feistel)
      mut as int64: cipherL = curR
      mut as int64: cipherR = curL

      println("   Texto cifrado resultante:")
      println("   Cipher L: " + cipherL + ", Cipher R: " + cipherR)

      println("==================================================")
      println("3. Decriptacao DES (Subchaves em Ordem Reversa):")

      mut as int64: decL = cipherL
      mut as int64: decR = cipherR

      mut as int64: decRound = 16
      infinite (decRound >= 1) {
            mut as int64: k = roundKeys[decRound]
            mut as int64: fVal = ((decR * 3 + k) ^ (decR /i 4)) /r 4294967296
            route { fVal < 0 ==> { fVal = fVal + 4294967296 } _ ==> {} }

            mut as int64: prevL = decR
            mut as int64: prevR = decL ^ fVal

            decL = prevL
            decR = prevR
            decRound = decRound - 1
      }

      #L Troca final
      mut as int64: restL = decR
      mut as int64: restR = decL

      println("   Texto decriptado:")
      println("   Restaurado L: " + restL + ", Restaurado R: " + restR)

      route {
            restL == plainL and restR == plainR ==> {
                  println("   SUCESSO: DES cifrou e decifrou através das 16 rodadas de Feistel!")
            }
            _ ==> {
                  println("   FALHA: Divergência na decriptacao DES.")
            }
      }
}
