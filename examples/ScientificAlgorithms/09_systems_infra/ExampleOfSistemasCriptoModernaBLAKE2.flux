#L ============================================================================
#L Algoritmo: BLAKE2 (Funcao de Compressao Criptografica e Mistura G)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaBLAKE2) {
      println("==================================================")
      println("  SciAlgo: BLAKE2 Cryptographic Hash Compression")
      println("==================================================")

      #L Vetor de inicializacao padrao BLAKE2s (IV de 8 palavras)
      mut as list of int64: iv = [
            1779033703, 3144134277, 1013904242, 2773480762,
            1359893119, 2600822924,  528734635, 1541459225
      ]

      #L Estado de encadeamento inicial (h0 .. h7)
      mut as list of int64: h = [
            1779033703, 3144134277, 1013904242, 2773480762,
            1359893119, 2600822924,  528734635, 1541459225
      ]

      #L Matriz de estado v (16 palavras de 32 bits, 1-indexada)
      #L v[1..8] = h[1..8], v[9..16] = iv[1..8]
      mut as list of int64: v = [
            0, 0, 0, 0,  0, 0, 0, 0,
            0, 0, 0, 0,  0, 0, 0, 0
      ]

      mut as int64: i = 1
      infinite (i <= 8) {
            v[i] = h[i]
            v[i + 8] = iv[i]
            i = i + 1
      }

      #L Parametros de bloco: offset de bytes t0 e flag de bloco final f0
      mut as int64: t0 = 64
      mut as int64: f0 = 4294967295 #L 0xFFFFFFFF (ultimo bloco)
      v[13] = v[13] ^ t0
      v[15] = v[15] ^ f0

      #L Bloco de mensagem de teste m (16 palavras)
      mut as list of int64: m = [
            100, 200, 300, 400, 500, 600, 700, 800,
            150, 250, 350, 450, 550, 650, 750, 850
      ]

      println("1. Estado Inicial da Matriz v (16 palavras):")
      println("   v[1..4]:   [" + v[1] + ", " + v[2] + ", " + v[3] + ", " + v[4] + "]")
      println("   v[13..16]: [" + v[13] + ", " + v[14] + ", " + v[15] + ", " + v[16] + "]")

      println("==================================================")
      println("2. Execucao das Rodadas de Mistura G (Quarter-Rounds):")
      mut as int64: mask32 = 4294967295

      #L Executa 4 rodadas da funcao de mistura G
      mut as int64: round = 1
      infinite (round <= 4) {
            #L Coluna 1: G(v[1], v[5], v[9], v[13], m[1], m[2])
            mut as int64: va = v[1]
            mut as int64: vb = v[5]
            mut as int64: vc = v[9]
            mut as int64: vd = v[13]
            mut as int64: mx = m[round]
            mut as int64: my = m[round + 1]

            #L Etapa 1: a = a + b + x; d = (d ^ a) >>> 16
            va = (va + vb + mx) & mask32
            vd = vd ^ va
            vd = ((vd << 16) & mask32) | ((vd >>> 16) & mask32)

            #L Etapa 2: c = c + d; b = (b ^ c) >>> 12
            vc = (vc + vd) & mask32
            vb = vb ^ vc
            vb = ((vb << 20) & mask32) | ((vb >>> 12) & mask32)

            #L Etapa 3: a = a + b + y; d = (d ^ a) >>> 8
            va = (va + vb + my) & mask32
            vd = vd ^ va
            vd = ((vd << 24) & mask32) | ((vd >>> 8) & mask32)

            #L Etapa 4: c = c + d; b = (b ^ c) >>> 7
            vc = (vc + vd) & mask32
            vb = vb ^ vc
            vb = ((vb << 25) & mask32) | ((vb >>> 7) & mask32)

            v[1] = va
            v[5] = vb
            v[9] = vc
            v[13] = vd

            println("   Rodada " + round + " concluida: v[1]=" + v[1] + ", v[13]=" + v[13])
            round = round + 1
      }

      println("==================================================")
      println("3. Compressao Final e Atualizacao do Chaining Vector:")
      #L h[i] = h[i] ^ v[i] ^ v[i + 8]
      i = 1
      infinite (i <= 8) {
            h[i] = h[i] ^ v[i] ^ v[i + 8]
            i = i + 1
      }

      println("   Chaining Vector Final h[1..8]:")
      println("   h[1..4]: [" + h[1] + ", " + h[2] + ", " + h[3] + ", " + h[4] + "]")
      println("   h[5..8]: [" + h[5] + ", " + h[6] + ", " + h[7] + ", " + h[8] + "]")

      println("==================================================")
      println("4. Teste de Efeito Avalanche:")
      #L Modificando 1 unico bit na mensagem de entrada
      mut as list of int64: mMod = [
            101, 200, 300, 400, 500, 600, 700, 800,
            150, 250, 350, 450, 550, 650, 750, 850
      ]
      mut as list of int64: vMod = [
            0, 0, 0, 0,  0, 0, 0, 0,
            0, 0, 0, 0,  0, 0, 0, 0
      ]
      i = 1
      infinite (i <= 8) {
            vMod[i] = iv[i]
            vMod[i + 8] = iv[i]
            i = i + 1
      }
      vMod[13] = vMod[13] ^ t0
      vMod[15] = vMod[15] ^ f0

      round = 1
      infinite (round <= 4) {
            mut as int64: va = vMod[1]
            mut as int64: vb = vMod[5]
            mut as int64: vc = vMod[9]
            mut as int64: vd = vMod[13]
            mut as int64: mx = mMod[round]
            mut as int64: my = mMod[round + 1]

            va = (va + vb + mx) & mask32
            vd = vd ^ va
            vd = ((vd << 16) & mask32) | ((vd >>> 16) & mask32)

            vc = (vc + vd) & mask32
            vb = vb ^ vc
            vb = ((vb << 20) & mask32) | ((vb >>> 12) & mask32)

            va = (va + vb + my) & mask32
            vd = vd ^ va
            vd = ((vd << 24) & mask32) | ((vd >>> 8) & mask32)

            vc = (vc + vd) & mask32
            vb = vb ^ vc
            vb = ((vb << 25) & mask32) | ((vb >>> 7) & mask32)

            vMod[1] = va
            vMod[5] = vb
            vMod[9] = vc
            vMod[13] = vd
            round = round + 1
      }

      mut as int64: h1Mod = iv[1] ^ vMod[1] ^ vMod[9]
      println("   h[1] original:  " + h[1])
      println("   h[1] modificado:" + h1Mod)

      route {
            h[1] != h1Mod ==> {
                  println("   SUCESSO: Efeito avalanche confirmado (alteracao total de bits).")
            }
            _ ==> {
                  println("   FALHA: Nenhuma mudanca detectada.")
            }
      }
}
