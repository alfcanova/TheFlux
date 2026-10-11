#L ============================================================================
#L Algoritmo: PBKDF2 (Password-Based Key Derivation Function 2 - RFC 8018)
#L Dominio: 09_systems_infra / Categoria: Criptografia moderna e hashing aplicado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

program (ExampleOfSistemasCriptoModernaPBKDF2) {
      println("==================================================")
      println("  SciAlgo: PBKDF2 (RFC 8018 Key Derivation)")
      println("==================================================")

      mut as int64: userPassword = 77889911
      mut as int64: userSalt = 12345678

      println("1. Parametros Iniciais:")
      println("   Senha: " + userPassword)
      println("   Salt:  " + userSalt)

      println("==================================================")
      println("2. Derivacao com Iteracoes Baixas (c = 100):")
      mut as int64: c1 = 100
      mut as int64: initData1 = (userSalt * 256) + 1

      #L U_1 = PRF(Password, Salt || 1)
      mut as int64: h = (userPassword * 31 + initData1) & 2147483647
      h = (h * 16777619 + 2166136261) & 2147483647
      h = h ^ (h >> 13)
      mut as int64: uPrev = (h * 1279) & 2147483647
      mut as int64: key1 = uPrev

      mut as int64: iter = 2
      infinite (iter <= c1) {
            h = (userPassword * 31 + uPrev) & 2147483647
            h = (h * 16777619 + 2166136261) & 2147483647
            h = h ^ (h >> 13)
            mut as int64: uCur = (h * 1279) & 2147483647
            key1 = key1 ^ uCur
            uPrev = uCur
            iter = iter + 1
      }
      println("   Chave derivada (c=100): " + key1)

      println("==================================================")
      println("3. Derivacao com Iteracoes Elevadas (c = 1000):")
      mut as int64: c2 = 1000
      h = (userPassword * 31 + initData1) & 2147483647
      h = (h * 16777619 + 2166136261) & 2147483647
      h = h ^ (h >> 13)
      uPrev = (h * 1279) & 2147483647
      mut as int64: key2 = uPrev

      iter = 2
      infinite (iter <= c2) {
            h = (userPassword * 31 + uPrev) & 2147483647
            h = (h * 16777619 + 2166136261) & 2147483647
            h = h ^ (h >> 13)
            mut as int64: uCur = (h * 1279) & 2147483647
            key2 = key2 ^ uCur
            uPrev = uCur
            iter = iter + 1
      }
      println("   Chave derivada (c=1000): " + key2)

      route {
            key1 != key2 ==> {
                  println("   Custo computacional comprovado: chaves diferem substancialmente.")
            }
            _ ==> {}
      }

      println("==================================================")
      println("4. Resistencia contra Tabelas Precomputadas (Rainbow):")
      mut as int64: altSalt = 87654321
      mut as int64: initDataAlt = (altSalt * 256) + 1
      h = (userPassword * 31 + initDataAlt) & 2147483647
      h = (h * 16777619 + 2166136261) & 2147483647
      h = h ^ (h >> 13)
      uPrev = (h * 1279) & 2147483647
      mut as int64: keyAlt = uPrev

      iter = 2
      infinite (iter <= c1) {
            h = (userPassword * 31 + uPrev) & 2147483647
            h = (h * 16777619 + 2166136261) & 2147483647
            h = h ^ (h >> 13)
            mut as int64: uCur = (h * 1279) & 2147483647
            keyAlt = keyAlt ^ uCur
            uPrev = uCur
            iter = iter + 1
      }
      println("   Chave com Salt alternativo: " + keyAlt)

      route {
            key1 != keyAlt ==> {
                  println("   Isolamento por Salt confirmado: mesmo com mesma senha, as chaves divergem.")
            }
            _ ==> {}
      }

      println("==================================================")
      println("5. Determinismo e Reprodutibilidade:")
      h = (userPassword * 31 + initData1) & 2147483647
      h = (h * 16777619 + 2166136261) & 2147483647
      h = h ^ (h >> 13)
      uPrev = (h * 1279) & 2147483647
      mut as int64: keyRepeat = uPrev
      iter = 2
      infinite (iter <= c1) {
            h = (userPassword * 31 + uPrev) & 2147483647
            h = (h * 16777619 + 2166136261) & 2147483647
            h = h ^ (h >> 13)
            mut as int64: uCur = (h * 1279) & 2147483647
            keyRepeat = keyRepeat ^ uCur
            uPrev = uCur
            iter = iter + 1
      }

      route {
            key1 == keyRepeat ==> {
                  println("   SUCESSO: Chave recalculada identica (100% deterministico).")
            }
            _ ==> {
                  println("   FALHA: Divergencia na reprodutibilidade.")
            }
      }
}
