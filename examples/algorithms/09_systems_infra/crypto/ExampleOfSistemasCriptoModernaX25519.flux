#L ============================================================================
#L Algoritmo: X25519 (Diffie-Hellman Key Exchange sobre Curva de Montgomery)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaX25519) {
      println("==================================================")
      println("  SciAlgo: X25519 (Montgomery Curve Key Exchange)")
      println("==================================================")

      #L Corpo primo p=10007 (p^2 < 2^31-1 garante paridade exata em 32-bit e 64-bit)
      mut as int64: p = 10007
      mut as int64: aConst = 6326  #L 486662 mod 10007
      mut as int64: baseU = 9      #L Ponto base da Curve25519

      #L Chaves privadas
      mut as int64: alicePriv = 1947
      mut as int64: bobPriv = 3891

      #L Inverso modular de 4 mod p: (p + 1) / 4 para p mod 4 == 3
      mut as int64: inv4 = (p + 1) /i 4
      mut as int64: a24 = (((aConst + 2) /r p) * inv4) /r p

      println("1. Parametros da Curva:")
      println("   Primo p = " + p)
      println("   Constante A = " + aConst)
      println("   Ponto Base U = " + baseU)

      println("==================================================")
      println("2. Geracao de Chave Publica de Alice:")
      #L Montgomery Ladder para Alice
      mut as int64: x1 = baseU
      mut as int64: x2 = 1
      mut as int64: z2 = 0
      mut as int64: x3 = baseU
      mut as int64: z3 = 1

      mut as int64: bitIdx = 11
      infinite (bitIdx >= 0) {
            mut as int64: bit = (alicePriv >> bitIdx) & 1
            route {
                  bit == 1 ==> {
                        mut as int64: tx = x2
                        x2 = x3
                        x3 = tx
                        mut as int64: tz = z2
                        z2 = z3
                        z3 = tz
                  }
                  _ ==> {}
            }

            mut as int64: aSum = (x2 + z2) /r p
            mut as int64: aDiff = x2 - z2
            route {
                  aDiff < 0 ==> {
                        aDiff = aDiff + p
                  }
                  _ ==> {}
            }
            aDiff = aDiff /r p

            mut as int64: bSum = (x3 + z3) /r p
            mut as int64: bDiff = x3 - z3
            route {
                  bDiff < 0 ==> {
                        bDiff = bDiff + p
                  }
                  _ ==> {}
            }
            bDiff = bDiff /r p

            mut as int64: da = (bDiff * aSum) /r p
            mut as int64: cb = (bSum * aDiff) /r p

            mut as int64: addP = (da + cb) /r p
            x3 = (addP * addP) /r p

            mut as int64: subP = da - cb
            route {
                  subP < 0 ==> {
                        subP = subP + p
                  }
                  _ ==> {}
            }
            subP = subP /r p
            z3 = (x1 * ((subP * subP) /r p)) /r p

            mut as int64: aa = (aSum * aSum) /r p
            mut as int64: bb = (aDiff * aDiff) /r p

            mut as int64: e = aa - bb
            route {
                  e < 0 ==> {
                        e = e + p
                  }
                  _ ==> {}
            }
            e = e /r p

            x2 = (aa * bb) /r p
            z2 = (e * ((bb + ((a24 * e) /r p)) /r p)) /r p

            route {
                  bit == 1 ==> {
                        mut as int64: tx = x2
                        x2 = x3
                        x3 = tx
                        mut as int64: tz = z2
                        z2 = z3
                        z3 = tz
                  }
                  _ ==> {}
            }
            bitIdx = bitIdx - 1
      }

      #L Inversao modular de z2 mod p via Fermat: z2^(p-2) mod p
      mut as int64: invZ2 = 1
      mut as int64: bExp = z2 /r p
      mut as int64: eExp = p - 2
      infinite (eExp > 0) {
            mut as int64: b = eExp & 1
            route {
                  b == 1 ==> {
                        invZ2 = (invZ2 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: alicePub = (x2 * invZ2) /r p
      println("   Alice: Priv=" + alicePriv + " -> Pub=" + alicePub)

      println("==================================================")
      println("3. Geracao de Chave Publica de Bob:")
      x1 = baseU
      x2 = 1
      z2 = 0
      x3 = baseU
      z3 = 1
      bitIdx = 11
      infinite (bitIdx >= 0) {
            mut as int64: bit = (bobPriv >> bitIdx) & 1
            route {
                  bit == 1 ==> {
                        mut as int64: tx = x2
                        x2 = x3
                        x3 = tx
                        mut as int64: tz = z2
                        z2 = z3
                        z3 = tz
                  }
                  _ ==> {}
            }

            mut as int64: aSum = (x2 + z2) /r p
            mut as int64: aDiff = x2 - z2
            route {
                  aDiff < 0 ==> {
                        aDiff = aDiff + p
                  }
                  _ ==> {}
            }
            aDiff = aDiff /r p

            mut as int64: bSum = (x3 + z3) /r p
            mut as int64: bDiff = x3 - z3
            route {
                  bDiff < 0 ==> {
                        bDiff = bDiff + p
                  }
                  _ ==> {}
            }
            bDiff = bDiff /r p

            mut as int64: da = (bDiff * aSum) /r p
            mut as int64: cb = (bSum * aDiff) /r p

            mut as int64: addP = (da + cb) /r p
            x3 = (addP * addP) /r p

            mut as int64: subP = da - cb
            route {
                  subP < 0 ==> {
                        subP = subP + p
                  }
                  _ ==> {}
            }
            subP = subP /r p
            z3 = (x1 * ((subP * subP) /r p)) /r p

            mut as int64: aa = (aSum * aSum) /r p
            mut as int64: bb = (aDiff * aDiff) /r p

            mut as int64: e = aa - bb
            route {
                  e < 0 ==> {
                        e = e + p
                  }
                  _ ==> {}
            }
            e = e /r p

            x2 = (aa * bb) /r p
            z2 = (e * ((bb + ((a24 * e) /r p)) /r p)) /r p

            route {
                  bit == 1 ==> {
                        mut as int64: tx = x2
                        x2 = x3
                        x3 = tx
                        mut as int64: tz = z2
                        z2 = z3
                        z3 = tz
                  }
                  _ ==> {}
            }
            bitIdx = bitIdx - 1
      }
      invZ2 = 1
      bExp = z2 /r p
      eExp = p - 2
      infinite (eExp > 0) {
            mut as int64: b = eExp & 1
            route {
                  b == 1 ==> {
                        invZ2 = (invZ2 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: bobPub = (x2 * invZ2) /r p
      println("   Bob:   Priv=" + bobPriv + " -> Pub=" + bobPub)

      println("==================================================")
      println("4. Acordo de Chaves (Shared Secret):")
      x1 = bobPub
      x2 = 1
      z2 = 0
      x3 = bobPub
      z3 = 1
      bitIdx = 11
      infinite (bitIdx >= 0) {
            mut as int64: bit = (alicePriv >> bitIdx) & 1
            route {
                  bit == 1 ==> {
                        mut as int64: tx = x2
                        x2 = x3
                        x3 = tx
                        mut as int64: tz = z2
                        z2 = z3
                        z3 = tz
                  }
                  _ ==> {}
            }

            mut as int64: aSum = (x2 + z2) /r p
            mut as int64: aDiff = x2 - z2
            route {
                  aDiff < 0 ==> {
                        aDiff = aDiff + p
                  }
                  _ ==> {}
            }
            aDiff = aDiff /r p

            mut as int64: bSum = (x3 + z3) /r p
            mut as int64: bDiff = x3 - z3
            route {
                  bDiff < 0 ==> {
                        bDiff = bDiff + p
                  }
                  _ ==> {}
            }
            bDiff = bDiff /r p

            mut as int64: da = (bDiff * aSum) /r p
            mut as int64: cb = (bSum * aDiff) /r p

            mut as int64: addP = (da + cb) /r p
            x3 = (addP * addP) /r p

            mut as int64: subP = da - cb
            route {
                  subP < 0 ==> {
                        subP = subP + p
                  }
                  _ ==> {}
            }
            subP = subP /r p
            z3 = (x1 * ((subP * subP) /r p)) /r p

            mut as int64: aa = (aSum * aSum) /r p
            mut as int64: bb = (aDiff * aDiff) /r p

            mut as int64: e = aa - bb
            route {
                  e < 0 ==> {
                        e = e + p
                  }
                  _ ==> {}
            }
            e = e /r p

            x2 = (aa * bb) /r p
            z2 = (e * ((bb + ((a24 * e) /r p)) /r p)) /r p

            route {
                  bit == 1 ==> {
                        mut as int64: tx = x2
                        x2 = x3
                        x3 = tx
                        mut as int64: tz = z2
                        z2 = z3
                        z3 = tz
                  }
                  _ ==> {}
            }
            bitIdx = bitIdx - 1
      }
      invZ2 = 1
      bExp = z2 /r p
      eExp = p - 2
      infinite (eExp > 0) {
            mut as int64: b = eExp & 1
            route {
                  b == 1 ==> {
                        invZ2 = (invZ2 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: aliceShared = (x2 * invZ2) /r p
      println("   Segredo computado por Alice: " + aliceShared)

      x1 = alicePub
      x2 = 1
      z2 = 0
      x3 = alicePub
      z3 = 1
      bitIdx = 11
      infinite (bitIdx >= 0) {
            mut as int64: bit = (bobPriv >> bitIdx) & 1
            route {
                  bit == 1 ==> {
                        mut as int64: tx = x2
                        x2 = x3
                        x3 = tx
                        mut as int64: tz = z2
                        z2 = z3
                        z3 = tz
                  }
                  _ ==> {}
            }

            mut as int64: aSum = (x2 + z2) /r p
            mut as int64: aDiff = x2 - z2
            route {
                  aDiff < 0 ==> {
                        aDiff = aDiff + p
                  }
                  _ ==> {}
            }
            aDiff = aDiff /r p

            mut as int64: bSum = (x3 + z3) /r p
            mut as int64: bDiff = x3 - z3
            route {
                  bDiff < 0 ==> {
                        bDiff = bDiff + p
                  }
                  _ ==> {}
            }
            bDiff = bDiff /r p

            mut as int64: da = (bDiff * aSum) /r p
            mut as int64: cb = (bSum * aDiff) /r p

            mut as int64: addP = (da + cb) /r p
            x3 = (addP * addP) /r p

            mut as int64: subP = da - cb
            route {
                  subP < 0 ==> {
                        subP = subP + p
                  }
                  _ ==> {}
            }
            subP = subP /r p
            z3 = (x1 * ((subP * subP) /r p)) /r p

            mut as int64: aa = (aSum * aSum) /r p
            mut as int64: bb = (aDiff * aDiff) /r p

            mut as int64: e = aa - bb
            route {
                  e < 0 ==> {
                        e = e + p
                  }
                  _ ==> {}
            }
            e = e /r p

            x2 = (aa * bb) /r p
            z2 = (e * ((bb + ((a24 * e) /r p)) /r p)) /r p

            route {
                  bit == 1 ==> {
                        mut as int64: tx = x2
                        x2 = x3
                        x3 = tx
                        mut as int64: tz = z2
                        z2 = z3
                        z3 = tz
                  }
                  _ ==> {}
            }
            bitIdx = bitIdx - 1
      }
      invZ2 = 1
      bExp = z2 /r p
      eExp = p - 2
      infinite (eExp > 0) {
            mut as int64: b = eExp & 1
            route {
                  b == 1 ==> {
                        invZ2 = (invZ2 * bExp) /r p
                  }
                  _ ==> {}
            }
            bExp = (bExp * bExp) /r p
            eExp = eExp >> 1
      }
      mut as int64: bobShared = (x2 * invZ2) /r p
      println("   Segredo computado por Bob:   " + bobShared)

      route {
            aliceShared == bobShared ==> {
                  println("   SUCESSO: Chaves concordam perfeitamente! K = " + aliceShared)
            }
            _ ==> {
                  println("   FALHA: Divergencia entre os segredos calculados.")
            }
      }
}
