#L ============================================================================
#L Algoritmo: IDEA (International Data Encryption Algorithm - Grupos Mistos)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaIDEA) {
      println("==================================================")
      println("  SciAlgo: IDEA Block Cipher (Mixed-Group Operations)")
      println("==================================================")

      #L Bloco de 64 bits composto por 4 palavras de 16 bits (X1, X2, X3, X4)
      mut as int64: p1 = 1111
      mut as int64: p2 = 2222
      mut as int64: p3 = 3333
      mut as int64: p4 = 4444

      #L Subchaves de 16 bits (6 subchaves por rodada)
      mut as int64: k1 = 1234
      mut as int64: k2 = 2345
      mut as int64: k3 = 3456
      mut as int64: k4 = 4567
      mut as int64: k5 = 5678
      mut as int64: k6 = 6789

      println("1. Bloco de Entrada (4 palavras de 16 bits):")
      println("   P: [" + p1 + ", " + p2 + ", " + p3 + ", " + p4 + "]")

      println("==================================================")
      println("2. Encriptacao IDEA (Multiplicacao mod 65537, Adicao mod 65536, XOR):")

      #L Multiplicacao modulo 65537 (onde 0 representa 65536):
      #L X1 = mul(p1, k1)
      mut as int64: a1 = p1
      route { a1 == 0 ==> { a1 = 65536 } _ ==> {} }
      mut as int64: b1 = k1
      route { b1 == 0 ==> { b1 = 65536 } _ ==> {} }
      mut as int64: prod1 = (a1 * b1) /r 65537
      route { prod1 == 65536 ==> { prod1 = 0 } _ ==> {} }
      mut as int64: x1 = prod1

      #L X2 = add(p2, k2)
      mut as int64: x2 = (p2 + k2) /r 65536

      #L X3 = add(p3, k3)
      mut as int64: x3 = (p3 + k3) /r 65536

      #L X4 = mul(p4, k4)
      mut as int64: a4 = p4
      route { a4 == 0 ==> { a4 = 65536 } _ ==> {} }
      mut as int64: b4 = k4
      route { b4 == 0 ==> { b4 = 65536 } _ ==> {} }
      mut as int64: prod4 = (a4 * b4) /r 65537
      route { prod4 == 65536 ==> { prod4 = 0 } _ ==> {} }
      mut as int64: x4 = prod4

      #L Estrutura MA (Multiplication-Addition):
      mut as int64: t1 = x1 ^ x3
      mut as int64: t2 = x2 ^ x4

      #L t1 = mul(t1, k5)
      mut as int64: at1 = t1
      route { at1 == 0 ==> { at1 = 65536 } _ ==> {} }
      mut as int64: bt1 = k5
      route { bt1 == 0 ==> { bt1 = 65536 } _ ==> {} }
      mut as int64: prodt1 = (at1 * bt1) /r 65537
      route { prodt1 == 65536 ==> { prodt1 = 0 } _ ==> {} }
      t1 = prodt1

      t2 = (t2 + t1) /r 65536

      #L t2 = mul(t2, k6)
      mut as int64: at2 = t2
      route { at2 == 0 ==> { at2 = 65536 } _ ==> {} }
      mut as int64: bt2 = k6
      route { bt2 == 0 ==> { bt2 = 65536 } _ ==> {} }
      mut as int64: prodt2 = (at2 * bt2) /r 65537
      route { prodt2 == 65536 ==> { prodt2 = 0 } _ ==> {} }
      t2 = prodt2

      t1 = (t1 + t2) /r 65536

      mut as int64: c1 = x1 ^ t2
      mut as int64: c3 = x3 ^ t2
      mut as int64: c2 = x2 ^ t1
      mut as int64: c4 = x4 ^ t1

      println("   Texto cifrado IDEA:")
      println("   C: [" + c1 + ", " + c2 + ", " + c3 + ", " + c4 + "]")

      println("==================================================")
      println("3. Decriptacao IDEA com Chaves Inversas dos Grupos:")

      #L Calcula inversos multiplicativos (Fermat: k^(65535) mod 65537) e aditivos:
      mut as int64: dk1 = 1
      mut as int64: baseK1 = k1
      mut as int64: expK1 = 65535
      infinite (expK1 > 0) {
            route { expK1 /r 2 == 1 ==> { dk1 = (dk1 * baseK1) /r 65537 } _ ==> {} }
            baseK1 = (baseK1 * baseK1) /r 65537
            expK1 = expK1 /i 2
      }

      mut as int64: dk2 = (65536 - k2) /r 65536
      mut as int64: dk3 = (65536 - k3) /r 65536

      mut as int64: dk4 = 1
      mut as int64: baseK4 = k4
      mut as int64: expK4 = 65535
      infinite (expK4 > 0) {
            route { expK4 /r 2 == 1 ==> { dk4 = (dk4 * baseK4) /r 65537 } _ ==> {} }
            baseK4 = (baseK4 * baseK4) /r 65537
            expK4 = expK4 /i 2
      }

      #L Decriptacao MA:
      mut as int64: dt1 = c1 ^ c3
      mut as int64: dt2 = c2 ^ c4

      mut as int64: adt1 = dt1
      route { adt1 == 0 ==> { adt1 = 65536 } _ ==> {} }
      mut as int64: bdt1 = k5
      route { bdt1 == 0 ==> { bdt1 = 65536 } _ ==> {} }
      mut as int64: proddt1 = (adt1 * bdt1) /r 65537
      route { proddt1 == 65536 ==> { proddt1 = 0 } _ ==> {} }
      dt1 = proddt1

      dt2 = (dt2 + dt1) /r 65536

      mut as int64: adt2 = dt2
      route { adt2 == 0 ==> { adt2 = 65536 } _ ==> {} }
      mut as int64: bdt2 = k6
      route { bdt2 == 0 ==> { bdt2 = 65536 } _ ==> {} }
      mut as int64: proddt2 = (adt2 * bdt2) /r 65537
      route { proddt2 == 65536 ==> { proddt2 = 0 } _ ==> {} }
      dt2 = proddt2

      dt1 = (dt1 + dt2) /r 65536

      mut as int64: dx1 = c1 ^ dt2
      mut as int64: dx3 = c3 ^ dt2
      mut as int64: dx2 = c2 ^ dt1
      mut as int64: dx4 = c4 ^ dt1

      #L Reversao das operacoes iniciais com as chaves inversas:
      mut as int64: rA1 = dx1
      route { rA1 == 0 ==> { rA1 = 65536 } _ ==> {} }
      mut as int64: rB1 = dk1
      route { rB1 == 0 ==> { rB1 = 65536 } _ ==> {} }
      mut as int64: rProd1 = (rA1 * rB1) /r 65537
      route { rProd1 == 65536 ==> { rProd1 = 0 } _ ==> {} }
      mut as int64: rest1 = rProd1

      mut as int64: rest2 = (dx2 + dk2) /r 65536
      mut as int64: rest3 = (dx3 + dk3) /r 65536

      mut as int64: rA4 = dx4
      route { rA4 == 0 ==> { rA4 = 65536 } _ ==> {} }
      mut as int64: rB4 = dk4
      route { rB4 == 0 ==> { rB4 = 65536 } _ ==> {} }
      mut as int64: rProd4 = (rA4 * rB4) /r 65537
      route { rProd4 == 65536 ==> { rProd4 = 0 } _ ==> {} }
      mut as int64: rest4 = rProd4

      println("   Texto restaurado IDEA:")
      println("   P': [" + rest1 + ", " + rest2 + ", " + rest3 + ", " + rest4 + "]")

      route {
            rest1 == p1 and rest2 == p2 and rest3 == p3 and rest4 == p4 ==> {
                  println("   SUCESSO: IDEA completou encriptacao e decriptacao algébrica com exito!")
            }
            _ ==> {
                  println("   FALHA: Divergência na decriptacao IDEA.")
            }
      }
}
