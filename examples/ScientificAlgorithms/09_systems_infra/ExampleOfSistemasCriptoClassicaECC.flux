#L ============================================================================
#L Algoritmo: Criptografia de Curva Eliptica (ECC sobre Corpos Finitos F_p)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaECC) {
      println("==================================================")
      println("  SciAlgo: Elliptic Curve Cryptography (ECC)")
      println("==================================================")

      #L Curva de Weierstrass: y^2 = x^3 + a*x + b (mod p)
      mut as int64: p = 97 #L Primo de corpo finito
      mut as int64: a = 2
      mut as int64: b = 3

      #L Ponto Base Gerador G = (3, 6)
      mut as int64: gx = 3
      mut as int64: gy = 6

      println("1. Parametros da Curva Eliptica:")
      println("   Corpo Primo p: " + p)
      println("   Equacao: y^2 = x^3 + " + a + "*x + " + b + " (mod " + p + ")")
      println("   Ponto Base G: (" + gx + ", " + gy + ")")

      #L Multiplicacao Escalar k * G via algoritmo Double-and-Add
      #L Chave privada d = 7
      mut as int64: privD = 7

      println("==================================================")
      println("2. Calculo da Chave Publica Q = d * G (Double-and-Add):")
      println("   Chave privada (d): " + privD)

      #L Acumulador inicial (ponto no infinito representado por isInf = 1)
      mut as int64: rx = 0
      mut as int64: ry = 0
      mut as int64: rInf = 1

      #L Ponto temporario para duplicacao
      mut as int64: curX = gx
      mut as int64: curY = gy

      mut as int64: k = privD
      infinite (k > 0) {
            route {
                  k /r 2 == 1 ==> {
                        #L Adiciona cur ao acumulador R: R = R + cur
                        route {
                              rInf == 1 ==> {
                                    rx = curX
                                    ry = curY
                                    rInf = 0
                              }
                              _ ==> {
                                    #L R + cur com R != cur
                                    mut as int64: dy = curY - ry
                                    infinite (dy < 0) {
                                          dy = dy + p * 10
                                    }
                                    dy = dy /r p

                                    mut as int64: dx = curX - rx
                                    infinite (dx < 0) {
                                          dx = dx + p * 10
                                    }
                                    dx = dx /r p

                                    #L Inverso modular de dx via Fermat: dx^(p-2) mod p
                                    mut as int64: dxInv = 1
                                    mut as int64: bInv = dx
                                    mut as int64: eInv = p - 2
                                    infinite (eInv > 0) {
                                          route { eInv /r 2 == 1 ==> { dxInv = (dxInv * bInv) /r p } _ ==> {} }
                                          bInv = (bInv * bInv) /r p
                                          eInv = eInv /i 2
                                    }

                                    mut as int64: slope = (dy * dxInv) /r p

                                    mut as int64: nxVal = slope * slope - rx - curX
                                    infinite (nxVal < 0) {
                                          nxVal = nxVal + p * 100
                                    }
                                    mut as int64: nx = nxVal /r p

                                    mut as int64: nyVal = slope * (rx - nx) - ry
                                    infinite (nyVal < 0) {
                                          nyVal = nyVal + p * 100
                                    }
                                    mut as int64: ny = nyVal /r p

                                    rx = nx
                                    ry = ny
                              }
                        }
                  }
                  _ ==> {}
            }

            #L Duplica cur: cur = 2 * cur (Point Doubling)
            mut as int64: numSlope = (3 * curX * curX + a) /r p
            mut as int64: denSlope = (2 * curY) /r p
            #L Inverso de denSlope
            mut as int64: denInv = 1
            mut as int64: bD = denSlope
            mut as int64: eD = p - 2
            infinite (eD > 0) {
                  route { eD /r 2 == 1 ==> { denInv = (denInv * bD) /r p } _ ==> {} }
                  bD = (bD * bD) /r p
                  eD = eD /i 2
            }

            mut as int64: lD = (numSlope * denInv) /r p

            mut as int64: dXVal = lD * lD - 2 * curX
            infinite (dXVal < 0) {
                  dXVal = dXVal + p * 100
            }
            mut as int64: dX = dXVal /r p

            mut as int64: dYVal = lD * (curX - dX) - curY
            infinite (dYVal < 0) {
                  dYVal = dYVal + p * 100
            }
            mut as int64: dY = dYVal /r p

            curX = dX
            curY = dY

            k = k /i 2
      }

      println("   Chave Publica Q = (" + rx + ", " + ry + ")")

      println("==================================================")
      println("3. Validacao do Ponto Q sobre a Curva:")

      #L Verifica y^2 == x^3 + a*x + b (mod p)
      mut as int64: lhs = (ry * ry) /r p
      mut as int64: rhs = (rx * rx * rx + a * rx + b) /r p

      println("   LHS (y^2 mod p): " + lhs)
      println("   RHS (x^3 + ax + b mod p): " + rhs)

      route {
            lhs == rhs and rInf == 0 ==> {
                  println("   SUCESSO: Ponto resultante pertence a curva eliptica!")
            }
            _ ==> {
                  println("   FALHA: Ponto invalido fora da curva.")
            }
      }
}
