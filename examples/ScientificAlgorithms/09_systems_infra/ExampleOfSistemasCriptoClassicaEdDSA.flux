#L ============================================================================
#L Algoritmo: EdDSA (Edwards-curve Digital Signature Algorithm)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaEdDSA) {
      println("==================================================")
      println("  SciAlgo: EdDSA (Edwards-curve Digital Signature)")
      println("==================================================")

      #L Curva de Edwards Completa: x^2 + y^2 = 1 + d*x^2*y^2 (mod p)
      #L Parametros: p = 67, a = 1, d = 2 (d nao-residuo quadratico mod 67)
      #L Ponto Base B = (2, 55) com ordem prima l = 17
      mut as int64: p = 67
      mut as int64: a = 1
      mut as int64: d = 2
      mut as int64: bx = 2
      mut as int64: by = 55
      mut as int64: l = 17

      #L Chave privada kPriv = 3
      mut as int64: kPriv = 3

      println("1. Parametros do Dominio de Edwards:")
      println("   Corpo p = " + p + ", Parametro d = " + d + ", Ordem do Subgrupo l = " + l)
      println("   Ponto Base B = (" + bx + ", " + by + ")")
      println("   Chave privada (k): " + kPriv)

      #L Calcula Chave Publica A = kPriv * B = 3 * B
      mut as int64: ax = 0
      mut as int64: ay = 1 #L Elemento neutro (0, 1) em curvas de Edwards

      mut as int64: sA = 1
      infinite (sA <= kPriv) {
            #L Adiciona B a A:
            mut as int64: numX = (ax * by + ay * bx) /r p
            mut as int64: denX = (1 + d * ((ax * bx) /r p) * ((ay * by) /r p)) /r p
            #L Inverso de denX mod p via Fermat
            mut as int64: invDenX = 1
            mut as int64: bX = denX
            mut as int64: eX = p - 2
            infinite (eX > 0) {
                  route { eX /r 2 == 1 ==> { invDenX = (invDenX * bX) /r p } _ ==> {} }
                  bX = (bX * bX) /r p
                  eX = eX /i 2
            }
            mut as int64: nAx = (numX * invDenX) /r p

            mut as int64: numYVal = ay * by - a * ((ax * bx) /r p)
            infinite (numYVal < 0) { numYVal = numYVal + p * 100 }
            mut as int64: numY = numYVal /r p

            mut as int64: denYVal = 1 - d * ((ax * bx) /r p) * ((ay * by) /r p)
            infinite (denYVal < 0) { denYVal = denYVal + p * 100 }
            mut as int64: denY = denYVal /r p

            mut as int64: invDenY = 1
            mut as int64: bY = denY
            mut as int64: eY = p - 2
            infinite (eY > 0) {
                  route { eY /r 2 == 1 ==> { invDenY = (invDenY * bY) /r p } _ ==> {} }
                  bY = (bY * bY) /r p
                  eY = eY /i 2
            }
            mut as int64: nAy = (numY * invDenY) /r p

            ax = nAx
            ay = nAy
            sA = sA + 1
      }
      println("   Chave Publica A = (" + ax + ", " + ay + ")")

      println("==================================================")
      println("2. Assinatura EdDSA:")

      #L Mensagem m = 25, segredo efemero r = 4
      mut as int64: m = 25
      mut as int64: r = 4

      #L Calcula R = r * B = 4 * B
      mut as int64: rx = 0
      mut as int64: ry = 1 #L Identidade

      mut as int64: sR = 1
      infinite (sR <= r) {
            mut as int64: numX = (rx * by + ry * bx) /r p
            mut as int64: denX = (1 + d * ((rx * bx) /r p) * ((ry * by) /r p)) /r p
            mut as int64: invDenX = 1
            mut as int64: bX = denX
            mut as int64: eX = p - 2
            infinite (eX > 0) {
                  route { eX /r 2 == 1 ==> { invDenX = (invDenX * bX) /r p } _ ==> {} }
                  bX = (bX * bX) /r p
                  eX = eX /i 2
            }
            mut as int64: nRx = (numX * invDenX) /r p

            mut as int64: numYVal = ry * by - a * ((rx * bx) /r p)
            infinite (numYVal < 0) { numYVal = numYVal + p * 100 }
            mut as int64: numY = numYVal /r p

            mut as int64: denYVal = 1 - d * ((rx * bx) /r p) * ((ry * by) /r p)
            infinite (denYVal < 0) { denYVal = denYVal + p * 100 }
            mut as int64: denY = denYVal /r p

            mut as int64: invDenY = 1
            mut as int64: bY = denY
            mut as int64: eY = p - 2
            infinite (eY > 0) {
                  route { eY /r 2 == 1 ==> { invDenY = (invDenY * bY) /r p } _ ==> {} }
                  bY = (bY * bY) /r p
                  eY = eY /i 2
            }
            mut as int64: nRy = (numY * invDenY) /r p

            rx = nRx
            ry = nRy
            sR = sR + 1
      }

      #L Desafio de Schnorr e: e = (rx + ax + m) mod l
      mut as int64: e = (rx + ax + m) /r l
      #L Escalar s = (r + e * kPriv) mod l
      mut as int64: s = (r + e * kPriv) /r l

      println("   Ponto Efemero R = (" + rx + ", " + ry + ")")
      println("   Desafio e: " + e + ", Escalar de Assinatura s: " + s)

      println("==================================================")
      println("3. Verificacao da Assinatura: s * B == R + e * A")

      #L LHS = s * B
      mut as int64: lhsX = 0
      mut as int64: lhsY = 1
      mut as int64: stepL = 1
      infinite (stepL <= s) {
            mut as int64: numX = (lhsX * by + lhsY * bx) /r p
            mut as int64: denX = (1 + d * ((lhsX * bx) /r p) * ((lhsY * by) /r p)) /r p
            mut as int64: invDenX = 1
            mut as int64: bX = denX
            mut as int64: eX = p - 2
            infinite (eX > 0) {
                  route { eX /r 2 == 1 ==> { invDenX = (invDenX * bX) /r p } _ ==> {} }
                  bX = (bX * bX) /r p
                  eX = eX /i 2
            }
            mut as int64: nLx = (numX * invDenX) /r p

            mut as int64: numYVal = lhsY * by - a * ((lhsX * bx) /r p)
            infinite (numYVal < 0) { numYVal = numYVal + p * 100 }
            mut as int64: numY = numYVal /r p

            mut as int64: denYVal = 1 - d * ((lhsX * bx) /r p) * ((lhsY * by) /r p)
            infinite (denYVal < 0) { denYVal = denYVal + p * 100 }
            mut as int64: denY = denYVal /r p

            mut as int64: invDenY = 1
            mut as int64: bY = denY
            mut as int64: eY = p - 2
            infinite (eY > 0) {
                  route { eY /r 2 == 1 ==> { invDenY = (invDenY * bY) /r p } _ ==> {} }
                  bY = (bY * bY) /r p
                  eY = eY /i 2
            }
            mut as int64: nLy = (numY * invDenY) /r p

            lhsX = nLx
            lhsY = nLy
            stepL = stepL + 1
      }

      #L RHS = R + e * A
      #L Primeiro calcula e * A:
      mut as int64: eaX = 0
      mut as int64: eaY = 1
      mut as int64: stepEA = 1
      infinite (stepEA <= e) {
            mut as int64: numX = (eaX * ay + eaY * ax) /r p
            mut as int64: denX = (1 + d * ((eaX * ax) /r p) * ((eaY * ay) /r p)) /r p
            mut as int64: invDenX = 1
            mut as int64: bX = denX
            mut as int64: eX = p - 2
            infinite (eX > 0) {
                  route { eX /r 2 == 1 ==> { invDenX = (invDenX * bX) /r p } _ ==> {} }
                  bX = (bX * bX) /r p
                  eX = eX /i 2
            }
            mut as int64: nEAx = (numX * invDenX) /r p

            mut as int64: numYVal = eaY * ay - a * ((eaX * ax) /r p)
            infinite (numYVal < 0) { numYVal = numYVal + p * 100 }
            mut as int64: numY = numYVal /r p

            mut as int64: denYVal = 1 - d * ((eaX * ax) /r p) * ((eaY * ay) /r p)
            infinite (denYVal < 0) { denYVal = denYVal + p * 100 }
            mut as int64: denY = denYVal /r p

            mut as int64: invDenY = 1
            mut as int64: bY = denY
            mut as int64: eY = p - 2
            infinite (eY > 0) {
                  route { eY /r 2 == 1 ==> { invDenY = (invDenY * bY) /r p } _ ==> {} }
                  bY = (bY * bY) /r p
                  eY = eY /i 2
            }
            mut as int64: nEAy = (numY * invDenY) /r p

            eaX = nEAx
            eaY = nEAy
            stepEA = stepEA + 1
      }

      #L Agora soma R + (e * A):
      mut as int64: numX = (rx * eaY + ry * eaX) /r p
      mut as int64: denX = (1 + d * ((rx * eaX) /r p) * ((ry * eaY) /r p)) /r p
      mut as int64: invDenX = 1
      mut as int64: bX = denX
      mut as int64: eX = p - 2
      infinite (eX > 0) {
            route { eX /r 2 == 1 ==> { invDenX = (invDenX * bX) /r p } _ ==> {} }
            bX = (bX * bX) /r p
            eX = eX /i 2
      }
      mut as int64: rhsX = (numX * invDenX) /r p

      mut as int64: numYVal = ry * eaY - a * ((rx * eaX) /r p)
      infinite (numYVal < 0) { numYVal = numYVal + p * 100 }
      mut as int64: numY = numYVal /r p

      mut as int64: denYVal = 1 - d * ((rx * eaX) /r p) * ((ry * eaY) /r p)
      infinite (denYVal < 0) { denYVal = denYVal + p * 100 }
      mut as int64: denY = denYVal /r p

      mut as int64: invDenY = 1
      mut as int64: bY = denY
      mut as int64: eY = p - 2
      infinite (eY > 0) {
            route { eY /r 2 == 1 ==> { invDenY = (invDenY * bY) /r p } _ ==> {} }
            bY = (bY * bY) /r p
            eY = eY /i 2
      }
      mut as int64: rhsY = (numY * invDenY) /r p

      println("   LHS = s * B:     (" + lhsX + ", " + lhsY + ")")
      println("   RHS = R + e * A: (" + rhsX + ", " + rhsY + ")")

      route {
            lhsX == rhsX and lhsY == rhsY ==> {
                  println("   SUCESSO: Assinatura EdDSA verificada na Curva de Edwards!")
            }
            _ ==> {
                  println("   FALHA: Divergência na verificacao EdDSA.")
            }
      }
}
