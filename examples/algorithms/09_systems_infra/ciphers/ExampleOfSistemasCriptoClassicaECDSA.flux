#L ============================================================================
#L Algoritmo: ECDSA (Elliptic Curve Digital Signature Algorithm)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaECDSA) {
      println("==================================================")
      println("  SciAlgo: ECDSA (Elliptic Curve Digital Signature)")
      println("==================================================")

      #L Parametros da Curva: y^2 = x^3 + 2*x + 8 (mod 31), Ordem n = 31
      mut as int64: p = 31
      mut as int64: n = 31
      mut as int64: a = 2
      mut as int64: b = 8
      mut as int64: gx = 0
      mut as int64: gy = 15

      #L Chave privada d = 7
      mut as int64: d = 7

      println("1. Parametros da Curva e Chaves:")
      println("   Corpo Primo p = " + p + ", Ordem n = " + n)
      println("   Ponto Base G = (" + gx + ", " + gy + ")")
      println("   Chave privada (d): " + d)

      #L Multiplicacao por adicao sucessiva em subgrupo pequeno:
      #L Calcula Chave Publica Q = d * G = 7 * G = (10, 6)
      mut as int64: qx = 0
      mut as int64: qy = 0
      mut as int64: qInf = 1

      mut as int64: stepQ = 1
      infinite (stepQ <= d) {
            route {
                  qInf == 1 ==> {
                        qx = gx
                        qy = gy
                        qInf = 0
                  }
                  _ ==> {
                        route {
                              qx == gx and qy == gy ==> {
                                    mut as int64: numS = (3 * qx * qx + a) /r p
                                    mut as int64: denS = (2 * qy) /r p
                                    mut as int64: denInv = 1
                                    mut as int64: bInv = denS
                                    mut as int64: eInv = p - 2
                                    infinite (eInv > 0) {
                                          route { eInv /r 2 == 1 ==> { denInv = (denInv * bInv) /r p } _ ==> {} }
                                          bInv = (bInv * bInv) /r p
                                          eInv = eInv /i 2
                                    }
                                    mut as int64: slope = (numS * denInv) /r p
                                    mut as int64: nxVal = slope * slope - 2 * qx
                                    infinite (nxVal < 0) { nxVal = nxVal + p * 100 }
                                    mut as int64: nx = nxVal /r p

                                    mut as int64: nyVal = slope * (qx - nx) - qy
                                    infinite (nyVal < 0) { nyVal = nyVal + p * 100 }
                                    mut as int64: ny = nyVal /r p

                                    qx = nx
                                    qy = ny
                              }
                              _ ==> {
                                    mut as int64: dy = gy - qy
                                    infinite (dy < 0) { dy = dy + p * 10 }
                                    dy = dy /r p

                                    mut as int64: dx = gx - qx
                                    infinite (dx < 0) { dx = dx + p * 10 }
                                    dx = dx /r p

                                    mut as int64: dxInv = 1
                                    mut as int64: bI = dx
                                    mut as int64: eI = p - 2
                                    infinite (eI > 0) {
                                          route { eI /r 2 == 1 ==> { dxInv = (dxInv * bI) /r p } _ ==> {} }
                                          bI = (bI * bI) /r p
                                          eI = eI /i 2
                                    }
                                    mut as int64: slope = (dy * dxInv) /r p
                                    mut as int64: nxVal = slope * slope - qx - gx
                                    infinite (nxVal < 0) { nxVal = nxVal + p * 100 }
                                    mut as int64: nx = nxVal /r p

                                    mut as int64: nyVal = slope * (qx - nx) - qy
                                    infinite (nyVal < 0) { nyVal = nyVal + p * 100 }
                                    mut as int64: ny = nyVal /r p

                                    qx = nx
                                    qy = ny
                              }
                        }
                  }
            }
            stepQ = stepQ + 1
      }
      println("   Chave Publica Q: (" + qx + ", " + qy + ")")

      println("==================================================")
      println("2. Assinatura ECDSA:")

      #L Hash da mensagem z = 17, efemero k = 11
      mut as int64: z = 17
      mut as int64: k = 11

      #L Calcula R = k * G
      mut as int64: rx = 0
      mut as int64: ry = 0
      mut as int64: rInf = 1

      mut as int64: stepR = 1
      infinite (stepR <= k) {
            route {
                  rInf == 1 ==> {
                        rx = gx
                        ry = gy
                        rInf = 0
                  }
                  _ ==> {
                        route {
                              rx == gx and ry == gy ==> {
                                    mut as int64: numS = (3 * rx * rx + a) /r p
                                    mut as int64: denS = (2 * ry) /r p
                                    mut as int64: denInv = 1
                                    mut as int64: bInv = denS
                                    mut as int64: eInv = p - 2
                                    infinite (eInv > 0) {
                                          route { eInv /r 2 == 1 ==> { denInv = (denInv * bInv) /r p } _ ==> {} }
                                          bInv = (bInv * bInv) /r p
                                          eInv = eInv /i 2
                                    }
                                    mut as int64: slope = (numS * denInv) /r p
                                    mut as int64: nxVal = slope * slope - 2 * rx
                                    infinite (nxVal < 0) { nxVal = nxVal + p * 100 }
                                    mut as int64: nx = nxVal /r p

                                    mut as int64: nyVal = slope * (rx - nx) - ry
                                    infinite (nyVal < 0) { nyVal = nyVal + p * 100 }
                                    mut as int64: ny = nyVal /r p

                                    rx = nx
                                    ry = ny
                              }
                              _ ==> {
                                    mut as int64: dy = gy - ry
                                    infinite (dy < 0) { dy = dy + p * 10 }
                                    dy = dy /r p

                                    mut as int64: dx = gx - rx
                                    infinite (dx < 0) { dx = dx + p * 10 }
                                    dx = dx /r p

                                    mut as int64: dxInv = 1
                                    mut as int64: bI = dx
                                    mut as int64: eI = p - 2
                                    infinite (eI > 0) {
                                          route { eI /r 2 == 1 ==> { dxInv = (dxInv * bI) /r p } _ ==> {} }
                                          bI = (bI * bI) /r p
                                          eI = eI /i 2
                                    }
                                    mut as int64: slope = (dy * dxInv) /r p
                                    mut as int64: nxVal = slope * slope - rx - gx
                                    infinite (nxVal < 0) { nxVal = nxVal + p * 100 }
                                    mut as int64: nx = nxVal /r p

                                    mut as int64: nyVal = slope * (rx - nx) - ry
                                    infinite (nyVal < 0) { nyVal = nyVal + p * 100 }
                                    mut as int64: ny = nyVal /r p

                                    rx = nx
                                    ry = ny
                              }
                        }
                  }
            }
            stepR = stepR + 1
      }

      mut as int64: sigR = rx /r n
      #L Inverso de k mod n
      mut as int64: kInv = 1
      mut as int64: bK = k
      mut as int64: eK = n - 2
      infinite (eK > 0) {
            route { eK /r 2 == 1 ==> { kInv = (kInv * bK) /r n } _ ==> {} }
            bK = (bK * bK) /r n
            eK = eK /i 2
      }
      #L s = kInv * (z + sigR * d) mod n
      mut as int64: sigS = (kInv * (z + sigR * d)) /r n

      println("   Assinatura gerada (r, s): (" + sigR + ", " + sigS + ")")

      println("==================================================")
      println("3. Verificacao da Assinatura ECDSA:")

      #L w = s^(-1) mod n
      mut as int64: w = 1
      mut as int64: bW = sigS
      mut as int64: eW = n - 2
      infinite (eW > 0) {
            route { eW /r 2 == 1 ==> { w = (w * bW) /r n } _ ==> {} }
            bW = (bW * bW) /r n
            eW = eW /i 2
      }
      mut as int64: u1 = (z * w) /r n
      mut as int64: u2 = (sigR * w) /r n

      #L P1 = u1 * G
      mut as int64: p1x = 0
      mut as int64: p1y = 0
      mut as int64: p1Inf = 1
      mut as int64: s1 = 1
      infinite (s1 <= u1) {
            route {
                  p1Inf == 1 ==> {
                        p1x = gx
                        p1y = gy
                        p1Inf = 0
                  }
                  _ ==> {
                        route {
                              p1x == gx and p1y == gy ==> {
                                    mut as int64: numS = (3 * p1x * p1x + a) /r p
                                    mut as int64: denS = (2 * p1y) /r p
                                    mut as int64: denInv = 1
                                    mut as int64: bInv = denS
                                    mut as int64: eInv = p - 2
                                    infinite (eInv > 0) {
                                          route { eInv /r 2 == 1 ==> { denInv = (denInv * bInv) /r p } _ ==> {} }
                                          bInv = (bInv * bInv) /r p
                                          eInv = eInv /i 2
                                    }
                                    mut as int64: slope = (numS * denInv) /r p
                                    mut as int64: nxVal = slope * slope - 2 * p1x
                                    infinite (nxVal < 0) { nxVal = nxVal + p * 100 }
                                    mut as int64: nx = nxVal /r p

                                    mut as int64: nyVal = slope * (p1x - nx) - p1y
                                    infinite (nyVal < 0) { nyVal = nyVal + p * 100 }
                                    mut as int64: ny = nyVal /r p

                                    p1x = nx
                                    p1y = ny
                              }
                              _ ==> {
                                    mut as int64: dy = gy - p1y
                                    infinite (dy < 0) { dy = dy + p * 10 }
                                    dy = dy /r p

                                    mut as int64: dx = gx - p1x
                                    infinite (dx < 0) { dx = dx + p * 10 }
                                    dx = dx /r p

                                    mut as int64: dxInv = 1
                                    mut as int64: bI = dx
                                    mut as int64: eI = p - 2
                                    infinite (eI > 0) {
                                          route { eI /r 2 == 1 ==> { dxInv = (dxInv * bI) /r p } _ ==> {} }
                                          bI = (bI * bI) /r p
                                          eI = eI /i 2
                                    }
                                    mut as int64: slope = (dy * dxInv) /r p
                                    mut as int64: nxVal = slope * slope - p1x - gx
                                    infinite (nxVal < 0) { nxVal = nxVal + p * 100 }
                                    mut as int64: nx = nxVal /r p

                                    mut as int64: nyVal = slope * (p1x - nx) - p1y
                                    infinite (nyVal < 0) { nyVal = nyVal + p * 100 }
                                    mut as int64: ny = nyVal /r p

                                    p1x = nx
                                    p1y = ny
                              }
                        }
                  }
            }
            s1 = s1 + 1
      }

      #L P2 = u2 * Q
      mut as int64: p2x = 0
      mut as int64: p2y = 0
      mut as int64: p2Inf = 1
      mut as int64: s2 = 1
      infinite (s2 <= u2) {
            route {
                  p2Inf == 1 ==> {
                        p2x = qx
                        p2y = qy
                        p2Inf = 0
                  }
                  _ ==> {
                        route {
                              p2x == qx and p2y == qy ==> {
                                    mut as int64: numS = (3 * p2x * p2x + a) /r p
                                    mut as int64: denS = (2 * p2y) /r p
                                    mut as int64: denInv = 1
                                    mut as int64: bInv = denS
                                    mut as int64: eInv = p - 2
                                    infinite (eInv > 0) {
                                          route { eInv /r 2 == 1 ==> { denInv = (denInv * bInv) /r p } _ ==> {} }
                                          bInv = (bInv * bInv) /r p
                                          eInv = eInv /i 2
                                    }
                                    mut as int64: slope = (numS * denInv) /r p
                                    mut as int64: nxVal = slope * slope - 2 * p2x
                                    infinite (nxVal < 0) { nxVal = nxVal + p * 100 }
                                    mut as int64: nx = nxVal /r p

                                    mut as int64: nyVal = slope * (p2x - nx) - p2y
                                    infinite (nyVal < 0) { nyVal = nyVal + p * 100 }
                                    mut as int64: ny = nyVal /r p

                                    p2x = nx
                                    p2y = ny
                              }
                              _ ==> {
                                    mut as int64: dy = qy - p2y
                                    infinite (dy < 0) { dy = dy + p * 10 }
                                    dy = dy /r p

                                    mut as int64: dx = qx - p2x
                                    infinite (dx < 0) { dx = dx + p * 10 }
                                    dx = dx /r p

                                    mut as int64: dxInv = 1
                                    mut as int64: bI = dx
                                    mut as int64: eI = p - 2
                                    infinite (eI > 0) {
                                          route { eI /r 2 == 1 ==> { dxInv = (dxInv * bI) /r p } _ ==> {} }
                                          bI = (bI * bI) /r p
                                          eI = eI /i 2
                                    }
                                    mut as int64: slope = (dy * dxInv) /r p
                                    mut as int64: nxVal = slope * slope - p2x - qx
                                    infinite (nxVal < 0) { nxVal = nxVal + p * 100 }
                                    mut as int64: nx = nxVal /r p

                                    mut as int64: nyVal = slope * (p2x - nx) - p2y
                                    infinite (nyVal < 0) { nyVal = nyVal + p * 100 }
                                    mut as int64: ny = nyVal /r p

                                    p2x = nx
                                    p2y = ny
                              }
                        }
                  }
            }
            s2 = s2 + 1
      }

      #L V = P1 + P2
      mut as int64: vx = 0
      mut as int64: vy = 0
      mut as int64: dyV = p2y - p1y
      infinite (dyV < 0) { dyV = dyV + p * 10 }
      dyV = dyV /r p

      mut as int64: dxV = p2x - p1x
      infinite (dxV < 0) { dxV = dxV + p * 10 }
      dxV = dxV /r p

      mut as int64: dxInvV = 1
      mut as int64: bIV = dxV
      mut as int64: eIV = p - 2
      infinite (eIV > 0) {
            route { eIV /r 2 == 1 ==> { dxInvV = (dxInvV * bIV) /r p } _ ==> {} }
            bIV = (bIV * bIV) /r p
            eIV = eIV /i 2
      }
      mut as int64: slopeV = (dyV * dxInvV) /r p
      mut as int64: vxVal = slopeV * slopeV - p1x - p2x
      infinite (vxVal < 0) { vxVal = vxVal + p * 100 }
      vx = vxVal /r p

      mut as int64: vyVal = slopeV * (p1x - vx) - p1y
      infinite (vyVal < 0) { vyVal = vyVal + p * 100 }
      vy = vyVal /r p

      mut as int64: vMod = vx /r n
      println("   Ponto de verificacao V = (" + vx + ", " + vy + ")")
      println("   V_x mod n = " + vMod + " (esperado r = " + sigR + ")")

      route {
            vMod == sigR and sigR > 0 ==> {
                  println("   SUCESSO: Assinatura ECDSA validada com perfeicao!")
            }
            _ ==> {
                  println("   FALHA: Assinatura ECDSA invalida.")
            }
      }
}
