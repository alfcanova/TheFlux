#L ============================================================================
#L Algoritmo: DSA (Digital Signature Algorithm)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaDSA) {
      println("==================================================")
      println("  SciAlgo: Digital Signature Algorithm (DSA)")
      println("==================================================")

      #L Parametros de Dominio DSA:
      mut as int64: p = 467 #L Primo de corpo
      mut as int64: q = 233 #L Subprimo tal que q divide (p - 1)
      mut as int64: g = 4   #L Gerador de subgrupo de ordem q em Z_p*

      #L Chave privada x em [1, q - 1]
      mut as int64: x = 105

      #L Chave publica y = g^x mod p
      mut as int64: y = 1
      mut as int64: baseY = g
      mut as int64: expY = x
      infinite (expY > 0) {
            route { expY /r 2 == 1 ==> { y = (y * baseY) /r p } _ ==> {} }
            baseY = (baseY * baseY) /r p
            expY = expY /i 2
      }

      println("1. Parametros e Chaves DSA:")
      println("   Primo p = " + p + ", Subprimo q = " + q + ", Gerador g = " + g)
      println("   Chave privada (x): " + x)
      println("   Chave publica (y = g^x mod p): " + y)

      #L Hash da mensagem H(m) e chave efemera k
      mut as int64: hm = 87
      mut as int64: k = 53

      println("==================================================")
      println("2. Assinatura Digital DSA:")
      println("   Hash da mensagem H(m): " + hm)
      println("   Segredo efemero k: " + k)

      #L r = (g^k mod p) mod q
      mut as int64: gk = 1
      mut as int64: bgk = g
      mut as int64: egk = k
      infinite (egk > 0) {
            route { egk /r 2 == 1 ==> { gk = (gk * bgk) /r p } _ ==> {} }
            bgk = (bgk * bgk) /r p
            egk = egk /i 2
      }
      mut as int64: r = gk /r q

      #L Inverso de k mod q: kInv = k^(q - 2) mod q
      mut as int64: kInv = 1
      mut as int64: bK = k
      mut as int64: eK = q - 2
      infinite (eK > 0) {
            route { eK /r 2 == 1 ==> { kInv = (kInv * bK) /r q } _ ==> {} }
            bK = (bK * bK) /r q
            eK = eK /i 2
      }

      #L s = (kInv * (hm + x * r)) mod q
      mut as int64: s = (kInv * (hm + x * r)) /r q

      println("   Assinatura gerada (r, s): (" + r + ", " + s + ")")

      println("==================================================")
      println("3. Verificacao da Assinatura:")

      #L w = s^(-1) mod q = s^(q - 2) mod q
      mut as int64: w = 1
      mut as int64: bW = s
      mut as int64: eW = q - 2
      infinite (eW > 0) {
            route { eW /r 2 == 1 ==> { w = (w * bW) /r q } _ ==> {} }
            bW = (bW * bW) /r q
            eW = eW /i 2
      }

      #L u1 = (hm * w) mod q
      mut as int64: u1 = (hm * w) /r q
      #L u2 = (r * w) mod q
      mut as int64: u2 = (r * w) /r q

      #L g^u1 mod p
      mut as int64: gu1 = 1
      mut as int64: bGu1 = g
      mut as int64: eGu1 = u1
      infinite (eGu1 > 0) {
            route { eGu1 /r 2 == 1 ==> { gu1 = (gu1 * bGu1) /r p } _ ==> {} }
            bGu1 = (bGu1 * bGu1) /r p
            eGu1 = eGu1 /i 2
      }

      #L y^u2 mod p
      mut as int64: yu2 = 1
      mut as int64: bYu2 = y
      mut as int64: eYu2 = u2
      infinite (eYu2 > 0) {
            route { eYu2 /r 2 == 1 ==> { yu2 = (yu2 * bYu2) /r p } _ ==> {} }
            bYu2 = (bYu2 * bYu2) /r p
            eYu2 = eYu2 /i 2
      }

      #L v = ((gu1 * yu2) mod p) mod q
      mut as int64: v = ((gu1 * yu2) /r p) /r q

      println("   Valor de verificacao v: " + v)
      println("   Componente de assinatura r: " + r)

      route {
            v == r and r > 0 and s > 0 ==> {
                  println("   SUCESSO: Assinatura DSA verificada com exito!")
            }
            _ ==> {
                  println("   FALHA: Assinatura DSA rejeitada.")
            }
      }
}
