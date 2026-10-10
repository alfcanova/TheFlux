#L ============================================================================
#L Algoritmo: Twofish (Cifra de Bloco de 128 bits com Rede Feistel e PHT)
#L Dominio: 09_systems_infra / Categoria: Primitivas criptograficas e cifras classicas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoClassicaTwofish) {
      println("==================================================")
      println("  SciAlgo: Twofish 128-bit Block Cipher")
      println("==================================================")

      #L Bloco de 128 bits dividido em 4 palavras de 32 bits: R0, R1, R2, R3
      mut as int64: plain0 = 305419896 #L 0x12345678
      mut as int64: plain1 = 259606910 #L 0x0F7945FE
      mut as int64: plain2 = 987654321
      mut as int64: plain3 = 135792468

      #L Subchaves de clareamento (whitening keys)
      mut as int64: wk0 = 111111111
      mut as int64: wk1 = 222222222
      mut as int64: wk2 = 333333333
      mut as int64: wk3 = 444444444

      println("1. Entrada de 128 bits (4 palavras):")
      println("   R: [" + plain0 + ", " + plain1 + ", " + plain2 + ", " + plain3 + "]")

      #L Clareamento Inicial (Input Whitening)
      mut as int64: r0 = plain0 ^ wk0
      mut as int64: r1 = plain1 ^ wk1
      mut as int64: r2 = plain2 ^ wk2
      mut as int64: r3 = plain3 ^ wk3

      println("==================================================")
      println("2. Executando Rodadas de Feistel Twofish com PHT:")

      #L Executa 4 rodadas representativas de Twofish
      mut as int64: rnd = 1
      infinite (rnd <= 4) {
            #L Funcao h de mistura MDS simplificada
            mut as int64: t0 = ((r0 * 65539 + 12345) ^ (r0 /i 256)) /r 4294967296
            infinite (t0 < 0) { t0 = t0 + 4294967296 }

            mut as int64: t1 = ((r1 * 65537 + 54321) ^ (r1 /i 256)) /r 4294967296
            infinite (t1 < 0) { t1 = t1 + 4294967296 }

            #L Transformada Pseudo-Hadamard (PHT):
            #L f0 = (t0 + t1 + rnd * 1000) mod 2^32
            #L f1 = (t0 + 2*t1 + rnd * 2000) mod 2^32
            mut as int64: f0 = (t0 + t1 + rnd * 1000) /r 4294967296
            infinite (f0 < 0) { f0 = f0 + 4294967296 }

            mut as int64: f1 = (t0 + 2 * t1 + rnd * 2000) /r 4294967296
            infinite (f1 < 0) { f1 = f1 + 4294967296 }

            mut as int64: nextR2 = r2 ^ f0
            mut as int64: nextR3 = r3 ^ f1

            #L Troca de metades Feistel (swap de 64 bits)
            mut as int64: swap0 = nextR2
            mut as int64: swap1 = nextR3
            mut as int64: swap2 = r0
            mut as int64: swap3 = r1

            r0 = swap0
            r1 = swap1
            r2 = swap2
            r3 = swap3

            rnd = rnd + 1
      }

      #L Clareamento Final (Output Whitening)
      mut as int64: c0 = r0 ^ wk0
      mut as int64: c1 = r1 ^ wk1
      mut as int64: c2 = r2 ^ wk2
      mut as int64: c3 = r3 ^ wk3

      println("   Texto cifrado Twofish (C0..C3):")
      println("   C: [" + c0 + ", " + c1 + ", " + c2 + ", " + c3 + "]")

      println("==================================================")
      println("3. Decriptacao Twofish:")

      #L Desfaz clareamento final
      mut as int64: d0 = c0 ^ wk0
      mut as int64: d1 = c1 ^ wk1
      mut as int64: d2 = c2 ^ wk2
      mut as int64: d3 = c3 ^ wk3

      mut as int64: drnd = 4
      infinite (drnd >= 1) {
            #L Desfaz troca Feistel
            mut as int64: prevR0 = d2
            mut as int64: prevR1 = d3
            mut as int64: prevR2 = d0
            mut as int64: prevR3 = d1

            mut as int64: t0 = ((prevR0 * 65539 + 12345) ^ (prevR0 /i 256)) /r 4294967296
            infinite (t0 < 0) { t0 = t0 + 4294967296 }

            mut as int64: t1 = ((prevR1 * 65537 + 54321) ^ (prevR1 /i 256)) /r 4294967296
            infinite (t1 < 0) { t1 = t1 + 4294967296 }

            mut as int64: f0 = (t0 + t1 + drnd * 1000) /r 4294967296
            infinite (f0 < 0) { f0 = f0 + 4294967296 }

            mut as int64: f1 = (t0 + 2 * t1 + drnd * 2000) /r 4294967296
            infinite (f1 < 0) { f1 = f1 + 4294967296 }

            d0 = prevR0
            d1 = prevR1
            d2 = prevR2 ^ f0
            d3 = prevR3 ^ f1

            drnd = drnd - 1
      }

      #L Desfaz clareamento inicial
      mut as int64: rest0 = d0 ^ wk0
      mut as int64: rest1 = d1 ^ wk1
      mut as int64: rest2 = d2 ^ wk2
      mut as int64: rest3 = d3 ^ wk3

      println("   Texto restaurado (P0..P3):")
      println("   P: [" + rest0 + ", " + rest1 + ", " + rest2 + ", " + rest3 + "]")

      route {
            rest0 == plain0 and rest1 == plain1 and rest2 == plain2 and rest3 == plain3 ==> {
                  println("   SUCESSO: Twofish cifrou e decifrou o bloco de 128 bits com fidelidade total!")
            }
            _ ==> {
                  println("   FALHA: Divergência na decriptacao Twofish.")
            }
      }
}
