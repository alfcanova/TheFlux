#L ============================================================================
#L Algoritmo: Shamir's Secret Sharing ((k, n) Threshold Scheme com Interpolacao de Lagrange)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaShamirSecretSharing) {
      println("==================================================")
      println("  SciAlgo: Shamir's (k, n) Threshold Secret Sharing")
      println("==================================================")

      #L Corpo primo p=10007
      mut as int64: p = 10007

      #L Segredo a ser compartilhado S = P(0)
      mut as int64: secretS = 4821

      #L Limiar k=3 (sao necessarias 3 partes para reconstruir), total n=5 partes
      mut as int64: k = 3
      mut as int64: nShares = 5

      #L Coeficientes do polinomio P(x) = S + a1*x + a2*x^2 mod p
      mut as int64: a1 = 317
      mut as int64: a2 = 59

      println("1. Parametros do Esquema:")
      println("   Segredo Original S: " + secretS)
      println("   Limiar k: " + k + " de n: " + nShares)
      println("   Corpo Primo p: " + p)
      println("   Polinomio P(x) = " + secretS + " + " + a1 + "*x + " + a2 + "*x^2 (mod " + p + ")")

      println("==================================================")
      println("2. Geracao das 5 Partes (Shares):")
      mut as list of int64: shareX = [1, 2, 3, 4, 5]
      mut as list of int64: shareY = [0, 0, 0, 0, 0]

      mut as int64: i = 1
      infinite (i <= nShares) {
            mut as int64: x = shareX[i]
            mut as int64: term1 = (a1 * x) /r p
            mut as int64: term2 = (a2 * ((x * x) /r p)) /r p
            mut as int64: y = (secretS + term1 + term2) /r p
            shareY[i] = y
            println("   Parte " + i + ": (x=" + x + ", y=" + y + ")")
            i = i + 1
      }

      println("==================================================")
      println("3. Reconstrucao de Lagrange usando o Subconjunto {1, 3, 5}:")
      #L Subconjunto de k=3 partes: P1=(1, shareY[1]), P3=(3, shareY[3]), P5=(5, shareY[5])
      mut as list of int64: subX = [shareX[1], shareX[3], shareX[5]]
      mut as list of int64: subY = [shareY[1], shareY[3], shareY[5]]

      mut as int64: reconstructedS = 0
      mut as int64: j = 1
      infinite (j <= k) {
            #L Calcula o polinomio base de Lagrange L_j(0) = PROD_{m != j} (-x_m) / (x_j - x_m) mod p
            mut as int64: numProd = 1
            mut as int64: denProd = 1

            mut as int64: m = 1
            infinite (m <= k) {
                  route {
                        m != j ==> {
                              mut as int64: numPart = p - subX[m]
                              numProd = (numProd * numPart) /r p

                              mut as int64: denDiff = subX[j] - subX[m]
                              route {
                                    denDiff < 0 ==> {
                                          denDiff = denDiff + p
                                    }
                                    _ ==> {}
                              }
                              denProd = (denProd * denDiff) /r p
                        }
                        _ ==> {}
                  }
                  m = m + 1
            }

            #L Inverso modular do denominador denProd^(p-2) mod p
            mut as int64: invDen = 1
            mut as int64: bExp = denProd /r p
            mut as int64: eExp = p - 2
            infinite (eExp > 0) {
                  mut as int64: bit = eExp & 1
                  route {
                        bit == 1 ==> {
                              invDen = (invDen * bExp) /r p
                        }
                        _ ==> {}
                  }
                  bExp = (bExp * bExp) /r p
                  eExp = eExp >> 1
            }

            mut as int64: lBasis = (numProd * invDen) /r p
            mut as int64: termY = (subY[j] * lBasis) /r p
            reconstructedS = (reconstructedS + termY) /r p
            j = j + 1
      }

      println("   Segredo Reconstruido a partir de {1, 3, 5}: " + reconstructedS)
      route {
            reconstructedS == secretS ==> {
                  println("   SUCESSO: Segredo perfeitamente recuperado com k=3 partes!")
            }
            _ ==> {
                  println("   FALHA: Divergencia no segredo recuperado.")
            }
      }

      println("==================================================")
      println("4. Reconstrucao com Subconjunto Alternativo {2, 3, 4}:")
      subX[1] = shareX[2]
      subX[2] = shareX[3]
      subX[3] = shareX[4]
      subY[1] = shareY[2]
      subY[2] = shareY[3]
      subY[3] = shareY[4]

      mut as int64: reconstructedS2 = 0
      j = 1
      infinite (j <= k) {
            mut as int64: numProd = 1
            mut as int64: denProd = 1

            mut as int64: m = 1
            infinite (m <= k) {
                  route {
                        m != j ==> {
                              mut as int64: numPart = p - subX[m]
                              numProd = (numProd * numPart) /r p

                              mut as int64: denDiff = subX[j] - subX[m]
                              route {
                                    denDiff < 0 ==> {
                                          denDiff = denDiff + p
                                    }
                                    _ ==> {}
                              }
                              denProd = (denProd * denDiff) /r p
                        }
                        _ ==> {}
                  }
                  m = m + 1
            }

            mut as int64: invDen = 1
            mut as int64: bExp = denProd /r p
            mut as int64: eExp = p - 2
            infinite (eExp > 0) {
                  mut as int64: bit = eExp & 1
                  route {
                        bit == 1 ==> {
                              invDen = (invDen * bExp) /r p
                        }
                        _ ==> {}
                  }
                  bExp = (bExp * bExp) /r p
                  eExp = eExp >> 1
            }

            mut as int64: lBasis = (numProd * invDen) /r p
            mut as int64: termY = (subY[j] * lBasis) /r p
            reconstructedS2 = (reconstructedS2 + termY) /r p
            j = j + 1
      }

      println("   Segredo Reconstruido a partir de {2, 3, 4}: " + reconstructedS2)
      route {
            reconstructedS2 == secretS ==> {
                  println("   SUCESSO: Qualquer subconjunto de tamanho k=3 recupera o mesmo segredo!")
            }
            _ ==> {
                  println("   FALHA: Divergencia no segundo subconjunto.")
            }
      }
}
