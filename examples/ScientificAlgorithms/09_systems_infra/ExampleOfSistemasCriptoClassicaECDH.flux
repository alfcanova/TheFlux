#L ============================================================================
#L Algoritmo: ECDH (Elliptic Curve Diffie-Hellman Key Exchange)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaECDH) {
      println("==================================================")
      println("  SciAlgo: Elliptic Curve Diffie-Hellman (ECDH)")
      println("==================================================")

      #L Parametros da Curva de Ordem Prima (89 pontos): y^2 = x^3 + 3*x + 1 (mod 97)
      mut as int64: p = 97
      mut as int64: a = 3
      mut as int64: b = 1
      mut as int64: gx = 0
      mut as int64: gy = 1

      #L Segredos privados:
      mut as int64: da = 2 #L Alice
      mut as int64: db = 3 #L Bob

      println("1. Parametros do Dominio:")
      println("   Primo p = " + p + ", Ponto Base G = (" + gx + ", " + gy + ")")
      println("   Chave privada Alice da = " + da + ", Chave privada Bob db = " + db)

      println("==================================================")
      println("2. Calculo das Chaves Publicas QA = da*G e QB = db*G:")

      #L QA = 2 * G (Duplicacao de Ponto):
      mut as int64: numS2 = (3 * gx * gx + a) /r p
      mut as int64: denS2 = (2 * gy) /r p
      mut as int64: denInv2 = 1
      mut as int64: b2 = denS2
      mut as int64: e2 = p - 2
      infinite (e2 > 0) {
            route { e2 /r 2 == 1 ==> { denInv2 = (denInv2 * b2) /r p } _ ==> {} }
            b2 = (b2 * b2) /r p
            e2 = e2 /i 2
      }
      mut as int64: l2 = (numS2 * denInv2) /r p
      mut as int64: qaxVal = l2 * l2 - 2 * gx
      infinite (qaxVal < 0) { qaxVal = qaxVal + p * 100 }
      mut as int64: qax = qaxVal /r p

      mut as int64: qayVal = l2 * (gx - qax) - gy
      infinite (qayVal < 0) { qayVal = qayVal + p * 100 }
      mut as int64: qay = qayVal /r p

      println("   Chave Publica Alice QA (2 * G): (" + qax + ", " + qay + ")")

      #L QB = 3 * G = 2G + G (Soma de Pontos):
      mut as int64: dy3 = qay - gy
      infinite (dy3 < 0) { dy3 = dy3 + p * 10 }
      dy3 = dy3 /r p

      mut as int64: dx3 = qax - gx
      infinite (dx3 < 0) { dx3 = dx3 + p * 10 }
      dx3 = dx3 /r p

      mut as int64: dxInv3 = 1
      mut as int64: b3 = dx3
      mut as int64: e3 = p - 2
      infinite (e3 > 0) {
            route { e3 /r 2 == 1 ==> { dxInv3 = (dxInv3 * b3) /r p } _ ==> {} }
            b3 = (b3 * b3) /r p
            e3 = e3 /i 2
      }
      mut as int64: l3 = (dy3 * dxInv3) /r p
      mut as int64: qbxVal = l3 * l3 - gx - qax
      infinite (qbxVal < 0) { qbxVal = qbxVal + p * 100 }
      mut as int64: qbx = qbxVal /r p

      mut as int64: qbyVal = l3 * (gx - qbx) - gy
      infinite (qbyVal < 0) { qbyVal = qbyVal + p * 100 }
      mut as int64: qby = qbyVal /r p

      println("   Chave Publica Bob QB (3 * G):   (" + qbx + ", " + qby + ")")

      println("==================================================")
      println("3. Derivacao do Segredo Compartilhado:")

      #L Alice calcula SA = da * QB = 2 * (3*G) = 2 * QB:
      mut as int64: numSSA = (3 * qbx * qbx + a) /r p
      mut as int64: denSSA = (2 * qby) /r p
      mut as int64: denInvSA = 1
      mut as int64: bSA = denSSA
      mut as int64: eSA = p - 2
      infinite (eSA > 0) {
            route { eSA /r 2 == 1 ==> { denInvSA = (denInvSA * bSA) /r p } _ ==> {} }
            bSA = (bSA * bSA) /r p
            eSA = eSA /i 2
      }
      mut as int64: lSA = (numSSA * denInvSA) /r p
      mut as int64: saxVal = lSA * lSA - 2 * qbx
      infinite (saxVal < 0) { saxVal = saxVal + p * 100 }
      mut as int64: sax = saxVal /r p

      mut as int64: sayVal = lSA * (qbx - sax) - qby
      infinite (sayVal < 0) { sayVal = sayVal + p * 100 }
      mut as int64: say = sayVal /r p

      println("   Segredo Alice SA (2 * QB): (" + sax + ", " + say + ")")

      #L Bob calcula SB = db * QA = 3 * QA = 2*QA + QA:
      #L Primeiro 2*QA:
      mut as int64: numS2A = (3 * qax * qax + a) /r p
      mut as int64: denS2A = (2 * qay) /r p
      mut as int64: denInv2A = 1
      mut as int64: b2A = denS2A
      mut as int64: e2A = p - 2
      infinite (e2A > 0) {
            route { e2A /r 2 == 1 ==> { denInv2A = (denInv2A * b2A) /r p } _ ==> {} }
            b2A = (b2A * b2A) /r p
            e2A = e2A /i 2
      }
      mut as int64: l2A = (numS2A * denInv2A) /r p
      mut as int64: qa2xVal = l2A * l2A - 2 * qax
      infinite (qa2xVal < 0) { qa2xVal = qa2xVal + p * 100 }
      mut as int64: qa2x = qa2xVal /r p

      mut as int64: qa2yVal = l2A * (qax - qa2x) - qay
      infinite (qa2yVal < 0) { qa2yVal = qa2yVal + p * 100 }
      mut as int64: qa2y = qa2yVal /r p

      #L Agora 2*QA + QA:
      mut as int64: dySB = qa2y - qay
      infinite (dySB < 0) { dySB = dySB + p * 10 }
      dySB = dySB /r p

      mut as int64: dxSB = qa2x - qax
      infinite (dxSB < 0) { dxSB = dxSB + p * 10 }
      dxSB = dxSB /r p

      mut as int64: dxInvSB = 1
      mut as int64: bSB = dxSB
      mut as int64: eSB = p - 2
      infinite (eSB > 0) {
            route { eSB /r 2 == 1 ==> { dxInvSB = (dxInvSB * bSB) /r p } _ ==> {} }
            bSB = (bSB * bSB) /r p
            eSB = eSB /i 2
      }
      mut as int64: lSB = (dySB * dxInvSB) /r p
      mut as int64: sbxVal = lSB * lSB - qax - qa2x
      infinite (sbxVal < 0) { sbxVal = sbxVal + p * 100 }
      mut as int64: sbx = sbxVal /r p

      mut as int64: sbyVal = lSB * (qax - sbx) - qay
      infinite (sbyVal < 0) { sbyVal = sbyVal + p * 100 }
      mut as int64: sby = sbyVal /r p

      println("   Segredo Bob SB   (3 * QA): (" + sbx + ", " + sby + ")")

      route {
            sax == sbx and say == sby ==> {
                  println("   SUCESSO: Segredos ECDH concordantes estabelecidos!")
            }
            _ ==> {
                  println("   FALHA: Divergência no acordo de chaves ECDH.")
            }
      }
}
