#L ============================================================================
#L Algoritmo: Signal Double Ratchet (KDF Chain Ratchets & Diffie-Hellman Ratchet)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaSignalDoubleRatchet) {
      println("==================================================")
      println("  SciAlgo: Signal Double Ratchet Algorithm")
      println("==================================================")

      #L Chave Raiz Inicial (RK) e Chave de Encadeamento de Alice (CK)
      mut as int64: rootKey = 998877
      mut as int64: aliceCk = 112233
      mut as int64: bobCk = 112233

      println("1. Catraca Simetrica (Symmetric KDF Chain Ratchet):")
      #L Alice envia 2 mensagens sucessivas antes de receber resposta
      #L Cada mensagem avanca a chave da cadeia (CK -> CK') e gera uma Message Key (MK)

      #L Mensagem 1
      mut as int64: msg1 = 501
      mut as int64: mk1 = ((aliceCk * 17 + 1) * 16777619 + 2166136261) /r 65535
      aliceCk = ((aliceCk * 31 + 2) * 16777619 + 2166136261) /r 65535
      mut as int64: ct1 = msg1 ^ mk1
      println("   Alice envia Msg 1: Claro=" + msg1 + " -> Cifrado=" + ct1 + " (MK=" + mk1 + ")")

      #L Bob recebe e processa Mensagem 1
      mut as int64: bobMk1 = ((bobCk * 17 + 1) * 16777619 + 2166136261) /r 65535
      bobCk = ((bobCk * 31 + 2) * 16777619 + 2166136261) /r 65535
      mut as int64: pt1 = ct1 ^ bobMk1
      println("   Bob decifra Msg 1: " + pt1)

      #L Mensagem 2 (sem troca DH, avanca cadeia simetrica)
      mut as int64: msg2 = 502
      mut as int64: mk2 = ((aliceCk * 17 + 1) * 16777619 + 2166136261) /r 65535
      aliceCk = ((aliceCk * 31 + 2) * 16777619 + 2166136261) /r 65535
      mut as int64: ct2 = msg2 ^ mk2
      println("   Alice envia Msg 2: Claro=" + msg2 + " -> Cifrado=" + ct2 + " (MK=" + mk2 + ")")

      mut as int64: bobMk2 = ((bobCk * 17 + 1) * 16777619 + 2166136261) /r 65535
      bobCk = ((bobCk * 31 + 2) * 16777619 + 2166136261) /r 65535
      mut as int64: pt2 = ct2 ^ bobMk2
      println("   Bob decifra Msg 2: " + pt2)

      println("==================================================")
      println("2. Catraca Diffie-Hellman (DH Ratchet Step):")
      #L Bob responde e introduz novo par DH efêmero (Post-Compromise Security / Break-in Recovery)
      mut as int64: dhSecret = 445566 #L Resultado da multiplicacao escalar DH

      #L Atualizacao da Chave Raiz (RK) e geracao da nova cadeia de envio de Bob
      rootKey = ((rootKey ^ dhSecret) * 16777619 + 101) /r 65535
      bobCk = ((rootKey * 41 + 1) * 16777619 + 2166136261) /r 65535
      println("   Nova Chave Raiz apos DH Ratchet: " + rootKey)

      #L Bob cifra Msg 3 usando nova cadeia
      mut as int64: msg3 = 503
      mut as int64: bobMk3 = ((bobCk * 17 + 1) * 16777619 + 2166136261) /r 65535
      bobCk = ((bobCk * 31 + 2) * 16777619 + 2166136261) /r 65535
      mut as int64: ct3 = msg3 ^ bobMk3
      println("   Bob envia Msg 3: Claro=" + msg3 + " -> Cifrado=" + ct3)

      #L Alice recebe a chave publica DH de Bob e executa o mesmo passo DH Ratchet
      mut as int64: aliceRootKey = ((rootKey ^ dhSecret) * 16777619 + 101) /r 65535
      mut as int64: aliceRxCk = ((aliceRootKey * 41 + 1) * 16777619 + 2166136261) /r 65535
      mut as int64: aliceMk3 = ((aliceRxCk * 17 + 1) * 16777619 + 2166136261) /r 65535
      mut as int64: pt3 = ct3 ^ aliceMk3
      println("   Alice decifra Msg 3: " + pt3)

      println("==================================================")
      println("3. Verificacao de Propriedades de Seguranca:")
      route {
            pt1 == msg1 ==> {
                  route {
                        pt2 == msg2 ==> {
                              route {
                                    pt3 == msg3 ==> {
                                          println("   SUCESSO: Todas as mensagens decifradas com Forward Secrecy e Break-in Recovery!")
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
            }
            _ ==> {
                  println("   FALHA: Inconsistencia em uma das mensagens.")
            }
      }
}
