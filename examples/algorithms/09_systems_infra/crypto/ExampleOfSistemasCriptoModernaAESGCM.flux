#L ============================================================================
#L Algoritmo: AES-GCM (Galois/Counter Mode Authenticated Encryption with Associated Data)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaAESGCM) {
      println("==================================================")
      println("  SciAlgo: AES-GCM (Authenticated Encryption)")
      println("==================================================")

      #L Chave de autenticacao H (subchave do bloco zero)
      mut as int64: hKey = 173
      mut as int64: poly = 135 #L Polinomio irredutivel de reducao GF(2^8) (x^8 + x^7 + x^2 + x + 1)

      #L Dados adicionais autenticados (AAD - integridade sem confidencialidade)
      mut as list of int64: aad = [10, 20]
      mut as int64: aadLen = 2

      #L Texto claro
      mut as list of int64: plaintext = [65, 66, 67, 68]
      mut as int64: ptLen = 4

      #L Vetor de inicializacao (IV / Contador inicial J0)
      mut as int64: iv = 42

      println("1. Cifragem em modo CTR (Counter Mode):")
      mut as list of int64: ciphertext = [0, 0, 0, 0]
      mut as int64: i = 1
      infinite (i <= ptLen) {
            mut as int64: counter = iv + i
            mut as int64: keystream = (counter * 37 + 101) /r 256
            mut as int64: ptByte = plaintext[i]
            mut as int64: ctByte = ptByte ^ keystream
            ciphertext[i] = ctByte
            println("   Bloco " + i + ": Claro=" + ptByte + " -> Cifrado=" + ctByte)
            i = i + 1
      }

      println("==================================================")
      println("2. Calculo da Tag GHASH sobre AAD e Texto Cifrado:")
      mut as int64: tag = 0

      #L Processa blocos AAD no acumulador GHASH
      mut as int64: j = 1
      infinite (j <= aadLen) {
            mut as int64: mixed = tag ^ aad[j]
            #L Multiplicacao GF(2^8)
            mut as int64: resGf = 0
            mut as int64: a = mixed
            mut as int64: b = hKey
            mut as int64: bitCount = 1
            infinite (bitCount <= 8) {
                  mut as int64: bit = b & 1
                  route {
                        bit == 1 ==> {
                              resGf = resGf ^ a
                        }
                        _ ==> {}
                  }
                  mut as int64: carry = a & 128
                  a = (a << 1) & 255
                  route {
                        carry != 0 ==> {
                              a = a ^ poly
                        }
                        _ ==> {}
                  }
                  b = b >> 1
                  bitCount = bitCount + 1
            }
            tag = resGf
            j = j + 1
      }

      #L Processa blocos do Texto Cifrado no GHASH
      j = 1
      infinite (j <= ptLen) {
            mut as int64: mixed = tag ^ ciphertext[j]
            mut as int64: resGf = 0
            mut as int64: a = mixed
            mut as int64: b = hKey
            mut as int64: bitCount = 1
            infinite (bitCount <= 8) {
                  mut as int64: bit = b & 1
                  route {
                        bit == 1 ==> {
                              resGf = resGf ^ a
                        }
                        _ ==> {}
                  }
                  mut as int64: carry = a & 128
                  a = (a << 1) & 255
                  route {
                        carry != 0 ==> {
                              a = a ^ poly
                        }
                        _ ==> {}
                  }
                  b = b >> 1
                  bitCount = bitCount + 1
            }
            tag = resGf
            j = j + 1
      }

      #L Mascara final da tag combinada com criptograma do contador inicial E_K(J0)
      mut as int64: j0Mask = (iv * 37 + 101) /r 256
      mut as int64: finalAuthTag = tag ^ j0Mask
      println("   Tag de Autenticacao gerada: " + finalAuthTag)

      println("==================================================")
      println("3. Verificacao e Decifragem no Destinatario:")
      mut as int64: rxTag = 0
      j = 1
      infinite (j <= aadLen) {
            mut as int64: mixed = rxTag ^ aad[j]
            mut as int64: resGf = 0
            mut as int64: a = mixed
            mut as int64: b = hKey
            mut as int64: bitCount = 1
            infinite (bitCount <= 8) {
                  mut as int64: bit = b & 1
                  route {
                        bit == 1 ==> {
                              resGf = resGf ^ a
                        }
                        _ ==> {}
                  }
                  mut as int64: carry = a & 128
                  a = (a << 1) & 255
                  route {
                        carry != 0 ==> {
                              a = a ^ poly
                        }
                        _ ==> {}
                  }
                  b = b >> 1
                  bitCount = bitCount + 1
            }
            rxTag = resGf
            j = j + 1
      }
      j = 1
      infinite (j <= ptLen) {
            mut as int64: mixed = rxTag ^ ciphertext[j]
            mut as int64: resGf = 0
            mut as int64: a = mixed
            mut as int64: b = hKey
            mut as int64: bitCount = 1
            infinite (bitCount <= 8) {
                  mut as int64: bit = b & 1
                  route {
                        bit == 1 ==> {
                              resGf = resGf ^ a
                        }
                        _ ==> {}
                  }
                  mut as int64: carry = a & 128
                  a = (a << 1) & 255
                  route {
                        carry != 0 ==> {
                              a = a ^ poly
                        }
                        _ ==> {}
                  }
                  b = b >> 1
                  bitCount = bitCount + 1
            }
            rxTag = resGf
            j = j + 1
      }
      mut as int64: rxAuthTag = rxTag ^ j0Mask

      route {
            rxAuthTag == finalAuthTag ==> {
                  println("   Autenticidade confirmada! Tag valida: " + rxAuthTag)
                  mut as list of int64: decrypted = [0, 0, 0, 0]
                  i = 1
                  infinite (i <= ptLen) {
                        mut as int64: counter = iv + i
                        mut as int64: keystream = (counter * 37 + 101) /r 256
                        decrypted[i] = ciphertext[i] ^ keystream
                        i = i + 1
                  }
                  println("   Texto recuperado: [" + decrypted[1] + ", " + decrypted[2] + ", " + decrypted[3] + ", " + decrypted[4] + "]")
            }
            _ ==> {
                  println("   ALERTA: Tag invalida! Dados rejeitados.")
            }
      }

      println("==================================================")
      println("4. Teste de Deteccao de Adulteracao:")
      ciphertext[2] = ciphertext[2] ^ 255
      rxTag = 0
      j = 1
      infinite (j <= aadLen) {
            mut as int64: mixed = rxTag ^ aad[j]
            mut as int64: resGf = 0
            mut as int64: a = mixed
            mut as int64: b = hKey
            mut as int64: bitCount = 1
            infinite (bitCount <= 8) {
                  mut as int64: bit = b & 1
                  route {
                        bit == 1 ==> {
                              resGf = resGf ^ a
                        }
                        _ ==> {}
                  }
                  mut as int64: carry = a & 128
                  a = (a << 1) & 255
                  route {
                        carry != 0 ==> {
                              a = a ^ poly
                        }
                        _ ==> {}
                  }
                  b = b >> 1
                  bitCount = bitCount + 1
            }
            rxTag = resGf
            j = j + 1
      }
      j = 1
      infinite (j <= ptLen) {
            mut as int64: mixed = rxTag ^ ciphertext[j]
            mut as int64: resGf = 0
            mut as int64: a = mixed
            mut as int64: b = hKey
            mut as int64: bitCount = 1
            infinite (bitCount <= 8) {
                  mut as int64: bit = b & 1
                  route {
                        bit == 1 ==> {
                              resGf = resGf ^ a
                        }
                        _ ==> {}
                  }
                  mut as int64: carry = a & 128
                  a = (a << 1) & 255
                  route {
                        carry != 0 ==> {
                              a = a ^ poly
                        }
                        _ ==> {}
                  }
                  b = b >> 1
                  bitCount = bitCount + 1
            }
            rxTag = resGf
            j = j + 1
      }
      rxAuthTag = rxTag ^ j0Mask
      route {
            rxAuthTag == finalAuthTag ==> {
                  println("   FALHA: Adulteracao nao detectada.")
            }
            _ ==> {
                  println("   SUCESSO: Adulteracao detectada! Tag recebida=" + rxAuthTag + " != esperada=" + finalAuthTag)
            }
      }
}
