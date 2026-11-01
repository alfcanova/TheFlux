#L ============================================================================
#L Algoritmo: Fiat–Shamir Heuristic & Identification Scheme
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaFiatShamir) {
      println("==================================================")
      println("  SciAlgo: Fiat–Shamir Heuristic & ZK Identification")
      println("==================================================")

      #L Modulo RSA n = p * q (101 * 103 = 10403)
      mut as int64: n = 10403

      #L Segredo privado do provador s
      mut as int64: secretS = 47
      #L Chave publica v = s^2 mod n
      mut as int64: pubV = (secretS * secretS) /r n

      println("1. Parametros e Chaves:")
      println("   Modulo n = " + n)
      println("   Segredo s = " + secretS)
      println("   Chave Publica v (s^2 mod n) = " + pubV)

      println("==================================================")
      println("2. Protocolo Interativo de Prova de Conhecimento ZK:")
      #L Etapa 1: Provador escolhe r aleatorio e envia compromisso x = r^2 mod n
      mut as int64: rNonce = 53
      mut as int64: commX = (rNonce * rNonce) /r n
      println("   Compromisso do Provador x (r^2 mod n) = " + commX)

      #L Etapa 2: Verificador envia desafio e in {0, 1}
      #L Teste com e = 1:
      mut as int64: challenge1 = 1
      #L Etapa 3: Resposta y = (r * s^e) mod n
      mut as int64: respY1 = (rNonce * secretS) /r n
      println("   Desafio Verificador e = 1 -> Resposta y = " + respY1)

      #L Etapa 4: Verificacao y^2 == x * v^e mod n
      mut as int64: lhs1 = (respY1 * respY1) /r n
      mut as int64: rhs1 = (commX * pubV) /r n
      println("   Verificacao e=1: y^2 mod n = " + lhs1 + ", x * v mod n = " + rhs1)
      route {
            lhs1 == rhs1 ==> {
                  println("   SUCESSO: Rodada 1 interativa validada!")
            }
            _ ==> {
                  println("   FALHA: Rodada 1 interativa rejeitada.")
            }
      }

      println("==================================================")
      println("3. Heuristica de Fiat–Shamir (Transformacao Nao-Interativa):")
      #L O provador substitui o verificador interativo por um Random Oracle H(Msg, x)
      mut as int64: msg = 98765
      #L Desafio derivado via hash: e = H(msg, x) mod 2
      mut as int64: eHash = (((msg * 31 + commX) * 16777619 + 2166136261) /r 2147483647) /r 2
      println("   Mensagem a assinar: " + msg)
      println("   Desafio nao-interativo e = H(msg, x) = " + eHash)

      mut as int64: sigY = rNonce
      route {
            eHash == 1 ==> {
                  sigY = (rNonce * secretS) /r n
            }
            _ ==> {}
      }
      println("   Assinatura Fiat-Shamir gerada: (x=" + commX + ", y=" + sigY + ")")

      #L Verificador independente valida a assinatura
      mut as int64: vEHash = (((msg * 31 + commX) * 16777619 + 2166136261) /r 2147483647) /r 2
      mut as int64: vLHS = (sigY * sigY) /r n
      mut as int64: vRHS = commX
      route {
            vEHash == 1 ==> {
                  vRHS = (commX * pubV) /r n
            }
            _ ==> {}
      }
      println("   Verificacao da Assinatura: LHS=" + vLHS + ", RHS=" + vRHS)

      route {
            vLHS == vRHS ==> {
                  println("   SUCESSO: Assinatura nao-interativa de Fiat-Shamir valida!")
            }
            _ ==> {
                  println("   FALHA: Assinatura rejeitada.")
            }
      }

      println("==================================================")
      println("4. Teste de Deteccao de Falsificacao (Mensagem Adulterada):")
      mut as int64: badMsg = msg + 1
      mut as int64: badEHash = (((badMsg * 31 + commX) * 16777619 + 2166136261) /r 2147483647) /r 2
      mut as int64: badRHS = commX
      route {
            badEHash == 1 ==> {
                  badRHS = (commX * pubV) /r n
            }
            _ ==> {}
      }

      route {
            vLHS == badRHS ==> {
                  println("   FALHA: Falsificacao aceita.")
            }
            _ ==> {
                  println("   SUCESSO: Falsificacao rejeitada com sucesso (LHS != RHS falso).")
            }
      }
}
