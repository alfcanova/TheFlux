#L ============================================================================
#L Algoritmo: Ed25519 (EdDSA Digital Signature sobre Curva de Edwards)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaEd25519) {
      println("==================================================")
      println("  SciAlgo: Ed25519 (Edwards Digital Signature)")
      println("==================================================")

      #L Parametros de corpo primo p=10007 e curva x^2 + y^2 = 1 + d*x^2*y^2
      mut as int64: p = 10007
      mut as int64: dCoeff = 370

      #L Ponto Base B validado na curva: (10, 514)
      mut as int64: bx = 10
      mut as int64: by = 514

      #L 1. Geracao do Par de Chaves: A = privKey * B
      mut as int64: privKey = 123

      mut as int64: pubAx = 0
      mut as int64: pubAy = 1 #L Ponto neutro (0, 1)
      mut as int64: curX = bx
      mut as int64: curY = by
      mut as int64: s = privKey

      infinite (s > 0) {
            mut as int64: bit = s & 1
            route {
                  bit == 1 ==> {
                        mut as int64: x1x2 = (pubAx * curX) /r p
                        mut as int64: y1y2 = (pubAy * curY) /r p
                        mut as int64: x1y2 = (pubAx * curY) /r p
                        mut as int64: y1x2 = (pubAy * curX) /r p
                        mut as int64: dxy = (dCoeff * ((x1x2 * y1y2) /r p)) /r p

                        mut as int64: xNum = (x1y2 + y1x2) /r p
                        mut as int64: xDen = (1 + dxy) /r p
                        mut as int64: invDen = 1
                        mut as int64: bExp = xDen /r p
                        mut as int64: eExp = p - 2
                        infinite (eExp > 0) {
                              mut as int64: b = eExp & 1
                              route {
                                    b == 1 ==> {
                                          invDen = (invDen * bExp) /r p
                                    }
                                    _ ==> {}
                              }
                              bExp = (bExp * bExp) /r p
                              eExp = eExp >> 1
                        }
                        pubAx = (xNum * invDen) /r p

                        mut as int64: ySub = y1y2 - x1x2
                        route {
                              ySub < 0 ==> {
                                    ySub = ySub + p
                              }
                              _ ==> {}
                        }
                        mut as int64: yNum = ySub /r p

                        mut as int64: yDenSub = 1 - dxy
                        route {
                              yDenSub < 0 ==> {
                                    yDenSub = yDenSub + p
                              }
                              _ ==> {}
                        }
                        mut as int64: yDen = yDenSub /r p

                        invDen = 1
                        bExp = yDen /r p
                        eExp = p - 2
                        infinite (eExp > 0) {
                              mut as int64: b = eExp & 1
                              route {
                                    b == 1 ==> {
                                          invDen = (invDen * bExp) /r p
                                    }
                                    _ ==> {}
                              }
                              bExp = (bExp * bExp) /r p
                              eExp = eExp >> 1
                        }
                        pubAy = (yNum * invDen) /r p
                  }
                  _ ==> {}
            }

            #L Dobro de ponto: cur = cur + cur
            mut as int64: x1x2 = (curX * curX) /r p
            mut as int64: y1y2 = (curY * curY) /r p
            mut as int64: x1y2 = (curX * curY) /r p
            mut as int64: y1x2 = x1y2
            mut as int64: dxy = (dCoeff * ((x1x2 * y1y2) /r p)) /r p

            mut as int64: xNum = (x1y2 + y1x2) /r p
            mut as int64: xDen = (1 + dxy) /r p
            mut as int64: invDen = 1
            mut as int64: bExp = xDen /r p
            mut as int64: eExp = p - 2
            infinite (eExp > 0) {
                  mut as int64: b = eExp & 1
                  route {
                        b == 1 ==> {
                              invDen = (invDen * bExp) /r p
                        }
                        _ ==> {}
                  }
                  bExp = (bExp * bExp) /r p
                  eExp = eExp >> 1
            }
            curX = (xNum * invDen) /r p

            mut as int64: ySub = y1y2 - x1x2
            route {
                  ySub < 0 ==> {
                        ySub = ySub + p
                  }
                  _ ==> {}
            }
            mut as int64: yNum = ySub /r p

            mut as int64: yDenSub = 1 - dxy
            route {
                  yDenSub < 0 ==> {
                        yDenSub = yDenSub + p
                  }
                  _ ==> {}
            }
            mut as int64: yDen = yDenSub /r p

            invDen = 1
            bExp = yDen /r p
            eExp = p - 2
            infinite (eExp > 0) {
                  mut as int64: b = eExp & 1
                  route {
                        b == 1 ==> {
                              invDen = (invDen * bExp) /r p
                        }
                        _ ==> {}
                  }
                  bExp = (bExp * bExp) /r p
                  eExp = eExp >> 1
            }
            curY = (yNum * invDen) /r p
            s = s >> 1
      }

      println("1. Par de Chaves Ed25519:")
      println("   Chave Privada: " + privKey)
      println("   Chave Publica A: (" + pubAx + ", " + pubAy + ")")

      #L 2. Geracao de Assinatura para Mensagem M
      mut as int64: msg = 987
      mut as int64: nonceR = 45 #L Nonce efêmero r

      #L R = nonceR * B
      mut as int64: commRx = 0
      mut as int64: commRy = 1
      curX = bx
      curY = by
      s = nonceR

      infinite (s > 0) {
            mut as int64: bit = s & 1
            route {
                  bit == 1 ==> {
                        mut as int64: x1x2 = (commRx * curX) /r p
                        mut as int64: y1y2 = (commRy * curY) /r p
                        mut as int64: x1y2 = (commRx * curY) /r p
                        mut as int64: y1x2 = (commRy * curX) /r p
                        mut as int64: dxy = (dCoeff * ((x1x2 * y1y2) /r p)) /r p

                        mut as int64: xNum = (x1y2 + y1x2) /r p
                        mut as int64: xDen = (1 + dxy) /r p
                        mut as int64: invDen = 1
                        mut as int64: bExp = xDen /r p
                        mut as int64: eExp = p - 2
                        infinite (eExp > 0) {
                              mut as int64: b = eExp & 1
                              route {
                                    b == 1 ==> {
                                          invDen = (invDen * bExp) /r p
                                    }
                                    _ ==> {}
                              }
                              bExp = (bExp * bExp) /r p
                              eExp = eExp >> 1
                        }
                        commRx = (xNum * invDen) /r p

                        mut as int64: ySub = y1y2 - x1x2
                        route {
                              ySub < 0 ==> {
                                    ySub = ySub + p
                              }
                              _ ==> {}
                        }
                        mut as int64: yNum = ySub /r p

                        mut as int64: yDenSub = 1 - dxy
                        route {
                              yDenSub < 0 ==> {
                                    yDenSub = yDenSub + p
                              }
                              _ ==> {}
                        }
                        mut as int64: yDen = yDenSub /r p

                        invDen = 1
                        bExp = yDen /r p
                        eExp = p - 2
                        infinite (eExp > 0) {
                              mut as int64: b = eExp & 1
                              route {
                                    b == 1 ==> {
                                          invDen = (invDen * bExp) /r p
                                    }
                                    _ ==> {}
                              }
                              bExp = (bExp * bExp) /r p
                              eExp = eExp >> 1
                        }
                        commRy = (yNum * invDen) /r p
                  }
                  _ ==> {}
            }

            mut as int64: x1x2 = (curX * curX) /r p
            mut as int64: y1y2 = (curY * curY) /r p
            mut as int64: x1y2 = (curX * curY) /r p
            mut as int64: y1x2 = x1y2
            mut as int64: dxy = (dCoeff * ((x1x2 * y1y2) /r p)) /r p

            mut as int64: xNum = (x1y2 + y1x2) /r p
            mut as int64: xDen = (1 + dxy) /r p
            mut as int64: invDen = 1
            mut as int64: bExp = xDen /r p
            mut as int64: eExp = p - 2
            infinite (eExp > 0) {
                  mut as int64: b = eExp & 1
                  route {
                        b == 1 ==> {
                              invDen = (invDen * bExp) /r p
                        }
                        _ ==> {}
                  }
                  bExp = (bExp * bExp) /r p
                  eExp = eExp >> 1
            }
            curX = (xNum * invDen) /r p

            mut as int64: ySub = y1y2 - x1x2
            route {
                  ySub < 0 ==> {
                        ySub = ySub + p
                  }
                  _ ==> {}
            }
            mut as int64: yNum = ySub /r p

            mut as int64: yDenSub = 1 - dxy
            route {
                  yDenSub < 0 ==> {
                        yDenSub = yDenSub + p
                  }
                  _ ==> {}
            }
            mut as int64: yDen = yDenSub /r p

            invDen = 1
            bExp = yDen /r p
            eExp = p - 2
            infinite (eExp > 0) {
                  mut as int64: b = eExp & 1
                  route {
                        b == 1 ==> {
                              invDen = (invDen * bExp) /r p
                        }
                        _ ==> {}
                  }
                  bExp = (bExp * bExp) /r p
                  eExp = eExp >> 1
            }
            curY = (yNum * invDen) /r p
            s = s >> 1
      }

      #L Desafio de Fiat-Shamir: e = H(R, A, msg) mod 100
      mut as int64: challengeE = ((commRx + pubAx * 7 + msg * 3) /r 100) + 1
      #L Escalar da assinatura s = nonceR + challengeE * privKey
      mut as int64: sigS = nonceR + challengeE * privKey

      println("==================================================")
      println("2. Assinatura Ed25519 (R, s):")
      println("   R = (" + commRx + ", " + commRy + ")")
      println("   s = " + sigS)

      println("==================================================")
      println("3. Verificacao da Assinatura: s * B == R + e * A:")

      #L LHS = s * B
      mut as int64: lhsX = 0
      mut as int64: lhsY = 1
      curX = bx
      curY = by
      s = sigS
      infinite (s > 0) {
            mut as int64: bit = s & 1
            route {
                  bit == 1 ==> {
                        mut as int64: x1x2 = (lhsX * curX) /r p
                        mut as int64: y1y2 = (lhsY * curY) /r p
                        mut as int64: x1y2 = (lhsX * curY) /r p
                        mut as int64: y1x2 = (lhsY * curX) /r p
                        mut as int64: dxy = (dCoeff * ((x1x2 * y1y2) /r p)) /r p

                        mut as int64: xNum = (x1y2 + y1x2) /r p
                        mut as int64: xDen = (1 + dxy) /r p
                        mut as int64: invDen = 1
                        mut as int64: bExp = xDen /r p
                        mut as int64: eExp = p - 2
                        infinite (eExp > 0) {
                              mut as int64: b = eExp & 1
                              route {
                                    b == 1 ==> {
                                          invDen = (invDen * bExp) /r p
                                    }
                                    _ ==> {}
                              }
                              bExp = (bExp * bExp) /r p
                              eExp = eExp >> 1
                        }
                        lhsX = (xNum * invDen) /r p

                        mut as int64: ySub = y1y2 - x1x2
                        route {
                              ySub < 0 ==> {
                                    ySub = ySub + p
                              }
                              _ ==> {}
                        }
                        mut as int64: yNum = ySub /r p

                        mut as int64: yDenSub = 1 - dxy
                        route {
                              yDenSub < 0 ==> {
                                    yDenSub = yDenSub + p
                              }
                              _ ==> {}
                        }
                        mut as int64: yDen = yDenSub /r p

                        invDen = 1
                        bExp = yDen /r p
                        eExp = p - 2
                        infinite (eExp > 0) {
                              mut as int64: b = eExp & 1
                              route {
                                    b == 1 ==> {
                                          invDen = (invDen * bExp) /r p
                                    }
                                    _ ==> {}
                              }
                              bExp = (bExp * bExp) /r p
                              eExp = eExp >> 1
                        }
                        lhsY = (yNum * invDen) /r p
                  }
                  _ ==> {}
            }

            mut as int64: x1x2 = (curX * curX) /r p
            mut as int64: y1y2 = (curY * curY) /r p
            mut as int64: x1y2 = (curX * curY) /r p
            mut as int64: y1x2 = x1y2
            mut as int64: dxy = (dCoeff * ((x1x2 * y1y2) /r p)) /r p

            mut as int64: xNum = (x1y2 + y1x2) /r p
            mut as int64: xDen = (1 + dxy) /r p
            mut as int64: invDen = 1
            mut as int64: bExp = xDen /r p
            mut as int64: eExp = p - 2
            infinite (eExp > 0) {
                  mut as int64: b = eExp & 1
                  route {
                        b == 1 ==> {
                              invDen = (invDen * bExp) /r p
                        }
                        _ ==> {}
                  }
                  bExp = (bExp * bExp) /r p
                  eExp = eExp >> 1
            }
            curX = (xNum * invDen) /r p

            mut as int64: ySub = y1y2 - x1x2
            route {
                  ySub < 0 ==> {
                        ySub = ySub + p
                  }
                  _ ==> {}
            }
            mut as int64: yNum = ySub /r p

            mut as int64: yDenSub = 1 - dxy
            route {
                  yDenSub < 0 ==> {
                        yDenSub = yDenSub + p
                  }
                  _ ==> {}
            }
            mut as int64: yDen = yDenSub /r p

            invDen = 1
            bExp = yDen /r p
            eExp = p - 2
            infinite (eExp > 0) {
                  mut as int64: b = eExp & 1
                  route {
                        b == 1 ==> {
                              invDen = (invDen * bExp) /r p
                        }
                        _ ==> {}
                  }
                  bExp = (bExp * bExp) /r p
                  eExp = eExp >> 1
            }
            curY = (yNum * invDen) /r p
            s = s >> 1
      }

      #L RHS = R + e * A
      #L Primeiro calcula ea = e * A
      mut as int64: eaX = 0
      mut as int64: eaY = 1
      curX = pubAx
      curY = pubAy
      s = challengeE
      infinite (s > 0) {
            mut as int64: bit = s & 1
            route {
                  bit == 1 ==> {
                        mut as int64: x1x2 = (eaX * curX) /r p
                        mut as int64: y1y2 = (eaY * curY) /r p
                        mut as int64: x1y2 = (eaX * curY) /r p
                        mut as int64: y1x2 = (eaY * curX) /r p
                        mut as int64: dxy = (dCoeff * ((x1x2 * y1y2) /r p)) /r p

                        mut as int64: xNum = (x1y2 + y1x2) /r p
                        mut as int64: xDen = (1 + dxy) /r p
                        mut as int64: invDen = 1
                        mut as int64: bExp = xDen /r p
                        mut as int64: eExp = p - 2
                        infinite (eExp > 0) {
                              mut as int64: b = eExp & 1
                              route {
                                    b == 1 ==> {
                                          invDen = (invDen * bExp) /r p
                                    }
                                    _ ==> {}
                              }
                              bExp = (bExp * bExp) /r p
                              eExp = eExp >> 1
                        }
                        eaX = (xNum * invDen) /r p

                        mut as int64: ySub = y1y2 - x1x2
                        route {
                              ySub < 0 ==> {
                                    ySub = ySub + p
                              }
                              _ ==> {}
                        }
                        mut as int64: yNum = ySub /r p

                        mut as int64: yDenSub = 1 - dxy
                        route {
                              yDenSub < 0 ==> {
                                    yDenSub = yDenSub + p
                              }
                              _ ==> {}
                        }
                        mut as int64: yDen = yDenSub /r p

                        invDen = 1
                        bExp = yDen /r p
                        eExp = p - 2
                        infinite (eExp > 0) {
                              mut as int64: b = eExp & 1
                              route {
                                    b == 1 ==> {
                                          invDen = (invDen * bExp) /r p
                                    }
                                    _ ==> {}
                              }
                              bExp = (bExp * bExp) /r p
                              eExp = eExp >> 1
                        }
                        eaY = (yNum * invDen) /r p
                  }
                  _ ==> {}
            }

            mut as int64: x1x2 = (curX * curX) /r p
            mut as int64: y1y2 = (curY * curY) /r p
            mut as int64: x1y2 = (curX * curY) /r p
            mut as int64: y1x2 = x1y2
            mut as int64: dxy = (dCoeff * ((x1x2 * y1y2) /r p)) /r p

            mut as int64: xNum = (x1y2 + y1x2) /r p
            mut as int64: xDen = (1 + dxy) /r p
            mut as int64: invDen = 1
            mut as int64: bExp = xDen /r p
            mut as int64: eExp = p - 2
            infinite (eExp > 0) {
                  mut as int64: b = eExp & 1
                  route {
                        b == 1 ==> {
                              invDen = (invDen * bExp) /r p
                        }
                        _ ==> {}
                  }
                  bExp = (bExp * bExp) /r p
                  eExp = eExp >> 1
            }
            curX = (xNum * invDen) /r p

            mut as int64: ySub = y1y2 - x1x2
            route {
                  ySub < 0 ==> {
                        ySub = ySub + p
                  }
                  _ ==> {}
            }
            mut as int64: yNum = ySub /r p

            mut as int64: yDenSub = 1 - dxy
            route {
                  yDenSub < 0 ==> {
                        yDenSub = yDenSub + p
                  }
                  _ ==> {}
            }
            mut as int64: yDen = yDenSub /r p

            invDen = 1
            bExp = yDen /r p
            eExp = p - 2
            infinite (eExp > 0) {
                  mut as int64: b = eExp & 1
                  route {
                        b == 1 ==> {
                              invDen = (invDen * bExp) /r p
                        }
                        _ ==> {}
                  }
                  bExp = (bExp * bExp) /r p
                  eExp = eExp >> 1
            }
            curY = (yNum * invDen) /r p
            s = s >> 1
      }

      #L Agora soma R + ea
      mut as int64: x1x2 = (commRx * eaX) /r p
      mut as int64: y1y2 = (commRy * eaY) /r p
      mut as int64: x1y2 = (commRx * eaY) /r p
      mut as int64: y1x2 = (commRy * eaX) /r p
      mut as int64: dxy = (dCoeff * ((x1x2 * y1y2) /r p)) /r p

      mut as int64: xNum = (x1y2 + y1x2) /r p
      mut as int64: xDen = (1 + dxy) /r p
      mut as int64: invDen = 1
      mut as int64: bExp = xDen /r p
      mut as int64: eExp = p - 2
      infinite (eExp > 0) {
            mut as int64: b = eExp & 1
            route {
                  b == 1 ==> {
                        invDen = (invDen * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: rhsX = (xNum * invDen) /r p

      mut as int64: ySub = y1y2 - x1x2
      route {
            ySub < 0 ==> {
                  ySub = ySub + p
            }
            _ ==> {}
      }
      mut as int64: yNum = ySub /r p

      mut as int64: yDenSub = 1 - dxy
      route {
            yDenSub < 0 ==> {
                  yDenSub = yDenSub + p
            }
            _ ==> {}
      }
      mut as int64: yDen = yDenSub /r p

      invDen = 1
      bExp = yDen /r p
      eExp = p - 2
      infinite (eExp > 0) {
            mut as int64: b = eExp & 1
            route {
                  b == 1 ==> {
                        invDen = (invDen * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: rhsY = (yNum * invDen) /r p

      println("   LHS (s * B):     (" + lhsX + ", " + lhsY + ")")
      println("   RHS (R + e * A): (" + rhsX + ", " + rhsY + ")")

      route {
            lhsX == rhsX ==> {
                  route {
                        lhsY == rhsY ==> {
                              println("   SUCESSO: Assinatura Ed25519 verificada e autentica!")
                        }
                        _ ==> {
                              println("   FALHA: Inconsistencia em Y.")
                        }
                  }
            }
            _ ==> {
                  println("   FALHA: Inconsistencia em X.")
            }
      }
}
