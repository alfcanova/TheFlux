#L ============================================================================
#L Algoritmo: TLS 1.3 Handshake Protocol (1-RTT Key Exchange & Finished Authentication)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaTLSHandshake) {
      println("==================================================")
      println("  SciAlgo: TLS 1.3 Cryptographic Handshake (1-RTT)")
      println("==================================================")

      #L Parametros de grupo DHE
      mut as int64: p = 10007
      mut as int64: g = 5

      println("1. Mensagem ClientHello (Envio de KeyShare):")
      #L Cliente gera par efemero de troca de chaves
      mut as int64: clientPriv = 567
      mut as int64: clientKeyShare = 1
      mut as int64: bExp = g
      mut as int64: eExp = clientPriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        clientKeyShare = (clientKeyShare * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      println("   Cliente envia ClientHello: KeyShare = " + clientKeyShare)

      println("==================================================")
      println("2. Mensagem ServerHello (KeyShare do Servidor e Segredo DHE):")
      #L Servidor gera par efemero
      mut as int64: serverPriv = 890
      mut as int64: serverKeyShare = 1
      bExp = g
      eExp = serverPriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        serverKeyShare = (serverKeyShare * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      println("   Servidor envia ServerHello: KeyShare = " + serverKeyShare)

      #L Servidor calcula segredo compartilhado S = (clientKeyShare)^serverPriv mod p
      mut as int64: serverDheSecret = 1
      bExp = clientKeyShare
      eExp = serverPriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        serverDheSecret = (serverDheSecret * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      #L Cliente calcula segredo compartilhado S = (serverKeyShare)^clientPriv mod p
      mut as int64: clientDheSecret = 1
      bExp = serverKeyShare
      eExp = clientPriv
      infinite (eExp > 0) {
            mut as int64: bit = eExp & 1
            route {
                  bit == 1 ==> {
                        clientDheSecret = (clientDheSecret * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }

      println("   Segredo DHE Compartilhado: " + clientDheSecret)

      println("==================================================")
      println("3. Derivacao HKDF das Chaves de Handshake:")
      #L Handshake Secret = HKDF-Extract(0, DHE_Secret)
      mut as int64: handshakeSecret = ((clientDheSecret * 31 + 101) * 16777619 + 2166136261) /r 2147483647
      println("   Handshake Secret: " + handshakeSecret)

      #L Chaves de Finished e Trafego
      mut as int64: serverFinishedKey = (handshakeSecret * 13 + 1) /r 2147483647
      mut as int64: clientFinishedKey = (handshakeSecret * 17 + 2) /r 2147483647

      #L Transcript hash simplificado ate ServerHello
      mut as int64: transcriptHash = (clientKeyShare * 31 + serverKeyShare) /r 1000000007

      #L Servidor gera tag Finished = HMAC(serverFinishedKey, transcript)
      mut as int64: serverFinishedTag = ((serverFinishedKey ^ 90) * 16777619 + transcriptHash) /r 2147483647
      println("   Servidor envia ServerFinished (Tag HMAC): " + serverFinishedTag)

      #L Cliente valida ServerFinished
      mut as int64: clientVerifyServerTag = ((serverFinishedKey ^ 90) * 16777619 + transcriptHash) /r 2147483647
      route {
            clientVerifyServerTag == serverFinishedTag ==> {
                  println("   Cliente: ServerFinished verificado com sucesso!")
            }
            _ ==> {
                  println("   Cliente: Falha de autenticacao do servidor!")
            }
      }

      #L Cliente envia ClientFinished
      mut as int64: clientTranscript = transcriptHash + serverFinishedTag
      mut as int64: clientFinishedTag = ((clientFinishedKey ^ 90) * 16777619 + clientTranscript) /r 2147483647
      println("   Cliente envia ClientFinished (Tag HMAC): " + clientFinishedTag)

      #L Servidor valida ClientFinished
      mut as int64: serverVerifyClientTag = ((clientFinishedKey ^ 90) * 16777619 + clientTranscript) /r 2147483647
      route {
            serverVerifyClientTag == clientFinishedTag ==> {
                  println("   Servidor: ClientFinished verificado com sucesso!")
            }
            _ ==> {
                  println("   Servidor: Falha de autenticacao do cliente!")
            }
      }

      println("==================================================")
      println("4. Transicao para Chaves de Trafego da Aplicacao (1-RTT):")
      mut as int64: appSecret = ((handshakeSecret * 41 + 202) * 16777619 + 2166136261) /r 2147483647
      mut as int64: clientWriteKey = (appSecret * 3 + 101) /r 65535
      mut as int64: serverWriteKey = (appSecret * 7 + 202) /r 65535

      println("   Chave de Escrita do Cliente:  " + clientWriteKey)
      println("   Chave de Escrita do Servidor: " + serverWriteKey)

      #L Simulacao de envio seguro de registro de dados pelo cliente
      mut as int64: appData = 12345
      mut as int64: encryptedRecord = appData ^ clientWriteKey
      mut as int64: decryptedRecord = encryptedRecord ^ clientWriteKey
      println("   Dado original: " + appData + " -> Cifrado: " + encryptedRecord + " -> Decifrado: " + decryptedRecord)

      route {
            decryptedRecord == appData ==> {
                  println("   SUCESSO: Sessao TLS 1.3 estabelecida e dados transferidos em segredo!")
            }
            _ ==> {
                  println("   FALHA: Erro no canal de dados.")
            }
      }
}
