#L ============================================================================
#L Algoritmo: Poly1305 (Autenticador Polinomial de Bernstein - RFC 8439)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaPoly1305) {
      println("==================================================")
      println("  SciAlgo: Poly1305 Polynomial Authenticator")
      println("==================================================")

      #L Chave de 32 bytes de uso unico: r (16 bytes avaliacao) e s (16 bytes mascara)
      #L r e clampado (bits especificos zerados) para garantir avaliacao estavel
      mut as int64: rawR = 268435455 #L 0x0FFFFFFF
      #L Clamping: r[3] & 15, r[7] & 15, etc.
      mut as int64: clampR = rawR & 251658240 #L Exemplo de mascara de clamping
      route {
            clampR == 0 ==> {
                  clampR = 268435451
            }
            _ ==> {}
      }
      mut as int64: keyS = 49153

      #L Primo de Mersenne do corpo Poly1305: p = 2^31 - 1
      mut as int64: primeP = 2147483647

      println("1. Parametros e Chaves Poly1305:")
      println("   Chave r (clampada): " + clampR)
      println("   Chave s (mascara):  " + keyS)
      println("   Corpo Primo p:      " + primeP)

      #L Mensagem de entrada particionada em 4 coeficientes
      mut as list of int64: msgBlocks = [1001, 2002, 3003, 4004]
      mut as int64: numBlocks = 4

      println("==================================================")
      println("2. Avaliacao Polinomial de Horner a = ((a + c_i) * r) mod p:")
      mut as int64: acc = 0
      mut as int64: i = 1
      infinite (i <= numBlocks) {
            mut as int64: block = msgBlocks[i]
            #L Adiciona bit sentinela / padding RFC 8439
            mut as int64: ci = (block + 65536) /r primeP
            acc = (acc + ci) /r primeP
            acc = (acc * (clampR /r 10007)) /r primeP
            println("   Apos bloco " + i + " (" + block + "): Acumulador a = " + acc)
            i = i + 1
      }

      #L Tag final = (a + s) mod 2^32
      mut as int64: authTag = (acc + keyS) /r primeP
      println("==================================================")
      println("3. Tag de Autenticacao Poly1305 Gerada: " + authTag)

      println("==================================================")
      println("4. Verificacao de Autenticidade no Receptor:")
      mut as int64: rxAcc = 0
      i = 1
      infinite (i <= numBlocks) {
            mut as int64: block = msgBlocks[i]
            mut as int64: ci = (block + 65536) /r primeP
            rxAcc = (rxAcc + ci) /r primeP
            rxAcc = (rxAcc * (clampR /r 10007)) /r primeP
            i = i + 1
      }
      mut as int64: rxTag = (rxAcc + keyS) /r primeP
      println("   Tag Recalculada pelo Receptor: " + rxTag)

      route {
            rxTag == authTag ==> {
                  println("   SUCESSO: Tag Poly1305 valida! Integridade e autenticidade confirmadas.")
            }
            _ ==> {
                  println("   FALHA: Tag rejeitada.")
            }
      }

      println("==================================================")
      println("5. Deteccao de Falsificacao (Byte Alterado no Bloco 2):")
      mut as list of int64: badBlocks = [msgBlocks[1], msgBlocks[2] ^ 1, msgBlocks[3], msgBlocks[4]]
      mut as int64: badAcc = 0
      i = 1
      infinite (i <= numBlocks) {
            mut as int64: block = badBlocks[i]
            mut as int64: ci = (block + 65536) /r primeP
            badAcc = (badAcc + ci) /r primeP
            badAcc = (badAcc * (clampR /r 10007)) /r primeP
            i = i + 1
      }
      mut as int64: badTag = (badAcc + keyS) /r primeP
      println("   Tag com dados adulterados: " + badTag)

      route {
            badTag != authTag ==> {
                  println("   SUCESSO: Adulteracao detectada com precisao (badTag != authTag).")
            }
            _ ==> {
                  println("   FALHA: Falsificacao passou despercebida.")
            }
      }
}
